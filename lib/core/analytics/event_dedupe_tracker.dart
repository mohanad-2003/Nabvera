/// Tracks which (event name, dedupe key) combinations have already been
/// sent — extracted as its own tiny, pure, in-memory class so the "send
/// this at most once" rule is unit-testable without any network or
/// Firebase dependency. See `AnalyticsService.logEvent`'s `dedupeKey`
/// parameter for how this is used.
class EventDedupeTracker {
  final Set<String> _seen = {};

  /// Returns `true` (and remembers the pair) the first time this exact
  /// (eventName, dedupeKey) combination is seen; `false` on every repeat.
  bool shouldSend(String eventName, String dedupeKey) {
    final key = '$eventName|$dedupeKey';
    if (_seen.contains(key)) return false;
    _seen.add(key);
    return true;
  }
}
