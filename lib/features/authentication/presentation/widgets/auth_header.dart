import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/generated/app_localizations.dart';
import '../../../../core/theme/app_theme_extension.dart';

/// Replaces the legacy `HeaderWidget`/`HeaderBack` (lib/view/headerApge.dart,
/// lib/view/header_back.dart) — back arrow now pops via GoRouter instead of
/// `Get.back()`.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, this.title, this.showBack = true});

  final String? title;

  /// False for auth-flow roots (login, signup) reached fresh from
  /// Welcome/Splash with no meaningful "back" destination — and for the
  /// biometric prompt, which is a one-time post-signup step, not a page the
  /// user should retreat from mid-way.
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final accent = Theme.of(context).colorScheme.primary;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () => context.canPop() ? context.pop() : null,
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: ext.glassFill,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: ext.glassBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: accent,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.actionBack,
                        style: TextStyle(
                          color: accent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (title != null)
            Text(
              title!,
              style: TextStyle(
                fontSize: 16,
                color: ext.textPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
              ),
            ),
        ],
      ),
    );
  }
}
