import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/pressable_scale.dart';
import 'package:nabvera/features/workout/domain/difficulty_rating.dart';
import 'package:flutter/material.dart';

/// Shown right after "Finish Workout" — a quick, skippable 4-option
/// difficulty check-in. Returns the chosen [DifficultyRating], or `null`
/// if the user dismisses the sheet or taps Skip.
Future<DifficultyRating?> showWorkoutRatingSheet(BuildContext context) {
  final ext = Theme.of(context).extension<AppThemeExtension>()!;
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<DifficultyRating?>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: ext.cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: ext.glassBorder,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                l10n.workoutRatingTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: ext.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.workoutRatingSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: ext.textMuted),
              ),
              const SizedBox(height: 20),
              _RatingOption(
                icon: Icons.sentiment_very_satisfied_rounded,
                color: AppColors.seedLime,
                label: l10n.workoutRatingTooEasy,
                onTap:
                    () => Navigator.of(
                      sheetContext,
                    ).pop(DifficultyRating.tooEasy),
              ),
              const SizedBox(height: 10),
              _RatingOption(
                icon: Icons.sentiment_satisfied_rounded,
                color: AppColors.aquaBlue,
                label: l10n.workoutRatingAppropriate,
                onTap:
                    () => Navigator.of(
                      sheetContext,
                    ).pop(DifficultyRating.appropriate),
              ),
              const SizedBox(height: 10),
              _RatingOption(
                icon: Icons.sentiment_dissatisfied_rounded,
                color: AppColors.electricOrange,
                label: l10n.workoutRatingHard,
                onTap:
                    () => Navigator.of(sheetContext).pop(DifficultyRating.hard),
              ),
              const SizedBox(height: 10),
              _RatingOption(
                icon: Icons.sentiment_very_dissatisfied_rounded,
                color: ext.danger,
                label: l10n.workoutRatingTooHard,
                onTap:
                    () => Navigator.of(
                      sheetContext,
                    ).pop(DifficultyRating.tooHard),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(null),
                child: Text(
                  l10n.actionSkip,
                  style: TextStyle(
                    color: ext.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _RatingOption extends StatelessWidget {
  const _RatingOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.22)),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: ext.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
