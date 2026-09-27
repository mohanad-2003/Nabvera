import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/workout/data/workout_repository.dart';
import 'package:nabvera/features/workout/presentation/providers/workout_request_providers.dart';
import 'package:nabvera/features/workout/presentation/providers/your_routine_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'routine_detail_page.dart';

class YourRoutinePage extends ConsumerStatefulWidget {
  const YourRoutinePage({super.key});

  @override
  ConsumerState<YourRoutinePage> createState() => _YourRoutinePageState();
}

class _YourRoutinePageState extends ConsumerState<YourRoutinePage> {
  String? _deletingRoutineId;

  Future<void> _deleteRoutine(Map<String, dynamic> routine) async {
    final id = routine['_id'] as String?;
    if (id == null || id.isEmpty || _deletingRoutineId != null) return;

    final name = routine['name'] as String? ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(
              workoutCopy(dialogContext, 'حذف الروتين؟', 'Delete routine?'),
            ),
            content: Text(
              workoutCopy(
                dialogContext,
                'هل أنت متأكد من حذف «$name»؟ لا يمكن التراجع عن هذا الإجراء.',
                'Are you sure you want to delete “$name”? This action cannot be undone.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(workoutCopy(dialogContext, 'إلغاء', 'Cancel')),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      Theme.of(
                        dialogContext,
                      ).extension<AppThemeExtension>()!.danger,
                ),
                child: Text(workoutCopy(dialogContext, 'حذف', 'Delete')),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deletingRoutineId = id);
    try {
      await ref.read(workoutRepositoryProvider).deleteRoutine(id);
      ref.invalidate(routinesRequestProvider);
      ref.invalidate(yourRoutineControllerProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            workoutCopy(
              context,
              'تم حذف الروتين بنجاح.',
              'Routine deleted successfully.',
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(workoutError(context, error))));
    } finally {
      if (mounted) setState(() => _deletingRoutineId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(routinesRequestProvider);
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    Future<void> create() async {
      await context.push(AppRoutes.createRoutine);
      if (context.mounted) ref.invalidate(routinesRequestProvider);
    }

    final createButton = FilledButton.icon(
      onPressed: create,
      icon: const Icon(Icons.add_rounded),
      style: FilledButton.styleFrom(
        backgroundColor: ext.accentGlow,
        foregroundColor: ext.onAccentGlow,
      ),
      label: Text(l10n.workoutCreateRoutine),
    );
    return WorkoutScaffold(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(routinesRequestProvider);
          await ref.read(routinesRequestProvider.future);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WorkoutHeader(title: l10n.workoutYourRoutineTitle),
                  const SizedBox(height: 12),
                  Text(
                    request.asData == null
                        ? l10n.workoutYourRoutineSubtitle
                        : workoutCopy(
                          context,
                          '${request.asData!.value.length} روتينات • مساحة تدريبك الشخصية',
                          '${request.asData!.value.length} routines • Your personal training space',
                        ),
                    style: TextStyle(color: ext.textMuted),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            request.when(
              loading:
                  () => const SliverToBoxAdapter(
                    child: WorkoutStatus(loading: true),
                  ),
              error:
                  (error, _) => SliverToBoxAdapter(
                    child: WorkoutStatus(
                      error: error,
                      onRetry: () => ref.invalidate(routinesRequestProvider),
                    ),
                  ),
              data:
                  (routines) =>
                      routines.isEmpty
                          ? SliverToBoxAdapter(
                            child: WorkoutStatus(
                              message: workoutCopy(
                                context,
                                'ابدأ بروتين يناسبك. اختر تمارينك ورتّبها لتجد خطة تدريبك هنا.',
                                'Choose and order your exercises to build your first training plan.',
                              ),
                              action: createButton,
                            ),
                          )
                          : SliverPadding(
                            padding: const EdgeInsets.only(top: 4),
                            sliver: SliverList.separated(
                              itemCount: routines.length,
                              separatorBuilder:
                                  (_, _) => const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final routine = routines[index];
                                final deleting =
                                    _deletingRoutineId == routine['_id'];
                                return _RoutineCard(
                                  index: index,
                                  routine: routine,
                                  deleting: deleting,
                                  onDelete: () => _deleteRoutine(routine),
                                  onTap:
                                      deleting
                                          ? null
                                          : () => Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder:
                                                  (_) => RoutineDetailPage(
                                                    routine: routine,
                                                  ),
                                            ),
                                          ),
                                );
                              },
                            ),
                          ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One routine row, as a bordered card rather than a bare [ListTile] — the
/// whole card is already tappable, so it carries no trailing chevron (that
/// was pure redundant noise once the card itself signals "tap me").
class _RoutineCard extends StatelessWidget {
  const _RoutineCard({
    required this.index,
    required this.routine,
    required this.deleting,
    required this.onDelete,
    required this.onTap,
  });

  final int index;
  final Map<String, dynamic> routine;
  final bool deleting;
  final VoidCallback onDelete;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ext.glassFill,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: ext.accentGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}'.padLeft(2, '0'),
                    style: TextStyle(
                      color: ext.onAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine['name'] as String? ?? '',
                      style: TextStyle(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RoutineSummary(routine: routine),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (deleting)
                SizedBox.square(
                  dimension: 40,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ext.danger,
                    ),
                  ),
                )
              else
                IconButton(
                  onPressed: onDelete,
                  tooltip: workoutCopy(
                    context,
                    'حذف الروتين',
                    'Delete routine',
                  ),
                  icon: Icon(Icons.delete_outline_rounded, color: ext.danger),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
