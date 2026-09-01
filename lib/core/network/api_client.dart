import 'dart:convert';
import 'dart:io';

import 'package:fitness_app/features/authentication/data/firebase_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

/// Origin of the Node/Express backend (no path suffix).
///
/// `10.0.2.2` is the Android emulator's alias for the host machine's
/// `localhost`; iOS simulators and desktop can reach `localhost` directly.
/// Override with `--dart-define=API_BASE_URL=https://your-api.example.com/api`
/// when pointing at a deployed backend — [apiOrigin] derives the plain
/// origin from it by stripping the trailing `/api`.
String get _defaultOrigin {
  if (kIsWeb) return 'http://localhost:5000';
  if (Platform.isAndroid) return 'http://10.0.2.2:5000';
  return 'http://localhost:5000';
}

const _apiBaseUrlOverride = String.fromEnvironment('API_BASE_URL');

/// The backend's origin (scheme + host + port, no `/api` suffix) — used to
/// resolve server-relative paths like `/static/icons/time.png` (see
/// `resolveBackendUrl`) the same way `ApiClient.baseUrl` resolves API calls.
String get apiOrigin {
  if (_apiBaseUrlOverride.isEmpty) return _defaultOrigin;
  return _apiBaseUrlOverride.replaceFirst(RegExp(r'/api/?$'), '');
}

/// Turns a server-relative path (e.g. `/static/icons/time.png`, as stored
/// by backend documents for self-hosted assets) into an absolute URL the
/// device can actually reach. Absolute URLs (Unsplash, Pexels, etc.) pass
/// through unchanged.
String resolveBackendUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return '$apiOrigin$path';
}

/// Thin REST client that signs every request with the current Firebase ID
/// token, matching the backend's `protect` middleware (see
/// `backend/src/middlewares/authMiddleware.js`).
class ApiClient {
  ApiClient(this._authService, {String? baseUrl})
    : baseUrl =
          baseUrl ??
          (_apiBaseUrlOverride.isNotEmpty ? _apiBaseUrlOverride : '$_defaultOrigin/api');

  final FirebaseAuthService _authService;
  final String baseUrl;
  final http.Client _client = http.Client();

  Future<Map<String, String>> _headers() async {
    final token = await _authService.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> get(String path) async {
    return _client.get(Uri.parse('$baseUrl$path'), headers: await _headers());
  }

  Future<http.Response> post(String path, {Object? body}) async {
    return _client.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> patch(String path, {Object? body}) async {
    return _client.patch(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    return _client.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
    );
  }

  /// Decodes a JSON body and throws [ApiException] for non-2xx responses,
  /// matching the backend's `{ success, message }` error shape.
  Map<String, dynamic> decode(http.Response response) {
    final body =
        response.body.isEmpty
            ? <String, dynamic>{}
            : jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: (body['message'] as String?) ?? 'Request failed',
      );
    }
    return body;
  }
}

class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(ref.watch(firebaseAuthServiceProvider));
}
