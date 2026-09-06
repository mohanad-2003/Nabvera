import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/health/data/health_service.dart';
import 'package:nabvera/features/health/presentation/providers/health_sync_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _Step { intro, denied, unavailable }

/// Short health-connection onboarding (Phase 7) — explains exactly what
/// data is used, lets the user pick which types to share, and handles
/// every non-happy path explicitly (denied, Health Connect/HealthKit not
/// available) without ever blocking the rest of the app.
class HealthConnectionPage extends ConsumerStatefulWidget {
  const HealthConnectionPage({super.key});

  @override
  ConsumerState<HealthConnectionPage> createState() => _HealthConnectionPageState();
}

class _HealthConnectionPageState extends ConsumerState<HealthConnectionPage> {
  final Set<HealthDataKind> _selected = {HealthDataKind.steps, HealthDataKind.activity};
  _Step _step = _Step.intro;
  bool _connecting = false;

  Future<void> _connect() async {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).healthConnectionSelectAtLeastOne)),
      );
      return;
    }
    setState(() => _connecting = true);
    final result = await ref.read(healthSyncControllerProvider.notifier).connectAndSync(_selected);
    if (!mounted) return;
    setState(() => _connecting = false);

    switch (result) {
      case HealthConnectResult.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).healthConnectionSuccess)),
        );
        Navigator.of(context).maybePop();
      case HealthConnectResult.permissionDenied:
        setState(() => _step = _Step.denied);
      case HealthConnectResult.platformUnavailable:
        setState(() => _step = _Step.unavailable);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(title: l10n.healthConnectionTitle),
          const SizedBox(height: 20),
          Expanded(
            child: switch (_step) {
              _Step.denied => _MessageState(
                icon: Icons.block_rounded,
                title: l10n.healthConnectionDeniedTitle,
                body: l10n.healthConnectionDeniedBody,
                actionLabel: l10n.actionRetry,
                onAction: () => setState(() => _step = _Step.intro),
              ),
              _Step.unavailable => _MessageState(
                icon: Icons.download_for_offline_outlined,
                title: l10n.healthConnectionUnavailableTitle,
                body: l10n.healthConnectionUnavailableBody,
                actionLabel: l10n.healthConnectionInstallAction,
                onAction: () => ref.read(healthServiceProvider).openPlatformInstall(),
              ),
              _Step.intro => SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.healthConnectionIntroBody, style: TextStyle(color: ext.textMuted, height: 1.5)),
                    const SizedBox(height: 24),
                    _DataTypeTile(
                      icon: Icons.directions_walk_rounded,
                      label: l10n.healthConnectionDataStepsLabel,
                      body: l10n.healthConnectionDataStepsBody,
                      selected: _selected.contains(HealthDataKind.steps),
                      onChanged: (v) => setState(() => v ? _selected.add(HealthDataKind.steps) : _selected.remove(HealthDataKind.steps)),
                    ),
                    _DataTypeTile(
                      icon: Icons.local_fire_department_outlined,
                      label: l10n.healthConnectionDataActivityLabel,
                      body: l10n.healthConnectionDataActivityBody,
                      selected: _selected.contains(HealthDataKind.activity),
                      onChanged: (v) => setState(() => v ? _selected.add(HealthDataKind.activity) : _selected.remove(HealthDataKind.activity)),
                    ),
                    _DataTypeTile(
                      icon: Icons.bedtime_outlined,
                      label: l10n.healthConnectionDataSleepLabel,
                      body: l10n.healthConnectionDataSleepBody,
                      selected: _selected.contains(HealthDataKind.sleep),
                      onChanged: (v) => setState(() => v ? _selected.add(HealthDataKind.sleep) : _selected.remove(HealthDataKind.sleep)),
                    ),
                  ],
                ),
              ),
            },
          ),
          if (_step == _Step.intro) ...[
            const SizedBox(height: 12),
            PrimaryButton(label: l10n.healthConnectionConnectButton, isLoading: _connecting, onPressed: _connecting ? null : _connect),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(l10n.healthConnectionSkip),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DataTypeTile extends StatelessWidget {
  const _DataTypeTile({required this.icon, required this.label, required this.body, required this.selected, required this.onChanged});

  final IconData icon;
  final String label;
  final String body;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? ext.accentGlow : ext.glassBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: ext.accentGlow, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w700)),
                  Text(body, style: TextStyle(color: ext.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Switch(value: selected, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.icon, required this.title, required this.body, required this.actionLabel, required this.onAction});

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: ext.textMuted),
          const SizedBox(height: 16),
          Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(body, textAlign: TextAlign.center, style: TextStyle(color: ext.textMuted)),
          ),
          const SizedBox(height: 20),
          OutlinedButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}
