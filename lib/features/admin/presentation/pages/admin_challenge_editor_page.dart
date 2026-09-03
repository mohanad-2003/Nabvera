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

/// Create-only form for a Challenge — name, goal (details), duration, and
/// image, per the brief. No `PATCH /challenges/:id` exists on the backend
/// (see `backend/src/routes/challengeRoutes.js`), so — like Articles —
/// this page never opens in an edit mode.
class AdminChallengeEditorPage extends ConsumerStatefulWidget {
  const AdminChallengeEditorPage({super.key});

  @override
  ConsumerState<AdminChallengeEditorPage> createState() =>
      _AdminChallengeEditorPageState();
}

class _AdminChallengeEditorPageState
    extends ConsumerState<AdminChallengeEditorPage> {
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _imageUrl = TextEditingController();
  final _durationLabel = TextEditingController();
  final _caloriesLabel = TextEditingController();
  bool _isFeatured = false;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _details.dispose();
    _imageUrl.dispose();
    _durationLabel.dispose();
    _caloriesLabel.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations l10n) async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final payload = <String, dynamic>{
      'name': _name.text.trim(),
      'details': _details.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'durationLabel': _durationLabel.text.trim(),
      'caloriesLabel': _caloriesLabel.text.trim(),
      'isFeatured': _isFeatured,
    };
    try {
      await ref
          .read(adminRepositoryProvider)
          .create(AdminEntity.challenge, payload);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return PremiumScaffold(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminPageHeader(title: l10n.adminAddChallengeTitle, showBack: true),
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
