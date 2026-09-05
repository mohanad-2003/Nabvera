import 'package:flutter/material.dart';

import 'package:nabvera/core/widgets/glow_orb.dart';

/// Abstract, fully vector hero visual for an onboarding slide: a gradient
/// medallion holding the slide's icon, floating inside a slowly rotating
/// dashed ring with ambient glow orbs behind it. Built entirely from shapes
/// so it stays crisp and on-brand in both themes without depending on any
/// photo asset.
class OnboardingHeroArt extends StatefulWidget {
  const OnboardingHeroArt({
    super.key,
    required this.icon,
    required this.colors,
    this.ringColor,
  });

  final IconData icon;
  final List<Color> colors;
  final Color? ringColor;

  @override
  State<OnboardingHeroArt> createState() => _OnboardingHeroArtState();
}

class _OnboardingHeroArtState extends State<OnboardingHeroArt>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 30),
  )..repeat();

  late final AnimationController _floatController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  )..repeat(reverse: true);

  late final Animation<double> _float = CurvedAnimation(
    parent: _floatController,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _rotationController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringColor =
        widget.ringColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.16);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest.shortestSide;
        final medallion = size * 0.42;

        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: size * 0.02,
              right: size * 0.04,
              child: GlowOrb(
                color: widget.colors.first,
                size: size * 0.58,
                opacity: 0.32,
              ),
            ),
            Positioned(
              bottom: size * 0.02,
              left: size * 0.02,
              child: GlowOrb(
                color: widget.colors.last,
                size: size * 0.5,
                opacity: 0.24,
              ),
            ),
            RotationTransition(
              turns: _rotationController,
              child: CustomPaint(
                size: Size.square(size * 0.84),
                painter: _DashedRingPainter(color: ringColor),
              ),
            ),
            AnimatedBuilder(
              animation: _float,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -6 + _float.value * 12),
                  child: child,
                );
              },
              child: Container(
                width: medallion,
                height: medallion,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: widget.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.colors.first.withValues(alpha: 0.45),
                      blurRadius: 44,
                      offset: const Offset(0, 22),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  size: medallion * 0.42,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: size * 0.08,
              left: size * 0.10,
              child: _AccentDot(color: widget.colors.last, size: size * 0.05),
            ),
            Positioned(
              bottom: size * 0.12,
              right: size * 0.08,
              child: _AccentDot(color: widget.colors.first, size: size * 0.035),
            ),
          ],
        );
      },
    );
  }
}

class _AccentDot extends StatelessWidget {
  const _AccentDot({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.85),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: size,
            offset: Offset(0, size * 0.3),
          ),
        ],
      ),
    );
  }
}

class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;

    const dashCount = 34;
    const dashSweep = 2 * 3.14159265 / dashCount * 0.55;

    for (var i = 0; i < dashCount; i++) {
      final start = i * (2 * 3.14159265 / dashCount);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        dashSweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRingPainter oldDelegate) =>
      oldDelegate.color != color;
}
