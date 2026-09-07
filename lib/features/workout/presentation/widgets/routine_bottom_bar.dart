import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class RoutineStat {
  const RoutineStat({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;
}

/// Sticky footer for Create Routine: a compact inline summary (exercise
/// count, duration, calories, days — separated by hairlines, not boxed)
/// plus the primary action, pinned below the scrollable content via
/// [PremiumScaffold.bottomBar] so it's always reachable without scrolling
/// to the end of a long exercise list.
class RoutineBottomBar extends StatelessWidget {
  const RoutineBottomBar({
    super.key,
    required this.stats,
    required this.buttonLabel,
    required this.isLoading,
    required this.onPressed,
    this.errorText,
  });

  final List<RoutineStat> stats;
  final String buttonLabel;
  final bool isLoading;
  final VoidCallback onPressed;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: ext.cardColor,
        border: Border(top: BorderSide(color: ext.glassBorder)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  for (var i = 0; i < stats.length; i++) ...[
                    if (i != 0)
                      Container(width: 1, height: 28, color: ext.glassBorder, margin: const EdgeInsets.symmetric(horizontal: 10)),
                    Expanded(child: _StatItem(stat: stats[i], ext: ext)),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              if (errorText != null) ...[
                Text(errorText!, style: TextStyle(color: ext.danger, fontSize: 12.5)),
                const SizedBox(height: 10),
              ],
              PrimaryButton(label: buttonLabel, isLoading: isLoading, onPressed: onPressed),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.stat, required this.ext});

  final RoutineStat stat;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(stat.icon, color: ext.accentGlow, size: 18),
        const SizedBox(height: 4),
        Text(
          stat.value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w900, fontSize: 13),
        ),
        Text(
          stat.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: ext.textMuted, fontSize: 10),
        ),
      ],
    );
  }
}
