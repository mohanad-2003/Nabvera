import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:flutter/material.dart';


/// The Weight/Age/Height stat row duplicated between ProfilePage and
/// EditProfilePage.
class ProfileStatRow extends StatelessWidget {
  const ProfileStatRow({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _Stat(
          icon: Icons.monitor_weight_outlined,
          label: profile.weightKg,
          subLabel: l10n.workoutProfileWeight,
        ),
        const _Divider(),
        _Stat(
          icon: Icons.cake_outlined,
          label: profile.ageYears,
          subLabel: l10n.workoutProfileAge,
        ),
        const _Divider(),
        _Stat(
          icon: Icons.height_rounded,
          label: profile.heightM,
          subLabel: l10n.workoutProfileHeight,
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.label,
    required this.subLabel,
  });
  final IconData icon;
  final String label;
  final String subLabel;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: ext.textPrimary,
          ),
        ),
        Text(subLabel, style: TextStyle(color: ext.textMuted, fontSize: 12)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(width: 1, height: 40, color: ext.glassBorder);
  }
}
