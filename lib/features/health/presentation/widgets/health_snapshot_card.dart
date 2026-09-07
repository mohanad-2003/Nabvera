import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/health/presentation/providers/health_preferences_controller.dart';
import 'package:nabvera/features/health/presentation/providers/health_summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Small Home-tab card: today's steps/active minutes and sync status when
/// connected, or an honest "not connected" prompt otherwise (never fake
/// data, never blocks the rest of Home from rendering — see
/// [asyncPrefs.maybeWhen]'s `orElse` returning the not-connected state).
class HealthSnapshotCard extends ConsumerWidget {
  const HealthSnapshotCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final prefs = ref.watch(healthPreferencesControllerProvider);
    final connected = prefs.maybeWhen(data: (p) => p.syncEnabled, orElse: () => false);

    return connected
        ? _ConnectedContent(l10n: l10n, ext: ext)
        : _NotConnected(l10n: l10n, ext: ext);
  }
}

class _ConnectedContent extends ConsumerWidget {
  const _ConnectedContent({required this.l10n, required this.ext});
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(healthSummaryControllerProvider);
    return summary.when(
      loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
      error: (_, _) => Text(l10n.healthSnapshotNotConnected, style: TextStyle(color: ext.textMuted, fontSize: 12)),
      data: (overview) {
        final today = overview.today;
        return Row(
          children: [
            Icon(Icons.favorite_rounded, color: ext.accentGlow, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.healthSnapshotTitle, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
                  const SizedBox(height: 2),
                  Text(
                    '${today?.steps ?? '—'} ${l10n.healthSnapshotStepsLabel} · ${today?.activeMinutes ?? '—'} ${l10n.healthSnapshotActiveMinutesLabel}',
                    style: TextStyle(color: ext.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _NotConnected extends StatelessWidget {
  const _NotConnected({required this.l10n, required this.ext});
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.favorite_border_rounded, color: ext.textMuted, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(l10n.healthSnapshotNotConnected, style: TextStyle(color: ext.textMuted, fontSize: 12)),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.healthConnection),
          child: Text(l10n.healthSnapshotConnectCta),
        ),
      ],
    );
  }
}
