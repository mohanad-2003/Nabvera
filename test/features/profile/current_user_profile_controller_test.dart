import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Returns a queued sequence of results on successive [fetchMe] calls —
/// lets a test simulate "the first /auth/me call right after sign-in
/// fails (as if it went out with no Authorization header), the next one
/// succeeds" without needing to reproduce a real timing race.
class FakeUserRepository implements UserRepository {
  int fetchMeCallCount = 0;
  final List<Future<UserProfile> Function()> _queue = [];

  void queueEmpty() => _queue.add(() async => UserProfile.empty);
  void queueError() => _queue.add(() async => throw Exception('no token'));
  void queueProfile(UserProfile profile) => _queue.add(() async => profile);

  @override
  Future<UserProfile> fetchMe() {
    fetchMeCallCount++;
    final next = _queue.isNotEmpty
        ? (_queue.length > 1 ? _queue.removeAt(0) : _queue.first)
        : () async => UserProfile.empty;
    return next();
  }

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async =>
      UserProfile.empty;
  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
    String? contentType,
  }) async => throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async =>
      throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async => [];
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async => [];
  @override
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();
}

UserProfile _realProfile() => UserProfile(
  id: 'user-1',
  name: 'Mohanad',
  email: 'user@example.com',
  birthday: '—',
  weightKg: '—',
  ageYears: '—',
  heightM: '—',
  fitnessLevel: 'Beginner',
  completedWorkouts: 3,
  caloriesBurned: 900,
  trainingDays: 3,
  currentStreak: 2,
);

/// `CurrentUserProfile.build()` itself kicks off one automatic
/// `Future.microtask(refresh)` the instant the provider is first read —
/// consumed here (against an empty [FakeUserRepository], so it resolves
/// to [UserProfile.empty] the same way it would against a real backend
/// with no token yet) *before* the caller queues any responses of its
/// own, so every test's queue/call-count assertions are only ever about
/// the explicit `refreshAfterSignIn()` call it makes, not this unrelated
/// one-time startup fetch.
Future<(ProviderContainer, FakeUserRepository)> _buildContainer() async {
  SharedPreferences.setMockInitialValues({});
  final prefs = await SharedPreferences.getInstance();
  final fakeUsers = FakeUserRepository();
  final container = ProviderContainer(
    overrides: [
      userRepositoryProvider.overrideWithValue(fakeUsers),
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );
  container.read(currentUserProfileProvider); // triggers build()
  await pumpEventQueue();
  fakeUsers.fetchMeCallCount = 0;
  return (container, fakeUsers);
}

void main() {
  test(
    'refreshAfterSignIn: a real profile on the first attempt is used immediately, no retry needed',
    () async {
      final (container, fakeUsers) = await _buildContainer();
      addTearDown(container.dispose);
      fakeUsers.queueProfile(_realProfile());

      await container.read(currentUserProfileProvider.notifier).refreshAfterSignIn();

      expect(container.read(currentUserProfileProvider).name, 'Mohanad');
      expect(fakeUsers.fetchMeCallCount, 1);
    },
  );

  test(
    'refreshAfterSignIn: retries once if the first attempt comes back empty, and the retry succeeds',
    () async {
      final (container, fakeUsers) = await _buildContainer();
      addTearDown(container.dispose);
      fakeUsers
        ..queueEmpty()
        ..queueProfile(_realProfile());

      await container.read(currentUserProfileProvider.notifier).refreshAfterSignIn();

      expect(container.read(currentUserProfileProvider).name, 'Mohanad');
      expect(fakeUsers.fetchMeCallCount, 2, reason: 'must have retried exactly once after the empty first attempt');
    },
  );

  test(
    'refreshAfterSignIn: retries once if the first attempt throws, and the retry succeeds',
    () async {
      final (container, fakeUsers) = await _buildContainer();
      addTearDown(container.dispose);
      fakeUsers
        ..queueError()
        ..queueProfile(_realProfile());

      await container.read(currentUserProfileProvider.notifier).refreshAfterSignIn();

      expect(container.read(currentUserProfileProvider).name, 'Mohanad');
      expect(fakeUsers.fetchMeCallCount, 2);
    },
  );

  test(
    'refreshAfterSignIn: never retries more than once — two failures in a row leave the profile empty, not stuck retrying forever',
    () async {
      final (container, fakeUsers) = await _buildContainer();
      addTearDown(container.dispose);
      fakeUsers
        ..queueEmpty()
        ..queueEmpty();

      await container.read(currentUserProfileProvider.notifier).refreshAfterSignIn();

      expect(container.read(currentUserProfileProvider).id, isEmpty);
      expect(fakeUsers.fetchMeCallCount, 2, reason: 'exactly one retry, even though it also failed');
    },
  );
}
