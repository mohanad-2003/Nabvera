import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
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
    this.imageBytes,
  });

  final double radius;
  final IconData icon;
  final Color? borderColor;
  final double borderWidth;
  final String? imageUrl;

  final Uint8List? imageBytes;
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
          imageBytes != null
              ? ClipOval(
                child: Image.memory(
                  imageBytes!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                ),
              )
              : hasPhoto
                  ? ClipOval(
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          Icon(icon, color: ext.onAccent, size: radius),
                  errorWidget:
                      (context, url, error) =>
                          Icon(icon, color: ext.onAccent, size: radius),
                ),
              )
              : Icon(icon, color: ext.onAccent, size: radius),
    );
  }
}
