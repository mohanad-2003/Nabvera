/// A single in-progress workout session, persisted locally (see
/// `PreferencesService.workoutProgress`) from the real completed/total set
/// counts `CategoryDetailPage` tracks while a session is active — never a
/// fabricated percentage. Powers the Workout tab's "continue where you left
/// off" card and the matching list card's progress ring.
class WorkoutProgressEntry {
  const WorkoutProgressEntry({
    required this.workoutId,
    required this.title,
    required this.titleAr,
    required this.image,
    required this.completedSets,
    required this.totalSets,
  });

  final String workoutId;
  final String title;
  final String titleAr;
  final String image;
  final int completedSets;
  final int totalSets;

  double get fraction =>
      totalSets == 0 ? 0 : (completedSets / totalSets).clamp(0, 1);

  bool get isComplete => totalSets > 0 && completedSets >= totalSets;

  String localizedTitle(String languageCode) =>
      languageCode == 'ar' && titleAr.isNotEmpty ? titleAr : title;

  Map<String, dynamic> toMap() => {
    'workoutId': workoutId,
    'title': title,
    'titleAr': titleAr,
    'image': image,
    'completedSets': completedSets,
    'totalSets': totalSets,
  };

  static WorkoutProgressEntry? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    final workoutId = map['workoutId'] as String?;
    if (workoutId == null || workoutId.isEmpty) return null;
    return WorkoutProgressEntry(
      workoutId: workoutId,
      title: map['title'] as String? ?? '',
      titleAr: map['titleAr'] as String? ?? '',
      image: map['image'] as String? ?? '',
      completedSets: (map['completedSets'] as num?)?.toInt() ?? 0,
      totalSets: (map['totalSets'] as num?)?.toInt() ?? 0,
    );
  }
}
