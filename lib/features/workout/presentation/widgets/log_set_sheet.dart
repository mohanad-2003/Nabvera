import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// What was actually done on one checked-off set — captured right when the
/// set is marked complete (see `CategoryDetailPage._toggleSet`), sent to
/// the backend as one `exerciseSets[]` entry when the workout is finished.
/// Both fields are optional: a user can mark a set done without recording
/// either, same as skipping the difficulty rating.
class LoggedSet {
  const LoggedSet({this.weightKg, this.reps});

  final double? weightKg;
  final int? reps;
}

/// A tiny bottom sheet for entering what was lifted on one set —
/// deliberately just two numeric fields and one button, since this shows
/// once per set and must never slow down an actual training session.
/// Returns `null` if dismissed without confirming (the set is then left
/// unmarked, not saved with empty values).
Future<LoggedSet?> showLogSetSheet(
  BuildContext context, {
  required int setNumber,
  double? initialWeightKg,
  int? initialReps,
}) {
  final ext = Theme.of(context).extension<AppThemeExtension>()!;
  final l10n = AppLocalizations.of(context);
  final weightController = TextEditingController(
    text: initialWeightKg == null ? '' : _formatWeight(initialWeightKg),
  );
  final repsController = TextEditingController(
    text: initialReps == null ? '' : '$initialReps',
  );

  return showModalBottomSheet<LoggedSet?>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: ext.cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: ext.glassBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ext.glassBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.workoutSetNumber(setNumber),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: ext.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _NumberField(
                        controller: weightController,
                        label: l10n.workoutWeightKgLabel,
                        allowDecimal: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _NumberField(
                        controller: repsController,
                        label: l10n.workoutRepsLabel,
                        allowDecimal: false,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  showShadow: false,
                  label: l10n.actionDone,
                  onPressed: () {
                    final weight = double.tryParse(weightController.text.trim());
                    final reps = int.tryParse(repsController.text.trim());
                    Navigator.of(
                      sheetContext,
                    ).pop(LoggedSet(weightKg: weight, reps: reps));
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String _formatWeight(double value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    required this.allowDecimal,
  });

  final TextEditingController controller;
  final String label;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return TextField(
      controller: controller,
      autofocus: false,
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          allowDecimal ? RegExp(r'^\d*\.?\d*') : RegExp(r'^\d*'),
        ),
      ],
      style: TextStyle(color: ext.textPrimary, fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ext.textMuted),
        filled: true,
        fillColor: ext.glassFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ext.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ext.glassBorder),
        ),
      ),
    );
  }
}
