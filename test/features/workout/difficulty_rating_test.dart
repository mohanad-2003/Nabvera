import 'package:fitness_app/features/workout/domain/difficulty_rating.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DifficultyRatingApi.apiValue', () {
    test('maps every enum value to the exact backend string', () {
      expect(DifficultyRating.tooEasy.apiValue, 'too_easy');
      expect(DifficultyRating.appropriate.apiValue, 'appropriate');
      expect(DifficultyRating.hard.apiValue, 'hard');
      expect(DifficultyRating.tooHard.apiValue, 'too_hard');
    });
  });

  group('difficultyRatingFromApi', () {
    test('parses every known backend value back to its enum', () {
      expect(difficultyRatingFromApi('too_easy'), DifficultyRating.tooEasy);
      expect(
        difficultyRatingFromApi('appropriate'),
        DifficultyRating.appropriate,
      );
      expect(difficultyRatingFromApi('hard'), DifficultyRating.hard);
      expect(difficultyRatingFromApi('too_hard'), DifficultyRating.tooHard);
    });

    test('returns null for missing, empty, or unrecognized values', () {
      expect(difficultyRatingFromApi(null), isNull);
      expect(difficultyRatingFromApi(''), isNull);
      expect(difficultyRatingFromApi('meh'), isNull);
    });

    test('round-trips every enum value through apiValue and back', () {
      for (final rating in DifficultyRating.values) {
        expect(difficultyRatingFromApi(rating.apiValue), rating);
      }
    });
  });
}
