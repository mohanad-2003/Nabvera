import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/storage/preferences_service.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/fade_slide_in.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.image,
    required this.colors,
    required this.kickerKey,
    required this.titleKey,
    required this.descriptionKey,
  });

  final String image;
  final List<Color> colors;
  final String kickerKey;
  final String titleKey;
  final String descriptionKey;
}

// Exactly 3 slides, each a single concrete benefit, illustrated with the
// real onboarding photography (assets/onboarding) instead of an abstract
// vector icon — start strong, train smarter, track every rep.
const _slides = [
  _OnboardingSlide(
    image: 'assets/onboarding/onboarding_start.png',
    colors: [AppColors.seedLime, AppColors.aquaBlue],
    kickerKey: 'onboardingSlide1Kicker',
    titleKey: 'onboardingSlide1Title',
    descriptionKey: 'onboardingSlide1Description',
  ),
  _OnboardingSlide(
    image: 'assets/onboarding/onboarding_workout.png',
    colors: [AppColors.seedViolet, AppColors.aquaBlue],
    kickerKey: 'onboardingSlide2Kicker',
    titleKey: 'onboardingSlide2Title',
    descriptionKey: 'onboardingSlide2Description',
  ),
  _OnboardingSlide(
    image: 'assets/onboarding/onboarding_progress.png',
    colors: [AppColors.electricOrange, AppColors.seedLime],
    kickerKey: 'onboardingSlide3Kicker',
    titleKey: 'onboardingSlide3Title',
    descriptionKey: 'onboardingSlide3Description',
  ),
];

class OnboardingCarouselPage extends ConsumerStatefulWidget {
  const OnboardingCarouselPage({super.key});

  @override
  ConsumerState<OnboardingCarouselPage> createState() =>
      _OnboardingCarouselPageState();
}

class _OnboardingCarouselPageState
    extends ConsumerState<OnboardingCarouselPage> {
  final _controller = PageController();
  int _currentIndex = 0;

  void _finish() {
    // First (and only) time this carousel is ever shown — see SplashPage,
    // which skips straight past it on every later launch.
    ref.read(preferencesServiceProvider).setOnboardingComplete(true);
    context.go(AppRoutes.login);
  }

  void _goToNextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLast = _currentIndex == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.midnight,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder:
                (context, index) => _SlidePage(
                  slide: _slides[index],
                  index: index,
                  controller: _controller,
                  isLast: index == _slides.length - 1,
                ),
          ),
          // Every slide photo is a dark, moody frame — the chrome below
          // stays a fixed light-on-dark style regardless of the app's own
          // theme, instead of fighting the photo for contrast.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 26),
              child: Column(
                children: [
                  FadeSlideIn(
                    offset: const Offset(0, -0.3),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                            ),
                          ),
                          child: Text(
                            l10n.onboardingBrand,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const Spacer(),
                        PressableScale(
                          child: TextButton(
                            onPressed: _finish,
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.14,
                              ),
                              foregroundColor: Colors.white.withValues(
                                alpha: 0.85,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              l10n.onboardingSkip,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FadeSlideIn(
                    delay: const Duration(milliseconds: 120),
                    child: Row(
                      children: [
                        _PageIndicator(
                          count: _slides.length,
                          currentIndex: _currentIndex,
                        ),
                        const Spacer(),
                        _NextButton(
                          isLast: isLast,
                          label:
                              isLast
                                  ? l10n.onboardingGetStarted
                                  : l10n.onboardingNext,
                          onPressed: _goToNextSlide,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Same pill-indicator language as [OnboardingPageIndicator] but with fixed
/// white-on-dark colors — every slide sits on a dark photo, so it should
/// never wash out to the app's own (possibly light) theme colors.
class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsetsDirectional.only(end: 8),
            width: i == currentIndex ? 30 : 8,
            height: 8,
            decoration: BoxDecoration(
              gradient:
                  i == currentIndex
                      ? const LinearGradient(
                        colors: [AppColors.seedLime, AppColors.electricOrange],
                      )
                      : null,
              color: i == currentIndex ? null : Colors.white.withValues(
                alpha: 0.32,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

class _SlidePage extends StatelessWidget {
  const _SlidePage({
    required this.slide,
    required this.index,
    required this.controller,
    required this.isLast,
  });

  final _OnboardingSlide slide;
  final int index;
  final PageController controller;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        var t = 0.0;
        if (controller.hasClients && controller.position.haveDimensions) {
          final page = controller.page ?? index.toDouble();
          t = (page - index).clamp(-1.0, 1.0);
        }
        final fade = (1 - t.abs()).clamp(0.0, 1.0);
        return Opacity(
          opacity: fade,
          child: Transform.translate(offset: Offset(t * 44, 0), child: child),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(slide.image, fit: BoxFit.cover),
          // Bottom scrim so the overlaid text stays legible regardless of
          // how bright that particular region of the photo is.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xE6070B14),
                  Color(0xFF070B14),
                ],
                stops: [0, 0.42, 0.72, 1],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 118),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: _SlideText(slide: slide, isLast: isLast),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideText extends StatelessWidget {
  const _SlideText({required this.slide, required this.isLast});

  final _OnboardingSlide slide;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final kicker = switch (slide.kickerKey) {
      'onboardingSlide1Kicker' => l10n.onboardingSlide1Kicker,
      'onboardingSlide2Kicker' => l10n.onboardingSlide2Kicker,
      'onboardingSlide3Kicker' => l10n.onboardingSlide3Kicker,
      _ => '',
    };
    final title = switch (slide.titleKey) {
      'onboardingSlide1Title' => l10n.onboardingSlide1Title,
      'onboardingSlide2Title' => l10n.onboardingSlide2Title,
      'onboardingSlide3Title' => l10n.onboardingSlide3Title,
      _ => '',
    };
    final description = switch (slide.descriptionKey) {
      'onboardingSlide1Description' => l10n.onboardingSlide1Description,
      'onboardingSlide2Description' => l10n.onboardingSlide2Description,
      'onboardingSlide3Description' => l10n.onboardingSlide3Description,
      _ => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: slide.colors),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            kicker,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 11,
              letterSpacing: 1.1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            height: 1.1,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
            height: 1.5,
          ),
        ),
        if (isLast) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.timer_outlined,
                size: 16,
                color: AppColors.seedLime,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  l10n.onboardingSetupTimeNote,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.seedLime,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({
    required this.isLast,
    required this.label,
    required this.onPressed,
  });

  final bool isLast;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return PressableScale(
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            gradient: ext.accentGradient,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: ext.accentGlow.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: ext.onAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                color: ext.onAccent,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
