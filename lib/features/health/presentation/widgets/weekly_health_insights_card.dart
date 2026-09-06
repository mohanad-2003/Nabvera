import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/health/domain/health_models.dart';
import 'package:nabvera/features/health/presentation/providers/health_preferences_controller.dart';
import 'package:nabvera/features/health/presentation/providers/health_summary_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Weekly health insights section for the Progress/charts page — rule-
/// based only (see `backend/src/services/healthInsightsService.js`),
/// never rendered as medical advice. Renders nothing at all (not even an
/// empty state) when the user hasn't connected health data, so it never
/// clutters Progress with an irrelevant prompt for users who opted out.
class WeeklyHealthInsightsCard extends ConsumerWidget {
  const WeeklyHealthInsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(healthPreferencesControllerProvider);
    final connected = prefs.maybeWhen(data: (p) => p.syncEnabled, orElse: () => false);
    if (!connected) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final summary = ref.watch(healthSummaryControllerProvider);

    return summary.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (overview) => _Content(l10n: l10n, ext: ext, overview: overview),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.l10n, required this.ext, required this.overview});
  final AppLocalizations l10n;
  final AppThemeExtension ext;
  final HealthOverview overview;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.healthInsightsSectionTitle,
            style: theme.textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.directions_walk_rounded, color: ext.accentGlow, size: 20),
              const SizedBox(width: 8),
              Text(
                overview.insights.avgStepsPrevious == null
                    ? '${l10n.healthInsightsStepsAverage}: ${overview.insights.avgStepsCurrent ?? '—'}'
                    : '${l10n.healthInsightsStepsAverage}: ${overview.insights.avgStepsCurrent ?? '—'} (${overview.insights.avgStepsPrevious})',
                style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final code in overview.insights.codes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.insights_rounded, size: 16, color: ext.textMuted),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(healthInsightCodeLabel(l10n, code), style: TextStyle(color: ext.textPrimary, fontSize: 13)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          Text(l10n.healthInsightsDisclaimer, style: TextStyle(color: ext.textMuted, fontSize: 11)),
        ],
      ),
    );
  }
}
