import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/features/coach/data/coach_repository.dart';
import 'package:nabvera/features/coach/domain/coach_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'coach_controller.g.dart';

/// The current chat's messages plus whether a reply is in flight — kept
/// only for the app session (see `CoachMessage`'s doc comment), so
/// reopening the coach screen later starts a fresh conversation.
class CoachChatState {
  const CoachChatState({this.messages = const [], this.isSending = false});

  final List<CoachMessage> messages;
  final bool isSending;

  CoachChatState copyWith({List<CoachMessage>? messages, bool? isSending}) =>
      CoachChatState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
      );
}

@riverpod
class CoachChatController extends _$CoachChatController {
  @override
  CoachChatState build() => const CoachChatState();

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    // The history sent to the backend excludes any local error bubbles —
    // those never happened as far as the model is concerned.
    final history =
        state.messages
            .where((m) => !m.isError)
            .map((m) => m.toApiJson())
            .toList();

    state = state.copyWith(
      messages: [
        ...state.messages,
        CoachMessage(role: CoachMessageRole.user, content: trimmed),
      ],
      isSending: true,
    );

    try {
      final reply = await ref
          .read(coachRepositoryProvider)
          .sendMessage(trimmed, history);
      state = state.copyWith(
        messages: [
          ...state.messages,
          CoachMessage(role: CoachMessageRole.assistant, content: reply),
        ],
        isSending: false,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          CoachMessage(
            role: CoachMessageRole.assistant,
            content: e.message,
            isError: true,
          ),
        ],
        isSending: false,
      );
    }
  }
}
