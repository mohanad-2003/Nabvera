import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/app_text_field.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/admin/data/admin_repository.dart';
import 'package:nabvera/features/admin/presentation/providers/admin_content_controllers.dart';
import 'package:nabvera/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Challenge types the app can actually track progress for — see
/// `backend/src/utils/challengeProgressHelpers.js`'s `CHALLENGE_TYPES`.
/// Kept in sync manually since this is the only Flutter call site that
/// needs the raw list (everywhere else reads `type` from the backend).
const _kChallengeTypes = [
  'workouts_count',
  'active_minutes',
  'workout_streak',
  'weekly_consistency',
];

/// Create/edit form for a Challenge — `state.extra` (the raw document from
/// the list page) means edit mode (`PATCH /challenges/:id`); no extra
/// means create (`POST /challenges`).
class AdminChallengeEditorPage extends ConsumerStatefulWidget {
  const AdminChallengeEditorPage({super.key, this.existing});

  final Map<String, dynamic>? existing;

  @override
  ConsumerState<AdminChallengeEditorPage> createState() =>
      _AdminChallengeEditorPageState();
}

class _AdminChallengeEditorPageState
    extends ConsumerState<AdminChallengeEditorPage> {
  late final _name = TextEditingController(
    text: widget.existing?['name'] as String?,
  );
  late final _nameAr = TextEditingController(
    text: widget.existing?['nameAr'] as String?,
  );
  late final _details = TextEditingController(
    text: widget.existing?['details'] as String?,
  );
  late final _detailsAr = TextEditingController(
    text: widget.existing?['detailsAr'] as String?,
  );
  late final _imageUrl = TextEditingController(
    text: widget.existing?['imageUrl'] as String?,
  );
  late final _durationLabel = TextEditingController(
    text: widget.existing?['durationLabel'] as String?,
  );
  late final _caloriesLabel = TextEditingController(
    text: widget.existing?['caloriesLabel'] as String?,
  );
  late final _targetValue = TextEditingController(
    text: widget.existing?['targetValue']?.toString(),
  );
  late bool _isFeatured = widget.existing?['isFeatured'] as bool? ?? false;
  bool _saving = false;
  bool get _isEditing => widget.existing != null;

  // `null` keeps the challenge untrackable (view-only, no join) — an admin
  // opts in to progress tracking explicitly by picking a type.
  late String? _type = widget.existing?['type'] as String?;

  @override
  void dispose() {
    _name.dispose();
    _nameAr.dispose();
    _details.dispose();
    _detailsAr.dispose();
    _imageUrl.dispose();
    _durationLabel.dispose();
    _caloriesLabel.dispose();
    _targetValue.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final targetValue = int.tryParse(_targetValue.text.trim());
    final payload = <String, dynamic>{
      'name': _name.text.trim(),
      // Optional Arabic translations — left as '' when not filled in, which
      // the Flutter app treats as "not translated yet" and falls back to
      // the English fields above (see `ChallengeItem.localizedName`).
      'nameAr': _nameAr.text.trim(),
      'details': _details.text.trim(),
      'detailsAr': _detailsAr.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'durationLabel': _durationLabel.text.trim(),
      'caloriesLabel': _caloriesLabel.text.trim(),
      'isFeatured': _isFeatured,
      if (_type != null) 'type': _type,
      if (_type != null && targetValue != null) 'targetValue': targetValue,
    };
    try {
      final repo = ref.read(adminRepositoryProvider);
      if (_isEditing) {
        await repo.update(
          AdminEntity.challenge,
          widget.existing!['_id'] as String,
          payload,
        );
      } else {
        await repo.create(AdminEntity.challenge, payload);
      }
      await ref.read(adminChallengesControllerProvider.notifier).refresh();
      if (!mounted) return;
      context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.adminSaveFailed)));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _challengeTypeLabel(AppLocalizations l10n, String type) {
    switch (type) {
      case 'workouts_count':
        return l10n.adminChallengeTypeWorkoutsCount;
      case 'active_minutes':
        return l10n.adminChallengeTypeActiveMinutes;
      case 'workout_streak':
        return l10n.adminChallengeTypeWorkoutStreak;
      case 'weekly_consistency':
        return l10n.adminChallengeTypeWeeklyConsistency;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(
            title:
                _isEditing
                    ? l10n.adminEditChallengeTitle
                    : l10n.adminAddChallengeTitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              children: [
                AppTextField(
                  controller: _name,
                  label: l10n.adminFieldName,
                  flat: true,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _details,
                  label: l10n.adminFieldGoal,
                  flat: true,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _imageUrl,
                  label: l10n.adminFieldImageUrl,
                  flat: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.adminArabicTranslationHeading,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.adminArabicTranslationSubtitle,
                  style: TextStyle(color: ext.textMuted, fontSize: 12),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _nameAr,
                  label: l10n.adminFieldNameAr,
                  flat: true,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _detailsAr,
                  label: l10n.adminFieldDetailsAr,
                  flat: true,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _durationLabel,
                        label: l10n.adminFieldDuration,
                        flat: true,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        controller: _caloriesLabel,
                        label: l10n.adminFieldCalories,
                        flat: true,
                      ),
                    ),
                  ],
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.adminFieldFeatured,
                    style: TextStyle(color: ext.textPrimary),
                  ),
                  value: _isFeatured,
                  onChanged: (value) => setState(() => _isFeatured = value),
                ),
                const SizedBox(height: AppSpacing.md),
                // Optional: a challenge stays view-only until both a type
                // and a target are set — see `Challenge.type`'s doc
                // comment on the backend for why this can't be required.
                DropdownButtonFormField<String?>(
                  initialValue: _type,
                  decoration: InputDecoration(
                    labelText: l10n.adminFieldChallengeType,
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(l10n.adminChallengeTypeNone),
                    ),
                    for (final type in _kChallengeTypes)
                      DropdownMenuItem(
                        value: type,
                        child: Text(_challengeTypeLabel(l10n, type)),
                      ),
                  ],
                  onChanged: (value) => setState(() => _type = value),
                ),
                if (_type != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    controller: _targetValue,
                    label: l10n.adminFieldTargetValue,
                    flat: true,
                    keyboardType: TextInputType.number,
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: l10n.adminSave,
                  isLoading: _saving,
                  onPressed: () => _save(l10n),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
