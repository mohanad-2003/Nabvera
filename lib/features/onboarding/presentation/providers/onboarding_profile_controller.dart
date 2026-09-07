import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_profile_controller.g.dart';

enum Gender { male, female }

enum ActivityLevel { beginner, intermediate, advanced }

enum AvailableEquipment {
  none,
  dumbbell,
  barbell,
  machine,
  resistanceBand,
  kettlebell,
}

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
  OnboardingProfile build() {
    // A user who already has a saved profile (e.g. they left the wizard
    // partway and came back, or are revisiting /setup directly) sees their
    // real existing answers pre-filled instead of the wizard's generic
    // defaults every time — a brand-new signup has an empty profile, so
    // this is a no-op for the common case.
    final existing = ref.watch(currentUserProfileProvider);
    if (existing.id.isEmpty) return const OnboardingProfile();
    return _fromExistingProfile(existing);
  }

  static OnboardingProfile _fromExistingProfile(UserProfile profile) {
    const fallback = OnboardingProfile();
    final equipment =
        profile.availableEquipment
            .map(equipmentFromApi)
            .whereType<AvailableEquipment>()
            .toSet();
    return OnboardingProfile(
      // Onboarding's Gender only models male/female (see the enum's doc);
      // an existing "other" value has no equivalent here, so it's left
      // unselected rather than guessed.
      gender: switch (profile.gender) {
        'male' => Gender.male,
        'female' => Gender.female,
        _ => null,
      },
      age:
          profile.dateOfBirth == null
              ? fallback.age
              : DateTime.now().year - profile.dateOfBirth!.year,
      heightCm: profile.heightCmRaw?.round() ?? fallback.heightCm,
      weightKg: profile.weightKgRaw?.round() ?? fallback.weightKg,
      goal: goalFromApi(profile.goal),
      activityLevel: activityLevelFromApi(profile.activityLevel),
      availableEquipment:
          equipment.isEmpty ? fallback.availableEquipment : equipment,
      availableTime: minutesToTime(profile.availableMinutes),
    );
  }

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

  void selectAvailableTime(AvailableTime time) =>
      state = state.copyWith(availableTime: time);

  /// Persists the wizard's answers to the user's backend profile. Throws
  /// on failure (a real network/server error) — the final wizard step
  /// must not navigate to Home until this actually succeeds, so it needs
  /// a real error to catch and offer Retry on, not a silently-swallowed
  /// one (Edit Profile is a fallback for changing details *later*, not a
  /// safety net for onboarding never having saved anything at all).
  Future<void> submit() async {
    final s = state;
    final patch = <String, dynamic>{
      'heightCm': s.heightCm,
      'weightKg': s.weightKg,
      'dateOfBirth':
          DateTime(DateTime.now().year - s.age, 1, 1).toIso8601String(),
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
    await ref.read(userRepositoryProvider).updateProfile(patch);
  }

  static String _goalToApi(FitnessGoal goal) => goalToApi(goal);

  static String _equipmentToApi(AvailableEquipment equipment) =>
      equipmentToApi(equipment);

  static int _timeToMinutes(AvailableTime time) => timeToMinutes(time);
}

// --- Shared enum <-> API-string mappers -------------------------------
//
// Onboarding only ever writes these (a fresh wizard has no prior value to
// parse back), but Edit Profile needs to go the other way too: it opens
// with the user's *existing* saved profile and has to reconstruct which
// enum value that corresponds to. Kept as public top-level functions here,
// next to the enums they describe, so both directions live in one place.

String goalToApi(FitnessGoal goal) => switch (goal) {
  FitnessGoal.loseWeight => 'lose_weight',
  FitnessGoal.gainWeight => 'gain_muscle',
  FitnessGoal.muscleMassGain => 'gain_muscle',
  FitnessGoal.shapeBody => 'keep_fit',
  FitnessGoal.others => 'keep_fit',
};

/// Inverse of [goalToApi]. Several enum values collapse to the same API
/// string (e.g. both `gainWeight` and `muscleMassGain` save as
/// `gain_muscle`) so this can't perfectly round-trip — it picks the most
/// common/representative enum value for each API string, which is all
/// Edit Profile needs (a sensible pre-selected option, not a guarantee of
/// recovering the exact original wizard choice).
FitnessGoal? goalFromApi(String? value) => switch (value) {
  'lose_weight' => FitnessGoal.loseWeight,
  'gain_muscle' => FitnessGoal.gainWeight,
  'keep_fit' => FitnessGoal.shapeBody,
  _ => null,
};

String equipmentToApi(AvailableEquipment equipment) => switch (equipment) {
  AvailableEquipment.resistanceBand => 'resistance_band',
  _ => equipment.name,
};

AvailableEquipment? equipmentFromApi(String value) => switch (value) {
  'resistance_band' => AvailableEquipment.resistanceBand,
  'none' => AvailableEquipment.none,
  'dumbbell' => AvailableEquipment.dumbbell,
  'barbell' => AvailableEquipment.barbell,
  'machine' => AvailableEquipment.machine,
  'kettlebell' => AvailableEquipment.kettlebell,
  _ => null,
};

int timeToMinutes(AvailableTime time) => switch (time) {
  AvailableTime.minutes15 => 15,
  AvailableTime.minutes30 => 30,
  AvailableTime.minutes45 => 45,
  AvailableTime.minutes60 => 60,
};

/// Inverse of [timeToMinutes]. Snaps to the nearest known bucket so any
/// value saved outside the wizard's fixed options (or a stale/odd value on
/// an old account) still resolves to something selectable in the UI.
AvailableTime minutesToTime(int? minutes) {
  if (minutes == null) return AvailableTime.minutes30;
  const options = AvailableTime.values;
  const values = [15, 30, 45, 60];
  var closest = options.first;
  var bestDiff = (minutes - values.first).abs();
  for (var i = 1; i < options.length; i++) {
    final diff = (minutes - values[i]).abs();
    if (diff < bestDiff) {
      bestDiff = diff;
      closest = options[i];
    }
  }
  return closest;
}

/// Inverse of [ActivityLevel.name] (used directly as the API string, no
/// separate mapper needed for the forward direction).
ActivityLevel? activityLevelFromApi(String? value) => switch (value) {
  'beginner' => ActivityLevel.beginner,
  'intermediate' => ActivityLevel.intermediate,
  'advanced' => ActivityLevel.advanced,
  _ => null,
};
