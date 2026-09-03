import 'package:fitness_app/core/analytics/event_dedupe_tracker.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EventDedupeTracker', () {
    test('allows the first (event, key) combination through', () {
      final tracker = EventDedupeTracker();
      expect(tracker.shouldSend('recommendation_viewed', 'w1|on_track'), isTrue);
    });

    test('blocks an exact repeat of the same (event, key) combination', () {
      final tracker = EventDedupeTracker();
      expect(tracker.shouldSend('recommendation_viewed', 'w1|on_track'), isTrue);
      expect(tracker.shouldSend('recommendation_viewed', 'w1|on_track'), isFalse);
      expect(tracker.shouldSend('recommendation_viewed', 'w1|on_track'), isFalse);
    });

    test('a different key for the same event is a separate combination', () {
      final tracker = EventDedupeTracker();
      expect(tracker.shouldSend('recommendation_viewed', 'w1|on_track'), isTrue);
      expect(tracker.shouldSend('recommendation_viewed', 'w2|on_track'), isTrue);
      expect(tracker.shouldSend('recommendation_viewed', 'w1|muscle_recovery'), isTrue);
    });

    test('the same key under a different event name is a separate combination', () {
      final tracker = EventDedupeTracker();
      expect(tracker.shouldSend('recommendation_viewed', 'w1'), isTrue);
      expect(tracker.shouldSend('workout_started', 'w1'), isTrue);
    });

    test('unrelated events (no dedupe key involved) are unaffected by each other', () {
      final tracker = EventDedupeTracker();
      expect(tracker.shouldSend('workout_started', 'a'), isTrue);
      expect(tracker.shouldSend('workout_completed', 'a'), isTrue);
      expect(tracker.shouldSend('workout_started', 'a'), isFalse);
    });
  });
}
