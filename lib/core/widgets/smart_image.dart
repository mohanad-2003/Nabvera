import 'package:flutter/material.dart';

const _smartImageFallback = 'assets/workout.png';

/// For call sites that need an `ImageProvider` rather than a widget (e.g.
/// `DecorationImage`, which can't use [SmartImage] directly) — same
/// asset-vs-URL switch, but without a runtime fallback on load failure
/// (`DecorationImage` has no error-widget hook; its `onError` callback
/// fires without a way to swap the provider it's already attached to).
/// Prefer [SmartImage] itself wherever a plain child widget will do.
ImageProvider smartImageProvider(String path) {
  final isNetwork = path.startsWith('http://') || path.startsWith('https://');
  if (isNetwork) return NetworkImage(path);
  return AssetImage(path.isEmpty ? _smartImageFallback : path);
}

/// Drop-in replacement for `Image.asset` that also handles real URLs.
/// Backend documents (`Workout.coverImageUrl`, `Exercise.imageUrl`,
/// `Recipe.imageUrl`, etc.) hold either a bundled fallback asset path (see
/// e.g. `WorkoutListItem.fromJson`, which defaults to `assets/workout.png`
/// when no URL is set) or a real `http(s)://` URL once content has a photo.
/// Falls back to the generic placeholder asset on any load failure —
/// broken link, offline, unsupported format.
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
      return Image.network(
        path,
        fit: fit,
        width: width,
        height: height,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (context, error, stackTrace) => _fallbackImage(),
        // `progress` is non-null on every in-flight frame and only turns
        // null once the image has fully decoded — returning the fallback
        // asset while it's non-null showed the placeholder for the whole
        // download instead of a brief loading state, then a same-frame
        // swap to `child` once the file lands.
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) return child;
          return _fallbackImage();
        },
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
