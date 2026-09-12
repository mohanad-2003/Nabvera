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

const _kCategories = ['nutrition', 'workout', 'recovery', 'mindset'];

/// Create/edit form for an Article — `state.extra` (the raw document from
/// the list page) means edit mode (`PATCH /articles/:id`); no extra means
/// create (`POST /articles`).
class AdminArticleEditorPage extends ConsumerStatefulWidget {
  const AdminArticleEditorPage({super.key, this.existing});

  final Map<String, dynamic>? existing;

  @override
  ConsumerState<AdminArticleEditorPage> createState() =>
      _AdminArticleEditorPageState();
}

class _AdminArticleEditorPageState
    extends ConsumerState<AdminArticleEditorPage> {
  late final _title = TextEditingController(
    text: widget.existing?['title'] as String?,
  );
  late final _description = TextEditingController(
    text: widget.existing?['description'] as String?,
  );
  late final _imageUrl = TextEditingController(
    text: widget.existing?['imageUrl'] as String?,
  );
  late final _content = TextEditingController(
    text: _linesOf(widget.existing?['content']),
  );
  late final _titleAr = TextEditingController(
    text: widget.existing?['titleAr'] as String?,
  );
  late final _descriptionAr = TextEditingController(
    text: widget.existing?['descriptionAr'] as String?,
  );
  late final _contentAr = TextEditingController(
    text: _linesOf(widget.existing?['contentAr']),
  );
  late final _readTime = TextEditingController(
    text: widget.existing?['readTimeMinutes']?.toString() ?? '3',
  );
  late String _category =
      (widget.existing?['category'] as String?) ?? _kCategories.first;
  bool _saving = false;
  bool get _isEditing => widget.existing != null;

  static String _linesOf(dynamic value) =>
      (value as List?)?.cast<String>().join('\n') ?? '';

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _imageUrl.dispose();
    _content.dispose();
    _titleAr.dispose();
    _descriptionAr.dispose();
    _contentAr.dispose();
    _readTime.dispose();
    super.dispose();
  }

  static List<String> _paragraphsOf(String text) => text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  Future<void> _save(AppLocalizations l10n) async {
    if (_title.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final payload = <String, dynamic>{
      'title': _title.text.trim(),
      'description': _description.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'content': _paragraphsOf(_content.text),
      'readTimeMinutes': int.tryParse(_readTime.text.trim()) ?? 3,
      'category': _category,
      // Optional Arabic translation — left as '' / [] when not filled in,
      // which the Flutter app treats as "not translated yet" and falls
      // back to the English fields above (see `ArticleTip.localizedTitle`).
      'titleAr': _titleAr.text.trim(),
      'descriptionAr': _descriptionAr.text.trim(),
      'contentAr': _paragraphsOf(_contentAr.text),
    };
    try {
      final repo = ref.read(adminRepositoryProvider);
      if (_isEditing) {
        await repo.update(
          AdminEntity.article,
          widget.existing!['_id'] as String,
          payload,
        );
      } else {
        await repo.create(AdminEntity.article, payload);
      }
      await ref.read(adminArticlesControllerProvider.notifier).refresh();
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
                    ? l10n.adminEditArticleTitle
                    : l10n.adminAddArticleTitle,
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
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _imageUrl,
                  label: l10n.adminFieldImageUrl,
                  flat: true,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _content,
                  label: l10n.adminFieldContent,
                  hint: l10n.adminFieldOnePerLine,
                  flat: true,
                  maxLines: 6,
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
                  controller: _titleAr,
                  label: l10n.adminFieldTitleAr,
                  flat: true,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _descriptionAr,
                  label: l10n.adminFieldDescriptionAr,
                  flat: true,
                  maxLines: 2,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _contentAr,
                  label: l10n.adminFieldContentAr,
                  hint: l10n.adminFieldOnePerLine,
                  flat: true,
                  maxLines: 6,
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: _readTime,
                        label: l10n.adminFieldReadTimeMinutes,
                        flat: true,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _category,
                        decoration: InputDecoration(
                          labelText: l10n.adminFieldCategory,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(color: ext.glassBorder),
                          ),
                        ),
                        items: [
                          for (final category in _kCategories)
                            DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) setState(() => _category = value);
                        },
                      ),
                    ),
                  ],
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
