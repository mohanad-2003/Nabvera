import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:flutter/material.dart';

/// "Today's Nutrition" summary: a calorie ring plus protein/carbs/fat
/// meters and a water-intake row, sitting directly on the page background
/// — the page's own "Recipe of the Day" featured photo card is its one
/// hero card, so this stays a plain section rather than a second boxed
/// card competing with it.
class NutritionSummaryCard extends StatelessWidget {
  const NutritionSummaryCard({super.key, required this.summary});

  final DailyNutritionSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final progress =
        summary.goalCalories == 0
            ? 0.0
            : (summary.consumedCalories / summary.goalCalories).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.nutritionDailySummary,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.nutritionDailySummarySubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ext.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            SizedBox(
              width: 84,
              height: 84,
              child: CustomPaint(
                painter: _CalorieRingPainter(
                  progress: progress,
                  trackColor: ext.glassBorder,
                  gradient: ext.accentGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${summary.consumedCalories}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: ext.textPrimary,
                        ),
                      ),
                      Text(
                        '/${summary.goalCalories}',
                        style: TextStyle(fontSize: 10, color: ext.textMuted),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _MacroMeter(
                label: l10n.nutritionProteinLabel,
                fraction: summary.proteinFraction,
                color: AppColors.seedLime,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MacroMeter(
                label: l10n.nutritionCarbsLabel,
                fraction: summary.carbsFraction,
                color: AppColors.aquaBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MacroMeter(
                label: l10n.nutritionFatLabel,
                fraction: summary.fatFraction,
                color: AppColors.electricOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Icon(Icons.water_drop_rounded, color: AppColors.aquaBlue, size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.nutritionWaterIntakeLabel,
              style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            ),
            const Spacer(),
            Text(
              summary.waterIntake,
              style: TextStyle(
                color: ext.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MacroMeter extends StatelessWidget {
  const _MacroMeter({
    required this.label,
    required this.fraction,
    required this.color,
  });

  final String label;
  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: ext.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: fraction.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: ext.glassBorder,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(fraction.clamp(0.0, 1.0) * 100).round()}%',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: ext.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CalorieRingPainter extends CustomPainter {
  const _CalorieRingPainter({
    required this.progress,
    required this.trackColor,
    required this.gradient,
  });

  final double progress;
  final Color trackColor;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = size.width * 0.11;
    final center = rect.center;
    final radius = (size.width - strokeWidth) / 2;

    final track =
        Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, track);

    final progressPaint =
        Paint()
          ..shader = gradient.createShader(rect)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159265 / 2;
    final sweepAngle = 2 * 3.14159265 * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CalorieRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.gradient != gradient;
}
