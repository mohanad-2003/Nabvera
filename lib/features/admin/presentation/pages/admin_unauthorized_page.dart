import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Shown when `adminRouteGuard` blocks a navigation into `/admin/...` for a
/// non-admin account — the structural half of the role guard (the other
/// half is that the "Admin Console" entry point never appears on Profile
/// for a non-admin in the first place). Reaching this page means someone
/// navigated to an admin path directly (a stale link, a typed URL, or a
/// role that changed since the app last loaded the profile).
class AdminUnauthorizedPage extends StatelessWidget {
  const AdminUnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PremiumScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ext.danger.withValues(alpha: 0.14),
              ),
              child: Icon(
                Icons.lock_person_outlined,
                color: ext.danger,
                size: 42,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              l10n.adminUnauthorizedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ext.textPrimary,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l10n.adminUnauthorizedBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: ext.textMuted, fontSize: 13.5),
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              width: 220,
              child: PrimaryButton(
                label: l10n.adminUnauthorizedAction,
                onPressed: () => context.go(AppRoutes.home),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
