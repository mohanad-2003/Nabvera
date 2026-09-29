import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/features/coach/domain/coach_models.dart';
import 'package:nabvera/features/coach/presentation/providers/coach_controller.dart';

/// The AI fitness/nutrition coach chat — a single conversation, held only
/// for this app session (see [CoachMessage]'s doc comment). Reached from
/// Home's header icon.
class CoachChatPage extends ConsumerStatefulWidget {
  const CoachChatPage({super.key});

  @override
  ConsumerState<CoachChatPage> createState() => _CoachChatPageState();
}

class _CoachChatPageState extends ConsumerState<CoachChatPage> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _send() async {
    final text = _inputController.text;
    if (text.trim().isEmpty) return;
    _inputController.clear();
    await ref.read(coachChatControllerProvider.notifier).sendMessage(text);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final isArabic =
        Directionality.of(context) == TextDirection.rtl;
    final state = ref.watch(coachChatControllerProvider);

    ref.listen(coachChatControllerProvider, (previous, next) {
      if (next.messages.length != previous?.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: ext.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                child: Row(
                  children: [
                    if (context.canPop())
                      PremiumBackButton(onTap: () => context.pop()),
                    const SizedBox(width: 8),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: ext.accentGradient,
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: ext.onAccent,
                        size: 19,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isArabic ? 'المدرب الذكي' : 'AI Coach',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: ext.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    state.messages.isEmpty
                        ? _EmptyState(isArabic: isArabic)
                        : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          itemCount: state.messages.length,
                          itemBuilder:
                              (context, index) =>
                                  _MessageBubble(message: state.messages[index]),
                        ),
              ),
              if (state.isSending)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _TypingIndicator(isArabic: isArabic),
                ),
              _InputBar(
                controller: _inputController,
                enabled: !state.isSending,
                onSend: _send,
                isArabic: isArabic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_rounded,
              size: 40,
              color: ext.accentGlow.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 14),
            Text(
              isArabic
                  ? 'اسأل مدربك الذكي عن أي شيء يخص تمرينك أو تغذيتك'
                  : 'Ask your AI coach anything about your workouts or nutrition',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: ext.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final CoachMessage message;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final isUser = message.role == CoachMessageRole.user;

    final bubbleColor =
        message.isError
            ? ext.danger.withValues(alpha: 0.14)
            : isUser
            ? ext.accentGlow.withValues(alpha: 0.18)
            : ext.glassFill;
    final borderColor =
        message.isError ? ext.danger.withValues(alpha: 0.3) : ext.glassBorder;
    final textColor = message.isError ? ext.danger : ext.textPrimary;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          message.content,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: textColor, height: 1.4),
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(ext.accentGlow),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            isArabic ? 'المدرب يكتب...' : 'Coach is typing...',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: ext.textMuted),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.enabled,
    required this.onSend,
    required this.isArabic,
  });

  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: ext.glassFill,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: ext.glassBorder),
              ),
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                style: TextStyle(color: ext.textPrimary),
                decoration: InputDecoration(
                  hintText:
                      isArabic ? 'اكتب رسالتك...' : 'Type your message...',
                  hintStyle: TextStyle(color: ext.textMuted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: enabled ? onSend : null,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient:
                    enabled
                        ? LinearGradient(
                          colors: [
                            AppColors.seedLime,
                            AppColors.electricOrange,
                          ],
                        )
                        : null,
                color: enabled ? null : ext.glassFill,
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: enabled ? ext.onAccent : ext.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
