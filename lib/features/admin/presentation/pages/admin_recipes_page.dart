import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/features/admin/presentation/providers/admin_content_controllers.dart';
import 'package:fitness_app/features/admin/presentation/widgets/admin_entity_list_view.dart';
import 'package:fitness_app/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:fitness_app/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:fitness_app/features/admin/presentation/widgets/danger_confirmation_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// List → search → filter by category → add/edit/delete, using only
/// `/api/recipes` (already supports full CRUD for admins).
class AdminRecipesPage extends ConsumerWidget {
  const AdminRecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final items = ref.watch(adminRecipesControllerProvider);
    final controller = ref.read(adminRecipesControllerProvider.notifier);

    return AdminScaffold(
      currentTab: AdminDestination.recipes,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: l10n.adminNavRecipes,
            showBack: true,
            trailing: IconButton.filled(
              onPressed: () => context.push(AppRoutes.adminRecipeEditor),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(backgroundColor: ext.accentGlow),
            ),
          ),
          Expanded(
            child: AdminEntityListView(
              items: items,
              titleOf: (item) => (item['title'] as String?) ?? '',
              imageOf: (item) => item['imageUrl'] as String?,
              subtitleOf: (item) {
                final nutrition = item['nutrition'] as Map<String, dynamic>?;
                return '${nutrition?['calories'] ?? 0} kcal · '
                    '${nutrition?['proteinG'] ?? 0}g protein';
              },
              chipsOf:
                  (item) => [
                    if (item['category'] != null) '${item['category']}',
                    if (item['difficulty'] != null) '${item['difficulty']}',
                  ],
              filters: [
                AdminFilterOption(label: l10n.adminFilterAll),
                for (final category in const [
                  'breakfast',
                  'lunch',
                  'dinner',
                  'snack',
                  'drink',
                ])
                  AdminFilterOption(
                    label: category,
                    matches: (item) => item['category'] == category,
                  ),
              ],
              onRefresh: controller.refresh,
              onEdit:
                  (item) =>
                      context.push(AppRoutes.adminRecipeEditor, extra: item),
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
              emptyIcon: Icons.restaurant_menu_outlined,
              emptyTitle: l10n.adminRecipesEmptyTitle,
              emptyMessage: l10n.adminRecipesEmptyMessage,
              errorMessage: l10n.adminLoadErrorTitle,
            ),
          ),
        ],
      ),
    );
  }
}
