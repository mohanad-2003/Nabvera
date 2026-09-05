import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Groups settings rows with a hairline divider and no enclosing surface.
class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: padding,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i != 0) Divider(color: ext.glassBorder, height: 1),
            children[i],
          ],
        ],
      ),
    );
  }
}
