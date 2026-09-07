/// Shared min/max bounds for the age/height/weight wizard steps — kept
/// here (not duplicated as a local constant per page) so the picker UI and
/// its validation always agree on the exact same range, and so the range
/// is unit-testable without pumping a widget.
abstract final class OnboardingBounds {
  static const minAge = 10;
  static const maxAge = 80;
  static const minHeightCm = 120;
  static const maxHeightCm = 220;
  static const minWeightKg = 30;
  static const maxWeightKg = 250;
}

/// True only for a value [WizardValueStepper] could actually produce for
/// this step — i.e. "a valid value within the accepted bounds". Since the
/// picker has no free-text entry path, a value from it is always in range
/// by construction; these exist as the single source of truth for that
/// range and to make the guarantee explicitly testable.
bool isValidAge(int age) =>
    age >= OnboardingBounds.minAge && age <= OnboardingBounds.maxAge;

bool isValidHeightCm(int heightCm) =>
    heightCm >= OnboardingBounds.minHeightCm &&
    heightCm <= OnboardingBounds.maxHeightCm;

bool isValidWeightKg(int weightKg) =>
    weightKg >= OnboardingBounds.minWeightKg &&
    weightKg <= OnboardingBounds.maxWeightKg;
