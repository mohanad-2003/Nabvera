import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_formatters.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_surface.dart';

/// "Water today": amount drunk against the goal, plus an "Add water" button
/// (which opens the existing log-water sheet — this card never saves
/// anything itself).
///
/// Amounts come from the API's raw millilitres. When those aren't available
/// it falls back to the cup units [DailyNutritionSummary] already exposes,
/// rather than turning rounded cups back into a precise-looking volume.
class NutritionWaterCard extends StatelessWidget {
  const NutritionWaterCard({
    super.key,
    required this.summary,
    required this.onAddWater,
  });

  final DailyNutritionSummary summary;
  final VoidCallback onAddWater;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    // Nothing real to show yet (first load running or failed) — the summary
    // card above already explains that, so don't show a made-up 0 here.
    if (summary.isLoading || summary.loadFailed) {
      return const SizedBox.shrink();
    }

    final amount =
        waterIntakeText(l10n, summary.waterConsumedMl, summary.waterGoalMl) ??
        summary.localizedWaterIntake(context);
    final progress = summary.waterProgress;

    final info = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.water_drop_rounded,
                color: ext.success,
                size: 20,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l10n.nutritionWaterToday,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: theme.textTheme.titleMedium?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (progress != null) ...[
          const SizedBox(height: AppSpacing.sm),
          ExcludeSemantics(
            child: NutritionProgressBar(value: progress, color: ext.success),
          ),
        ],
      ],
    );

    return NutritionSurface(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
          final stacked = textScale > 1.2 || constraints.maxWidth < 280;
          final button = NutritionActionButton(
            label: l10n.nutritionAddWater,
            icon: Icons.add_rounded,
            onPressed: onAddWater,
            expand: stacked,
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [info, const SizedBox(height: AppSpacing.md), button],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: info),
              const SizedBox(width: AppSpacing.md),
              button,
            ],
          );
        },
      ),
    );
  }
}
