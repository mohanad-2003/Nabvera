import 'package:flutter/widgets.dart';

/// Native builds never render this (see `google_web_button.dart`'s
/// conditional import) — this stub only exists so the shared,
/// platform-agnostic call site still compiles on iOS/Android/desktop.
Widget buildGoogleWebButton({required bool isDark}) => const SizedBox.shrink();
