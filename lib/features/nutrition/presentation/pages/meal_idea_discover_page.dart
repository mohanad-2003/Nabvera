import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/glow_orb.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MealIdeaDiscoverPage extends StatelessWidget {
  const MealIdeaDiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: ext.backgroundGradient),
            ),
          ),
          Positioned(
            top: -100,
            right: -90,
            child: GlowOrb(
              color: ext.accentGlow,
              size: 280,
              opacity: theme.brightness == Brightness.dark ? 0.26 : 0.34,
            ),
          ),
          Positioned(
            bottom: -80,
            left: -100,
            child: GlowOrb(
              color: theme.colorScheme.secondary,
              size: 300,
              opacity: theme.brightness == Brightness.dark ? 0.22 : 0.28,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.canPop() ? context.pop() : null,
                    child: Icon(
                      Directionality.of(context) == TextDirection.rtl
                          ? Icons.arrow_forward_ios_rounded
                          : Icons.arrow_back_ios_new_rounded,
                      color: ext.textPrimary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeSlideIn(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: ext.accentGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: ext.accentGlow.withValues(alpha: 0.3),
                                  blurRadius: 32,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.restaurant_menu_rounded,
                              color: ext.onAccent,
                              size: 44,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            l10n.mealIdeasDiscoverTitle,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: ext.textPrimary,
                              height: 1.06,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.mealIdeasDiscoverBody,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: ext.textMuted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 120),
                      child: PrimaryButton(
                        label: l10n.actionDiscover,
                        icon: Icons.arrow_forward_rounded,
                        onPressed: () => context.push(AppRoutes.mealIdea),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
