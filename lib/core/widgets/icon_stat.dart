import 'package:flutter/material.dart';

import 'smart_image.dart';

/// Small icon+text stat (time/calories/reps/etc.), duplicated as a private
/// `_buildIconText` method in ~8 legacy workout screens.
class IconStat extends StatelessWidget {
  const IconStat({
    super.key,
    required this.icon,
    required this.label,
    this.color = Colors.white,
    this.iconSize = 14,
    this.fontSize = 12,
  });

  final String icon;
  final String label;
  final Color color;
  final double iconSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmartImage(icon, width: iconSize, height: iconSize, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: color, fontSize: fontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
