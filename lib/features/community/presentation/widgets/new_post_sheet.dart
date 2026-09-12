import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/app_text_field.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/community/presentation/providers/community_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the composer for a new Community post — the feature the feed's
/// "Forums" tab never actually had (view/like/comment all worked, nothing
/// ever called `POST /posts`; see `CommunityRepository.createPost`).
Future<void> showNewPostSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _NewPostSheet(),
  );
}

class _NewPostSheet extends ConsumerStatefulWidget {
  const _NewPostSheet();

  @override
  ConsumerState<_NewPostSheet> createState() => _NewPostSheetState();
}

class _NewPostSheetState extends ConsumerState<_NewPostSheet> {
  final _controller = TextEditingController();
  bool _posting = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() {
      _posting = true;
      _error = null;
    });
    try {
      await ref.read(communityForumsProvider.notifier).create(content);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = AppLocalizations.of(context).communityPostFailed;
        _posting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ext.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: ext.glassBorder),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.communityNewPostTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ext.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 14),
            AppTextField(
              controller: _controller,
              hint: l10n.communityNewPostHint,
              maxLines: 5,
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: ext.danger, fontSize: 12.5)),
            ],
            const SizedBox(height: 16),
            PrimaryButton(
              label: l10n.communityPostAction,
              isLoading: _posting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
