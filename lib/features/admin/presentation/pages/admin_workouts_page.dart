import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/admin/presentation/providers/admin_content_controllers.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_entity_list_view.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:nabvera/features/admin/presentation/widgets/danger_confirmation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// List → search → filter by difficulty/category → add/edit/delete, using
/// only `/api/workouts` (already supports full CRUD for admins).
class AdminWorkoutsPage extends ConsumerWidget {
  const AdminWorkoutsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final items = ref.watch(adminWorkoutsControllerProvider);
    final controller = ref.read(adminWorkoutsControllerProvider.notifier);

    return AdminScaffold(
      currentTab: AdminDestination.workouts,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: l10n.adminNavWorkouts,
            trailing: IconButton.filled(
              onPressed: () => context.push(AppRoutes.adminWorkoutEditor),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(backgroundColor: ext.accentGlow),
            ),
          ),
          Expanded(
            child: AdminEntityListView(
              items: items,
              titleOf: (item) => (item['title'] as String?) ?? '',
              imageOf: (item) => item['coverImageUrl'] as String?,
              subtitleOf:
                  (item) =>
                      '${item['durationMinutes'] ?? 0} min · '
                      '${item['estimatedCalories'] ?? 0} kcal',
              chipsOf:
                  (item) => [
                    if (item['difficulty'] != null) '${item['difficulty']}',
                    if (item['category'] != null) '${item['category']}',
                  ],
              filters: [
                AdminFilterOption(label: l10n.adminFilterAll),
                AdminFilterOption(
                  label: l10n.workoutLevelBeginner,
                  matches: (item) => item['difficulty'] == 'beginner',
                ),
                AdminFilterOption(
                  label: l10n.workoutLevelIntermediate,
                  matches: (item) => item['difficulty'] == 'intermediate',
                ),
                AdminFilterOption(
                  label: l10n.workoutLevelAdvanced,
                  matches: (item) => item['difficulty'] == 'advanced',
                ),
              ],
              onRefresh: controller.refresh,
              onEdit:
                  (item) =>
                      context.push(AppRoutes.adminWorkoutEditor, extra: item),
              onDelete: (item) async {
                final confirmed = await showDangerConfirmationSheet(
                  context,
                  title: l10n.adminDeleteConfirmTitle,
                  message: l10n.adminDeleteConfirmBody(
                    (item['title'] as String?) ?? '',
                  ),
                );
                if (!confirmed) return;
                await controller.deleteItem(item['_id'] as String);
              },
              emptyIcon: Icons.fitness_center_outlined,
              emptyTitle: l10n.adminWorkoutsEmptyTitle,
              emptyMessage: l10n.adminWorkoutsEmptyMessage,
              errorMessage: l10n.adminLoadErrorTitle,
            ),
          ),
        ],
      ),
    );
  }
}
