import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/admin/presentation/providers/admin_content_controllers.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Admin console landing page: real content counts (from the same list
/// endpoints every other page uses — no separate stats API exists or is
/// invented here) with a per-tile empty/error state when a fetch fails,
/// and quick links into each content type.
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stats = ref.watch(adminDashboardControllerProvider);

    return AdminScaffold(
      currentTab: AdminDestination.dashboard,
      child: RefreshIndicator(
        onRefresh:
            () => ref.read(adminDashboardControllerProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: [
            AdminPageHeader(
              title: l10n.adminDashboardTitle,
              subtitle: l10n.adminDashboardSubtitle,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  _StatTile(
                    icon: Icons.fitness_center_rounded,
                    label: l10n.adminNavWorkouts,
                    count: stats.workoutCount,
                    onTap: () => context.go(AppRoutes.adminWorkouts),
                  ),
                  _StatTile(
                    icon: Icons.sports_gymnastics_rounded,
                    label: l10n.adminNavExercises,
                    count: stats.exerciseCount,
                    onTap: () => context.go(AppRoutes.adminExercises),
                  ),
                  _StatTile(
                    icon: Icons.restaurant_menu_rounded,
                    label: l10n.adminNavRecipes,
                    count: stats.recipeCount,
                    onTap: () => context.go(AppRoutes.adminRecipes),
                  ),
                  _StatTile(
                    icon: Icons.article_rounded,
                    label: l10n.adminNavArticles,
                    count: stats.articleCount,
                    onTap: () => context.go(AppRoutes.adminArticles),
                  ),
                  _StatTile(
                    icon: Icons.emoji_events_rounded,
                    label: l10n.adminNavChallenges,
                    count: stats.challengeCount,
                    onTap: () => context.go(AppRoutes.adminChallenges),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String label;

  /// `null` means the fetch for this type failed — shown as a dash rather
  /// than a fabricated zero.
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xxl),
      child: Container(
        width: 156,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(color: ext.glassBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: ext.accentGlow, size: 26),
            const SizedBox(height: AppSpacing.md),
            Text(
              count == null ? '—' : '$count',
              style: TextStyle(
                color: ext.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              count == null ? l10n.adminStatUnavailable : label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: ext.textMuted, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
