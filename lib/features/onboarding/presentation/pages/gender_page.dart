import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/onboarding/presentation/widgets/wizard_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GenderPage extends ConsumerWidget {
  const GenderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(onboardingProfileControllerProvider).gender;
    final controller = ref.read(onboardingProfileControllerProvider.notifier);
    final l10n = AppLocalizations.of(context);
    final canContinue = selected != null;

    return WizardScaffold(
      step: 1,
      totalSteps: 8,
      title: l10n.onboardingGenderTitle,
      description: l10n.onboardingGenderBody,
      footerMessage: canContinue ? null : l10n.onboardingGenderRequired,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _GenderOption(
            icon: Icons.male_rounded,
            label: l10n.onboardingMale,
            isSelected: selected == Gender.male,
            onTap: () => controller.selectGender(Gender.male),
          ),
          const SizedBox(width: 20),
          _GenderOption(
            icon: Icons.female_rounded,
            label: l10n.onboardingFemale,
            isSelected: selected == Gender.female,
            onTap: () => controller.selectGender(Gender.female),
          ),
        ],
      ),
      button: PrimaryButton(
        label: l10n.actionContinue,
        onPressed:
            canContinue ? () => context.push(AppRoutes.setupAge) : null,
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: isSelected ? 1.0 : 0.94,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutBack,
          child: SizedBox(
            width: 130,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // The unselected medallion keeps the fixed violet→aqua
                        // brand gradient; its white glyph stays readable on it
                        // in both light and dark mode.
                        gradient:
                            isSelected
                                ? ext.accentGradient
                                : const LinearGradient(
                                  colors: [
                                    AppColors.seedViolet,
                                    AppColors.aquaBlue,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                        border: Border.all(
                          color: isSelected ? ext.onAccent : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: ext.accentGlow.withValues(alpha: 0.4),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                        ],
                      ),
                      child: Icon(icon, size: 52, color: Colors.white),
                    ),
                    if (isSelected)
                      PositionedDirectional(
                        end: -4,
                        bottom: -4,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ext.onAccent,
                            border: Border.all(color: ext.accentGlow, width: 2),
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: ext.accentGlow,
                            size: 16,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? ext.textPrimary : ext.textMuted,
                    fontSize: 17,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
