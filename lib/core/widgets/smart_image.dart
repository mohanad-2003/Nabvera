import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const _smartImageFallback = 'assets/workout.png';

/// For call sites that need an `ImageProvider` rather than a widget (e.g.
/// `DecorationImage`, which can't use [SmartImage] directly) — same
/// asset-vs-URL switch, but without a runtime fallback on load failure
/// (`DecorationImage` has no error-widget hook; its `onError` callback
/// fires without a way to swap the provider it's already attached to).
/// Network URLs go through `CachedNetworkImageProvider` so they share the
/// same on-disk cache as [SmartImage] instead of being re-fetched.
/// Prefer [SmartImage] itself wherever a plain child widget will do.
ImageProvider smartImageProvider(String path) {
  final isNetwork = path.startsWith('http://') || path.startsWith('https://');
  if (isNetwork) return CachedNetworkImageProvider(path);
  return AssetImage(path.isEmpty ? _smartImageFallback : path);
}

/// Drop-in replacement for `Image.asset` that also handles real URLs.
/// Backend documents (`Workout.coverImageUrl`, `Exercise.imageUrl`,
/// `Recipe.imageUrl`, etc.) hold either a bundled fallback asset path (see
/// e.g. `WorkoutListItem.fromJson`, which defaults to `assets/workout.png`
/// when no URL is set) or a real `http(s)://` URL once content has a photo.
/// Falls back to the generic placeholder asset on any load failure —
/// broken link, offline, unsupported format.
///
/// Network images are cached to disk (via `cached_network_image`), not
/// just held in the in-memory `ImageCache` — a photo already downloaded in
/// a prior app session loads instantly and without a network request
/// instead of being re-fetched every cold start.
class SmartImage extends StatelessWidget {
  const SmartImage(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.color,
    this.colorBlendMode,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  /// Tint applied to the loaded image (e.g. an icon recolored to match
  /// theme text, or a dark scrim over a hero photo) — passed straight
  /// through to the underlying `Image`.
  final Color? color;
  final BlendMode? colorBlendMode;

  static const _fallback = _smartImageFallback;

  bool get _isNetwork =>
      path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        // Same fallback shown for both an in-flight fetch and a failed
        // one, matching the old `Image.network` frameBuilder/errorBuilder
        // pair — no spinner, just the placeholder swapped for the real
        // photo once it lands (from cache or network).
        placeholder: (context, url) => _fallbackImage(),
        errorWidget: (context, url, error) => _fallbackImage(),
      );
    }
    return Image.asset(
      path.isEmpty ? _fallback : path,
      fit: fit,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) => _fallbackImage(),
    );
  }

  Widget _fallbackImage() => Image.asset(
    _fallback,
    fit: fit,
    width: width,
    height: height,
    color: color,
    colorBlendMode: colorBlendMode,
  );
}
