import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/fade_slide_in.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/features/authentication/data/firebase_auth_service.dart';
import 'package:fitness_app/features/profile/presentation/providers/profile_controller.dart';
import 'package:fitness_app/features/profile/presentation/widgets/delete_account_sheet.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_header.dart';
import 'package:fitness_app/features/profile/presentation/widgets/profile_stat_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      // One CustomScrollView: the header/avatar/stats card lives in a
      // SliverToBoxAdapter, and each menu section is its own SliverList —
      // a single real scroll view, so vertical overflow is structurally
      // impossible regardless of device or content length.
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(
              title: l10n.profileMyProfile,
              name: profile.name,
              email: profile.email,
              fitnessLevel: profile.fitnessLevel,
              motivation: l10n.profileMotivation,
              avatarUrl: profile.avatarUrl,
              onBack: null,
              onEdit: () => context.push(AppRoutes.editProfile),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeSlideIn(
              delay: const Duration(milliseconds: 90),
              child: Padding(
                padding: const EdgeInsets.only(top: 22),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 10.0;
                    final columns = constraints.maxWidth >= 420 ? 4 : 2;
                    final itemWidth =
                        (constraints.maxWidth - spacing * (columns - 1)) /
                        columns;
                    final stats = [
                      (
                        Icons.fitness_center_rounded,
                        '${profile.completedWorkouts}',
                        l10n.profileStatWorkouts,
                      ),
                      (
                        Icons.local_fire_department_rounded,
                        '${profile.caloriesBurned}',
                        l10n.profileStatCalories,
                      ),
                      (
                        Icons.calendar_month_rounded,
                        '${profile.trainingDays}',
                        l10n.profileStatDays,
                      ),
                      (
                        Icons.bolt_rounded,
                        '${profile.currentStreak}',
                        l10n.profileStatStreak,
                      ),
                    ];
                    return Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: [
                        for (final stat in stats)
                          SizedBox(
                            width: itemWidth,
                            child: _ProfileStat(
                              icon: stat.$1,
                              value: stat.$2,
                              label: stat.$3,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeSlideIn(
              delay: const Duration(milliseconds: 140),
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ProfileStatRow(profile: profile),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 26),
                PremiumSectionHeader(title: l10n.profileSectionAccount),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SliverList.separated(
            // The Admin Console entry only exists for an admin account —
            // this is a convenience shortcut, not the actual access
            // control: `adminRouteGuard` in app_router.dart is what
            // structurally blocks a non-admin from every /admin route,
            // regardless of whether this tile is shown.
            itemCount: profile.isAdmin ? 4 : 3,
            separatorBuilder: (_, _) => Divider(color: ext.glassBorder),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return ProfileMenuTile(
                    icon: Icons.person_outline_rounded,
                    title: l10n.profileMenuProfile,
                    subtitle: l10n.profileMenuProfileSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.editProfile),
                  );
                case 1:
                  return ProfileMenuTile(
                    icon: Icons.star_border_rounded,
                    title: l10n.profileMenuFavorite,
                    subtitle: l10n.profileMenuFavoriteSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.favorite),
                  );
                case 2:
                  return ProfileMenuTile(
                    icon: Icons.lock_outline_rounded,
                    title: l10n.profileMenuPrivacyPolicy,
                    subtitle: l10n.profileMenuPrivacyPolicySubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.privacy),
                  );
                default:
                  return ProfileMenuTile(
                    icon: Icons.shield_moon_outlined,
                    title: l10n.profileMenuAdminConsole,
                    subtitle: l10n.profileMenuAdminConsoleSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.adminDashboard),
                  );
              }
            },
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                PremiumSectionHeader(title: l10n.profileSectionPreferences),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SliverList.separated(
            itemCount: 3,
            separatorBuilder: (_, _) => Divider(color: ext.glassBorder),
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return ProfileMenuTile(
                    icon: Icons.settings_outlined,
                    title: l10n.profileMenuSetting,
                    subtitle: l10n.profileMenuSettingSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.settings),
                  );
                case 1:
                  return ProfileMenuTile(
                    icon: Icons.support_agent_rounded,
                    title: l10n.profileMenuHelp,
                    subtitle: l10n.profileMenuHelpSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.help),
                  );
                default:
                  return ProfileMenuTile(
                    icon: Icons.logout_rounded,
                    title: l10n.profileMenuLogout,
                    subtitle: l10n.profileMenuLogoutSubtitle,
                    iconColor: ext.danger,
                    flat: true,
                    onTap: () => _showLogoutConfirmation(context, ref),
                  );
              }
            },
          ),
          SliverToBoxAdapter(
            child: FadeSlideIn(
              delay: const Duration(milliseconds: 220),
              child: Padding(
                padding: const EdgeInsets.only(top: 28, bottom: 12),
                child: _DeleteAccountButton(
                  label: l10n.privacyDeleteAccount,
                  onTap: () => showDeleteAccountSheet(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      barrierDismissible: false,
      // Without this, the sheet is pushed onto the shell branch's nested
      // Navigator, whose Overlay sits *below* the outer Scaffold's
      // bottomNavigationBar slot — the floating nav bar then paints over
      // the bottom of the sheet. The root Navigator's Overlay sits above
      // the whole app shell, so the sheet renders fully on top of it.
      useRootNavigator: true,
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ext.cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: ext.glassBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.profileLogoutConfirm,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _LogoutButton(
                        text: l10n.actionCancel,
                        isPrimary: false,
                        onTap: () => dialogContext.pop(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _LogoutButton(
                        text: l10n.profileLogoutYes,
                        isPrimary: true,
                        onTap: () async {
                          dialogContext.pop();
                          await ref.read(firebaseAuthServiceProvider).signOut();
                          ref.invalidate(currentUserProfileProvider);
                          if (context.mounted) context.go(AppRoutes.login);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final accent = ext.accentGlow;

    return Column(
      children: [
        Icon(icon, color: accent, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: ext.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: ext.textMuted, fontSize: 10.5),
        ),
      ],
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: ext.danger.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ext.danger.withValues(alpha: 0.42)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline_rounded, color: ext.danger),
                  const SizedBox(width: 9),
                  Text(
                    label,
                    style: TextStyle(
                      color: ext.danger,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.text,
    required this.isPrimary,
    required this.onTap,
  });
  final String text;
  final bool isPrimary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          gradient: isPrimary ? ext.accentGradient : null,
          color: isPrimary ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(20),
          border: isPrimary ? null : Border.all(color: ext.glassBorder),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isPrimary ? ext.onAccent : ext.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
