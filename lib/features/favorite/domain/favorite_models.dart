import 'package:flutter/widgets.dart' show BuildContext, Localizations;

enum FavoriteType { video, article }

class FavoriteItem {
  const FavoriteItem({
    required this.id,
    required this.image,
    required this.title,
    required this.type,
    this.duration,
    this.calories,
    this.exercises,
    this.text,
    this.titleAr = '',
  });

  /// Backend `Workout._id` or `Recipe._id`, depending on [type].
  final String id;
  final String image;
  final String title;
  final FavoriteType type;
  final String? duration;
  final String? calories;
  final String? exercises;
  final String? text;

  /// Arabic translation, from `Workout.titleAr`/`Recipe.titleAr` — empty
  /// for an item an admin hasn't translated yet, in which case
  /// [localizedTitle] falls back to [title] (same pattern as
  /// `ArticleTip.localizedTitle`).
  final String titleAr;

  String localizedTitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && titleAr.isNotEmpty
          ? titleAr
          : title;

  /// Builds a "video" (favorited workout) card from a `/api/workouts/:id`
  /// JSON document.
  factory FavoriteItem.fromWorkoutJson(Map<String, dynamic> json) {
    final exerciseCount = (json['exercises'] as List?)?.length ?? 0;
    return FavoriteItem(
      id: json['_id'] as String? ?? '',
      image: (json['coverImageUrl'] as String?) ?? 'assets/workout.png',
      title: (json['title'] as String?) ?? '',
      titleAr: (json['titleAr'] as String?) ?? '',
      type: FavoriteType.video,
      duration: '${json['durationMinutes'] ?? '—'} Minutes',
      calories: '${json['estimatedCalories'] ?? '—'} Kcal',
      exercises: exerciseCount == 0 ? null : '$exerciseCount Exercises',
    );
  }

  /// Builds an "article" (favorited recipe) card from a
  /// `/api/recipes/:id` JSON document.
  factory FavoriteItem.fromRecipeJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>? ?? const {};
    return FavoriteItem(
      id: json['_id'] as String? ?? '',
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      title: (json['title'] as String?) ?? '',
      titleAr: (json['titleAr'] as String?) ?? '',
      type: FavoriteType.article,
      duration: '${json['prepTimeMinutes'] ?? '—'} Minutes',
      calories: '${nutrition['calories'] ?? '—'} Cal',
      text: json['description'] as String?,
    );
  }
}
