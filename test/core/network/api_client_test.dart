import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' show User, UserCredential;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nabvera/core/network/api_client.dart';
import 'package:nabvera/features/authentication/data/firebase_auth_service.dart';

/// A token-issuing double for [FirebaseAuthService] — real behavior
/// (Firebase plugin calls) is exactly what these tests must avoid, so this
/// only ever answers [getIdToken] and counts how it was called.
class FakeFirebaseAuthService implements FirebaseAuthService {
  String? token = 'token-initial';
  int plainCallCount = 0;
  int forceRefreshCallCount = 0;

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    if (forceRefresh) {
      forceRefreshCallCount++;
      token = 'token-refreshed';
    } else {
      plainCallCount++;
    }
    return token;
  }

  @override
  User? get currentUser => null;
  @override
  Stream<User?> get authStateChanges => const Stream.empty();
  @override
  Future<UserCredential> signInWithEmail({required String email, required String password}) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> signUpWithEmail({required String fullName, required String email, required String password}) async =>
      throw UnimplementedError();
  @override
  Future<UserCredential> signInWithGoogle() async => throw UnimplementedError();
  @override
  Future<void> sendPasswordResetEmail(String email) async => throw UnimplementedError();
  @override
  Future<void> signOut() async {}
}

void main() {
  const baseUrl = 'https://example.test/api';

  ApiClient buildClient(
    FakeFirebaseAuthService auth,
    Future<http.Response> Function(http.Request) handler,
  ) {
    return ApiClient(
      auth,
      baseUrl: baseUrl,
      httpClient: MockClient(handler),
    );
  }

  test('get: a normal 200 response passes straight through', () async {
    final auth = FakeFirebaseAuthService();
    final client = buildClient(auth, (request) async {
      expect(request.url.toString(), '$baseUrl/ping');
      expect(request.headers['Authorization'], 'Bearer token-initial');
      return http.Response(jsonEncode({'success': true, 'data': 'pong'}), 200);
    });

    final response = await client.get('/ping');
    expect(client.decode(response)['data'], 'pong');
    expect(auth.plainCallCount, 1);
    expect(auth.forceRefreshCallCount, 0);
  });

  test('401 is retried exactly once with a force-refreshed token, then succeeds', () async {
    final auth = FakeFirebaseAuthService();
    var callCount = 0;
    final client = buildClient(auth, (request) async {
      callCount++;
      if (callCount == 1) {
        expect(request.headers['Authorization'], 'Bearer token-initial');
        return http.Response(jsonEncode({'success': false, 'message': 'jwt expired'}), 401);
      }
      expect(request.headers['Authorization'], 'Bearer token-refreshed');
      return http.Response(jsonEncode({'success': true, 'data': 'ok'}), 200);
    });

    final response = await client.get('/me');
    expect(response.statusCode, 200);
    expect(callCount, 2);
    expect(auth.forceRefreshCallCount, 1);
  });

  test('a 401 that persists after the refreshed retry is returned as-is, never retried a third time', () async {
    final auth = FakeFirebaseAuthService();
    var callCount = 0;
    final client = buildClient(auth, (request) async {
      callCount++;
      return http.Response(jsonEncode({'success': false, 'message': 'still unauthorized'}), 401);
    });

    final response = await client.get('/me');
    expect(response.statusCode, 401);
    expect(callCount, 2, reason: 'exactly one retry, even though the retried attempt also failed');
  });

  test('a POST is never silently retried a second time on its own (only 401 triggers the one retry)', () async {
    final auth = FakeFirebaseAuthService();
    var callCount = 0;
    final client = buildClient(auth, (request) async {
      callCount++;
      return http.Response(jsonEncode({'success': true, 'data': 'created'}), 201);
    });

    await client.post('/workout-logs', body: {'title': 'Leg day'});
    expect(callCount, 1);
  });

  test('a timeout is converted to an ApiException of type timeout, not a raw TimeoutException', () async {
    final auth = FakeFirebaseAuthService();
    final client = buildClient(auth, (request) async {
      await Future<void>.delayed(const Duration(seconds: 2));
      return http.Response('{}', 200);
    });

    await expectLater(
      client.get('/slow', timeout: const Duration(milliseconds: 20)),
      throwsA(
        isA<ApiException>()
            .having((e) => e.type, 'type', ApiExceptionType.timeout)
            .having((e) => e.statusCode, 'statusCode', 0),
      ),
    );
  });

  test('a connection failure is converted to an ApiException of type network', () async {
    final auth = FakeFirebaseAuthService();
    final client = buildClient(auth, (request) async {
      throw http.ClientException('Connection refused');
    });

    await expectLater(
      client.get('/anything'),
      throwsA(isA<ApiException>().having((e) => e.type, 'type', ApiExceptionType.network)),
    );
  });

  test('decode: a non-JSON body is an ApiException of type invalidResponse, not a FormatException', () {
    final response = http.Response('<html>not json</html>', 200);
    final auth = FakeFirebaseAuthService();
    final client = buildClient(auth, (request) async => http.Response('{}', 200));

    expect(
      () => client.decode(response),
      throwsA(isA<ApiException>().having((e) => e.type, 'type', ApiExceptionType.invalidResponse)),
    );
  });

  test('decode: a JSON body that is not an object (e.g. a bare string) is invalidResponse-safe, not a crash', () {
    final response = http.Response(jsonEncode('just a string'), 200);
    final auth = FakeFirebaseAuthService();
    final client = buildClient(auth, (request) async => http.Response('{}', 200));

    // A 2xx with a non-object body is treated as an empty body rather than
    // throwing — there is nothing genuinely wrong with the HTTP exchange.
    expect(client.decode(response), <String, dynamic>{});
  });

  test('decode: a non-2xx status still throws the normal server ApiException with the backend message', () {
    final response = http.Response(jsonEncode({'success': false, 'message': 'Not found'}), 404);
    final auth = FakeFirebaseAuthService();
    final client = buildClient(auth, (request) async => http.Response('{}', 200));

    expect(
      () => client.decode(response),
      throwsA(
        isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', 404)
            .having((e) => e.message, 'message', 'Not found')
            .having((e) => e.type, 'type', ApiExceptionType.server),
      ),
    );
  });
}
