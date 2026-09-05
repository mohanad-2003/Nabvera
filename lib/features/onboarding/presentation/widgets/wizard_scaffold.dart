import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_background.dart';
import 'package:nabvera/features/authentication/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';

/// Common layout for every profile-setup wizard step: gradient background,
/// back header, step-progress indicator, and a bottom-anchored continue
/// button.
class WizardScaffold extends StatelessWidget {
  const WizardScaffold({
    super.key,
    required this.title,
    required this.description,
    required this.body,
    required this.button,
    this.step,
    this.totalSteps = 7,
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

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Scaffold(
      body: AuthBackground(
        child: Column(
          children: [
            const AuthHeader(),
            if (step != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: WizardStepIndicator(step: step!, totalSteps: totalSteps),
              ),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 25,
                color: ext.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(color: ext.textMuted, fontSize: 14),
              ),
            ),
            const SizedBox(height: 30),
            body,
            const SizedBox(height: 50),
            button,
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Slim segmented progress bar shared by the setup wizard steps and the
/// intro/summary screens.
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

    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
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
    );
  }
}
