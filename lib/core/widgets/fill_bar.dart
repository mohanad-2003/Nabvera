import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Vertical fill-bar chart primitive. Renamed from the legacy `Bar` widget
/// (lib/view/bar.dart) and moved to core since it's a generic chart mark,
/// not workout-specific.
class FillBar extends StatelessWidget {
  const FillBar({super.key, required this.fillFraction, this.height = 147});

  final double fillFraction;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            FractionallySizedBox(
              heightFactor: fillFraction.clamp(0.0, 1.0),
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.seedLime, AppColors.electricOrange],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
