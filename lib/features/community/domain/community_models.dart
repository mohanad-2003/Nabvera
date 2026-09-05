class ChallengeItem {
  const ChallengeItem({
    this.id = '',
    required this.image,
    required this.name,
    required this.details,
    this.durationLabel,
    this.caloriesLabel,
    this.type,
    this.targetValue,
  });

  /// Backend `Challenge._id` — needed to call `/challenges/:id/join`, etc.
  final String id;
  final String image;
  final String name;
  final String details;
  final String? durationLabel;
  final String? caloriesLabel;

  /// One of `workouts_count` / `active_minutes` / `workout_streak` /
  /// `weekly_consistency` (see `backend/src/utils/challengeProgressHelpers.
  /// js`), or `null` for a legacy challenge an admin hasn't configured for
  /// progress tracking yet — such a challenge can be viewed but not joined.
  final String? type;
  final int? targetValue;

  /// Whether this challenge has been configured for progress tracking at
  /// all — gates showing a Join button.
  bool get isTrackable => type != null && targetValue != null;

  /// Builds a card from a `/api/challenges` (or `/challenges/available`)
  /// JSON document.
  factory ChallengeItem.fromJson(Map<String, dynamic> json) {
    return ChallengeItem(
      id: (json['_id'] as String?) ?? '',
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      name: (json['name'] as String?) ?? '',
      details: (json['details'] as String?) ?? '',
      durationLabel: json['durationLabel'] as String?,
      caloriesLabel: json['caloriesLabel'] as String?,
      type: json['type'] as String?,
      targetValue: (json['targetValue'] as num?)?.toInt(),
    );
  }
}

/// Mirrors the backend's `ChallengeProgress.status` (see `backend/src/
/// models/ChallengeProgress.js`) — set only by the server; the client
/// never assigns one directly.
enum ChallengeStatus { active, completed, abandoned, expired }

ChallengeStatus challengeStatusFromApi(String? value) {
  switch (value) {
    case 'completed':
      return ChallengeStatus.completed;
    case 'abandoned':
      return ChallengeStatus.abandoned;
    case 'expired':
      return ChallengeStatus.expired;
    case 'active':
    default:
      return ChallengeStatus.active;
  }
}

/// The current user's progress toward one [ChallengeItem] — from
/// `/api/challenges/my` or `/api/challenges/:id/progress`. `progressValue`
/// and `targetValue` are read-only snapshots the backend owns; nothing on
/// this side ever computes or edits them.
class ChallengeProgressItem {
  const ChallengeProgressItem({
    required this.id,
    required this.challenge,
    required this.type,
    required this.status,
    required this.progressValue,
    required this.targetValue,
    required this.startedAt,
    this.completedAt,
    this.lastProgressAt,
  });

  final String id;
  final ChallengeItem challenge;
  final String type;
  final ChallengeStatus status;
  final int progressValue;
  final int targetValue;
  final DateTime startedAt;
  final DateTime? completedAt;
  final DateTime? lastProgressAt;

  bool get isCompleted => status == ChallengeStatus.completed;
  bool get isActive => status == ChallengeStatus.active;

  double get progressRatio {
    if (targetValue <= 0) return 0;
    final ratio = progressValue / targetValue;
    if (ratio < 0) return 0;
    if (ratio > 1) return 1;
    return ratio;
  }

  /// Time left before a `weekly_consistency` challenge's 7-day window
  /// closes, or `null` for a type with no inherent expiry.
  Duration? remainingTime(DateTime now) {
    if (type != 'weekly_consistency') return null;
    final end = startedAt.add(const Duration(days: 7));
    final remaining = end.difference(now);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  factory ChallengeProgressItem.fromJson(Map<String, dynamic> json) {
    final challengeJson = json['challenge'];
    return ChallengeProgressItem(
      id: (json['_id'] as String?) ?? '',
      challenge:
          challengeJson is Map<String, dynamic>
              ? ChallengeItem.fromJson(challengeJson)
              : const ChallengeItem(image: 'assets/workout.png', name: '', details: ''),
      type: (json['type'] as String?) ?? 'workouts_count',
      status: challengeStatusFromApi(json['status'] as String?),
      progressValue: (json['progressValue'] as num?)?.toInt() ?? 0,
      targetValue: (json['targetValue'] as num?)?.toInt() ?? 0,
      startedAt:
          DateTime.tryParse(json['startedAt'] as String? ?? '') ?? DateTime.now(),
      completedAt:
          json['completedAt'] == null
              ? null
              : DateTime.tryParse(json['completedAt'] as String),
      lastProgressAt:
          json['lastProgressAt'] == null
              ? null
              : DateTime.tryParse(json['lastProgressAt'] as String),
    );
  }
}

/// One rule-based suggestion from `/api/challenges/suggested` — a
/// challenge paired with a `reasonCode` the UI translates locally (never a
/// pre-rendered string from the backend).
class ChallengeSuggestion {
  const ChallengeSuggestion({required this.challenge, required this.reasonCode});

  final ChallengeItem challenge;
  final String reasonCode;

  factory ChallengeSuggestion.fromJson(Map<String, dynamic> json) {
    final challengeJson = json['challenge'] as Map<String, dynamic>?;
    return ChallengeSuggestion(
      challenge:
          challengeJson != null
              ? ChallengeItem.fromJson(challengeJson)
              : const ChallengeItem(image: 'assets/workout.png', name: '', details: ''),
      reasonCode: (json['reasonCode'] as String?) ?? '',
    );
  }
}

/// A community feed post (`/api/posts`), shown as a "forum thread" card.
class ForumThread {
  const ForumThread({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.allLabel,
    required this.date,
    required this.content,
    required this.likesCount,
    required this.liked,
    required this.commentsCount,
  });

  final String id;
  final String title;
  final String subtitle;
  final String allLabel;
  final String date;
  final String content;
  final int likesCount;
  final bool liked;
  final int commentsCount;

  ForumThread copyWith({int? likesCount, bool? liked}) => ForumThread(
    id: id,
    title: title,
    subtitle: subtitle,
    allLabel: allLabel,
    date: date,
    content: content,
    likesCount: likesCount ?? this.likesCount,
    liked: liked ?? this.liked,
    commentsCount: commentsCount,
  );

  /// Builds a thread card from a `/api/posts` JSON document.
  /// [currentUserId] decides whether the current user already liked it —
  /// the feed endpoint returns each post's raw `likes` id array but doesn't
  /// pre-compute this, unlike the toggle endpoint's response.
  factory ForumThread.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final author = json['author'] as Map<String, dynamic>?;
    final content = (json['content'] as String?) ?? '';
    final likes = (json['likes'] as List? ?? const []).cast<String>();
    return ForumThread(
      id: json['_id'] as String? ?? '',
      title: content.length > 60 ? '${content.substring(0, 60)}…' : content,
      subtitle: (author?['name'] as String?) ?? 'Member',
      allLabel: 'See All',
      date: _formatDate(json['createdAt'] as String?),
      content: content,
      likesCount: likes.length,
      liked: currentUserId.isNotEmpty && likes.contains(currentUserId),
      commentsCount: (json['commentsCount'] as int?) ?? 0,
    );
  }

  static String _formatDate(String? iso) {
    if (iso == null) return '';
    final date = DateTime.tryParse(iso);
    if (date == null) return '';
    final h = date.hour.toString().padLeft(2, '0');
    final m = date.minute.toString().padLeft(2, '0');
    return '${date.day}/${date.month} $h:$m';
  }
}

/// A comment on a post (`/api/posts/:id/comments`), shown as a reply in the
/// forum thread's discussion view.
class ForumComment {
  const ForumComment({
    required this.authorName,
    required this.text,
    required this.date,
  });

  final String authorName;
  final String text;
  final String date;

  factory ForumComment.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>?;
    return ForumComment(
      authorName: (author?['name'] as String?) ?? 'Member',
      text: (json['text'] as String?) ?? '',
      date: ForumThread._formatDate(json['createdAt'] as String?),
    );
  }
}
