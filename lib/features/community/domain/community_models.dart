import 'package:flutter/widgets.dart' show BuildContext, Localizations;

import '../../../core/localization/generated/app_localizations.dart';

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
    this.nameAr = '',
    this.detailsAr = '',
  });

  /// Backend `Challenge._id` — needed to call `/challenges/:id/join`, etc.
  final String id;
  final String image;
  final String name;
  final String details;
  final String? durationLabel;
  final String? caloriesLabel;

  /// Arabic translations, from `Challenge.nameAr`/`detailsAr` — empty for a
  /// challenge an admin hasn't translated yet, in which case
  /// [localizedName]/[localizedDetails] fall back to [name]/[details]
  /// (same pattern as `ArticleTip.localizedTitle`).
  final String nameAr;
  final String detailsAr;

  String localizedName(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && nameAr.isNotEmpty
          ? nameAr
          : name;

  String localizedDetails(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              detailsAr.isNotEmpty
          ? detailsAr
          : details;

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
      nameAr: (json['nameAr'] as String?) ?? '',
      details: (json['details'] as String?) ?? '',
      detailsAr: (json['detailsAr'] as String?) ?? '',
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
    required this.authorAvatarUrl,
    required this.date,
    required this.content,
    required this.likesCount,
    required this.liked,
    required this.commentsCount,
    this.isOwnPost = false,
  });

  final String id;
  final String title;

  /// The post author's display name — empty when the backend's `author`
  /// record is missing, in which case [displayAuthorName] falls back to a
  /// localized generic label rather than showing blank text or a
  /// hardcoded English "Member".
  final String subtitle;
  final String? authorAvatarUrl;
  final String date;
  final String content;
  final int likesCount;
  final bool liked;
  final int commentsCount;

  /// Whether the signed-in user authored this post — gates showing a
  /// delete action (`DELETE /posts/:id` refuses anyone else's post
  /// anyway; this just keeps the option from being offered at all instead
  /// of failing when tapped).
  final bool isOwnPost;

  String displayAuthorName(AppLocalizations l10n) =>
      subtitle.trim().isEmpty ? l10n.communityMember : subtitle.trim();

  ForumThread copyWith({int? likesCount, bool? liked, int? commentsCount}) =>
      ForumThread(
        id: id,
        title: title,
        subtitle: subtitle,
        authorAvatarUrl: authorAvatarUrl,
        date: date,
        content: content,
        likesCount: likesCount ?? this.likesCount,
        liked: liked ?? this.liked,
        commentsCount: commentsCount ?? this.commentsCount,
        isOwnPost: isOwnPost,
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
    final authorId = author?['_id'] as String?;
    return ForumThread(
      id: json['_id'] as String? ?? '',
      title: content.length > 60 ? '${content.substring(0, 60)}…' : content,
      subtitle: (author?['name'] as String?) ?? '',
      authorAvatarUrl: author?['avatarUrl'] as String?,
      date: _formatDate(json['createdAt'] as String?),
      content: content,
      likesCount: likes.length,
      liked: currentUserId.isNotEmpty && likes.contains(currentUserId),
      commentsCount: (json['commentsCount'] as int?) ?? 0,
      isOwnPost: currentUserId.isNotEmpty && authorId == currentUserId,
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
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.text,
    required this.date,
    this.isOwnComment = false,
  });

  final String id;

  /// The commenter's display name — same empty-string/fallback contract as
  /// `ForumThread.subtitle`.
  final String authorName;
  final String? authorAvatarUrl;
  final String text;
  final String date;

  /// Whether the signed-in user authored this comment — same
  /// gate-the-option-rather-than-fail-on-tap contract as
  /// `ForumThread.isOwnPost`.
  final bool isOwnComment;

  String displayAuthorName(AppLocalizations l10n) =>
      authorName.trim().isEmpty ? l10n.communityMember : authorName.trim();

  factory ForumComment.fromJson(
    Map<String, dynamic> json, {
    String currentUserId = '',
  }) {
    final author = json['author'] as Map<String, dynamic>?;
    final authorId = author?['_id'] as String?;
    return ForumComment(
      id: json['_id'] as String? ?? '',
      authorName: (author?['name'] as String?) ?? '',
      authorAvatarUrl: author?['avatarUrl'] as String?,
      text: (json['text'] as String?) ?? '',
      date: ForumThread._formatDate(json['createdAt'] as String?),
      isOwnComment: currentUserId.isNotEmpty && authorId == currentUserId,
    );
  }
}
