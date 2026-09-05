import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/workout/presentation/providers/workout_progress_controller.dart';
import 'package:flutter/material.dart';

/// The Workout Log / Charts tab switcher shared by [WorkoutLogsPage] and
/// [CategoryChartsPage] (previously duplicated in both legacy screens).
class ProgressTabBar extends StatelessWidget {
  const ProgressTabBar({
    super.key,
    required this.selected,
    this.onLogsTap,
    this.onChartsTap,
  });

  final ProgressTab selected;
  final VoidCallback? onLogsTap;
  final VoidCallback? onChartsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _tab(context, l10n.progressTabLogs, ProgressTab.logs, onLogsTap),
        const SizedBox(width: 16),
        _tab(context, l10n.progressTabCharts, ProgressTab.charts, onChartsTap),
      ],
    );
  }

  Widget _tab(
    BuildContext context,
    String label,
    ProgressTab tab,
    VoidCallback? onTap,
  ) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final isSelected = tab == selected;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 151,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? theme.colorScheme.primary : ext.glassFill,
          border: isSelected ? null : Border.all(color: ext.glassBorder),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color:
                  isSelected
                      ? theme.colorScheme.onPrimary
                      : ext.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
