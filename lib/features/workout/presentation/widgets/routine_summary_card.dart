import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

class _StatData {
  const _StatData(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

/// Premium stat grid summarizing the routine being built: exercise count,
/// total duration, estimated calories, and training-day count. Lays out as
/// 2 columns on phones and 4 in a single row once the card is wide enough
/// (tablets), computed from the card's own constraints rather than a fixed
/// device breakpoint.
class RoutineSummaryCard extends StatelessWidget {
  const RoutineSummaryCard({
    super.key,
    required this.title,
    required this.exercisesLabel,
    required this.exercisesValue,
    required this.durationLabel,
    required this.durationValue,
    required this.caloriesLabel,
    required this.caloriesValue,
    required this.daysLabel,
    required this.daysValue,
  });

  final String title;
  final String exercisesLabel;
  final String exercisesValue;
  final String durationLabel;
  final String durationValue;
  final String caloriesLabel;
  final String caloriesValue;
  final String daysLabel;
  final String daysValue;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final stats = [
      _StatData(Icons.fitness_center_rounded, exercisesLabel, exercisesValue),
      _StatData(Icons.timer_outlined, durationLabel, durationValue),
      _StatData(
        Icons.local_fire_department_rounded,
        caloriesLabel,
        caloriesValue,
      ),
      _StatData(Icons.calendar_month_rounded, daysLabel, daysValue),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 14.0;
              final columns = constraints.maxWidth >= 420 ? 4 : 2;
              final itemWidth =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final stat in stats)
                    SizedBox(
                      width: itemWidth,
                      child: _Stat(
                        icon: stat.icon,
                        label: stat.label,
                        value: stat.value,
                        ext: ext,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.value,
    required this.ext,
  });

  final IconData icon;
  final String label;
  final String value;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: ext.accentGlow.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ext.accentGlow, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: ext.textMuted, fontSize: 10.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
