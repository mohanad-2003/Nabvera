import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/fade_slide_in.dart';

/// Large title + motivational subtitle + flat back button + "mark all as
/// read" action. Fades and slides in on first build.
class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.onMarkAllRead,
    required this.markAllReadLabel,
    this.canPop = true,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final VoidCallback onMarkAllRead;
  final String markAllReadLabel;
  final bool canPop;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return FadeSlideIn(
      offset: const Offset(0, -0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (canPop)
                _HeaderIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
              const Spacer(),
              _HeaderIconButton(
                icon: Icons.done_all_rounded,
                onTap: onMarkAllRead,
                tooltip: markAllReadLabel,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final button = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, color: ext.textPrimary, size: 20),
      ),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}
