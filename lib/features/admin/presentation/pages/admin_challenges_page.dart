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

/// List → search → add/delete, using only `/api/challenges` — like
/// Articles, the backend never added an update endpoint (see
/// `backend/src/routes/challengeRoutes.js`), so there's no edit action.
class AdminChallengesPage extends ConsumerWidget {
  const AdminChallengesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final items = ref.watch(adminChallengesControllerProvider);
    final controller = ref.read(adminChallengesControllerProvider.notifier);

    return AdminScaffold(
      currentTab: AdminDestination.challenges,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title: l10n.adminNavChallenges,
            showBack: true,
            trailing: IconButton.filled(
              onPressed: () => context.push(AppRoutes.adminChallengeEditor),
              icon: const Icon(Icons.add_rounded),
              style: IconButton.styleFrom(backgroundColor: ext.accentGlow),
            ),
          ),
          Expanded(
            child: AdminEntityListView(
              items: items,
              titleOf: (item) => (item['name'] as String?) ?? '',
              imageOf: (item) => item['imageUrl'] as String?,
              subtitleOf: (item) => item['durationLabel'] as String?,
              chipsOf:
                  (item) => [
                    if (item['caloriesLabel'] != null)
                      '${item['caloriesLabel']}',
                    if (item['isFeatured'] == true) l10n.adminFeaturedBadge,
                  ],
              onRefresh: controller.refresh,
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
              emptyIcon: Icons.emoji_events_outlined,
              emptyTitle: l10n.adminChallengesEmptyTitle,
              emptyMessage: l10n.adminChallengesEmptyMessage,
              errorMessage: l10n.adminLoadErrorTitle,
            ),
          ),
        ],
      ),
    );
  }
}
