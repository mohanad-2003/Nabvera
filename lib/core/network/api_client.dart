import 'dart:convert';

import 'package:fitness_app/features/authentication/data/firebase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client.g.dart';

/// Origin of the Node/Express backend (no path suffix).
///
/// Defaults to the deployed Render backend so a plain `flutter run` works
/// out of the box without a local server. Override with
/// `--dart-define=API_BASE_URL=http://10.0.2.2:5000/api` (Android emulator)
/// or `http://localhost:5000/api` (iOS simulator/desktop/web) to point at a
/// local dev server instead — [apiOrigin] derives the plain origin from
/// whichever URL is active by stripping the trailing `/api`.
String get _defaultOrigin => 'https://nabvera-backend.onrender.com';

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
          (_apiBaseUrlOverride.isNotEmpty
              ? _apiBaseUrlOverride
              : '$_defaultOrigin/api');

  final FirebaseAuthService _authService;
  final String baseUrl;
  final http.Client _client = http.Client();

  Future<Map<String, String>> _headers({bool forceRefresh = false}) async {
    final token = await _authService.getIdToken(forceRefresh: forceRefresh);
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Sends the request and, if the backend rejects the token as invalid or
  /// expired, retries exactly once with a force-refreshed one. Firebase's
  /// own auto-refresh timer normally keeps `getIdToken()` current, but it
  /// can miss a beat after the app sits backgrounded/idle for a while —
  /// without this, that shows up to the user as a real request (e.g.
  /// finishing a workout) failing for no visible reason.
  Future<http.Response> _send(
    String method,
    String path, {
    Object? body,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final encodedBody = body == null ? null : jsonEncode(body);

    Future<http.Response> attempt(bool forceRefresh) async {
      final headers = await _headers(forceRefresh: forceRefresh);
      return switch (method) {
        'GET' => _client.get(uri, headers: headers),
        'POST' => _client.post(uri, headers: headers, body: encodedBody),
        'PATCH' => _client.patch(uri, headers: headers, body: encodedBody),
        'DELETE' => _client.delete(uri, headers: headers, body: encodedBody),
        _ => throw ArgumentError('Unsupported method: $method'),
      };
    }

    final response = await attempt(false);
    if (response.statusCode != 401) return response;
    return attempt(true);
  }

  Future<http.Response> get(String path) => _send('GET', path);

  Future<http.Response> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<http.Response> patch(String path, {Object? body}) =>
      _send('PATCH', path, body: body);

  Future<http.Response> delete(String path, {Object? body}) =>
      _send('DELETE', path, body: body);

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
