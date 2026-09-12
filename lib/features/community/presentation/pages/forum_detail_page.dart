import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/user_avatar.dart';
import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:nabvera/features/community/presentation/providers/community_controller.dart';

class ForumDetailPage extends ConsumerStatefulWidget {
  const ForumDetailPage({super.key, required this.thread});

  final ForumThread thread;

  @override
  ConsumerState<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends ConsumerState<ForumDetailPage> {
  final _replyController = TextEditingController();
  bool _sending = false;
  bool _deleting = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.communityDeletePostTitle),
            content: Text(l10n.communityDeletePostBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.actionCancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(
                  l10n.privacyDelete,
                  style: TextStyle(color: ext.danger),
                ),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleting = true);
    try {
      await ref
          .read(communityForumsProvider.notifier)
          .delete(widget.thread.id);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.communityDeletePostFailed)),
      );
    }
  }

  Future<void> _send() async {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref
          .read(forumCommentsProvider(widget.thread.id).notifier)
          .add(text);
      _replyController.clear();
    } catch (_) {
      // Swallow — the composer just stays populated so the user can retry.
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);
    final comments = ref.watch(forumCommentsProvider(widget.thread.id));

    return PremiumScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumHeader(
            title: widget.thread.displayAuthorName(l10n),
            subtitle: widget.thread.date,
            showBack: true,
            trailing:
                widget.thread.isOwnPost
                    ? PremiumIconButton(
                      icon: Icons.delete_outline_rounded,
                      onTap: () {
                        if (!_deleting) _confirmDelete();
                      },
                    )
                    : null,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                _DiscussionCard(
                  ext: ext,
                  authorName: widget.thread.displayAuthorName(l10n),
                  body: widget.thread.content,
                  isTopContribution: true,
                ),
                for (final comment in comments) ...[
                  Divider(height: 1, color: ext.glassBorder),
                  _DiscussionCard(
                    ext: ext,
                    authorName: comment.displayAuthorName(l10n),
                    body: comment.text,
                    isTopContribution: false,
                  ),
                ],
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: _replyController,
                      hint: l10n.communityReplyHint,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sending ? null : _send,
                    icon:
                        _sending
                            ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscussionCard extends StatelessWidget {
  const _DiscussionCard({
    required this.ext,
    required this.authorName,
    required this.body,
    required this.isTopContribution,
  });

  final AppThemeExtension ext;
  final String authorName;
  final String body;
  final bool isTopContribution;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const UserAvatar(radius: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authorName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: ext.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      isTopContribution
                          ? l10n.communityTopContribution
                          : l10n.communityMember,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: ext.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (isTopContribution)
                Icon(Icons.star_rounded, color: theme.colorScheme.primary),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: theme.textTheme.bodyMedium?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}
