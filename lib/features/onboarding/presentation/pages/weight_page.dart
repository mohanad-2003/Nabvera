import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:fitness_app/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WeightPage extends ConsumerStatefulWidget {
  const WeightPage({super.key});

  @override
  ConsumerState<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends ConsumerState<WeightPage> {
  static const _minWeight = 40;
  static const _maxWeight = 200;
  late final _pageController = PageController(
    viewportFraction: 0.2,
    initialPage: 35,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weight = ref.watch(onboardingProfileControllerProvider).weightKg;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 3,
      totalSteps: 8,
      title: l10n.onboardingWeightTitle,
      description: l10n.onboardingWeightBody,
      body: Column(
        children: [
          Text(
            '$weight ${l10n.unitKg}',
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
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: ext.glassFill,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: ext.glassBorder),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _maxWeight - _minWeight + 1,
              onPageChanged:
                  (index) => controller.setWeight(_minWeight + index),
              itemBuilder: (context, index) {
                final value = _minWeight + index;
                final isSelected = value == weight;
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
          onPressed: () => context.push(AppRoutes.setupHeight),
        ),
      ),
    );
  }
}
