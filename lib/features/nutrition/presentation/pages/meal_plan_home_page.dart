import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/core/widgets/smart_image.dart';
import 'package:nabvera/features/nutrition/domain/meal_plan_models.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_logging_controller.dart';
import 'package:nabvera/features/nutrition/presentation/providers/meal_plan_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String _mealTypeLabel(AppLocalizations l10n, String mealType) => switch (mealType) {
  'breakfast' => l10n.mealPlanSectionBreakfast,
  'lunch' => l10n.mealPlanSectionLunch,
  'dinner' => l10n.mealPlanSectionDinner,
  _ => l10n.mealPlanSectionSnacks,
};

/// Entry point for the Nutrition tab's "Meal Plans" pill — shows the
/// current 7-day plan with a day selector, or the empty state (no plan
/// generated yet) with the setup/generate CTAs. See the Phase 6 brief's
/// explicit "honest empty state, not a fake one" requirement.
class MealPlanHomePage extends ConsumerStatefulWidget {
  const MealPlanHomePage({super.key});

  @override
  ConsumerState<MealPlanHomePage> createState() => _MealPlanHomePageState();
}

class _MealPlanHomePageState extends ConsumerState<MealPlanHomePage> {
  int _dayIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final asyncPlan = ref.watch(mealPlanControllerProvider);

    return PremiumScaffold(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: asyncPlan.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error', style: TextStyle(color: ext.textMuted))),
        data: (plan) {
          if (plan == null) return _EmptyState(l10n: l10n, ext: ext);
          return _PlanView(plan: plan, dayIndex: _dayIndex, onDaySelected: (i) => setState(() => _dayIndex = i));
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.l10n, required this.ext});
  final AppLocalizations l10n;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WorkoutHeader(title: l10n.nutritionTabMealPlans),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_month_rounded, size: 64, color: ext.textMuted),
                const SizedBox(height: 20),
                Text(
                  l10n.mealPlanEmptyTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    l10n.mealPlanEmptyBody,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      PrimaryButton(
                        label: l10n.mealPlanSetPreferences,
                        onPressed: () => context.push(AppRoutes.mealPlanPreferences),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.push(AppRoutes.mealPlanGenerating),
                        child: Text(l10n.mealPlanGenerateCta),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanView extends ConsumerWidget {
  const _PlanView({required this.plan, required this.dayIndex, required this.onDaySelected});

  final MealPlan plan;
  final int dayIndex;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final day = plan.days[dayIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: WorkoutHeader(title: l10n.nutritionTabMealPlans)),
            IconButton(
              tooltip: l10n.mealPlanViewShoppingList,
              onPressed: () => context.push(AppRoutes.mealPlanShoppingList),
              icon: const Icon(Icons.shopping_bag_outlined),
            ),
          ],
        ),
        if (plan.generationSource == 'fallback')
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(l10n.mealPlanSourceFallbackNote, style: TextStyle(color: ext.textMuted, fontSize: 12)),
          ),
        SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) => ChoiceChip(
              label: Text(l10n.mealPlanDayLabel(i + 1)),
              selected: dayIndex == i,
              onSelected: (_) => onDaySelected(i),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView(
            children: [
              if (day.dayExplanationCode != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    explanationCodeLabel(l10n, day.dayExplanationCode!),
                    style: TextStyle(color: ext.textMuted, fontStyle: FontStyle.italic),
                  ),
                ),
              for (final mealType in ['breakfast', 'lunch', 'dinner', 'snack'])
                _MealSection(
                  title: _mealTypeLabel(l10n, mealType),
                  items: switch (mealType) {
                    'breakfast' => day.breakfast,
                    'lunch' => day.lunch,
                    'dinner' => day.dinner,
                    _ => day.snacks,
                  },
                  mealType: mealType,
                  dayIndex: dayIndex,
                ),
              const SizedBox(height: 12),
              Text(mealPlanDisclaimer(l10n, plan.disclaimerCode), style: TextStyle(color: ext.textMuted, fontSize: 11)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _MealSection extends StatelessWidget {
  const _MealSection({required this.title, required this.items, required this.mealType, required this.dayIndex});

  final String title;
  final List<MealPlanItem> items;
  final String mealType;
  final int dayIndex;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w800, fontSize: 16)),
          const SizedBox(height: 8),
          for (final item in items)
            _MealItemCard(item: item, mealType: mealType, dayIndex: dayIndex),
        ],
      ),
    );
  }
}

class _MealItemCard extends ConsumerWidget {
  const _MealItemCard({required this.item, required this.mealType, required this.dayIndex});

  final MealPlanItem item;
  final String mealType;
  final int dayIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: ext.glassFill,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SmartImage(item.recipeImageUrl ?? '', width: 64, height: 64, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.displayTitle, style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  '${l10n.nutritionCaloriesValue(item.calories)} • ${item.proteinG}g ${l10n.nutritionProteinLabel} '
                  '${item.recipePrepTimeMinutes != null ? '• ${l10n.nutritionMinutesValue(item.recipePrepTimeMinutes!)}' : ''}',
                  style: TextStyle(color: ext.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  explanationCodeLabel(l10n, item.explanationCode),
                  style: TextStyle(color: ext.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
            ],
          ),
          if (item.recipeId != null) ...[
            const SizedBox(height: 8),
            _MealItemActions(item: item, mealType: mealType, dayIndex: dayIndex),
          ],
        ],
      ),
    );
  }
}

/// "Mark as eaten" / "Logged (Undo)" + "Replace" — split from the card's
/// header row so both actions can live on their own row without crowding
/// the recipe image/title. Reads [mealLoggingControllerProvider] to know
/// whether this exact plan item was already logged today (seeded from the
/// real backend record, not just this session's taps — see that
/// controller's doc comment).
class _MealItemActions extends ConsumerStatefulWidget {
  const _MealItemActions({required this.item, required this.mealType, required this.dayIndex});

  final MealPlanItem item;
  final String mealType;
  final int dayIndex;

  @override
  ConsumerState<_MealItemActions> createState() => _MealItemActionsState();
}

class _MealItemActionsState extends ConsumerState<_MealItemActions> {
  bool _submitting = false;

  Future<void> _markEaten() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      await ref.read(mealLoggingControllerProvider.notifier).markEaten(
        recipeId: widget.item.recipeId!,
        mealType: widget.mealType,
        mealPlanItemId: widget.item.id,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogAdded)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogFailed)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _undo(String logId) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _submitting = true);
    try {
      await ref.read(mealLoggingControllerProvider.notifier).undo(logId, mealPlanItemId: widget.item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogRemoved)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.mealLogUndoFailed)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final loggedMap = ref.watch(mealLoggingControllerProvider).value ?? const {};
    final logId = loggedMap[widget.item.id];

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (logId != null) ...[
          Icon(Icons.check_circle_rounded, size: 16, color: ext.accentGlow),
          const SizedBox(width: 4),
          Text(l10n.mealLogged, style: TextStyle(color: ext.accentGlow, fontSize: 12, fontWeight: FontWeight.w700)),
          TextButton(
            onPressed: _submitting ? null : () => _undo(logId),
            child: Text(l10n.mealLogUndo),
          ),
        ] else
          TextButton.icon(
            onPressed: _submitting ? null : _markEaten,
            icon: _submitting
                ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.restaurant_rounded, size: 16),
            label: Text(l10n.mealMarkAsEaten),
          ),
        TextButton(
          onPressed: () => ref
              .read(mealPlanControllerProvider.notifier)
              .replaceMeal(dayIndex: widget.dayIndex, mealType: widget.mealType, itemId: widget.item.id),
          child: Text(l10n.mealPlanReplaceMeal),
        ),
      ],
    );
  }
}
