import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_extension.dart';
import 'pressable_scale.dart';
import 'smart_image.dart';

class PremiumScaffold extends StatelessWidget {
  const PremiumScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 20),
    this.safeArea = true,
    this.bottomBar,
  });

  final Widget child;

  final EdgeInsetsGeometry padding;
  final bool safeArea;

  /// A fixed bar pinned below the scrollable [child] (e.g. a sticky
  /// summary + primary action) — sits outside the gradient/glow
  /// background's Stack as a real `Scaffold.bottomNavigationBar`, so it
  /// never scrolls away and the keyboard pushes it up correctly. Omit for
  /// the previous full-bleed-background behavior.
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final content = Padding(padding: padding, child: child);
    return Scaffold(
      bottomNavigationBar: bottomBar,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: ext.backgroundGradient),
            ),
          ),
          Positioned(
            top: -120,
            right: -100,
            child: _Glow(color: AppColors.seedLime, size: 270, opacity: 0.16),
          ),
          Positioned(
            bottom: -130,
            left: -120,
            child: _Glow(
              color: AppColors.electricOrange,
              size: 320,
              opacity: 0.12,
            ),
          ),
          safeArea ? SafeArea(child: content) : content,
        ],
      ),
    );
  }
}

class PremiumHeader extends StatelessWidget {
  const PremiumHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      children: [
        if (showBack) ...[
          PremiumIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => context.canPop() ? context.pop() : null,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  subtitle!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class PremiumGlassCard extends StatelessWidget {
  const PremiumGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = AppRadius.card,
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? ext.glassFill,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: ext.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return PressableScale(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: card,
      ),
    );
  }
}

class PremiumIconButton extends StatelessWidget {
  const PremiumIconButton({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ext.glassBorder),
        ),
        child: Icon(icon, color: ext.textPrimary, size: 22),
      ),
    );
  }
}

/// Same look as [PremiumIconButton], but wraps [BackButtonIcon] instead of
/// a fixed `arrow_back_ios` glyph — [BackButtonIcon] resolves to the
/// correct visual direction per platform *and* text direction, so it
/// points right under RTL instead of always pointing left (several pages
/// used a raw `Icons.arrow_back_ios_new_rounded` for their back button,
/// which stayed pointing the LTR direction even under Arabic).
class PremiumBackButton extends StatelessWidget {
  const PremiumBackButton({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ext.glassBorder),
        ),
        child: IconTheme(
          data: IconThemeData(color: ext.textPrimary, size: 22),
          child: const BackButtonIcon(),
        ),
      ),
    );
  }
}

class PremiumSectionHeader extends StatelessWidget {
  const PremiumSectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onActionTap,
  });

  final String title;
  final String? action;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (action != null)
          TextButton(onPressed: onActionTap, child: Text(action!)),
      ],
    );
  }
}

class PremiumPill extends StatelessWidget {
  const PremiumPill({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final child = LayoutBuilder(
      builder: (context, constraints) {
        final isBounded = constraints.hasBoundedWidth;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: isBounded ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            gradient:
                selected
                    ? const LinearGradient(
                      colors: [AppColors.seedLime, AppColors.electricOrange],
                    )
                    : null,
            color: selected ? null : ext.glassFill,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? Colors.transparent : ext.glassBorder,
            ),
          ),
          child: Row(
            mainAxisSize: isBounded ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 17,
                  color: selected ? AppColors.seedInk : AppColors.seedLime,
                ),
                const SizedBox(width: 7),
              ],
              if (isBounded)
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? AppColors.seedInk : ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                )
              else
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? AppColors.seedInk : ext.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );

    if (onTap == null) return child;
    return GestureDetector(onTap: onTap, child: child);
  }
}

class PremiumImageCard extends StatelessWidget {
  const PremiumImageCard({
    super.key,
    required this.image,
    required this.child,
    this.height = 220,
    this.radius = AppRadius.card,
    this.onTap,
  });

  final String image;
  final Widget child;
  final double height;
  final double radius;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final card = Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        image: DecorationImage(
          image: smartImageProvider(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.28),
            BlendMode.darken,
          ),
        ),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              // Photo cards always scrim to near-black regardless of theme
              // so the (always-white) overlaid text stays legible.
              AppColors.seedInk.withValues(alpha: 0.92),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: child,
      ),
    );

    if (onTap == null) return card;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(radius),
      child: card,
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size, required this.opacity});

  final Color color;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: opacity),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
