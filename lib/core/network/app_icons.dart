import 'api_client.dart';

/// The app's small UI-chrome icons (time, calories, social login marks,
/// home nav tiles) — self-hosted on the backend at `/static/icons/*` (see
/// `backend/public/icons/` and `app.js`'s `/static` mount) rather than
/// bundled as local Flutter assets, so every image in the app — content
/// and chrome alike — comes from the API.
///
/// Getters, not `const` fields: the resolved URL depends on the platform
/// (emulator vs. device) via [resolveBackendUrl], which can't be computed
/// at compile time.
abstract final class AppIcons {
  static String get time => resolveBackendUrl('/static/icons/time.png');
  static String get calories => resolveBackendUrl('/static/icons/calories.png');
  static String get run => resolveBackendUrl('/static/icons/run.png');
  static String get gmail => resolveBackendUrl('/static/icons/gmail.png');
  static String get facebook => resolveBackendUrl('/static/icons/facebook.png');
  static String get apple => resolveBackendUrl('/static/icons/apple.png');
  static String get workout => resolveBackendUrl('/static/icons/workout.png');
  static String get progress => resolveBackendUrl('/static/icons/progress.png');
  static String get nutrition => resolveBackendUrl('/static/icons/nutrition.png');
  static String get community => resolveBackendUrl('/static/icons/community.png');
}
