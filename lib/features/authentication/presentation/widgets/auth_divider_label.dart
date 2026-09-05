import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';

/// "— or continue with —" style divider, shared by login and signup
/// (previously duplicated as private `_DividerLabel` widgets in each page).
class AuthDividerLabel extends StatelessWidget {
  const AuthDividerLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Row(
      children: [
        Expanded(child: Divider(color: ext.glassBorder)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: TextStyle(color: ext.textMuted)),
        ),
        Expanded(child: Divider(color: ext.glassBorder)),
      ],
    );
  }
}
