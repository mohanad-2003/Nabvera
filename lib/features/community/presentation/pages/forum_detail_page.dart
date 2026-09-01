import 'package:fitness_app/core/localization/generated/app_localizations.dart';
import 'package:fitness_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/widgets/premium_scaffold.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../domain/community_models.dart';
import '../providers/community_controller.dart';

class ForumDetailPage extends ConsumerStatefulWidget {
  const ForumDetailPage({super.key, required this.thread});

  final ForumThread thread;

  @override
  ConsumerState<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends ConsumerState<ForumDetailPage> {
  final _replyController = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
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
    final comments = ref.watch(forumCommentsProvider(widget.thread.id));

    return PremiumScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PremiumHeader(
            title: widget.thread.subtitle,
            subtitle: widget.thread.date,
            showBack: true,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                _DiscussionCard(
                  ext: ext,
                  authorName: widget.thread.subtitle,
                  body: widget.thread.content,
                  isTopContribution: true,
                ),
                for (final comment in comments) ...[
                  Divider(height: 1, color: ext.glassBorder),
                  _DiscussionCard(
                    ext: ext,
                    authorName: comment.authorName,
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
                      hint: 'Write a reply…',
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
