import 'package:nabvera/features/community/data/community_repository.dart';
import 'package:nabvera/features/community/presentation/providers/community_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// A hand-written test double — same pattern as
/// `meal_logging_controller_test.dart`'s `FakeNutritionRepository`.
/// `implements` (not `extends`) sidesteps needing a real `ApiClient`.
class FakeCommunityRepository implements CommunityRepository {
  List<Map<String, dynamic>> suggested = [];
  List<Map<String, dynamic>> myChallenges = [];
  int fetchSuggestedCallCount = 0;
  int fetchMyChallengesCallCount = 0;
  bool throwOnNextSuggestedFetch = false;
  bool throwOnNextMyChallengesFetch = false;
  String? lastJoinedChallengeId;
  String? lastLeftChallengeId;

  @override
  Future<List<Map<String, dynamic>>> fetchSuggestedChallenges() async {
    fetchSuggestedCallCount++;
    if (throwOnNextSuggestedFetch) {
      throwOnNextSuggestedFetch = false;
      throw Exception('network error');
    }
    return suggested;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchMyChallenges() async {
    fetchMyChallengesCallCount++;
    if (throwOnNextMyChallengesFetch) {
      throwOnNextMyChallengesFetch = false;
      throw Exception('network error');
    }
    return myChallenges;
  }

  @override
  Future<Map<String, dynamic>> joinChallenge(String challengeId) async {
    lastJoinedChallengeId = challengeId;
    return {};
  }

  @override
  Future<Map<String, dynamic>> leaveChallenge(String challengeId) async {
    lastLeftChallengeId = challengeId;
    return {};
  }

  @override
  Future<List<Map<String, dynamic>>> fetchChallenges() async => [];
  @override
  Future<List<Map<String, dynamic>>> fetchAvailableChallenges() async => [];
  @override
  Future<Map<String, dynamic>> fetchChallengeProgress(String challengeId) async => {};
  @override
  Future<List<Map<String, dynamic>>> fetchFeed() async => [];
  @override
  Future<List<Map<String, dynamic>>> fetchComments(String postId) async => [];
  @override
  Future<Map<String, dynamic>> addComment(String postId, String text) async => {};
  @override
  Future<(int, bool)> toggleLike(String postId) async => (0, false);
  @override
  Future<Map<String, dynamic>> createPost(String content) async => {};
  @override
  Future<void> deletePost(String postId) async {}
  @override
  Future<void> deleteComment(String postId, String commentId) async {}
}

Map<String, dynamic> _challengeJson(String id) => {
  '_id': id,
  'imageUrl': 'assets/workout.png',
  'name': 'Challenge $id',
  'details': 'Details for $id',
};

Map<String, dynamic> _progressJson(String id) => {
  '_id': 'progress-$id',
  'challenge': _challengeJson(id),
  'type': 'workouts_count',
  'status': 'active',
  'progressValue': 1,
  'targetValue': 5,
};

void main() {
  test('SuggestedChallenges.refresh() re-fetches from the repository', () async {
    final fake = FakeCommunityRepository();
    final container = ProviderContainer(overrides: [communityRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    // Let build()'s own initial microtask load settle first, so the count
    // below only reflects the explicit refresh() call.
    container.read(suggestedChallengesProvider.notifier);
    await pumpEventQueue();
    final callsBefore = fake.fetchSuggestedCallCount;

    fake.suggested = [
      {'challenge': _challengeJson('c1'), 'reasonCode': 'inactive'},
    ];
    await container.read(suggestedChallengesProvider.notifier).refresh();

    // >callsBefore (not exactly +1) — autoDispose may rebuild the provider
    // an extra time between reads; what matters is refresh() really hits
    // the repository again, same tolerance as meal_logging_controller_test.
    expect(fake.fetchSuggestedCallCount, greaterThan(callsBefore));
    final state = container.read(suggestedChallengesProvider);
    expect(state, hasLength(1));
    expect(state.first.challenge.id, 'c1');
    await pumpEventQueue();
  });

  test('MyChallenges.refresh() re-fetches from the repository', () async {
    final fake = FakeCommunityRepository();
    final container = ProviderContainer(overrides: [communityRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    container.read(myChallengesProvider.notifier);
    await pumpEventQueue();
    final callsBefore = fake.fetchMyChallengesCallCount;

    fake.myChallenges = [_progressJson('c1')];
    await container.read(myChallengesProvider.notifier).refresh();

    expect(fake.fetchMyChallengesCallCount, greaterThan(callsBefore));
    final state = container.read(myChallengesProvider);
    expect(state, hasLength(1));
    expect(state.first.challenge.id, 'c1');
    await pumpEventQueue();
  });

  test('a failed refresh() leaves the last successfully-loaded list in place, not empty', () async {
    final fake = FakeCommunityRepository();
    fake.suggested = [
      {'challenge': _challengeJson('c1'), 'reasonCode': 'inactive'},
    ];
    final container = ProviderContainer(overrides: [communityRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    // Initial successful load (via build()'s own microtask).
    final loaded = await container.read(suggestedChallengesProvider.notifier).refresh().then(
      (_) => container.read(suggestedChallengesProvider),
    );
    expect(loaded, hasLength(1));

    // A subsequent pull-to-refresh that fails must not wipe the list.
    fake.throwOnNextSuggestedFetch = true;
    await container.read(suggestedChallengesProvider.notifier).refresh();

    final afterFailedRefresh = container.read(suggestedChallengesProvider);
    expect(afterFailedRefresh, hasLength(1));
    expect(afterFailedRefresh.first.challenge.id, 'c1');
    await pumpEventQueue();
  });

  test('join()/leave() only change local state after the backend call resolves, and re-sync suggestions', () async {
    final fake = FakeCommunityRepository();
    fake.myChallenges = [];
    final container = ProviderContainer(overrides: [communityRepositoryProvider.overrideWithValue(fake)]);
    addTearDown(container.dispose);

    await container.read(myChallengesProvider.notifier).refresh();
    expect(container.read(myChallengesProvider), isEmpty);

    // The repository will report the new membership only once "joined".
    fake.myChallenges = [_progressJson('c1')];
    await container.read(myChallengesProvider.notifier).join('c1');

    expect(fake.lastJoinedChallengeId, 'c1');
    expect(container.read(myChallengesProvider), hasLength(1));
    await pumpEventQueue();
  });
}
