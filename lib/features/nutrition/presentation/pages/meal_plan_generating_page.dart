import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_plan_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shows real generation progress — no fixed-duration fake animation (see
/// the Phase 6 brief's explicit requirement). The spinner just reflects
/// [mealPlanControllerProvider]'s actual `AsyncLoading`/`AsyncError`/
/// `AsyncData` state for the in-flight `generate()` call started when this
/// screen opens.
class MealPlanGeneratingPage extends ConsumerStatefulWidget {
  const MealPlanGeneratingPage({super.key});

  @override
  ConsumerState<MealPlanGeneratingPage> createState() => _MealPlanGeneratingPageState();
}

class _MealPlanGeneratingPageState extends ConsumerState<MealPlanGeneratingPage> {
  bool _started = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    if (!_started) {
      _started = true;
      Future.microtask(() async {
        await ref.read(mealPlanControllerProvider.notifier).generate();
        if (context.mounted && ref.read(mealPlanControllerProvider).hasValue) {
          context.go(AppRoutes.mealPlanHome);
        }
      });
    }

    final state = ref.watch(mealPlanControllerProvider);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WorkoutHeader(title: l10n.nutritionTabMealPlans),
          const SizedBox(height: 18),
          Expanded(
            child: Center(
              child: state.hasError
                  ? _ErrorContent(l10n: l10n, ext: ext)
                  : _ProgressContent(l10n: l10n, ext: ext),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({required this.l10n, required this.ext});
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 168,
          height: 168,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 168,
                height: 168,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  strokeCap: StrokeCap.round,
                  backgroundColor: ext.glassBorder,
                  valueColor: AlwaysStoppedAnimation<Color>(ext.accentGlow),
                ),
              ),
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ext.accentGradient,
                  boxShadow: [
                    BoxShadow(color: ext.accentGlow.withValues(alpha: 0.3), blurRadius: 28, offset: const Offset(0, 14)),
                  ],
                ),
                child: Icon(Icons.restaurant_menu_rounded, size: 44, color: ext.onAccent),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Text(
          l10n.mealPlanGeneratingTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.mealPlanGeneratingBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
      ],
    );
  }
}

class _ErrorContent extends ConsumerWidget {
  const _ErrorContent({required this.l10n, required this.ext});
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline_rounded, size: 56, color: ext.textMuted),
        const SizedBox(height: 16),
        Text(
          l10n.mealPlanGenerationFailedTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mealPlanGenerationFailedBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 200,
          child: PrimaryButton(
            label: l10n.actionRetry,
            onPressed: () => ref.read(mealPlanControllerProvider.notifier).generate(),
          ),
        ),
      ],
    );
  }
}
