package com.nabvera.app

import io.flutter.embedding.android.FlutterFragmentActivity

// local_auth's Android BiometricPrompt integration requires a
// FragmentActivity host, not the plain FlutterActivity template default.
class MainActivity : FlutterFragmentActivity()
