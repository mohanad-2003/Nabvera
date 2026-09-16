import 'package:flutter/widgets.dart' show BuildContext, Localizations;

import '../../../core/localization/generated/app_localizations.dart';

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
    this.durationMinutes,
    this.caloriesValue,
    this.exerciseCount,
  });

  /// Backend `Workout._id` or `Recipe._id`, depending on [type].
  final String id;
  final String image;
  final String title;
  final FavoriteType type;

  /// English-formatted fallback, used only when [durationMinutes] /
  /// [caloriesValue] / [exerciseCount] aren't available. Prefer
  /// [localizedDuration] / [localizedCalories] / [localizedExercises] for
  /// display — a raw "35 Minutes"/"320 Kcal" string mixed into an Arabic
  /// layout doesn't just read as untranslated, it can visually reorder
  /// under RTL bidi (same issue fixed for `WorkoutListItem`).
  final String? duration;
  final String? calories;
  final String? exercises;
  final String? text;

  /// Arabic translation, from `Workout.titleAr`/`Recipe.titleAr` — empty
  /// for an item an admin hasn't translated yet, in which case
  /// [localizedTitle] falls back to [title] (same pattern as
  /// `ArticleTip.localizedTitle`).
  final String titleAr;

  final int? durationMinutes;
  final int? caloriesValue;
  final int? exerciseCount;

  String localizedTitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && titleAr.isNotEmpty
          ? titleAr
          : title;

  /// Duration formatted for [context]'s current locale — falls back to
  /// [duration] only when the raw minute count isn't known.
  String? localizedDuration(BuildContext context) => durationMinutes == null
      ? duration
      : AppLocalizations.of(context).homeHeroDuration(durationMinutes!);

  /// Calories formatted for [context]'s current locale — falls back to
  /// [calories] only when the raw kcal value isn't known.
  String? localizedCalories(BuildContext context) => caloriesValue == null
      ? calories
      : AppLocalizations.of(context).homeHeroCalories(caloriesValue!);

  /// Exercise count formatted for [context]'s current locale — falls back
  /// to [exercises] only when the raw count isn't known.
  String? localizedExercises(BuildContext context) => exerciseCount == null
      ? exercises
      : AppLocalizations.of(context).homeHeroExercises(exerciseCount!);

  /// Builds a "video" (favorited workout) card from a `/api/workouts/:id`
  /// JSON document.
  factory FavoriteItem.fromWorkoutJson(Map<String, dynamic> json) {
    final exerciseCount = (json['exercises'] as List?)?.length ?? 0;
    final durationMinutes = (json['durationMinutes'] as num?)?.toInt();
    final caloriesValue = (json['estimatedCalories'] as num?)?.toInt();
    return FavoriteItem(
      id: json['_id'] as String? ?? '',
      image: (json['coverImageUrl'] as String?) ?? 'assets/workout.png',
      title: (json['title'] as String?) ?? '',
      titleAr: (json['titleAr'] as String?) ?? '',
      type: FavoriteType.video,
      duration: '${durationMinutes ?? '—'} Minutes',
      calories: '${caloriesValue ?? '—'} Kcal',
      exercises: exerciseCount == 0 ? null : '$exerciseCount Exercises',
      durationMinutes: durationMinutes,
      caloriesValue: caloriesValue,
      exerciseCount: exerciseCount == 0 ? null : exerciseCount,
    );
  }

  /// Builds an "article" (favorited recipe) card from a
  /// `/api/recipes/:id` JSON document.
  factory FavoriteItem.fromRecipeJson(Map<String, dynamic> json) {
    final nutrition = json['nutrition'] as Map<String, dynamic>? ?? const {};
    final durationMinutes = (json['prepTimeMinutes'] as num?)?.toInt();
    final caloriesValue = (nutrition['calories'] as num?)?.toInt();
    return FavoriteItem(
      id: json['_id'] as String? ?? '',
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      title: (json['title'] as String?) ?? '',
      titleAr: (json['titleAr'] as String?) ?? '',
      type: FavoriteType.article,
      duration: '${durationMinutes ?? '—'} Minutes',
      calories: '${caloriesValue ?? '—'} Cal',
      text: json['description'] as String?,
      durationMinutes: durationMinutes,
      caloriesValue: caloriesValue,
    );
  }
}
