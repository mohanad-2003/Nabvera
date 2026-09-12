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

/// List → search → add/edit/delete, using `/api/articles`.
class AdminArticlesPage extends ConsumerWidget {
  const AdminArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final items = ref.watch(adminArticlesControllerProvider);
    final controller = ref.read(adminArticlesControllerProvider.notifier);

    return AdminScaffold(
      currentTab: AdminDestination.articles,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: l10n.adminNavArticles,
            showBack: true,
            trailing: IconButton.filled(
              onPressed: () => context.push(AppRoutes.adminArticleEditor),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(backgroundColor: ext.accentGlow),
            ),
          ),
          Expanded(
            child: AdminEntityListView(
              items: items,
              titleOf: (item) => (item['title'] as String?) ?? '',
              imageOf: (item) => item['imageUrl'] as String?,
              subtitleOf: (item) => item['description'] as String?,
              chipsOf:
                  (item) => [
                    if (item['category'] != null) '${item['category']}',
                    '${item['readTimeMinutes'] ?? 3} min read',
                  ],
              onRefresh: controller.refresh,
              onEdit:
                  (item) =>
                      context.push(AppRoutes.adminArticleEditor, extra: item),
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
              emptyIcon: Icons.article_outlined,
              emptyTitle: l10n.adminArticlesEmptyTitle,
              emptyMessage: l10n.adminArticlesEmptyMessage,
              errorMessage: l10n.adminLoadErrorTitle,
            ),
          ),
        ],
      ),
    );
  }
}
