import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A small, functional water-logging sheet — replaces the old "Drink
/// Water" Home suggestion, which navigated to the Nutrition tab with no
/// way to actually log anything there (tapping it visibly did nothing).
/// Logs a real amount via `POST /nutrition/water`
/// ([DailyNutritionSummaryController.logWater]) and every screen watching
/// that controller (this sheet, the Home next-step card, the Nutrition
/// summary card) updates immediately — no restart, no separate refresh.
/// No AI, no personalized health goals or medical claims — just a plain
/// counter against the existing daily water goal.
Future<void> showLogWaterSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _LogWaterSheet(),
  );
}

class _LogWaterSheet extends ConsumerStatefulWidget {
  const _LogWaterSheet();

  @override
  ConsumerState<_LogWaterSheet> createState() => _LogWaterSheetState();
}

class _LogWaterSheetState extends ConsumerState<_LogWaterSheet> {
  bool _submitting = false;

  Future<void> _add(int amountMl) async {
    setState(() => _submitting = true);
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(dailyNutritionSummaryControllerProvider.notifier).logWater(amountMl);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.waterLogAdded)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.waterLogFailed)));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    // Watches the live controller so the count on this sheet updates the
    // instant a tap below succeeds, same as everywhere else on screen.
    final summary = ref.watch(dailyNutritionSummaryControllerProvider);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
        decoration: BoxDecoration(
          color: ext.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: ext.glassBorder, borderRadius: BorderRadius.circular(999)),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Icon(Icons.water_drop_rounded, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  l10n.waterLogSheetTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ext.textPrimary, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(summary.localizedWaterIntake(context), style: TextStyle(color: ext.textMuted)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _submitting ? null : () => _add(250),
                    child: Text(l10n.waterLogAddCup),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _submitting ? null : () => _add(500),
                    child: Text(l10n.waterLogAddTwoCups),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: l10n.actionDone,
              isLoading: _submitting,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
