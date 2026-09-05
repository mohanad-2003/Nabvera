import 'package:flutter/material.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';


/// Shared frosted-glass card surface for auth form panels — replaces the
/// decoration block that used to be duplicated in every auth page.
class AuthGlassCard extends StatelessWidget {
  const AuthGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: ext.glassBorder),
        boxShadow:
            theme.brightness == Brightness.dark
                ? const []
                : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 26,
                    offset: const Offset(0, 12),
                  ),
                ],
      ),
      child: child,
    );
  }
}
