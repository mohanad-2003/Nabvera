import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Standard header for every Admin console page — a back button (when
/// there's somewhere to go back to), title/subtitle, and an optional
/// trailing action (usually an "Add" button). Thin wrapper around
/// [PremiumHeader]/[PremiumIconButton] so Admin pages automatically match
/// the rest of the app's premium chrome instead of inventing their own.
class AdminPageHeader extends StatelessWidget {
  const AdminPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showBack = false,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          if (showBack && context.canPop()) ...[
            PremiumBackButton(onTap: () => context.pop()),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: TextStyle(color: ext.textMuted, fontSize: 13),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
