// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.

@ProviderFor(CurrentUserProfile)
final currentUserProfileProvider = CurrentUserProfileProvider._();

/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.
final class CurrentUserProfileProvider
    extends $NotifierProvider<CurrentUserProfile, UserProfile> {
  /// Loads the signed-in user's profile from the backend on first read.
  /// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
  /// consumer keeps working unchanged: it starts as [UserProfile.empty] and
  /// swaps in the real data — or stays empty on failure — once the fetch
  /// resolves, notifying listeners like any other state change.
  CurrentUserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserProfileHash();

  @$internal
  @override
  CurrentUserProfile create() => CurrentUserProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProfile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProfile>(value),
    );
  }
}

String _$currentUserProfileHash() =>
    r'54533bc819b40d307ff632b079b879ff130b25d2';

/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.

abstract class _$CurrentUserProfile extends $Notifier<UserProfile> {
  UserProfile build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<UserProfile, UserProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserProfile, UserProfile>,
              UserProfile,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(userDocuments)
final userDocumentsProvider = UserDocumentsProvider._();

final class UserDocumentsProvider
    extends
        $FunctionalProvider<
          List<DocumentItem>,
          List<DocumentItem>,
          List<DocumentItem>
        >
    with $Provider<List<DocumentItem>> {
  UserDocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userDocumentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userDocumentsHash();

  @$internal
  @override
  $ProviderElement<List<DocumentItem>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<DocumentItem> create(Ref ref) {
    return userDocuments(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DocumentItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DocumentItem>>(value),
    );
  }
}

String _$userDocumentsHash() => r'9c66ce656ea0cb1e20ef0141704a86820cadd036';
