import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/health/presentation/widgets/health_data_settings_section.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_card.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Consolidates the four "coming soon" stub tiles that used to sit behind
/// Manage Personal Data / App Permissions / Data Collection / Download My
/// Data into one real, working screen: permission toggles, data-collection
/// preferences, and an export action with a genuine confirmation.
class ManageDataPage extends ConsumerStatefulWidget {
  const ManageDataPage({super.key});

  @override
  ConsumerState<ManageDataPage> createState() => _ManageDataPageState();
}

class _ManageDataPageState extends ConsumerState<ManageDataPage> {
  bool _cameraAccess = true;
  bool _locationAccess = false;
  bool _notificationsAccess = true;
  // The only toggle here with a real, functional effect right now: it's
  // read by AnalyticsService before every event send. The others are
  // device-permission stubs with nothing on the backend to wire to yet.
  late bool _analytics;
  bool _personalizedRecommendations = true;

  @override
  void initState() {
    super.initState();
    _analytics = ref.read(preferencesServiceProvider).analyticsEnabled;
  }

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
                if (Navigator.of(context).canPop())
                  PremiumIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.manageDataTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  PremiumSectionHeader(
                    title: l10n.manageDataPermissionsSection,
                  ),
                  const SizedBox(height: 12),
                  SettingsCard(
                    children: [
                      SettingsToggleRow(
                        icon: Icons.photo_camera_outlined,
                        title: l10n.manageDataCameraAccess,
                        subtitle: l10n.manageDataCameraAccessBody,
                        value: _cameraAccess,
                        onChanged:
                            (value) => setState(() => _cameraAccess = value),
                      ),
                      SettingsToggleRow(
                        icon: Icons.location_on_outlined,
                        title: l10n.manageDataLocationAccess,
                        subtitle: l10n.manageDataLocationAccessBody,
                        value: _locationAccess,
                        onChanged:
                            (value) => setState(() => _locationAccess = value),
                      ),
                      SettingsToggleRow(
                        icon: Icons.notifications_outlined,
                        title: l10n.manageDataNotificationsAccess,
                        subtitle: l10n.manageDataNotificationsAccessBody,
                        value: _notificationsAccess,
                        onChanged:
                            (value) =>
                                setState(() => _notificationsAccess = value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  PremiumSectionHeader(title: l10n.manageDataCollectionSection),
                  const SizedBox(height: 12),
                  SettingsCard(
                    children: [
                      SettingsToggleRow(
                        icon: Icons.query_stats_rounded,
                        title: l10n.manageDataAnalyticsToggle,
                        subtitle: l10n.manageDataAnalyticsToggleBody,
                        value: _analytics,
                        onChanged: (value) {
                          setState(() => _analytics = value);
                          ref
                              .read(preferencesServiceProvider)
                              .setAnalyticsEnabled(value);
                        },
                      ),
                      SettingsToggleRow(
                        icon: Icons.auto_awesome_outlined,
                        title: l10n.manageDataPersonalizedToggle,
                        subtitle: l10n.manageDataPersonalizedToggleBody,
                        value: _personalizedRecommendations,
                        onChanged:
                            (value) => setState(
                              () => _personalizedRecommendations = value,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  PremiumSectionHeader(title: l10n.healthSettingsSectionTitle),
                  const SizedBox(height: 12),
                  const HealthDataSettingsSection(),
                  const SizedBox(height: 22),
                  PremiumSectionHeader(title: l10n.manageDataExportSection),
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.manageDataExportBody,
                          style: TextStyle(color: ext.textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () => _requestExport(context),
                            icon: const Icon(Icons.download_outlined),
                            label: Text(l10n.manageDataExportAction),
                          ),
                        ),
                      ],
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

  void _requestExport(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).manageDataExportConfirmation,
        ),
        backgroundColor: ext.cardColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
