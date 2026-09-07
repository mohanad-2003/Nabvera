import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Header for the Create Routine screen: back button, large title,
/// subtitle, and a small motivational line — plain text, not a boxed
/// chip, so the header stays as flat as the rest of the redesigned page.
class RoutineHeader extends StatelessWidget {
  const RoutineHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.motivation,
  });

  final String title;
  final String subtitle;
  final String motivation;

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
              if (context.canPop())
                PremiumIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => context.pop(),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: ext.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.bolt_rounded, color: ext.accentGlow, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  motivation,
                  style: TextStyle(
                    color: ext.accentGlow,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
