import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:nabvera/features/authentication/data/firebase_auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;
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

/// Plain requests (the overwhelming majority) get this long to complete
/// before the caller sees a clear timeout error instead of hanging
/// indefinitely on a dead connection.
const _defaultTimeout = Duration(seconds: 15);

/// Image uploads have real bytes to push over the wire on top of normal
/// server processing — [ApiClient.uploadImage] uses this instead of
/// [_defaultTimeout].
const _uploadTimeout = Duration(seconds: 60);

/// A response that isn't valid JSON where JSON was expected, or isn't a
/// `Map` at the top level. Kept distinct from a 4xx/5xx [ApiException] so
/// callers (and tests) can tell "the server answered with an error" apart
/// from "the server (or a proxy in between) sent something the app can't
/// even parse".
enum ApiExceptionType { network, timeout, invalidResponse, server }

/// Thin REST client that signs every request with the current Firebase ID
/// token, matching the backend's `protect` middleware (see
/// `backend/src/middlewares/authMiddleware.js`).
class ApiClient {
  /// [httpClient] is injectable purely for tests (a `MockClient` from
  /// `package:http/testing.dart`) — every real call site lets it default
  /// to a normal [http.Client].
  ApiClient(this._authService, {String? baseUrl, http.Client? httpClient})
    : baseUrl =
          baseUrl ??
          (_apiBaseUrlOverride.isNotEmpty
              ? _apiBaseUrlOverride
              : '$_defaultOrigin/api'),
      _client = httpClient ?? http.Client() {
    // A release build must never talk to a plain-HTTP backend — that would
    // send the Firebase ID token (and every request body) in the clear.
    // Debug/profile builds are exempt so `http://10.0.2.2:5000/api`
    // (Android emulator) and `http://localhost:5000/api` keep working for
    // local development.
    final scheme = Uri.parse(this.baseUrl).scheme;
    if (kReleaseMode && scheme != 'https') {
      throw StateError(
        'Refusing to start ApiClient with a non-HTTPS baseUrl in a release '
        'build: $scheme://... — set API_BASE_URL to an https:// URL.',
      );
    }
  }

  final FirebaseAuthService _authService;
  final String baseUrl;
  final http.Client _client;

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
  ///
  /// Never retries anything else: a timeout or connection failure is
  /// surfaced immediately rather than silently re-sent, because for a
  /// non-idempotent request (a POST logging a workout, adding a comment)
  /// there is no way to tell here whether the *first* attempt already
  /// reached the server and did its job before the response was lost — an
  /// automatic retry in that case would double it. The one exception
  /// (retrying on 401) is safe specifically because auth middleware
  /// rejects the request *before* any handler runs, so nothing was done
  /// server-side to double.
  ///
  /// Network failures, timeouts, and non-JSON responses are all converted
  /// to [ApiException] here — a caller only ever needs to catch one type.
  Future<http.Response> _send(
    String method,
    String path, {
    Object? body,
    Duration timeout = _defaultTimeout,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final encodedBody = body == null ? null : jsonEncode(body);

    Future<http.Response> attempt(bool forceRefresh) async {
      final headers = await _headers(forceRefresh: forceRefresh);
      final future = switch (method) {
        'GET' => _client.get(uri, headers: headers),
        'POST' => _client.post(uri, headers: headers, body: encodedBody),
        'PATCH' => _client.patch(uri, headers: headers, body: encodedBody),
        'DELETE' => _client.delete(uri, headers: headers, body: encodedBody),
        _ => throw ArgumentError('Unsupported method: $method'),
      };
      return _guarded(() => future.timeout(timeout));
    }

    final response = await attempt(false);
    if (response.statusCode != 401) return response;
    return attempt(true);
  }

  /// Runs an in-flight HTTP call and maps every failure mode that isn't
  /// already an [ApiException] onto one — never lets a raw
  /// [TimeoutException], [http.ClientException], or other platform-level
  /// network error escape to a caller that only knows how to handle
  /// [ApiException]. Deliberately never includes the request's headers
  /// (which would leak the Authorization/Firebase token) in the resulting
  /// message.
  Future<http.Response> _guarded(
    Future<http.Response> Function() call,
  ) async {
    try {
      return await call();
    } on TimeoutException {
      throw ApiException(
        statusCode: 0,
        message: 'The request took too long to respond. Please try again.',
        type: ApiExceptionType.timeout,
      );
    } on http.ClientException {
      throw ApiException(
        statusCode: 0,
        message: 'Could not reach the server. Check your connection and try again.',
        type: ApiExceptionType.network,
      );
    } on ApiException {
      rethrow;
    } on FormatException {
      throw ApiException(
        statusCode: 0,
        message: 'Received an unreadable response from the server.',
        type: ApiExceptionType.invalidResponse,
      );
    }
  }

  Future<http.Response> get(String path, {Duration timeout = _defaultTimeout}) =>
      _send('GET', path, timeout: timeout);

  Future<http.Response> post(
    String path, {
    Object? body,
    Duration timeout = _defaultTimeout,
  }) => _send('POST', path, body: body, timeout: timeout);

  Future<http.Response> patch(
    String path, {
    Object? body,
    Duration timeout = _defaultTimeout,
  }) => _send('PATCH', path, body: body, timeout: timeout);

  Future<http.Response> delete(
    String path, {
    Object? body,
    Duration timeout = _defaultTimeout,
  }) => _send('DELETE', path, body: body, timeout: timeout);

  /// Uploads one image while preserving the token refresh behavior used by
  /// JSON requests. Multipart requests set their own content-type boundary.
  ///
  /// [contentType] matters: without it, `http`'s `MultipartFile.fromBytes`
  /// defaults the part's content-type to `application/octet-stream`, which
  /// fails the backend's `fileFilter` (`file.mimetype.startsWith('image/')`)
  /// and rejects the upload with 400 "Only image files are allowed" — the
  /// upload actually reaching the server and being turned down, not a
  /// network failure. Pass the picker's own reported mime type when
  /// available; [_guessImageContentType] is only the fallback for when it
  /// isn't.
  Future<http.Response> uploadImage(
    String path, {
    required List<int> bytes,
    required String filename,
    String? contentType,
    Duration timeout = _uploadTimeout,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final mediaType = MediaType.parse(
      contentType ?? _guessImageContentType(filename),
    );

    Future<http.Response> attempt(bool forceRefresh) async {
      final headers = await _headers(forceRefresh: forceRefresh);
      headers.remove('Content-Type');
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers)
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: filename,
            contentType: mediaType,
          ),
        );
      return _guarded(
        () async =>
            http.Response.fromStream(await request.send().timeout(timeout)),
      );
    }

    final response = await attempt(false);
    if (response.statusCode != 401) return response;
    return attempt(true);
  }

  /// Extension-based fallback for when the caller has no reported mime
  /// type (e.g. `XFile.mimeType` was null) — covers every format the
  /// gallery/camera picker can realistically hand back. Defaults to JPEG
  /// rather than a non-image type, since an unrecognized extension is far
  /// more likely to be a photo the OS just didn't label than anything else.
  static String _guessImageContentType(String filename) {
    final lower = filename.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    if (lower.endsWith('.heic')) return 'image/heic';
    if (lower.endsWith('.heif')) return 'image/heif';
    return 'image/jpeg';
  }

  /// Decodes a JSON body and throws [ApiException] for non-2xx responses,
  /// matching the backend's `{ success, message }` error shape. A body
  /// that isn't valid JSON, or isn't a JSON object, is treated the same
  /// way as a network failure — [ApiExceptionType.invalidResponse] — rather
  /// than letting a raw [FormatException]/[TypeError] surface to the UI.
  Map<String, dynamic> decode(http.Response response) {
    Object? decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } on FormatException {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Received an unreadable response from the server.',
          type: ApiExceptionType.invalidResponse,
        );
      }
    }
    final body = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: (body['message'] as String?) ?? 'Request failed',
      );
    }
    return body;
  }

  /// Releases the underlying connection pool. Safe to call even though
  /// [ApiClient] is normally a `keepAlive` singleton for the app's whole
  /// lifetime (see the `apiClient` provider below) — tests, and any future
  /// scoped usage, still need a clean way to tear it down.
  void dispose() => _client.close();
}

class ApiException implements Exception {
  ApiException({
    required this.statusCode,
    required this.message,
    this.type = ApiExceptionType.server,
  });

  /// The HTTP status code, or `0` when this exception was never a real
  /// HTTP response (network failure, timeout, unparseable body) — see
  /// [type] to tell those cases apart.
  final int statusCode;
  final String message;
  final ApiExceptionType type;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final client = ApiClient(ref.watch(firebaseAuthServiceProvider));
  ref.onDispose(client.dispose);
  return client;
}
