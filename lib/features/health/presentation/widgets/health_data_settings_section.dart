import 'package:intl/intl.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/health/presentation/providers/health_preferences_controller.dart';
import 'package:nabvera/features/health/presentation/providers/health_sync_controller.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_card.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_toggle_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// The "Health Data" section on Manage Data — the real, backend-backed
/// counterpart to the rest of that page's settings. Every toggle here has
/// an actual effect (see [HealthPreferencesController]), unlike the
/// page's other permission stubs.
class HealthDataSettingsSection extends ConsumerWidget {
  const HealthDataSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final asyncPrefs = ref.watch(healthPreferencesControllerProvider);

    return asyncPrefs.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (prefs) {
        final notifier = ref.read(healthPreferencesControllerProvider.notifier);
        return SettingsCard(
          children: [
            SettingsToggleRow(
              icon: Icons.favorite_outline_rounded,
              title: l10n.healthSettingsSyncToggle,
              subtitle: l10n.healthSettingsSyncToggleBody,
              value: prefs.syncEnabled,
              onChanged: (value) async {
                if (value) {
                  context.push(AppRoutes.healthConnection);
                } else {
                  await notifier.disableSync();
                }
              },
            ),
            if (prefs.syncEnabled) ...[
              SettingsToggleRow(
                icon: Icons.directions_walk_rounded,
                title: l10n.healthSettingsStepsToggle,
                subtitle: '',
                value: prefs.shareSteps,
                onChanged: (v) => notifier.save(prefs.copyWith(shareSteps: v)),
              ),
              SettingsToggleRow(
                icon: Icons.local_fire_department_outlined,
                title: l10n.healthSettingsActivityToggle,
                subtitle: '',
                value: prefs.shareActivity,
                onChanged: (v) => notifier.save(prefs.copyWith(shareActivity: v)),
              ),
              SettingsToggleRow(
                icon: Icons.bedtime_outlined,
                title: l10n.healthSettingsSleepToggle,
                subtitle: '',
                value: prefs.shareSleep,
                onChanged: (v) => notifier.save(prefs.copyWith(shareSleep: v)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.sync_rounded, size: 16, color: ext.textMuted),
                    const SizedBox(width: 8),
                    Text(
                      prefs.lastSyncedAt == null
                          ? l10n.healthSettingsLastSyncedNever
                          : l10n.healthSettingsLastSynced(DateFormat.yMMMd().add_jm().format(prefs.lastSyncedAt!)),
                      style: TextStyle(color: ext.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context, ref),
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(l10n.healthSettingsDeleteButton),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.healthSettingsDeleteConfirmTitle),
        content: Text(l10n.healthSettingsDeleteConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.actionCancel)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.healthSettingsDeleteButton)),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await ref.read(healthSyncControllerProvider.notifier).disconnectAndDeleteData();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.healthSettingsDeleteSuccess)));
    }
  }
}
