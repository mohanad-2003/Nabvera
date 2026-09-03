import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_radius_shadows.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/pressable_scale.dart';
import 'package:fitness_app/core/widgets/smart_image.dart';
import 'package:flutter/material.dart';

/// One row in an Admin content list (a workout, exercise, recipe, article,
/// or challenge): thumbnail, title, a couple of small meta chips, and
/// edit/delete actions. One shared card for every entity list so they all
/// look and behave identically regardless of what they manage.
class AdminContentCard extends StatelessWidget {
  const AdminContentCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.subtitle,
    this.metaChips = const [],
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final String title;
  final String? imageUrl;
  final String? subtitle;

  /// Small pill labels — difficulty, category, muscle group, etc.
  final List<String> metaChips;

  final VoidCallback? onTap;

  /// Null hides the edit action entirely — some entities (Articles,
  /// Challenges) have no update endpoint, so there's genuinely nothing to
  /// edit rather than a disabled button pretending otherwise.
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return PressableScale(
      enabled: onTap != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: ext.glassFill,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
              border: Border.all(color: ext.glassBorder),
              boxShadow: AppShadows.floating(Theme.of(context).brightness),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: SmartImage(
                    imageUrl ?? '',
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: ext.textMuted, fontSize: 12),
                        ),
                      ],
                      if (metaChips.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: [
                            for (final chip in metaChips)
                              _MetaChip(label: chip, ext: ext),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                if (onEdit != null)
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: ext.textMuted,
                      size: 20,
                    ),
                    onPressed: onEdit,
                    tooltip: l10n.adminActionEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: ext.danger,
                      size: 20,
                    ),
                    onPressed: onDelete,
                    tooltip: l10n.adminActionDelete,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, required this.ext});

  final String label;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: ext.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: ext.glassBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ext.textMuted,
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
