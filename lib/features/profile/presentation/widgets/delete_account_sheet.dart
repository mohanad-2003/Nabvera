import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/authentication/data/firebase_auth_service.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Centered confirmation dialog for the destructive delete-account action.
/// The confirm button really deletes the account — a real
/// `DELETE /api/users/me` call (Firebase Auth account + every collection
/// of the user's data on the backend, see
/// `backend/src/services/accountDeletionService.js`) — not just a local
/// navigation to Login. Nothing is cleared client-side and the dialog
/// only closes to Login once that call actually succeeds; on failure the
/// dialog stays open with a real error and the account is untouched.
Future<void> showDeleteAccountSheet(BuildContext context, WidgetRef ref) {
  return showDialog<void>(
    barrierDismissible: false,
    useRootNavigator: true,
    context: context,
    builder: (dialogContext) => const _DeleteAccountDialog(),
  );
}

class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog();

  @override
  ConsumerState<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  bool _deleting = false;

  Future<void> _confirmDelete() async {
    setState(() => _deleting = true);
    try {
      await ref.read(userRepositoryProvider).deleteAccount();
      // The Firebase Auth account is already gone server-side at this
      // point — this just clears the local SDK session/token cache so
      // nothing in-app still thinks it's signed in.
      await ref.read(firebaseAuthServiceProvider).signOut();
      ref.invalidate(currentUserProfileProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
      context.go(AppRoutes.login);
    } catch (error) {
      if (!mounted) return;
      setState(() => _deleting = false);
      final l10n = AppLocalizations.of(context);
      final message =
          error is ApiException ? error.message : l10n.privacyDeleteFailed;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

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
                    onTap: _deleting ? null : () => Navigator.of(context).pop(),
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
                    onTap: _deleting ? null : _confirmDelete,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: ext.danger,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child:
                            _deleting
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
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
  }
}
