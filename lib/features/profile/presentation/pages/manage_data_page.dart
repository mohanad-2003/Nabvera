import 'dart:convert';
import 'dart:typed_data';

import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/health/presentation/widgets/health_data_settings_section.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_card.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

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
  // The only toggle this screen ever had a real, functional effect for:
  // read by AnalyticsService before every event send. A camera/location
  // "Permissions" section and a "Personalized recommendations" toggle used
  // to sit here too — pure `setState` stubs with nothing behind them
  // (the app never requests camera or location access at all, and no
  // recommendation code ever read the personalization flag) — removed
  // rather than shipped as decoration. Real notification controls already
  // have their own screen — see NotificationSettingsPage — so a redundant,
  // equally-fake toggle isn't recreated here either.
  late bool _analytics;
  bool _exporting = false;

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
                        iconColor: AppColors.seedViolet,
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
                            onPressed: _exporting ? null : _exportData,
                            icon:
                                _exporting
                                    ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.download_outlined),
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

  /// Real "right to access" export — fetches every collection this user
  /// owns from `GET /users/me/export` (see `UserRepository.exportData`)
  /// and hands the result to the OS share sheet as a JSON file, so the
  /// user can save it, email it, or drop it in cloud storage. Replaces the
  /// old snackbar-only stub that called no endpoint and produced no file.
  Future<void> _exportData() async {
    setState(() => _exporting = true);
    try {
      final data = await ref.read(userRepositoryProvider).exportData();
      final bytes = Uint8List.fromList(
        utf8.encode(const JsonEncoder.withIndent('  ').convert(data)),
      );
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              bytes,
              name: 'nabvera-data-export.json',
              mimeType: 'application/json',
            ),
          ],
        ),
      );
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final message =
          error is ApiException ? error.message : l10n.manageDataExportFailed;
      final ext = Theme.of(context).extension<AppThemeExtension>()!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: ext.cardColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}
