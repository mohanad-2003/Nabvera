import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Mobile-only hub for the four content types that don't fit on the
/// condensed bottom nav (see `AdminScaffold`'s "More" tab) — Exercises,
/// Recipes, Articles, Challenges. Wide screens never see this page: their
/// [NavigationRail] lists all seven destinations directly.
class AdminMorePage extends StatelessWidget {
  const AdminMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(title: l10n.adminNavMore, showBack: true),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                _MoreTile(
                  icon: Icons.sports_gymnastics_outlined,
                  title: l10n.adminNavExercises,
                  onTap: () => context.push(AppRoutes.adminExercises),
                ),
                _MoreTile(
                  icon: Icons.restaurant_menu_outlined,
                  title: l10n.adminNavRecipes,
                  onTap: () => context.push(AppRoutes.adminRecipes),
                ),
                _MoreTile(
                  icon: Icons.article_outlined,
                  title: l10n.adminNavArticles,
                  onTap: () => context.push(AppRoutes.adminArticles),
                ),
                _MoreTile(
                  icon: Icons.emoji_events_outlined,
                  title: l10n.adminNavChallenges,
                  onTap: () => context.push(AppRoutes.adminChallenges),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  const _MoreTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Material(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xxl),
              border: Border.all(color: ext.glassBorder),
            ),
            child: Row(
              children: [
                Icon(icon, color: ext.accentGlow),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: ext.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
