import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Common layout for every profile-setup wizard step: back header with a
/// real "X of Y" step counter, a soft segmented progress bar, one main
/// question + a short personalization blurb, a scrollable body (so small
/// screens never overflow), and a continue button pinned to the bottom —
/// never scrolling away with the content, always inside the safe area
/// (`AuthBackground(scrollable: false)` below already wraps everything in
/// one `SafeArea`).
///
/// [footerMessage] sits just above the button — a validation hint while a
/// step's answer is incomplete, or a real save-failure error on the final
/// step. [footerMessageIsError] switches its color; a screen-reader
/// announces it as a live region either way (see [Semantics] below) so a
/// blocked continue attempt is actually communicated, not just implied by
/// a greyed-out button.
class WizardScaffold extends StatelessWidget {
  const WizardScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.body,
    required this.button,
    this.step,
    this.totalSteps = 8,
    this.footerMessage,
    this.footerMessageIsError = false,
  });

  final String title;
  final String description;
  final Widget body;
  final Widget button;

  /// 1-indexed current step in the setup wizard, or null to hide the
  /// progress indicator (used by the intro/summary screens which aren't
  /// part of the numbered flow).
  final int? step;
  final int totalSteps;

  final String? footerMessage;
  final bool footerMessageIsError;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: AuthBackground(
        // Not scrollable here — this widget owns its own scroll region
        // (just the question body) so the continue button below can stay
        // fixed at the bottom instead of drifting off-screen with content.
        scrollable: false,
        showPreferenceControls: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                0,
              ),
              child: Row(
                children: [
                  _WizardBackButton(),
                  const Spacer(),
                  if (step != null)
                    Text(
                      l10n.onboardingStepCounter(step!, totalSteps),
                      style: TextStyle(
                        color: ext.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
            if (step != null) ...[
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: WizardStepIndicator(step: step!, totalSteps: totalSteps),
              ),
            ],
            const SizedBox(height: AppSpacing.xl),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    FadeSlideIn(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 24,
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 40),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: ext.textMuted,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 80),
                      child: body,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (footerMessage != null) ...[
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        footerMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: footerMessageIsError ? ext.danger : ext.textMuted,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  button,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WizardBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final canPop = context.canPop();

    return Semantics(
      button: true,
      label: l10n.actionBack,
      child: IconButton(
        tooltip: l10n.actionBack,
        onPressed: canPop ? context.pop : null,
        icon: const BackButtonIcon(),
        style: IconButton.styleFrom(
          backgroundColor: ext.glassFill,
          foregroundColor: ext.textPrimary,
          side: BorderSide(color: ext.glassBorder),
        ),
      ),
    );
  }
}

/// Slim segmented progress bar shared by the setup wizard steps and the
/// intro/summary screens. Direction-agnostic: a `Row` inside `Directionality`
/// already fills right-to-left under Arabic, so step 1 is always the
/// segment nearest the back button with no extra RTL handling needed here.
class WizardStepIndicator extends StatelessWidget {
  const WizardStepIndicator({
    super.key,
    required this.step,
    required this.totalSteps,
  });

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Semantics(
      label: AppLocalizations.of(context).onboardingStepCounter(step, totalSteps),
      child: Row(
        children: [
          for (var i = 0; i < totalSteps; i++) ...[
            if (i > 0) const SizedBox(width: 5),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient:
                      i < step
                          ? LinearGradient(
                            colors: [colorScheme.primary, colorScheme.secondary],
                          )
                          : null,
                  color: i < step ? null : ext.glassBorder,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
