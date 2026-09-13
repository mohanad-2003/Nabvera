import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nabvera/features/community/data/community_repository.dart';
import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'community_controller.g.dart';

enum CommunityTab { forum, challenges }

@riverpod
class CommunityTabController extends _$CommunityTabController {
  @override
  CommunityTab build() => CommunityTab.forum;
  void select(CommunityTab tab) => state = tab;
}

/// Lolads `/api/challenges` for the Community "Challenges" tab.
@riverpod
class CommunityChallenges extends _$CommunityChallenges {
  @override
  List<ChallengeItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs =
          await ref.read(communityRepositoryProvider).fetchChallenges();
      state = docs.map(ChallengeItem.fromJson).toList();
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }
}

/// Loads the real community feed from `/api/posts`.
@riverpod
class CommunityForums extends _$CommunityForums {
  @override
  List<ForumThread> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final currentUserId = ref.read(currentUserProfileProvider).id;
      final docs = await ref.read(communityRepositoryProvider).fetchFeed();
      state = [
        for (final doc in docs)
          ForumThread.fromJson(doc, currentUserId: currentUserId),
      ];
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  /// Publishes a new post and reloads the feed so it appears immediately
  /// at the top (matching the backend's newest-first sort) — no manual
  /// prepend, since that would have to guess at every server-assigned
  /// field (`_id`, `createdAt`, the populated `author`) that
  /// [ForumThread.fromJson] needs. Rethrows on failure so the composer UI
  /// can show a real error instead of silently discarding the post.
  Future<void> create(String content) async {
    await ref.read(communityRepositoryProvider).createPost(content);
    await _load();
  }

  /// Deletes one of the current user's own posts and reloads the feed.
  Future<void> delete(String postId) async {
    await ref.read(communityRepositoryProvider).deletePost(postId);
    await _load();
  }

  /// Bumps a post's `commentsCount` by one in the feed's own copy of it —
  /// called after [ForumComments.add] actually posts the comment, since
  /// that provider only holds *that one thread's* comment list and has no
  /// way to update the count shown back on the feed/card otherwise. Purely
  /// a local increment (no re-fetch): the feed's sort order and every
  /// other field stay exactly as last loaded.
  void incrementCommentCount(String postId) {
    final index = state.indexWhere((t) => t.id == postId);
    if (index == -1) return;
    final updated = state[index].copyWith(
      commentsCount: state[index].commentsCount + 1,
    );
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];
  }

  /// The [incrementCommentCount] counterpart, called after
  /// [ForumComments.delete] — never goes below zero even if the two
  /// somehow drift (a defensive floor, not an expected path).
  void decrementCommentCount(String postId) {
    final index = state.indexWhere((t) => t.id == postId);
    if (index == -1) return;
    final updated = state[index].copyWith(
      commentsCount: (state[index].commentsCount - 1).clamp(0, 1 << 31),
    );
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) updated else state[i],
    ];
  }

  Future<void> toggleLike(String postId) async {
    final index = state.indexWhere((t) => t.id == postId);
    if (index == -1) return;
    final thread = state[index];
    final optimistic = thread.copyWith(
      liked: !thread.liked,
      likesCount: thread.liked ? thread.likesCount - 1 : thread.likesCount + 1,
    );
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) optimistic else state[i],
    ];
    try {
      final (likesCount, liked) = await ref
          .read(communityRepositoryProvider)
          .toggleLike(postId);
      final confirmed = thread.copyWith(likesCount: likesCount, liked: liked);
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) confirmed else state[i],
      ];
    } catch (_) {
      state = [
        for (var i = 0; i < state.length; i++)
          if (i == index) thread else state[i],
      ];
    }
  }
}

/// Loads `/api/challenges/suggested` — up to two rule-based suggestions for
/// the current user's "Suggested for you" section.
@riverpod
class SuggestedChallenges extends _$SuggestedChallenges {
  @override
  List<ChallengeSuggestion> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs =
          await ref
              .read(communityRepositoryProvider)
              .fetchSuggestedChallenges();
      state = docs.map(ChallengeSuggestion.fromJson).toList();
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> refresh() => _load();
}

/// Loads `/api/challenges/my` — the current user's own challenge progress
/// (active, completed, abandoned, expired) — and owns join/leave, which
/// always re-syncs both this and [SuggestedChallenges] afterward so a
/// just-joined challenge disappears from "Suggested" and appears under
/// "My active challenges" without a manual refresh.
@riverpod
class MyChallenges extends _$MyChallenges {
  @override
  List<ChallengeProgressItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs =
          await ref.read(communityRepositoryProvider).fetchMyChallenges();
      state = docs.map(ChallengeProgressItem.fromJson).toList();
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> refresh() => _load();

  Future<void> join(String challengeId) async {
    await ref.read(communityRepositoryProvider).joinChallenge(challengeId);
    await _load();
    unawaited(ref.read(suggestedChallengesProvider.notifier).refresh());
  }

  Future<void> leave(String challengeId) async {
    await ref.read(communityRepositoryProvider).leaveChallenge(challengeId);
    await _load();
    unawaited(ref.read(suggestedChallengesProvider.notifier).refresh());
  }
}

/// Central "something important changed" refresh hook for challenges —
/// mirrors `refreshHomeProviders` (see `home_dashboard_controller.dart`).
/// Called after finishing a workout, since that's the only thing that can
/// silently move challenge progress forward server-side.
void refreshChallengeProviders(WidgetRef ref) {
  ref.invalidate(myChallengesProvider);
  ref.invalidate(suggestedChallengesProvider);
}

/// Loads `/api/posts/:id/comments` for one thread.
@riverpod
class ForumComments extends _$ForumComments {
  @override
  List<ForumComment> build(String postId) {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final currentUserId = ref.read(currentUserProfileProvider).id;
      final docs = await ref
          .read(communityRepositoryProvider)
          .fetchComments(postId);
      state = [
        for (final doc in docs)
          ForumComment.fromJson(doc, currentUserId: currentUserId),
      ];
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> add(String text) async {
    if (text.trim().isEmpty) return;
    await ref.read(communityRepositoryProvider).addComment(postId, text.trim());
    await _load();
    // Keep the feed's card in sync too — it holds its own copy of
    // commentsCount (see ForumThread), which this provider never touches
    // otherwise, so without this the count only catches up on the next
    // full feed reload (pull-to-refresh, or leaving and coming back).
    ref.read(communityForumsProvider.notifier).incrementCommentCount(postId);
  }

  /// Deletes one of the current user's own comments and reloads this
  /// thread's list, then decrements the feed card's count the same way
  /// [add] increments it.
  Future<void> delete(String commentId) async {
    await ref.read(communityRepositoryProvider).deleteComment(postId, commentId);
    await _load();
    ref.read(communityForumsProvider.notifier).decrementCommentCount(postId);
  }
}
