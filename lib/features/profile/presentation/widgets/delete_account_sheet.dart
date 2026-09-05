import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Centered confirmation dialog for the destructive delete-account action.
Future<void> showDeleteAccountSheet(BuildContext context) {
  final ext = Theme.of(context).extension<AppThemeExtension>()!;
  final l10n = AppLocalizations.of(context);

  return showDialog<void>(
    barrierDismissible: false,
    useRootNavigator: true,
    context: context,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: ext.cardColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: ext.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ext.danger.withValues(alpha: 0.14),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: ext.danger,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.privacyDeleteConfirmTitle,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: ext.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.privacyDeleteConfirmBody,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: ext.textMuted),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => dialogContext.pop(),
                      child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: ext.glassFill,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: ext.glassBorder),
                      ),
                      child: Center(
                        child: Text(
                          l10n.actionCancel,
                          style: TextStyle(
                            color: ext.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                      dialogContext.pop();
                      context.go(AppRoutes.login);
                      },
                      child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: ext.danger,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          l10n.privacyDelete,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
