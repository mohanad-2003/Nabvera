import 'package:fitness_app/features/profile/data/user_repository.dart';
import 'package:fitness_app/features/profile/domain/profile_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_controller.g.dart';

/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.
@riverpod
class CurrentUserProfile extends _$CurrentUserProfile {
  @override
  UserProfile build() {
    Future.microtask(refresh);
    return UserProfile.empty;
  }

  Future<void> refresh() async {
    try {
      state = await ref.read(userRepositoryProvider).fetchMe();
    } catch (_) {
      // Left at the previous (or empty) state — pages render their empty
      // placeholders rather than crashing when the backend is unreachable.
    }
  }

  Future<void> update(Map<String, dynamic> patch) async {
    state = await ref.read(userRepositoryProvider).updateProfile(patch);
  }
}

@riverpod
List<DocumentItem> userDocuments(Ref ref) => const [
  DocumentItem(
    title: 'Document 1',
    description: 'Description or details of document 1',
  ),
  DocumentItem(
    title: 'Document 2',
    description: 'Description or details of document 2',
  ),
  DocumentItem(
    title: 'Document 3',
    description: 'Description or details of document 3',
  ),
  DocumentItem(
    title: 'Document 4',
    description: 'Description or details of document 4',
  ),
  DocumentItem(
    title: 'Document 5',
    description: 'Description or details of document 5',
  ),
];
