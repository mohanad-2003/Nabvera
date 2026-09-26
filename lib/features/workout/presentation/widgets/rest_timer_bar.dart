import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:flutter/material.dart';

/// A countdown banner shown between sets during an active workout session
/// (see `CategoryDetailPage`). Auto-dismisses via [onFinished] when the
/// countdown reaches zero; [onSkip] lets the user end the rest early.
class RestTimerBar extends StatelessWidget {
  const RestTimerBar({
    super.key,
    required this.remaining,
    required this.total,
    required this.onSkip,
    required this.onAddSeconds,
  });

  final Duration remaining;
  final Duration total;
  final VoidCallback onSkip;
  final VoidCallback onAddSeconds;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final progress =
        total.inMilliseconds == 0
            ? 0.0
            : 1 - (remaining.inMilliseconds / total.inMilliseconds);
    final seconds = remaining.inSeconds.clamp(0, 999);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 3,
                  backgroundColor: ext.glassBorder,
                  valueColor: AlwaysStoppedAnimation(ext.accentGlow),
                ),
                Icon(Icons.timer_rounded, size: 18, color: ext.accentGlow),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.workoutRestTitle,
                  style: TextStyle(
                    color: ext.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '0:${seconds.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onAddSeconds,
            child: Text(
              l10n.workoutRestAddSeconds,
              style: TextStyle(color: ext.accentGlow, fontWeight: FontWeight.w800),
            ),
          ),
          TextButton(
            onPressed: onSkip,
            child: Text(
              l10n.workoutRestSkip,
              style: TextStyle(color: ext.textMuted, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
