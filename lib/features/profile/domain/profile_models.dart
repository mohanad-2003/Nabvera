class UserProfile {
  const UserProfile({
    this.id = '',
    required this.name,
    required this.email,
    required this.birthday,
    required this.weightKg,
    required this.ageYears,
    required this.heightM,
    required this.fitnessLevel,
    required this.completedWorkouts,
    required this.caloriesBurned,
    required this.trainingDays,
    required this.currentStreak,
    this.gender,
    this.dateOfBirth,
    this.heightCmRaw,
    this.weightKgRaw,
    this.goal,
    this.activityLevel,
    this.availableEquipment = const [],
    this.availableMinutes,
    this.avatarUrl,
    this.favoriteWorkoutIds = const [],
    this.favoriteRecipeIds = const [],
  });

  /// Backend `User._id` — empty for [UserProfile.empty].
  final String id;
  final String name;
  final String email;
  final String birthday;
  final String weightKg;
  final String ageYears;
  final String heightM;

  /// Display label for the user's current fitness level (e.g. "Intermediate").
  final String fitnessLevel;

  /// Lifetime achievement stats shown on the Profile Statistics grid.
  final int completedWorkouts;
  final int caloriesBurned;
  final int trainingDays;
  final int currentStreak;

  // Raw values as stored by the backend — kept alongside the formatted
  // display strings above so edit forms and the onboarding sync can send
  // real data back instead of re-parsing display text.
  final String? gender;
  final DateTime? dateOfBirth;
  final num? heightCmRaw;
  final num? weightKgRaw;
  final String? goal;
  final String? activityLevel;
  final List<String> availableEquipment;
  final int? availableMinutes;
  final String? avatarUrl;
  final List<String> favoriteWorkoutIds;
  final List<String> favoriteRecipeIds;

  static const empty = UserProfile(
    name: '',
    email: '',
    birthday: '—',
    weightKg: '—',
    ageYears: '—',
    heightM: '—',
    fitnessLevel: 'Beginner',
    completedWorkouts: 0,
    caloriesBurned: 0,
    trainingDays: 0,
    currentStreak: 0,
  );

  /// Builds a display-ready [UserProfile] from the backend's `User` JSON
  /// (see `backend/src/models/User.js`).
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final dobRaw = json['dateOfBirth'] as String?;
    final dateOfBirth = dobRaw == null ? null : DateTime.tryParse(dobRaw);
    final heightCm = (json['heightCm'] as num?);
    final weightKg = (json['weightKg'] as num?);
    final stats = json['stats'] as Map<String, dynamic>? ?? const {};

    return UserProfile(
      id: (json['_id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      birthday: dateOfBirth == null ? '—' : _formatBirthday(dateOfBirth),
      weightKg: weightKg == null ? '—' : '${weightKg.round()} Kg',
      ageYears: dateOfBirth == null ? '—' : '${_ageFrom(dateOfBirth)}',
      heightM: heightCm == null ? '—' : '${(heightCm / 100).toStringAsFixed(2)} m',
      fitnessLevel: _fitnessLevelFor(stats['workoutsCompleted'] as int? ?? 0),
      completedWorkouts: stats['workoutsCompleted'] as int? ?? 0,
      caloriesBurned: stats['caloriesBurned'] as int? ?? 0,
      trainingDays: stats['totalTrainingDays'] as int? ?? 0,
      currentStreak: stats['currentStreak'] as int? ?? 0,
      gender: json['gender'] as String?,
      dateOfBirth: dateOfBirth,
      heightCmRaw: heightCm,
      weightKgRaw: weightKg,
      goal: json['goal'] as String?,
      activityLevel: json['activityLevel'] as String?,
      availableEquipment: _stringList(json['availableEquipment']),
      availableMinutes: (json['availableMinutes'] as num?)?.toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      favoriteWorkoutIds: _idList(json['favoriteWorkouts']),
      favoriteRecipeIds: _idList(json['favoriteRecipes']),
    );
  }

  static List<String> _idList(Object? value) {
    if (value is! List) return const [];
    return value.map((e) => e.toString()).toList();
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList();
  }

  static int _ageFrom(DateTime dateOfBirth) {
    final now = DateTime.now();
    var age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  static String _formatBirthday(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  static String _fitnessLevelFor(int workoutsCompleted) {
    if (workoutsCompleted >= 100) return 'Advanced';
    if (workoutsCompleted >= 30) return 'Intermediate';
    return 'Beginner';
  }
}

class DocumentItem {
  const DocumentItem({required this.title, required this.description});
  final String title;
  final String description;
}
