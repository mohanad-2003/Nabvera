import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/storage/preferences_service.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/glow_orb.dart';
import 'package:fitness_app/features/authentication/data/firebase_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Premium, fully-vector splash screen: an ambient gradient backdrop, a
/// pulsing energy ring around the brand mark, and a staggered fade/scale
/// entrance for the wordmark, tagline, stat pills, and loading bar.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  // Short enough to read as "instant" rather than a loading wait — this is
  // purely the entrance animation's own duration, not an artificial delay;
  // navigation fires the moment it finishes (see the status listener below),
  // by which point the (local, synchronous) session/onboarding checks are
  // long done.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..addStatusListener(_handleAnimationStatus)
   ..forward();

  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  late final Animation<double> _logoScale = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
  );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
  );
  late final Animation<double> _brandFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.25, 0.6, curve: Curves.easeOut),
  );
  late final Animation<Offset> _brandSlide = Tween<Offset>(
    begin: const Offset(0, 0.24),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.65, curve: Curves.easeOutCubic),
    ),
  );
  late final Animation<double> _barFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
  );

  bool _navigated = false;

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || _navigated) return;
    _navigated = true;
    if (!mounted) return;

    // The onboarding carousel is a one-time, first-run intro — every later
    // launch skips straight past it. Both checks below are local/
    // synchronous (SharedPreferences + Firebase's cached current user), so
    // there is nothing to actually "wait" on beyond the entrance animation
    // itself.
    final onboardingComplete =
        ref.read(preferencesServiceProvider).onboardingComplete;
    if (!onboardingComplete) {
      context.go(AppRoutes.onboarding);
      return;
    }
    final signedIn = ref.read(firebaseAuthServiceProvider).currentUser != null;
    if (!signedIn) {
      context.go(AppRoutes.login);
      return;
    }
    // A signed-in user who opted into the biometric app-lock must confirm
    // it's them before reaching real data — see BiometricUnlockPage.
    final biometricEnabled =
        ref.read(preferencesServiceProvider).biometricEnabled;
    context.go(biometricEnabled ? AppRoutes.biometricUnlock : AppRoutes.home);
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: ext.backgroundGradient),
            ),
          ),
          Positioned(
            top: -70,
            right: -80,
            child: GlowOrb(
              color: ext.accentGlow,
              size: 300,
              opacity: theme.brightness == Brightness.dark ? 0.30 : 0.4,
            ),
          ),
          Positioned(
            bottom: 60,
            left: -120,
            child: GlowOrb(
              color: theme.colorScheme.secondary,
              size: 320,
              opacity: theme.brightness == Brightness.dark ? 0.26 : 0.32,
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final logoSize = width * 0.30 < 96
                    ? 96.0
                    : (width * 0.30 > 152 ? 152.0 : width * 0.30);

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 3),
                          _PulsingLogo(
                            size: logoSize,
                            pulse: _pulseController,
                            fade: _logoFade,
                            scale: _logoScale,
                            ringColor: ext.accentGlow,
                          ),
                          const SizedBox(height: 32),
                          FadeTransition(
                            opacity: _brandFade,
                            child: SlideTransition(
                              position: _brandSlide,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) =>
                                        ext.accentGradient.createShader(bounds),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(text: l10n.splashBrandFit),
                                        ],
                                      ),
                                      style: theme.textTheme.displayLarge
                                          ?.copyWith(
                                        fontSize: 58,
                                        height: 0.94,
                                        letterSpacing: -2,
                                      ),
                                    ),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -14),
                                    child: Text(
                                      l10n.splashBrandBody,
                                      style: theme.textTheme.displayLarge
                                          ?.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontSize: 58,
                                        height: 0.94,
                                        letterSpacing: -2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    l10n.splashTagline,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(color: ext.textMuted),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Spacer(flex: 4),
                          FadeTransition(
                            opacity: _barFade,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _GradientProgressBar(
                                  controller: _controller,
                                  gradient: ext.accentGradient,
                                  trackColor: theme
                                      .colorScheme.surfaceContainerHighest
                                      .withValues(alpha: 0.16),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  l10n.loadingLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: ext.textMuted,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingLogo extends StatelessWidget {
  const _PulsingLogo({
    required this.size,
    required this.pulse,
    required this.fade,
    required this.scale,
    required this.ringColor,
  });

  final double size;
  final Animation<double> pulse;
  final Animation<double> fade;
  final Animation<double> scale;
  final Color ringColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(
        scale: scale,
        child: SizedBox(
          width: size * 1.7,
          height: size * 1.7,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: pulse,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      _pulseRing(size, pulse.value),
                      _pulseRing(size, (pulse.value + 0.5) % 1.0),
                    ],
                  );
                },
              ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(size * 0.3),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.14),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ringColor.withValues(alpha: 0.24),
                      blurRadius: 40,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(size * 0.14),
                  child: Image.asset('assets/app_logo.png'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pulseRing(double baseSize, double t) {
    final ringSize = baseSize * (1 + t * 0.7);
    final opacity = (1 - t) * 0.35;
    return Container(
      width: ringSize,
      height: ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ringColor.withValues(alpha: opacity.clamp(0.0, 1.0)),
          width: 1.4,
        ),
      ),
    );
  }
}

class _GradientProgressBar extends StatelessWidget {
  const _GradientProgressBar({
    required this.controller,
    required this.gradient,
    required this.trackColor,
  });

  final Animation<double> controller;
  final Gradient gradient;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 6,
        child: DecoratedBox(
          decoration: BoxDecoration(color: trackColor),
          child: AnimatedBuilder(
            animation: controller,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: controller.value.clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(gradient: gradient),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
