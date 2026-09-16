import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/profile/presentation/pages/help_page.dart';
import 'package:nabvera/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Privacy & data-control screen, reachable from Profile → Privacy Policy.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return PremiumScaffold(
      child: FadeSlideIn(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (context.canPop())
                  PremiumBackButton(onTap: () => context.pop()),
                const SizedBox(width: 12),
                Text(
                  l10n.privacyTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  PremiumSectionHeader(title: l10n.privacySectionLegal),
                  const SizedBox(height: 12),
                  ProfileMenuTile(
                    icon: Icons.policy_outlined,
                    title: l10n.privacyPolicy,
                    subtitle: l10n.privacyPolicySubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.privacyPolicy),
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuTile(
                    icon: Icons.description_outlined,
                    title: l10n.privacyTerms,
                    subtitle: l10n.privacyTermsSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.termsAndConditions),
                  ),
                  const SizedBox(height: 22),
                  PremiumSectionHeader(title: l10n.privacySectionYourData),
                  const SizedBox(height: 12),
                  ProfileMenuTile(
                    icon: Icons.manage_accounts_outlined,
                    title: l10n.privacyManagePersonalData,
                    subtitle: l10n.privacyManagePersonalDataSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.manageData),
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuTile(
                    icon: Icons.admin_panel_settings_outlined,
                    title: l10n.privacyAppPermissions,
                    subtitle: l10n.privacyAppPermissionsSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.manageData),
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuTile(
                    icon: Icons.data_usage_outlined,
                    title: l10n.privacyDataCollection,
                    subtitle: l10n.privacyDataCollectionSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.manageData),
                  ),
                  const SizedBox(height: 10),
                  ProfileMenuTile(
                    icon: Icons.download_outlined,
                    title: l10n.privacyDownloadMyData,
                    subtitle: l10n.privacyDownloadMyDataSubtitle,
                    flat: true,
                    onTap: () => context.push(AppRoutes.manageData),
                  ),
                  ProfileMenuTile(
                    icon: Icons.support_agent_rounded,
                    title: l10n.privacyContactSupport,
                    subtitle: l10n.privacyContactSupportSubtitle,
                    flat: true,
                    onTap:
                        () => context.push(
                          AppRoutes.help,
                          extra: const HelpPageArgs(startOnContact: true),
                        ),
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
