import 'package:flutter/widgets.dart' show BuildContext, Localizations;

/// Fixed navigation tiles to the app's four main sections — always exactly
/// these four, so unlike the rest of Home there's no backend "category"
/// document behind them; only their icon comes from the API (see
/// `AppIcons`), not a data model.
class HomeCategory {
  const HomeCategory({required this.image, required this.name});
  final String image;
  final String name;
}

class RecommendedWorkout {
  const RecommendedWorkout({
    this.id = '',
    required this.image,
    required this.title,
    required this.duration,
    required this.calories,
  });

  final String id;
  final String image;
  final String title;
  final String duration;
  final String calories;

  /// Builds a card from a `/api/workouts` JSON document.
  factory RecommendedWorkout.fromJson(Map<String, dynamic> json) {
    return RecommendedWorkout(
      id: json['_id'] as String? ?? '',
      image: (json['coverImageUrl'] as String?) ?? 'assets/workout.png',
      title: (json['title'] as String?) ?? '',
      duration: '${json['durationMinutes'] ?? '—'} Minutes',
      calories: '${json['estimatedCalories'] ?? '—'} Kcal',
    );
  }
}

class ArticleTip {
  const ArticleTip({
    required this.image,
    required this.description,
    this.title = '',
    this.body = '',
    this.category = '',
    this.paragraphs = const [],
    this.readTimeMinutes = 3,
    this.tags = const [],
    this.titleAr = '',
    this.descriptionAr = '',
    this.paragraphsAr = const [],
  });
  final String image;

  /// Display text for the home-screen card — the article title.
  final String description;

  /// Same as [description] — kept for the detail page, which shows the
  /// title separately from [body].
  final String title;
  final String body;
  final String category;

  /// The full article, one entry per paragraph — from `Article.content`.
  final List<String> paragraphs;
  final int readTimeMinutes;
  final List<String> tags;

  /// Arabic translations, from `Article.titleAr`/`descriptionAr`/
  /// `contentAr` — empty for an article an admin hasn't translated yet, in
  /// which case [localizedTitle] etc. fall back to the English fields
  /// above rather than showing blank text.
  final String titleAr;
  final String descriptionAr;
  final List<String> paragraphsAr;

  bool get _isArabic => titleAr.isNotEmpty;

  /// The title to display for [context]'s current locale — Arabic when the
  /// app is in Arabic *and* this article has an Arabic title, English
  /// otherwise.
  String localizedTitle(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' && _isArabic
          ? titleAr
          : title;

  String localizedDescription(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              descriptionAr.isNotEmpty
          ? descriptionAr
          : description.isEmpty ? body : description;

  String localizedBody(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              descriptionAr.isNotEmpty
          ? descriptionAr
          : body;

  List<String> localizedParagraphs(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar' &&
              paragraphsAr.isNotEmpty
          ? paragraphsAr
          : paragraphs;

  /// Builds a card from a `/api/articles` JSON document.
  factory ArticleTip.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String?) ?? '';
    return ArticleTip(
      image: (json['imageUrl'] as String?) ?? 'assets/workout.png',
      description: title,
      title: title,
      body: (json['description'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      paragraphs: (json['content'] as List? ?? const []).cast<String>(),
      readTimeMinutes: (json['readTimeMinutes'] as num?)?.toInt() ?? 3,
      tags: (json['tags'] as List? ?? const []).cast<String>(),
      titleAr: (json['titleAr'] as String?) ?? '',
      descriptionAr: (json['descriptionAr'] as String?) ?? '',
      paragraphsAr: (json['contentAr'] as List? ?? const []).cast<String>(),
    );
  }
}
