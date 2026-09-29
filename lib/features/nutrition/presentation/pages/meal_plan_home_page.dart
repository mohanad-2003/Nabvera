import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/network/api_client.dart';
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
        // A failed generate() attempt (e.g. today's free-tier quota
        // already used) landed its error on this same provider — the one
        // that also serves "fetch the current plan" — so without this,
        // simply reopening this tab afterwards got stuck showing that
        // stale error forever, with no header and no way back except
        // leaving the tab. This tells the two cases apart and always
        // offers a way out: reload (recovers to whatever plan already
        // exists) for a generic failure, or the same upgrade prompt
        // MealPlanGeneratingPage shows for the quota case specifically.
        error:
            (error, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MealPlanHeader(l10n: l10n),
                Expanded(
                  child: Center(
                    child:
                        error is ApiException && error.statusCode == 403
                            ? _MealPlanErrorContent(
                              l10n: l10n,
                              ext: ext,
                              icon: Icons.workspace_premium_rounded,
                              title: l10n.mealPlanUpgradeRequiredTitle,
                              body: l10n.mealPlanUpgradeRequiredBody,
                              actionLabel: l10n.mealPlanUpgradeRequiredCta,
                              onAction:
                                  () => context.push(
                                    AppRoutes.subscriptionPaywall,
                                  ),
                            )
                            : _MealPlanErrorContent(
                              l10n: l10n,
                              ext: ext,
                              icon: Icons.error_outline_rounded,
                              title: l10n.mealPlanGenerationFailedTitle,
                              body: l10n.mealPlanGenerationFailedBody,
                              actionLabel: l10n.actionRetry,
                              onAction:
                                  () => ref.invalidate(
                                    mealPlanControllerProvider,
                                  ),
                            ),
                  ),
                ),
              ],
            ),
        data: (plan) {
          if (plan == null) return _EmptyState(l10n: l10n, ext: ext);
          return _PlanView(plan: plan, dayIndex: _dayIndex, onDaySelected: (i) => setState(() => _dayIndex = i));
        },
      ),
    );
  }
}

/// Header row for the Meal Plans page — pairs [WorkoutHeader] with a home
/// icon button. This page can be reached via `context.go`, which replaces
/// the route stack and leaves no back destination, so this keeps a
/// reliable way back to the main dashboard. Optionally also shows a
/// shopping-list shortcut once a plan exists.
class _MealPlanHeader extends StatelessWidget {
  const _MealPlanHeader({
    required this.l10n,
    this.showShoppingList = false,
    this.showGenerateNew = false,
  });

  final AppLocalizations l10n;
  final bool showShoppingList;

  /// Only when a plan already exists — the empty state has its own,
  /// larger "Generate" CTA in the body, so this would just be a
  /// redundant second entry point there.
  final bool showGenerateNew;

  /// Confirms (generating overwrites today's active plan — the old one
  /// stays reachable from history, but this isn't obviously reversible
  /// from this screen) then opens the same generating screen the empty
  /// state uses. Previously only reachable from the empty state, so a
  /// plan with a data issue (e.g. an item with no recipe attached) had no
  /// in-app way to get a fresh one without deleting/losing the existing
  /// plan first.
  Future<void> _regenerate(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.mealPlanRegenerateConfirmTitle),
            content: Text(l10n.mealPlanRegenerateConfirmBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.actionCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.mealPlanGenerateNewTooltip),
              ),
            ],
          ),
    );
    if (confirmed == true && context.mounted) {
      context.push(AppRoutes.mealPlanGenerating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WorkoutHeader(
            title: l10n.nutritionTabMealPlans,
            showActions: false,
          ),
        ),
        if (showGenerateNew)
          IconButton(
            tooltip: l10n.mealPlanGenerateNewTooltip,
            onPressed: () => _regenerate(context),
            icon: const Icon(Icons.auto_awesome_outlined),
          ),
        if (showShoppingList)
          IconButton(
            tooltip: l10n.mealPlanViewShoppingList,
            onPressed: () => context.push(AppRoutes.mealPlanShoppingList),
            icon: const Icon(Icons.shopping_bag_outlined),
          ),
        // Only when there's no back button to fall back on — this page can
        // be reached via `context.go` (replaces the stack, no back
        // destination), where this is the one reliable way back to the
        // dashboard; when it's reached by a normal push, WorkoutHeader
        // already shows a back button and a second way back is just more
        // clutter next to an already-narrow title.
        if (!context.canPop())
          PremiumIconButton(icon: Icons.home_outlined, onTap: () => context.go(AppRoutes.home)),
      ],
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
        _MealPlanHeader(l10n: l10n),
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

/// Shared content for the meal-plan-provider error state — either the
/// generic "something went wrong, retry" case or (distinguished by a 403
/// ApiException) the same "upgrade required" messaging
/// MealPlanGeneratingPage shows for a free-tier account that already used
/// today's generation.
class _MealPlanErrorContent extends StatelessWidget {
  const _MealPlanErrorContent({
    required this.l10n,
    required this.ext,
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final AppLocalizations l10n;
  final AppThemeExtension ext;
  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: ext.textMuted),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(body, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted)),
          const SizedBox(height: 24),
          SizedBox(width: 220, child: PrimaryButton(label: actionLabel, onPressed: onAction)),
        ],
      ),
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
        _MealPlanHeader(l10n: l10n, showShoppingList: true, showGenerateNew: true),
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
          const SizedBox(height: 4),
          for (final item in items) ...[
            _MealItemCard(item: item, mealType: mealType, dayIndex: dayIndex),
            if (item != items.last) Divider(height: 1, color: ext.glassBorder),
          ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                Text(item.localizedDisplayTitle(l10n), style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w700)),
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
