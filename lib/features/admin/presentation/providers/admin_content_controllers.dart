import 'package:nabvera/features/admin/data/admin_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_content_controllers.g.dart';

/// Shared fetch logic for every entity list controller below — a plain
/// top-level helper (not a mixin) so each `@riverpod` class stays a
/// straightforward `extends _$Generated` the way the rest of this codebase
/// writes controllers, with no family/generic-provider machinery.
Future<AsyncValue<List<Map<String, dynamic>>>> _fetchEntityList(
  Ref ref,
  AdminEntity entity,
) async {
  try {
    final items = await ref.read(adminRepositoryProvider).fetchAll(entity);
    return AsyncValue.data(items);
  } catch (error, stackTrace) {
    return AsyncValue.error(error, stackTrace);
  }
}

/// One list controller per Admin content type. All five have the exact
/// same shape (`AsyncValue` of raw documents, a `refresh`, and a
/// `deleteItem`) — five small classes rather than one generic/family
/// provider, matching how this codebase already writes near-identical
/// per-feature controllers (see `WeeklyActivityController`/
/// `RecoveryMapController`).
@riverpod
class AdminWorkoutsController extends _$AdminWorkoutsController {
  static const _entity = AdminEntity.workout;

  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    Future.microtask(refresh);
    return const AsyncValue.loading();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _fetchEntityList(ref, _entity);
    // Navigating away from the Admin list while this fetch is in flight
    // disposes this autoDispose provider before `await` resumes here —
    // writing to `state` after that throws UnmountedRefException.
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> deleteItem(String id) async {
    await ref.read(adminRepositoryProvider).delete(_entity, id);
    await refresh();
  }
}

@riverpod
class AdminExercisesController extends _$AdminExercisesController {
  static const _entity = AdminEntity.exercise;

  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    Future.microtask(refresh);
    return const AsyncValue.loading();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _fetchEntityList(ref, _entity);
    // Navigating away from the Admin list while this fetch is in flight
    // disposes this autoDispose provider before `await` resumes here —
    // writing to `state` after that throws UnmountedRefException.
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> deleteItem(String id) async {
    await ref.read(adminRepositoryProvider).delete(_entity, id);
    await refresh();
  }
}

@riverpod
class AdminRecipesController extends _$AdminRecipesController {
  static const _entity = AdminEntity.recipe;

  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    Future.microtask(refresh);
    return const AsyncValue.loading();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _fetchEntityList(ref, _entity);
    // Navigating away from the Admin list while this fetch is in flight
    // disposes this autoDispose provider before `await` resumes here —
    // writing to `state` after that throws UnmountedRefException.
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> deleteItem(String id) async {
    await ref.read(adminRepositoryProvider).delete(_entity, id);
    await refresh();
  }
}

@riverpod
class AdminArticlesController extends _$AdminArticlesController {
  static const _entity = AdminEntity.article;

  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    Future.microtask(refresh);
    return const AsyncValue.loading();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _fetchEntityList(ref, _entity);
    // Navigating away from the Admin list while this fetch is in flight
    // disposes this autoDispose provider before `await` resumes here —
    // writing to `state` after that throws UnmountedRefException.
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> deleteItem(String id) async {
    await ref.read(adminRepositoryProvider).delete(_entity, id);
    await refresh();
  }
}

@riverpod
class AdminChallengesController extends _$AdminChallengesController {
  static const _entity = AdminEntity.challenge;

  @override
  AsyncValue<List<Map<String, dynamic>>> build() {
    Future.microtask(refresh);
    return const AsyncValue.loading();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final result = await _fetchEntityList(ref, _entity);
    // Navigating away from the Admin list while this fetch is in flight
    // disposes this autoDispose provider before `await` resumes here —
    // writing to `state` after that throws UnmountedRefException.
    if (!ref.mounted) return;
    state = result;
  }

  Future<void> deleteItem(String id) async {
    await ref.read(adminRepositoryProvider).delete(_entity, id);
    await refresh();
  }
}

/// Real per-type content counts for the Dashboard — `null` for a type whose
/// fetch failed (shown as its own small empty/error state) rather than
/// treating "couldn't reach the server" the same as "zero items".
class AdminDashboardStats {
  const AdminDashboardStats({
    required this.workoutCount,
    required this.exerciseCount,
    required this.recipeCount,
    required this.articleCount,
    required this.challengeCount,
  });

  final int? workoutCount;
  final int? exerciseCount;
  final int? recipeCount;
  final int? articleCount;
  final int? challengeCount;

  static const loading = AdminDashboardStats(
    workoutCount: null,
    exerciseCount: null,
    recipeCount: null,
    articleCount: null,
    challengeCount: null,
  );
}

@riverpod
class AdminDashboardController extends _$AdminDashboardController {
  @override
  AdminDashboardStats build() {
    Future.microtask(refresh);
    return AdminDashboardStats.loading;
  }

  Future<void> refresh() async {
    final repo = ref.read(adminRepositoryProvider);
    Future<int?> count(AdminEntity entity) async {
      try {
        return (await repo.fetchAll(entity)).length;
      } catch (_) {
        return null;
      }
    }

    final counts = await Future.wait([
      count(AdminEntity.workout),
      count(AdminEntity.exercise),
      count(AdminEntity.recipe),
      count(AdminEntity.article),
      count(AdminEntity.challenge),
    ]);
    // The user may have navigated away from the Admin Dashboard while these
    // requests were in flight — this provider is autoDispose, so it can
    // already be torn down by the time `await` resumes here. Writing to
    // `state` after that throws UnmountedRefException instead of silently
    // no-op'ing, so this guard is required, not just defensive.
    if (!ref.mounted) return;
    state = AdminDashboardStats(
      workoutCount: counts[0],
      exerciseCount: counts[1],
      recipeCount: counts[2],
      articleCount: counts[3],
      challengeCount: counts[4],
    );
  }
}
