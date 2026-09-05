import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          await ref.read(communityRepositoryProvider).fetchSuggestedChallenges();
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
      final docs = await ref.read(communityRepositoryProvider).fetchMyChallenges();
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
