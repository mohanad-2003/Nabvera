import 'package:flutter/material.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_formatters.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/nutrition_surface.dart';

/// "Your nutrition today": the Nutrition page's primary section. Leads with
/// the calories left (or how far over the goal the user is), then consumed /
/// goal, then protein / carbs / fat as grams consumed / goal.
///
/// Everything shown comes from [DailyNutritionSummary] as the API reported
/// it; progress bars are clamped to 0..1 for drawing only, and a missing
/// value is shown as "not available", never as 0.
class NutritionSummaryCard extends StatelessWidget {
  const NutritionSummaryCard({
    super.key,
    required this.summary,
    this.onSetGoals,
    this.onRetry,
  });

  final DailyNutritionSummary summary;

  /// Shown as a CTA row whenever [DailyNutritionSummary.hasPersonalGoal]
  /// is false, so a guessed/fallback goal is never presented as the
  /// user's own — omit to hide it entirely.
  final VoidCallback? onSetGoals;

  /// Retry action for the "couldn't load" state.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    final title = Text(
      l10n.nutritionDailySummary,
      style: theme.textTheme.titleLarge?.copyWith(
        color: ext.textPrimary,
        fontWeight: FontWeight.w900,
      ),
    );

    if (summary.isLoading) {
      return NutritionSurface(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                child: Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (summary.loadFailed) {
      return NutritionSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.nutritionSummaryUnavailable,
              style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.md),
              NutritionActionButton(
                label: l10n.actionRetry,
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      );
    }

    return NutritionSurface(
      padding: const EdgeInsets.all(AppSpacing.lg + 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: title),
              if (!summary.hasPersonalGoal) ...[
                const SizedBox(width: AppSpacing.sm),
                _GoalTag(
                  label:
                      summary.goalSource == 'estimate'
                          ? l10n.nutritionGoalTagEstimate
                          : l10n.nutritionGoalTagDefault,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _CalorieHeadline(summary: summary),
          const SizedBox(height: AppSpacing.md),
          if (summary.hasCalorieGoal)
            Semantics(
              label: l10n.nutritionCalorieProgressSemantics(
                summary.consumedCalories,
                summary.goalCalories,
              ),
              child: ExcludeSemantics(
                child: NutritionProgressBar(
                  value: summary.calorieProgress,
                  color:
                      summary.isOverCalorieGoal ? ext.warning : ext.accentGlow,
                  height: 10,
                ),
              ),
            ),
          if (summary.hasCalorieGoal) const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Stat(
                  label: l10n.nutritionCaloriesConsumedLabel,
                  value: l10n.nutritionCaloriesValue(summary.consumedCalories),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _Stat(
                  label: l10n.nutritionCaloriesGoalLabel,
                  value:
                      summary.hasCalorieGoal
                          ? l10n.nutritionCaloriesValue(summary.goalCalories)
                          : l10n.nutritionDataUnavailable,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _MacroSection(summary: summary),
          if (!summary.hasPersonalGoal && onSetGoals != null) ...[
            const SizedBox(height: AppSpacing.lg),
            _SetGoalsRow(onTap: onSetGoals!),
          ],
        ],
      ),
    );
  }
}

class _CalorieHeadline extends StatelessWidget {
  const _CalorieHeadline({required this.summary});

  final DailyNutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    final String caption;
    final int value;
    if (!summary.hasCalorieGoal) {
      caption = l10n.nutritionCaloriesConsumedTodayLabel;
      value = summary.consumedCalories;
    } else if (summary.isOverCalorieGoal) {
      caption = l10n.nutritionCaloriesOverGoalLabel;
      value = summary.caloriesOverGoal;
    } else {
      caption = l10n.nutritionCaloriesRemainingLabel;
      value = summary.caloriesRemaining ?? 0;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          caption,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ext.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$value',
                style: theme.textTheme.displaySmall?.copyWith(
                  color:
                      summary.isOverCalorieGoal ? ext.warning : ext.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: ' ${l10n.nutritionCaloriesUnit}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: ext.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: ext.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _GoalTag extends StatelessWidget {
  const _GoalTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: ext.accentGlow.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: ext.textPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MacroSection extends StatelessWidget {
  const _MacroSection({required this.summary});

  final DailyNutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    final macros = [
      _MacroData(l10n.nutritionProteinLabel, summary.protein, ext.accentGlow),
      _MacroData(l10n.nutritionCarbsLabel, summary.carbs, ext.success),
      _MacroData(l10n.nutritionFatLabel, summary.fat, ext.warning),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final textScale = MediaQuery.textScalerOf(context).scale(12) / 12;
        final stacked = textScale > 1.15 || constraints.maxWidth < 270;

        if (stacked) {
          return Column(
            children: [
              for (var i = 0; i < macros.length; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.md),
                _MacroMeter(data: macros[i], inline: true),
              ],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < macros.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              Expanded(child: _MacroMeter(data: macros[i])),
            ],
          ],
        );
      },
    );
  }
}

class _MacroData {
  const _MacroData(this.label, this.intake, this.color);

  final String label;
  final MacroIntake intake;
  final Color color;
}

class _MacroMeter extends StatelessWidget {
  const _MacroMeter({required this.data, this.inline = false});

  final _MacroData data;

  /// Label and value share one row (stacked layout) instead of two lines.
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    final text = macroIntakeText(l10n, data.intake);
    final label = Text(
      data.label,
      style: theme.textTheme.labelMedium?.copyWith(
        color: ext.textMuted,
        fontWeight: FontWeight.w700,
      ),
    );
    final value = Text(
      text ?? '—',
      style: theme.textTheme.labelLarge?.copyWith(
        color: ext.textPrimary,
        fontWeight: FontWeight.w800,
      ),
    );

    return Semantics(
      container: true,
      label: '${data.label}: ${text ?? l10n.nutritionDataUnavailable}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (inline)
              Row(
                children: [
                  Expanded(child: label),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(child: value),
                ],
              )
            else ...[
              label,
              const SizedBox(height: 2),
              value,
            ],
            const SizedBox(height: 6),
            NutritionProgressBar(
              value: data.intake.progress,
              color: data.color,
            ),
          ],
        ),
      ),
    );
  }
}

class _SetGoalsRow extends StatelessWidget {
  const _SetGoalsRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final radius = BorderRadius.circular(AppRadius.md);

    return Semantics(
      button: true,
      child: Material(
        color: ext.accentGlow.withValues(alpha: 0.1),
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: kNutritionTapTarget),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, color: ext.accentGlow, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.nutritionSetGoalsCta,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Directionality.of(context) == TextDirection.rtl
                        ? Icons.chevron_left_rounded
                        : Icons.chevron_right_rounded,
                    color: ext.textMuted,
                    size: 20,
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
