import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:fitness_app/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HeightPage extends ConsumerStatefulWidget {
  const HeightPage({super.key});

  @override
  ConsumerState<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends ConsumerState<HeightPage> {
  static const _minHeight = 140;
  static const _maxHeight = 210;
  late final _pageController = PageController(
    viewportFraction: 0.25,
    initialPage: 25,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = ref.watch(onboardingProfileControllerProvider).heightCm;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 4,
      totalSteps: 8,
      title: l10n.onboardingHeightTitle,
      description: l10n.onboardingHeightBody,
      body: Column(
        children: [
          Text(
            '$height ${l10n.unitCm}',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: ext.textPrimary,
            ),
          ),
          Icon(
            Icons.arrow_drop_up_outlined,
            size: 60,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: screenHeight * 0.3,
            width: 60,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: _maxHeight - _minHeight + 1,
              onPageChanged:
                  (index) => controller.setHeight(_minHeight + index),
              itemBuilder: (context, index) {
                final value = _minHeight + index;
                final isSelected = value == height;
                return Center(
                  child: Text(
                    '$value',
                    style: TextStyle(
                      fontSize: isSelected ? 40 : 30,
                      color: isSelected ? ext.textPrimary : ext.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      button: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: PrimaryButton(
          label: l10n.actionContinue,
          onPressed: () => context.push(AppRoutes.setupGoal),
        ),
      ),
    );
  }
}
