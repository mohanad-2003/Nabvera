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

const _kCategories = ['breakfast', 'lunch', 'dinner', 'snack', 'drink'];
const _kDifficulties = ['easy', 'medium', 'hard'];

/// Create/edit form for one Recipe — name, calories, protein, ingredients,
/// and steps, per the brief. Ingredients/steps are edited as one entry per
/// line (name/instruction only — amount and step order are auto-assigned)
/// to keep the form usable on a phone without a full repeatable-row editor.
class AdminRecipeEditorPage extends ConsumerStatefulWidget {
  const AdminRecipeEditorPage({super.key, this.existing});

  final Map<String, dynamic>? existing;

  @override
  ConsumerState<AdminRecipeEditorPage> createState() =>
      _AdminRecipeEditorPageState();
}

class _AdminRecipeEditorPageState extends ConsumerState<AdminRecipeEditorPage> {
  late final _title = TextEditingController(
    text: widget.existing?['title'] as String?,
  );
  late final _description = TextEditingController(
    text: widget.existing?['description'] as String?,
  );
  late final _imageUrl = TextEditingController(
    text: widget.existing?['imageUrl'] as String?,
  );
  late final _prepTime = TextEditingController(
    text: widget.existing?['prepTimeMinutes']?.toString(),
  );
  late final _nutrition =
      widget.existing?['nutrition'] as Map<String, dynamic>?;
  late final _calories = TextEditingController(
    text: _nutrition?['calories']?.toString(),
  );
  late final _protein = TextEditingController(
    text: _nutrition?['proteinG']?.toString(),
  );
  late final _carbs = TextEditingController(
    text: _nutrition?['carbsG']?.toString(),
  );
  late final _fat = TextEditingController(
    text: _nutrition?['fatG']?.toString(),
  );
  late final _ingredients = TextEditingController(
    text: ((widget.existing?['ingredients'] as List?) ?? const [])
        .map((e) => (e as Map)['name'])
        .join('\n'),
  );
  late final _steps = TextEditingController(
    text: ((widget.existing?['steps'] as List?) ?? const [])
        .map((e) => (e as Map)['instruction'])
        .join('\n'),
  );
  late String _category =
      (widget.existing?['category'] as String?) ?? _kCategories.first;
  late String _difficulty =
      (widget.existing?['difficulty'] as String?) ?? _kDifficulties.first;
  bool _saving = false;
  bool get _isEditing => widget.existing != null;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _imageUrl.dispose();
    _prepTime.dispose();
    _calories.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    _ingredients.dispose();
    _steps.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _saving = true);

    final ingredientLines = _ingredients.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);
    final stepLines = _steps.text
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);

    final payload = <String, dynamic>{
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'category': _category,
      'difficulty': _difficulty,
      'prepTimeMinutes': int.tryParse(_prepTime.text.trim()) ?? 0,
      'nutrition': {
        'calories': int.tryParse(_calories.text.trim()) ?? 0,
        'proteinG': int.tryParse(_protein.text.trim()) ?? 0,
        'carbsG': int.tryParse(_carbs.text.trim()) ?? 0,
        'fatG': int.tryParse(_fat.text.trim()) ?? 0,
      },
      'ingredients': [
        for (final name in ingredientLines) {'name': name, 'amount': ''},
      ],
      'steps': [
        for (final (index, instruction) in stepLines.indexed)
          {'order': index + 1, 'instruction': instruction},
      ],
    };
    try {
      final repo = ref.read(adminRepositoryProvider);
      if (_isEditing) {
        await repo.update(
          AdminEntity.recipe,
          widget.existing!['_id'] as String,
          payload,
        );
      } else {
        await repo.create(AdminEntity.recipe, payload);
      }
      await ref.read(adminRecipesControllerProvider.notifier).refresh();
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
                    ? l10n.adminEditRecipeTitle
                    : l10n.adminAddRecipeTitle,
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
                AppTextField(
                  controller: _prepTime,
                  label: l10n.adminFieldPrepTimeMinutes,
                  flat: true,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _Dropdown(
                        label: l10n.adminFieldCategory,
                        value: _category,
                        options: _kCategories,
                        onChanged: (value) => setState(() => _category = value),
                        ext: ext,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _Dropdown(
                        label: l10n.adminFieldDifficulty,
                        value: _difficulty,
                        options: _kDifficulties,
                        onChanged:
                            (value) => setState(() => _difficulty = value),
                        ext: ext,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  l10n.adminFieldNutrition,
                  style: TextStyle(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _calories,
                        label: l10n.adminFieldCalories,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _protein,
                        label: l10n.adminFieldProtein,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _carbs,
                        label: l10n.adminFieldCarbs,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppTextField(
                        controller: _fat,
                        label: l10n.adminFieldFat,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _ingredients,
                  label: l10n.adminFieldIngredients,
                  hint: l10n.adminFieldOnePerLine,
                  flat: true,
                  maxLines: 5,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _steps,
                  label: l10n.adminFieldSteps,
                  hint: l10n.adminFieldOnePerLine,
                  flat: true,
                  maxLines: 5,
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
