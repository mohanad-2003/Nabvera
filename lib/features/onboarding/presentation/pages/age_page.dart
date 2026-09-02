import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/onboarding_profile_controller.dart';
import '../widgets/wizard_scaffold.dart';

class AgePage extends ConsumerStatefulWidget {
  const AgePage({super.key});

  @override
  ConsumerState<AgePage> createState() => _AgePageState();
}

class _AgePageState extends ConsumerState<AgePage> {
  static const _minAge = 10;
  static const _maxAge = 40;
  late final _pageController = PageController(
    viewportFraction: 0.2,
    initialPage: 18,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final age = ref.watch(onboardingProfileControllerProvider).age;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WizardScaffold(
      step: 2,
      totalSteps: 8,
      title: l10n.onboardingAgeTitle,
      description: l10n.onboardingAgeBody,
      body: Column(
        children: [
          Text(
            '$age',
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: ext.textPrimary,
            ),
          ),
          Icon(
            Icons.arrow_drop_up,
            color: theme.colorScheme.primary,
            size: 60,
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: ext.glassFill,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: ext.glassBorder),
            ),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _maxAge - _minAge + 1,
              onPageChanged: (index) => controller.setAge(_minAge + index),
              itemBuilder: (context, index) {
                final value = _minAge + index;
                final isSelected = value == age;
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
          onPressed: () => context.push(AppRoutes.setupWeight),
        ),
      ),
    );
  }
}
