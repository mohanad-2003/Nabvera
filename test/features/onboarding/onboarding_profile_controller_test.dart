import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeUserRepository implements UserRepository {
  Map<String, dynamic>? lastUpdatePatch;
  bool throwOnUpdate = false;
  UserProfile? existingProfile;

  @override
  Future<UserProfile> fetchMe() async => existingProfile ?? UserProfile.empty;

  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async {
    lastUpdatePatch = patch;
    if (throwOnUpdate) throw Exception('network error');
    return existingProfile ?? UserProfile.empty;
  }

  @override
  Future<String> uploadAvatar({required Uint8List bytes, required String filename, String? contentType}) async =>
      throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async => throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async => throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async => throw UnimplementedError();
  @override
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> exportData() async => throw UnimplementedError();
}

void main() {
  test('a fresh (no existing profile) build() starts from the wizard defaults', () async {
    final fake = FakeUserRepository();
    final container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);

    final state = container.read(onboardingProfileControllerProvider);
    expect(state.gender, isNull);
    expect(state.goal, isNull);
    expect(state.activityLevel, isNull);
    expect(state.availableEquipment, {AvailableEquipment.none});
    await pumpEventQueue();
  });

  test(
    'revisiting the wizard with an existing saved profile pre-fills it instead of starting from scratch',
    () async {
      final fake = FakeUserRepository()
        ..existingProfile = UserProfile.fromJson({
          '_id': 'user-1',
          'gender': 'female',
          'dateOfBirth': DateTime(DateTime.now().year - 24, 5, 1).toIso8601String(),
          'heightCm': 168,
          'weightKg': 60,
          'goal': 'gain_muscle',
          'activityLevel': 'advanced',
          'availableEquipment': ['dumbbell', 'barbell'],
          'availableMinutes': 45,
        });
      final container = ProviderContainer(
        overrides: [userRepositoryProvider.overrideWithValue(fake)],
      );
      addTearDown(container.dispose);
      // Let currentUserProfileProvider's own build() microtask settle so
      // its watched state is the populated profile, not the empty default.
      await container.read(currentUserProfileProvider.notifier).refresh();

      final state = container.read(onboardingProfileControllerProvider);
      expect(state.gender, Gender.female);
      expect(state.heightCm, 168);
      expect(state.weightKg, 60);
      expect(state.activityLevel, ActivityLevel.advanced);
      expect(
        state.availableEquipment,
        {AvailableEquipment.dumbbell, AvailableEquipment.barbell},
      );
      expect(state.availableTime, AvailableTime.minutes45);
      await pumpEventQueue();
    },
  );

  test('selections accumulate — choosing a later step never resets an earlier one (back-navigation keeps answers)', () async {
    final fake = FakeUserRepository();
    final container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProfileControllerProvider.notifier);

    notifier.selectGender(Gender.male);
    notifier.setAge(31);
    notifier.selectGoal(FitnessGoal.muscleMassGain);

    final state = container.read(onboardingProfileControllerProvider);
    expect(state.gender, Gender.male);
    expect(state.age, 31);
    expect(state.goal, FitnessGoal.muscleMassGain);
    await pumpEventQueue();
  });

  test('submit() sends the expected patch and succeeds', () async {
    final fake = FakeUserRepository();
    final container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProfileControllerProvider.notifier);
    notifier.selectGender(Gender.male);
    notifier.selectGoal(FitnessGoal.loseWeight);
    notifier.selectActivityLevel(ActivityLevel.beginner);

    await notifier.submit();

    expect(fake.lastUpdatePatch!['gender'], 'male');
    expect(fake.lastUpdatePatch!['goal'], 'lose_weight');
    expect(fake.lastUpdatePatch!['activityLevel'], 'beginner');
    await pumpEventQueue();
  });

  test('submit() rethrows on failure instead of swallowing it — the final step must see the error', () async {
    final fake = FakeUserRepository()..throwOnUpdate = true;
    final container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProfileControllerProvider.notifier);

    await expectLater(notifier.submit(), throwsA(isA<Exception>()));
    await pumpEventQueue();
  });

  test('toggleEquipment: selecting "none" always clears every other selection, and never leaves the set empty', () {
    final fake = FakeUserRepository();
    final container = ProviderContainer(
      overrides: [userRepositoryProvider.overrideWithValue(fake)],
    );
    addTearDown(container.dispose);
    final notifier = container.read(onboardingProfileControllerProvider.notifier);

    notifier.toggleEquipment(AvailableEquipment.dumbbell);
    notifier.toggleEquipment(AvailableEquipment.barbell);
    expect(
      container.read(onboardingProfileControllerProvider).availableEquipment,
      {AvailableEquipment.dumbbell, AvailableEquipment.barbell},
    );

    notifier.toggleEquipment(AvailableEquipment.none);
    expect(
      container.read(onboardingProfileControllerProvider).availableEquipment,
      {AvailableEquipment.none},
    );

    // Deselecting the last real item falls back to "none" — the set is
    // never left empty.
    notifier.toggleEquipment(AvailableEquipment.dumbbell);
    notifier.toggleEquipment(AvailableEquipment.dumbbell);
    expect(
      container.read(onboardingProfileControllerProvider).availableEquipment,
      {AvailableEquipment.none},
    );
  });
}
