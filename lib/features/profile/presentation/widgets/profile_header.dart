import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/user_avatar.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart' show exerciseDifficultyLabel;
import 'package:flutter/material.dart';

/// Premium profile header: back/edit actions, gradient-ringed avatar with a
/// verified badge, name, email, a fitness-level pill, and a short
/// motivational line. Fades and slides in on first build.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.title,
    required this.name,
    required this.email,
    required this.fitnessLevel,
    required this.motivation,
    this.avatarUrl,
    this.onBack,
    this.onEdit,
  });

  final String title;
  final String name;
  final String email;
  final String fitnessLevel;
  final String motivation;
  final String? avatarUrl;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return FadeSlideIn(
      offset: const Offset(0, -0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (onBack != null) PremiumBackButton(onTap: onBack),
              // Expanded so the title gets every pixel not used by the
              // (optional) back/edit icons — a bare `Flexible` here used to
              // sit between two `Spacer()`s of the same flex:1, so the
              // three of them split the row into thirds and gave the title
              // only a third of the available width regardless of how much
              // room the icons actually left, clipping a title as short as
              // "ملفي الشخصي" to "ملفي ال…".
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (onEdit != null)
                PremiumIconButton(icon: Icons.edit_rounded, onTap: onEdit),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: ext.accentGradient,
                  ),
                  child: UserAvatar(radius: 52, imageUrl: avatarUrl),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ext.cardColor,
                      border: Border.all(color: ext.glassBorder, width: 2),
                    ),
                    child: Icon(
                      Icons.verified_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ext.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: ext.textMuted),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: ext.accentGlow.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                exerciseDifficultyLabel(AppLocalizations.of(context), fitnessLevel),
                style: TextStyle(
                  color: ext.accentGlow,
                  fontWeight: FontWeight.w800,
                  fontSize: 11.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: Text(
              motivation,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ext.textMuted,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
