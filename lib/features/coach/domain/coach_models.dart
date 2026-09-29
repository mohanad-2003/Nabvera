/// One turn in the AI coach conversation. Held only in memory for the
/// current app session — not persisted, so the conversation resets on
/// app restart (see `CoachChatController`).
class CoachMessage {
  const CoachMessage({
    required this.role,
    required this.content,
    this.isError = false,
  });

  final CoachMessageRole role;
  final String content;

  /// True for a locally-generated "couldn't reach the coach" bubble —
  /// never sent to the backend as conversation history.
  final bool isError;

  Map<String, String> toApiJson() => {
    'role': role == CoachMessageRole.user ? 'user' : 'assistant',
    'content': content,
  };
}

enum CoachMessageRole { user, assistant }
