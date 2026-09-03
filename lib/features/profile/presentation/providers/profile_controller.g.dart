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
///
/// `keepAlive: true` is load-bearing, not just an optimization: this is
/// also where `adminRouteGuard` reads `role` from on every navigation
/// (see `app_router.dart`). Left as the default autoDispose, this provider
/// would tear itself down the moment nothing currently on screen watches
/// it (e.g. switching between Admin console tabs, none of which watch
/// profile) and reset to `UserProfile.empty` — an admin's own `role` would
/// momentarily read back as `'user'` mid-navigation and the guard would
/// wrongly bounce them to the unauthorized page.

@ProviderFor(CurrentUserProfile)
final currentUserProfileProvider = CurrentUserProfileProvider._();

/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.
///
/// `keepAlive: true` is load-bearing, not just an optimization: this is
/// also where `adminRouteGuard` reads `role` from on every navigation
/// (see `app_router.dart`). Left as the default autoDispose, this provider
/// would tear itself down the moment nothing currently on screen watches
/// it (e.g. switching between Admin console tabs, none of which watch
/// profile) and reset to `UserProfile.empty` — an admin's own `role` would
/// momentarily read back as `'user'` mid-navigation and the guard would
/// wrongly bounce them to the unauthorized page.
final class CurrentUserProfileProvider
    extends $NotifierProvider<CurrentUserProfile, UserProfile> {
  /// Loads the signed-in user's profile from the backend on first read.
  /// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
  /// consumer keeps working unchanged: it starts as [UserProfile.empty] and
  /// swaps in the real data — or stays empty on failure — once the fetch
  /// resolves, notifying listeners like any other state change.
  ///
  /// `keepAlive: true` is load-bearing, not just an optimization: this is
  /// also where `adminRouteGuard` reads `role` from on every navigation
  /// (see `app_router.dart`). Left as the default autoDispose, this provider
  /// would tear itself down the moment nothing currently on screen watches
  /// it (e.g. switching between Admin console tabs, none of which watch
  /// profile) and reset to `UserProfile.empty` — an admin's own `role` would
  /// momentarily read back as `'user'` mid-navigation and the guard would
  /// wrongly bounce them to the unauthorized page.
  CurrentUserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProfileProvider',
        isAutoDispose: false,
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
    r'084a9b7ce8105aeffb96ab2b8e708c4f05235735';

/// Loads the signed-in user's profile from the backend on first read.
/// Exposes a plain [UserProfile] (not `AsyncValue`) so every existing
/// consumer keeps working unchanged: it starts as [UserProfile.empty] and
/// swaps in the real data — or stays empty on failure — once the fetch
/// resolves, notifying listeners like any other state change.
///
/// `keepAlive: true` is load-bearing, not just an optimization: this is
/// also where `adminRouteGuard` reads `role` from on every navigation
/// (see `app_router.dart`). Left as the default autoDispose, this provider
/// would tear itself down the moment nothing currently on screen watches
/// it (e.g. switching between Admin console tabs, none of which watch
/// profile) and reset to `UserProfile.empty` — an admin's own `role` would
/// momentarily read back as `'user'` mid-navigation and the guard would
/// wrongly bounce them to the unauthorized page.

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
