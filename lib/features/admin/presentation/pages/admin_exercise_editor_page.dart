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

const _kMuscleGroups = [
  'chest',
  'back',
  'legs',
  'shoulders',
  'arms',
  'core',
  'full_body',
  'cardio',
];
const _kEquipment = [
  'none',
  'dumbbell',
  'barbell',
  'machine',
  'resistance_band',
  'kettlebell',
];
const _kDifficulties = ['beginner', 'intermediate', 'advanced'];

/// Create/edit form for one Exercise — name, muscle group, equipment,
/// difficulty, and video, per the brief; `PATCH`/`POST /exercises`.
class AdminExerciseEditorPage extends ConsumerStatefulWidget {
  const AdminExerciseEditorPage({super.key, this.existing});

  final Map<String, dynamic>? existing;

  @override
  ConsumerState<AdminExerciseEditorPage> createState() =>
      _AdminExerciseEditorPageState();
}

class _AdminExerciseEditorPageState
    extends ConsumerState<AdminExerciseEditorPage> {
  late final _name = TextEditingController(
    text: widget.existing?['name'] as String?,
  );
  late final _nameAr = TextEditingController(
    text: widget.existing?['nameAr'] as String?,
  );
  late final _description = TextEditingController(
    text: widget.existing?['description'] as String?,
  );
  late final _descriptionAr = TextEditingController(
    text: widget.existing?['descriptionAr'] as String?,
  );
  late final _imageUrl = TextEditingController(
    text: widget.existing?['imageUrl'] as String?,
  );
  late final _videoUrl = TextEditingController(
    text: widget.existing?['videoUrl'] as String?,
  );
  late String _muscleGroup =
      (widget.existing?['muscleGroup'] as String?) ?? _kMuscleGroups.first;
  late String _equipment =
      (widget.existing?['equipment'] as String?) ?? _kEquipment.first;
  late String _difficulty =
      (widget.existing?['difficulty'] as String?) ?? _kDifficulties.first;
  bool _saving = false;
  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _name.dispose();
    _nameAr.dispose();
    _description.dispose();
    _descriptionAr.dispose();
    _imageUrl.dispose();
    _videoUrl.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final payload = <String, dynamic>{
      'name': _name.text.trim(),
      // Optional Arabic translation — left as '' when not filled in, which
      // the Flutter app treats as "not translated yet" and falls back to
      // the English name above (see `RoutineExercise.localizedName`).
      'nameAr': _nameAr.text.trim(),
      'description': _description.text.trim(),
      'descriptionAr': _descriptionAr.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'videoUrl': _videoUrl.text.trim(),
      'muscleGroup': _muscleGroup,
      'equipment': _equipment,
      'difficulty': _difficulty,
    };
    try {
      final repo = ref.read(adminRepositoryProvider);
      if (_isEditing) {
        await repo.update(
          AdminEntity.exercise,
          widget.existing!['_id'] as String,
          payload,
        );
      } else {
        await repo.create(AdminEntity.exercise, payload);
      }
      await ref.read(adminExercisesControllerProvider.notifier).refresh();
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
                    ? l10n.adminEditExerciseTitle
                    : l10n.adminAddExerciseTitle,
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
                  controller: _description,
                  label: l10n.adminFieldDescription,
                  flat: true,
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _imageUrl,
                  label: l10n.adminFieldImageUrl,
                  flat: true,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _videoUrl,
                  label: l10n.adminFieldVideoUrl,
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
                  controller: _descriptionAr,
                  label: l10n.adminFieldDescriptionAr,
                  flat: true,
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                _Dropdown(
                  label: l10n.adminFieldMuscleGroup,
                  value: _muscleGroup,
                  options: _kMuscleGroups,
                  onChanged: (value) => setState(() => _muscleGroup = value),
                  ext: ext,
                ),
                const SizedBox(height: AppSpacing.md),
                _Dropdown(
                  label: l10n.adminFieldEquipment,
                  value: _equipment,
                  options: _kEquipment,
                  onChanged: (value) => setState(() => _equipment = value),
                  ext: ext,
                ),
                const SizedBox(height: AppSpacing.md),
                _Dropdown(
                  label: l10n.adminFieldDifficulty,
                  value: _difficulty,
                  options: _kDifficulties,
                  onChanged: (value) => setState(() => _difficulty = value),
                  ext: ext,
                ),
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

class _Dropdown extends StatelessWidget {
  const _Dropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    required this.ext,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ext.glassBorder),
        ),
      ),
      items: [
        for (final option in options)
          DropdownMenuItem(value: option, child: Text(option)),
      ],
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
