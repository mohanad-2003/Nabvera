import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// Represents "a user" — the gradient/glyph placeholder everywhere no real
/// photo is available (profile, home greeting, workout logs, community
/// posts), or the user's real photo (`User.avatarUrl`) when [imageUrl] is
/// set. Falls back to the placeholder on load failure too.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.radius = 24,
    this.icon = Icons.person_rounded,
    this.borderColor,
    this.borderWidth = 0,
    this.imageUrl,
  });

  final double radius;
  final IconData icon;
  final Color? borderColor;
  final double borderWidth;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final hasPhoto = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: ext.accentGradient,
        border:
            borderWidth > 0
                ? Border.all(
                  color: borderColor ?? Colors.transparent,
                  width: borderWidth,
                )
                : null,
      ),
      child:
          hasPhoto
              ? ClipOval(
                child: Image.network(
                  imageUrl!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Icon(icon, color: ext.onAccent, size: radius),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Icon(icon, color: ext.onAccent, size: radius);
                  },
                ),
              )
              : Icon(icon, color: ext.onAccent, size: radius),
    );
  }
}
