import 'package:flutter/widgets.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/features/health/domain/health_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  test('healthInsightCodeLabel maps every known code to a non-empty label', () {
    const codes = [
      'activity_up',
      'activity_down',
      'sleep_consistent',
      'sleep_low_data',
      'rest_day_suggested',
      'keep_momentum',
    ];
    for (final code in codes) {
      final label = healthInsightCodeLabel(l10n, code);
      expect(label, isNotEmpty, reason: 'no label for "$code"');
    }
  });

  test('healthInsightCodeLabel never renders a claim of a health problem or medical advice', () {
    // A content guard, not a translation check: none of the fixed labels
    // should ever contain alarming/medical language, regardless of how
    // they're worded — see the Phase 7 brief's explicit ban on phrasing
    // like "you're exhausted" or "you have a problem".
    const forbidden = ['exhausted', 'sick', 'problem', 'disease', 'diagnos'];
    const codes = ['activity_up', 'activity_down', 'sleep_consistent', 'sleep_low_data', 'rest_day_suggested', 'keep_momentum'];
    for (final code in codes) {
      final label = healthInsightCodeLabel(l10n, code).toLowerCase();
      for (final word in forbidden) {
        expect(label.contains(word), isFalse, reason: '"$code" label contains "$word": $label');
      }
    }
  });

  test('healthInsightCodeLabel returns empty string for an unknown code, never throws', () {
    expect(healthInsightCodeLabel(l10n, 'made_up_code'), '');
  });
}
