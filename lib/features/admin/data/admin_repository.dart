import 'package:fitness_app/core/network/api_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_repository.g.dart';

/// The five content types the Admin console manages, and the existing
/// backend collection each maps to (`backend/src/routes/*.js`). Deliberately
/// thin: every method here calls an endpoint that already exists — no new
/// backend routes, and nothing for managing users/roles (not implemented
/// server-side, so not exposed here either).
enum AdminEntity { workout, exercise, recipe, article, challenge }

extension on AdminEntity {
  String get path => switch (this) {
    AdminEntity.workout => '/workouts',
    AdminEntity.exercise => '/exercises',
    AdminEntity.recipe => '/recipes',
    AdminEntity.article => '/articles',
    AdminEntity.challenge => '/challenges',
  };

  /// Only Workout/Exercise/Recipe have `PATCH /:id` on the backend —
  /// Article and Challenge only ever supported create + delete. See the
  /// respective `backend/src/routes/*.js` for the exact set of methods
  /// mounted per entity.
  bool get supportsUpdate =>
      this == AdminEntity.workout ||
      this == AdminEntity.exercise ||
      this == AdminEntity.recipe;
}

/// Talks to the same list/create/update/delete endpoints the rest of the
/// app already uses for browsing — this repository only adds the
/// admin-only write calls (`restrictTo('admin')` on the backend) on top.
/// Returns raw decoded JSON, same convention as `WorkoutRepository`.
class AdminRepository {
  AdminRepository(this._client);

  final ApiClient _client;

  Future<List<Map<String, dynamic>>> fetchAll(AdminEntity entity) async {
    final response = await _client.get(entity.path);
    final body = _client.decode(response);
    return (body['data'] as List).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> create(
    AdminEntity entity,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.post(entity.path, body: payload);
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  /// Throws [UnsupportedError] for [AdminEntity.article]/[AdminEntity.challenge]
  /// — see [AdminEntity.supportsUpdate]. Call sites should check that
  /// first (the Article/Challenge editors never offer an edit mode at all).
  Future<Map<String, dynamic>> update(
    AdminEntity entity,
    String id,
    Map<String, dynamic> payload,
  ) async {
    if (!entity.supportsUpdate) {
      throw UnsupportedError('${entity.name} has no update endpoint');
    }
    final response = await _client.patch('${entity.path}/$id', body: payload);
    final body = _client.decode(response);
    return body['data'] as Map<String, dynamic>;
  }

  Future<void> delete(AdminEntity entity, String id) async {
    final response = await _client.delete('${entity.path}/$id');
    _client.decode(response);
  }
}

@Riverpod(keepAlive: true)
AdminRepository adminRepository(Ref ref) {
  return AdminRepository(ref.watch(apiClientProvider));
}
