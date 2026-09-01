import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/presentation/providers/profile_controller.dart';
import '../../data/community_repository.dart';
import '../../domain/community_models.dart';

part 'community_controller.g.dart';

enum CommunityTab { forum, challenges }

@riverpod
class CommunityTabController extends _$CommunityTabController {
  @override
  CommunityTab build() => CommunityTab.forum;

  void select(CommunityTab tab) => state = tab;
}

/// Loads `/api/challenges` for the Community "Challenges" tab.
@riverpod
class CommunityChallenges extends _$CommunityChallenges {
  @override
  List<ChallengeItem> build() {
    Future.microtask(_load);
    return const [];
  }

  Future<void> _load() async {
    try {
      final docs = await ref.read(communityRepositoryProvider).fetchChallenges();
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

  Future<void> toggleLike(String postId) async {
    final index = state.indexWhere((t) => t.id == postId);
    if (index == -1) return;
    final thread = state[index];
    final optimistic = thread.copyWith(
      liked: !thread.liked,
      likesCount: thread.liked ? thread.likesCount - 1 : thread.likesCount + 1,
    );
    state = [for (var i = 0; i < state.length; i++) if (i == index) optimistic else state[i]];
    try {
      final (likesCount, liked) =
          await ref.read(communityRepositoryProvider).toggleLike(postId);
      final confirmed = thread.copyWith(likesCount: likesCount, liked: liked);
      state = [for (var i = 0; i < state.length; i++) if (i == index) confirmed else state[i]];
    } catch (_) {
      state = [for (var i = 0; i < state.length; i++) if (i == index) thread else state[i]];
    }
  }
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
      final docs = await ref.read(communityRepositoryProvider).fetchComments(postId);
      state = [for (final doc in docs) ForumComment.fromJson(doc)];
    } catch (_) {
      // Left empty — see WorkoutListByLevel for the same pattern.
    }
  }

  Future<void> add(String text) async {
    if (text.trim().isEmpty) return;
    await ref.read(communityRepositoryProvider).addComment(postId, text.trim());
    await _load();
  }
}
