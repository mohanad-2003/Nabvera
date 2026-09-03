import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/user_avatar.dart';
import 'package:fitness_app/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:fitness_app/features/admin/presentation/widgets/admin_scaffold.dart';
import 'package:fitness_app/features/authentication/data/firebase_auth_service.dart';
import 'package:fitness_app/features/profile/presentation/providers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The Admin console's own small profile page — who's signed in, a badge
/// confirming the admin role, a way back to the ordinary user app, and
/// sign out. Deliberately not a full settings page: user-management and
/// role changes aren't implemented on the backend, so there's nothing to
/// manage here beyond identity and navigation.
class AdminProfilePage extends ConsumerWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final profile = ref.watch(currentUserProfileProvider);

    return AdminScaffold(
      currentTab: AdminDestination.profile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(title: l10n.adminNavProfile),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              children: [
                Center(
                  child: Column(
                    children: [
                      UserAvatar(radius: 44, imageUrl: profile.avatarUrl),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        profile.name,
                        style: TextStyle(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profile.email,
                        style: TextStyle(color: ext.textMuted, fontSize: 13),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ext.accentGlow.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                        ),
                        child: Text(
                          l10n.adminRoleBadge,
                          style: TextStyle(
                            color: ext.accentGlow,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                _ProfileAction(
                  icon: Icons.home_outlined,
                  label: l10n.adminBackToApp,
                  onTap: () => context.go(AppRoutes.home),
                ),
                const SizedBox(height: AppSpacing.md),
                _ProfileAction(
                  icon: Icons.logout_rounded,
                  label: l10n.profileMenuLogout,
                  iconColor: ext.danger,
                  onTap: () async {
                    await signOutCurrentUser(ref.read);
                    ref.invalidate(currentUserProfileProvider);
                    if (context.mounted) context.go(AppRoutes.login);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Material(
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
              Icon(icon, color: iconColor ?? ext.textPrimary),
              const SizedBox(width: AppSpacing.md),
              Text(
                label,
                style: TextStyle(
                  color: iconColor ?? ext.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
