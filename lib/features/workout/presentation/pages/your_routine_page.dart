import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import '../providers/workout_request_providers.dart';
import '../widgets/workout_header.dart';
import '../widgets/workout_surface.dart';
import 'routine_detail_page.dart';

class YourRoutinePage extends ConsumerWidget {
  const YourRoutinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  const SizedBox(height: 16),
                  createButton,
                  const SizedBox(height: 24),
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
                          : SliverList.separated(
                            itemCount: routines.length,
                            separatorBuilder:
                                (_, _) => Divider(
                                  height: 1,
                                  thickness: .5,
                                  color: ext.glassBorder,
                                ),
                            itemBuilder: (context, index) {
                              final routine = routines[index];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                leading: Text(
                                  '${index + 1}'.padLeft(2, '0'),
                                  style: TextStyle(
                                    color: ext.accentGlow,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                title: Text(
                                  routine['name'] as String? ?? '',
                                  style: TextStyle(
                                    color: ext.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: RoutineSummary(routine: routine),
                                ),
                                trailing: Icon(
                                  Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? Icons.chevron_left_rounded
                                      : Icons.chevron_right_rounded,
                                  color: ext.textMuted,
                                ),
                                onTap:
                                    () => Navigator.of(context).push(
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
          ],
        ),
      ),
    );
  }
}
