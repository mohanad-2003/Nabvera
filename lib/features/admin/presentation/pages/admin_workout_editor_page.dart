import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/theme/app_spacing.dart';
import 'package:fitness_app/core/theme/app_theme_extension.dart';
import 'package:fitness_app/core/widgets/app_text_field.dart';
import 'package:fitness_app/core/widgets/premium_scaffold.dart';
import 'package:fitness_app/core/widgets/primary_button.dart';
import 'package:fitness_app/features/admin/data/admin_repository.dart';
import 'package:fitness_app/features/admin/presentation/providers/admin_content_controllers.dart';
import 'package:fitness_app/features/admin/presentation/widgets/admin_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const _kCategories = [
  'strength',
  'cardio',
  'yoga',
  'hiit',
  'stretching',
  'full_body',
];
const _kDifficulties = ['beginner', 'intermediate', 'advanced'];

/// Create/edit form for one Workout — `state.extra` (the raw document from
/// the list page) means edit mode (`PATCH /workouts/:id`); no extra means
/// create (`POST /workouts`). The nested exercises list isn't edited here
/// (no exercise picker in this batch) — editing preserves whatever
/// exercises the workout already had, since an omitted field in a PATCH
/// body leaves the existing value untouched.
class AdminWorkoutEditorPage extends ConsumerStatefulWidget {
  const AdminWorkoutEditorPage({super.key, this.existing});

  final Map<String, dynamic>? existing;

  @override
  ConsumerState<AdminWorkoutEditorPage> createState() =>
      _AdminWorkoutEditorPageState();
}

class _AdminWorkoutEditorPageState
    extends ConsumerState<AdminWorkoutEditorPage> {
  late final _title = TextEditingController(
    text: widget.existing?['title'] as String?,
  );
  late final _description = TextEditingController(
    text: widget.existing?['description'] as String?,
  );
  late final _imageUrl = TextEditingController(
    text: widget.existing?['coverImageUrl'] as String?,
  );
  late final _duration = TextEditingController(
    text: widget.existing?['durationMinutes']?.toString(),
  );
  late final _calories = TextEditingController(
    text: widget.existing?['estimatedCalories']?.toString(),
  );
  late String _category =
      (widget.existing?['category'] as String?) ?? _kCategories.first;
  late String _difficulty =
      (widget.existing?['difficulty'] as String?) ?? _kDifficulties.first;
  late bool _isFeatured = widget.existing?['isFeatured'] as bool? ?? false;
  late bool _isPopular = widget.existing?['isPopular'] as bool? ?? false;
  bool _saving = false;
  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _imageUrl.dispose();
    _duration.dispose();
    _calories.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final payload = <String, dynamic>{
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'coverImageUrl': _imageUrl.text.trim(),
      'category': _category,
      'difficulty': _difficulty,
      'durationMinutes': int.tryParse(_duration.text.trim()) ?? 0,
      'estimatedCalories': int.tryParse(_calories.text.trim()) ?? 0,
      'isFeatured': _isFeatured,
      'isPopular': _isPopular,
    };
    try {
      final repo = ref.read(adminRepositoryProvider);
      if (_isEditing) {
        await repo.update(
          AdminEntity.workout,
          widget.existing!['_id'] as String,
          payload,
        );
      } else {
        await repo.create(AdminEntity.workout, payload);
      }
      await ref.read(adminWorkoutsControllerProvider.notifier).refresh();
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
                    ? l10n.adminEditWorkoutTitle
                    : l10n.adminAddWorkoutTitle,
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
                  controller: _title,
                  label: l10n.adminFieldTitle,
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
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _duration,
                        label: l10n.adminFieldDurationMinutes,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppTextField(
                        controller: _calories,
                        label: l10n.adminFieldCalories,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _EnumDropdown(
                  label: l10n.adminFieldCategory,
                  value: _category,
                  options: _kCategories,
                  onChanged: (value) => setState(() => _category = value),
                ),
                const SizedBox(height: AppSpacing.md),
                _EnumDropdown(
                  label: l10n.adminFieldDifficulty,
                  value: _difficulty,
                  options: _kDifficulties,
                  onChanged: (value) => setState(() => _difficulty = value),
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
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    l10n.adminFieldPopular,
                    style: TextStyle(color: ext.textPrimary),
                  ),
                  value: _isPopular,
                  onChanged: (value) => setState(() => _isPopular = value),
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

class _EnumDropdown extends StatelessWidget {
  const _EnumDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
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
