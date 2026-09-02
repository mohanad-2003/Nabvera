import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../profile/data/user_repository.dart';

part 'onboarding_profile_controller.g.dart';

enum Gender { male, female }

enum ActivityLevel { beginner, intermediate, advanced }

enum AvailableEquipment { none, dumbbell, barbell, machine, resistanceBand, kettlebell }

enum AvailableTime { minutes15, minutes30, minutes45, minutes60 }

/// Stable identifiers for fitness goals — the UI maps these to localized
/// labels, so a language switch mid-wizard keeps the selection intact.
enum FitnessGoal { loseWeight, gainWeight, muscleMassGain, shapeBody, others }

class OnboardingProfile {
  const OnboardingProfile({
    this.gender,
    this.age = 28,
    this.heightCm = 165,
    this.weightKg = 75,
    this.goal,
    this.activityLevel,
    this.availableEquipment = const {AvailableEquipment.none},
    this.availableTime = AvailableTime.minutes30,
  });

  final Gender? gender;
  final int age;
  final int heightCm;
  final int weightKg;
  final FitnessGoal? goal;
  final ActivityLevel? activityLevel;
  final Set<AvailableEquipment> availableEquipment;
  final AvailableTime availableTime;

  OnboardingProfile copyWith({
    Gender? gender,
    int? age,
    int? heightCm,
    int? weightKg,
    FitnessGoal? goal,
    ActivityLevel? activityLevel,
    Set<AvailableEquipment>? availableEquipment,
    AvailableTime? availableTime,
  }) {
    return OnboardingProfile(
      gender: gender ?? this.gender,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      availableEquipment: availableEquipment ?? this.availableEquipment,
      availableTime: availableTime ?? this.availableTime,
    );
  }
}

/// Single source of truth for the whole profile-setup wizard, replacing
/// five separate near-identical GetX controllers (GenderController,
/// AgeControllert, HeightController, WeightController, GoalController)
/// that each only held one primitive value.
@riverpod
class OnboardingProfileController extends _$OnboardingProfileController {
  @override
  OnboardingProfile build() => const OnboardingProfile();

  void selectGender(Gender gender) => state = state.copyWith(gender: gender);
  void setAge(int age) => state = state.copyWith(age: age);
  void setHeight(int heightCm) => state = state.copyWith(heightCm: heightCm);
  void setWeight(int weightKg) => state = state.copyWith(weightKg: weightKg);
  void selectGoal(FitnessGoal goal) => state = state.copyWith(goal: goal);
  void selectActivityLevel(ActivityLevel level) =>
      state = state.copyWith(activityLevel: level);
  void toggleEquipment(AvailableEquipment equipment) {
    final selected = {...state.availableEquipment};
    if (equipment == AvailableEquipment.none) {
      selected
        ..clear()
        ..add(equipment);
    } else {
      selected.remove(AvailableEquipment.none);
      if (!selected.add(equipment)) selected.remove(equipment);
      if (selected.isEmpty) selected.add(AvailableEquipment.none);
    }
    state = state.copyWith(availableEquipment: selected);
  }
  void selectAvailableTime(AvailableTime time) => state = state.copyWith(availableTime: time);

  /// Persists the wizard's answers to the user's backend profile. Best
  /// effort: onboarding still finishes and lands on Home even if this
  /// fails — the user can always fix details later from Edit Profile.
  Future<void> submit() async {
    final s = state;
    final patch = <String, dynamic>{
      'heightCm': s.heightCm,
      'weightKg': s.weightKg,
      'dateOfBirth': DateTime(DateTime.now().year - s.age, 1, 1).toIso8601String(),
      if (s.gender != null)
        'gender': switch (s.gender!) {
          Gender.male => 'male',
          Gender.female => 'female',
        },
      if (s.goal != null) 'goal': _goalToApi(s.goal!),
      if (s.activityLevel != null) 'activityLevel': s.activityLevel!.name,
      'availableEquipment': s.availableEquipment.map(_equipmentToApi).toList(),
      'availableMinutes': _timeToMinutes(s.availableTime),
    };
    try {
      await ref.read(userRepositoryProvider).updateProfile(patch);
    } catch (_) {
      // See doc comment — swallow and let the user continue.
    }
  }

  static String _goalToApi(FitnessGoal goal) => switch (goal) {
    FitnessGoal.loseWeight => 'lose_weight',
    FitnessGoal.gainWeight => 'gain_muscle',
    FitnessGoal.muscleMassGain => 'gain_muscle',
    FitnessGoal.shapeBody => 'keep_fit',
    FitnessGoal.others => 'keep_fit',
  };

  static String _equipmentToApi(AvailableEquipment equipment) => switch (equipment) {
    AvailableEquipment.resistanceBand => 'resistance_band',
    _ => equipment.name,
  };

  static int _timeToMinutes(AvailableTime time) => switch (time) {
    AvailableTime.minutes15 => 15,
    AvailableTime.minutes30 => 30,
    AvailableTime.minutes45 => 45,
    AvailableTime.minutes60 => 60,
  };
}
