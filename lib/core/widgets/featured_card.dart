import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

import 'icon_stat.dart';
import 'pressable_scale.dart';
import 'smart_image.dart';

/// One meta entry (asset icon + label) on a [FeaturedCard]'s stats row.
class FeaturedCardMeta {
  const FeaturedCardMeta({required this.icon, required this.label});

  final String icon;
  final String label;
}

/// The design system's featured hero card, shared by the Train, Nutrition,
/// and Community tabs: background photo + badge (top-start) + favorite
/// toggle (top-end) + title + icon-meta row + optional CTA button — one
/// widget, one structure, instead of three per-screen variants.
///
/// The photo always sits under a fixed dark scrim, so the white overlay
/// text stays legible in both light and dark themes.
class FeaturedCard extends StatefulWidget {
  const FeaturedCard({
    super.key,
    required this.image,
    required this.badge,
    required this.title,
    this.metas = const [],
    this.badgeColor,
    this.ctaLabel,
    this.height = 220,
    this.onTap,
  });

  final String image;
  final String badge;
  final String title;
  final List<FeaturedCardMeta> metas;

  /// Optional per-section accent for the badge (e.g. violet for Nutrition,
  /// aqua for Community). When null the badge uses the primary brand
  /// gradient — reserved for the main Train card per the design system.
  final Color? badgeColor;

  /// When provided, renders the pill CTA button at the bottom of the card.
  final String? ctaLabel;
  final double height;
  final VoidCallback? onTap;

  @override
  State<FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return PressableScale(
      enabled: widget.onTap != null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.26),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.card),
                child: SmartImage(
                  widget.image,
                  color: Colors.black.withValues(alpha: 0.12),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.82),
                      ],
                      stops: const [0, 0.4, 1],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                top: 14,
                start: 14,
                child: _Badge(label: widget.badge, color: widget.badgeColor),
              ),
              PositionedDirectional(
                top: 14,
                end: 14,
                child: GestureDetector(
                  onTap: () => setState(() => _isFavorite = !_isFavorite),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.32),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Icon(
                      _isFavorite
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: _isFavorite ? ext.accentGlow : Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: 16,
                end: 16,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.12,
                      ),
                    ),
                    if (widget.metas.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (final meta in widget.metas) ...[
                            if (meta != widget.metas.first)
                              const SizedBox(width: 14),
                            IconStat(icon: meta.icon, label: meta.label),
                          ],
                        ],
                      ),
                    ],
                    if (widget.ctaLabel != null) ...[
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 38,
                        child: ElevatedButton.icon(
                          onPressed: widget.onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(Icons.play_arrow_rounded, size: 18),
                          label: Text(
                            widget.ctaLabel!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.color});

  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final onColor =
        color == null
            ? ext.onAccent
            : (ThemeData.estimateBrightnessForColor(color!) == Brightness.dark
                ? Colors.white
                : const Color(0xFF080D12));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        gradient: color == null ? ext.accentGradient : null,
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: onColor,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
