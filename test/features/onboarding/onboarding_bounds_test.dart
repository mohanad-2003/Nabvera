import 'package:nabvera/features/onboarding/domain/onboarding_bounds.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isValidAge', () {
    test('accepts the boundary values themselves', () {
      expect(isValidAge(OnboardingBounds.minAge), isTrue);
      expect(isValidAge(OnboardingBounds.maxAge), isTrue);
    });

    test('rejects one step past either boundary', () {
      expect(isValidAge(OnboardingBounds.minAge - 1), isFalse);
      expect(isValidAge(OnboardingBounds.maxAge + 1), isFalse);
    });

    test('accepts a normal age', () => expect(isValidAge(28), isTrue));
  });

  group('isValidHeightCm', () {
    test('accepts the boundary values themselves', () {
      expect(isValidHeightCm(OnboardingBounds.minHeightCm), isTrue);
      expect(isValidHeightCm(OnboardingBounds.maxHeightCm), isTrue);
    });

    test('rejects one step past either boundary', () {
      expect(isValidHeightCm(OnboardingBounds.minHeightCm - 1), isFalse);
      expect(isValidHeightCm(OnboardingBounds.maxHeightCm + 1), isFalse);
    });

    test('accepts a normal height', () => expect(isValidHeightCm(170), isTrue));
  });

  group('isValidWeightKg', () {
    test('accepts the boundary values themselves', () {
      expect(isValidWeightKg(OnboardingBounds.minWeightKg), isTrue);
      expect(isValidWeightKg(OnboardingBounds.maxWeightKg), isTrue);
    });

    test('rejects one step past either boundary', () {
      expect(isValidWeightKg(OnboardingBounds.minWeightKg - 1), isFalse);
      expect(isValidWeightKg(OnboardingBounds.maxWeightKg + 1), isFalse);
    });

    test('accepts a normal weight', () => expect(isValidWeightKg(75), isTrue));
  });
}
