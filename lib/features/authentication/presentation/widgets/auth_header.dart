import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';


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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showBack)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: IconButton(
                tooltip: l10n.actionBack,
                onPressed: context.canPop() ? context.pop : null,
                icon: BackButtonIcon(),
                color: accent,
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
