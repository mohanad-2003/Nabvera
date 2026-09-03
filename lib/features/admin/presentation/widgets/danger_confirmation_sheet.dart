import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// One shared bottom sheet for every destructive Admin action (deleting a
/// workout, exercise, recipe, article, or challenge). Returns `true` only
/// if the user tapped the destructive confirm button — every other way of
/// dismissing (swipe down, tap outside, Cancel) resolves to `false`/`null`,
/// so a call site can safely treat anything but `true` as "don't delete".
Future<bool> showDangerConfirmationSheet(
  BuildContext context, {
  required String title,
  required String message,
  String? confirmLabel,
}) async {
  final ext = Theme.of(context).extension<AppThemeExtension>()!;
  final l10n = AppLocalizations.of(context);

  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: ext.cardColor,
              borderRadius: BorderRadius.circular(AppRadius.xxxl),
              border: Border.all(color: ext.glassBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: ext.glassBorder,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ext.danger.withValues(alpha: 0.14),
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: ext.danger,
                    size: 30,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ext.textMuted, fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ext.textPrimary,
                          side: BorderSide(color: ext.glassBorder),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        child: Text(l10n.actionCancel),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(sheetContext).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ext.danger,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.md,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                        child: Text(confirmLabel ?? l10n.adminActionDelete),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return confirmed ?? false;
}
