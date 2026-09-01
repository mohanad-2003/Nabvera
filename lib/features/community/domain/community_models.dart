class ChallengeItem {
  const ChallengeItem({
    required this.image,
    required this.name,
    required this.details,
    this.durationLabel,
    this.caloriesLabel,
  });
  final String image;
  final String name;
  final String details;
  final String? durationLabel;
  final String? caloriesLabel;

  /// Builds a card from a `/api/challenges` JSON document.
  factory ChallengeItem.fromJson(Map<String, dynamic> json) {
    return ChallengeItem(
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      name: (json['name'] as String?) ?? '',
      details: (json['details'] as String?) ?? '',
      durationLabel: json['durationLabel'] as String?,
      caloriesLabel: json['caloriesLabel'] as String?,
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
