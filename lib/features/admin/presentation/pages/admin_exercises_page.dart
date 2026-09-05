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

/// List → search → filter by muscle group → add/edit/delete, using only
/// `/api/exercises` (already supports full CRUD for admins).
class AdminExercisesPage extends ConsumerWidget {
  const AdminExercisesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final items = ref.watch(adminExercisesControllerProvider);
    final controller = ref.read(adminExercisesControllerProvider.notifier);

    return AdminScaffold(
      currentTab: AdminDestination.exercises,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: l10n.adminNavExercises,
            showBack: true,
            trailing: IconButton.filled(
              onPressed: () => context.push(AppRoutes.adminExerciseEditor),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(backgroundColor: ext.accentGlow),
            ),
          ),
          Expanded(
            child: AdminEntityListView(
              items: items,
              titleOf: (item) => (item['name'] as String?) ?? '',
              imageOf: (item) => item['imageUrl'] as String?,
              subtitleOf: (item) => item['equipment'] as String?,
              chipsOf:
                  (item) => [
                    if (item['muscleGroup'] != null) '${item['muscleGroup']}',
                    if (item['difficulty'] != null) '${item['difficulty']}',
                  ],
              filters: [
                AdminFilterOption(label: l10n.adminFilterAll),
                for (final group in const [
                  'chest',
                  'back',
                  'legs',
                  'shoulders',
                  'arms',
                  'core',
                  'full_body',
                  'cardio',
                ])
                  AdminFilterOption(
                    label: group,
                    matches: (item) => item['muscleGroup'] == group,
                  ),
              ],
              onRefresh: controller.refresh,
              onEdit:
                  (item) =>
                      context.push(AppRoutes.adminExerciseEditor, extra: item),
              onDelete: (item) async {
                final confirmed = await showDangerConfirmationSheet(
                  context,
                  title: l10n.adminDeleteConfirmTitle,
                  message: l10n.adminDeleteConfirmBody(
                    (item['name'] as String?) ?? '',
                  ),
                );
                if (!confirmed) return;
                await controller.deleteItem(item['_id'] as String);
              },
              emptyIcon: Icons.sports_gymnastics_outlined,
              emptyTitle: l10n.adminExercisesEmptyTitle,
              emptyMessage: l10n.adminExercisesEmptyMessage,
              errorMessage: l10n.adminLoadErrorTitle,
            ),
          ),
        ],
      ),
    );
  }
}
