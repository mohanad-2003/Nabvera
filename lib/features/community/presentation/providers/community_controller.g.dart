// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CommunityTabController)
final communityTabControllerProvider = CommunityTabControllerProvider._();

final class CommunityTabControllerProvider
    extends $NotifierProvider<CommunityTabController, CommunityTab> {
  CommunityTabControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityTabControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityTabControllerHash();

  @$internal
  @override
  CommunityTabController create() => CommunityTabController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CommunityTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CommunityTab>(value),
    );
  }
}

String _$communityTabControllerHash() =>
    r'c72ac38b235f539e1e69eaa07636dda2f0236c9f';

abstract class _$CommunityTabController extends $Notifier<CommunityTab> {
  CommunityTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CommunityTab, CommunityTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CommunityTab, CommunityTab>,
              CommunityTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Lolads `/api/challenges` for the Community "Challenges" tab.

@ProviderFor(CommunityChallenges)
final communityChallengesProvider = CommunityChallengesProvider._();

/// Lolads `/api/challenges` for the Community "Challenges" tab.
final class CommunityChallengesProvider
    extends $NotifierProvider<CommunityChallenges, List<ChallengeItem>> {
  /// Lolads `/api/challenges` for the Community "Challenges" tab.
  CommunityChallengesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityChallengesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityChallengesHash();

  @$internal
  @override
  CommunityChallenges create() => CommunityChallenges();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChallengeItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChallengeItem>>(value),
    );
  }
}

String _$communityChallengesHash() =>
    r'aa86f6f2d411f58780b2c3e29a8dcfbd7abe3e48';

/// Lolads `/api/challenges` for the Community "Challenges" tab.

abstract class _$CommunityChallenges extends $Notifier<List<ChallengeItem>> {
  List<ChallengeItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ChallengeItem>, List<ChallengeItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChallengeItem>, List<ChallengeItem>>,
              List<ChallengeItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads the real community feed from `/api/posts`.

@ProviderFor(CommunityForums)
final communityForumsProvider = CommunityForumsProvider._();

/// Loads the real community feed from `/api/posts`.
final class CommunityForumsProvider
    extends $NotifierProvider<CommunityForums, List<ForumThread>> {
  /// Loads the real community feed from `/api/posts`.
  CommunityForumsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'communityForumsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$communityForumsHash();

  @$internal
  @override
  CommunityForums create() => CommunityForums();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ForumThread> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ForumThread>>(value),
    );
  }
}

String _$communityForumsHash() => r'5c23e002e3fc4e1110bbbe2c8029c6d1b9ddebae';

/// Loads the real community feed from `/api/posts`.

abstract class _$CommunityForums extends $Notifier<List<ForumThread>> {
  List<ForumThread> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ForumThread>, List<ForumThread>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ForumThread>, List<ForumThread>>,
              List<ForumThread>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/challenges/suggested` — up to two rule-based suggestions for
/// the current user's "Suggested for you" section.

@ProviderFor(SuggestedChallenges)
final suggestedChallengesProvider = SuggestedChallengesProvider._();

/// Loads `/api/challenges/suggested` — up to two rule-based suggestions for
/// the current user's "Suggested for you" section.
final class SuggestedChallengesProvider
    extends $NotifierProvider<SuggestedChallenges, List<ChallengeSuggestion>> {
  /// Loads `/api/challenges/suggested` — up to two rule-based suggestions for
  /// the current user's "Suggested for you" section.
  SuggestedChallengesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suggestedChallengesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suggestedChallengesHash();

  @$internal
  @override
  SuggestedChallenges create() => SuggestedChallenges();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChallengeSuggestion> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChallengeSuggestion>>(value),
    );
  }
}

String _$suggestedChallengesHash() =>
    r'f1b87922ac6fe55562a21fd064e69d411e17e357';

/// Loads `/api/challenges/suggested` — up to two rule-based suggestions for
/// the current user's "Suggested for you" section.

abstract class _$SuggestedChallenges
    extends $Notifier<List<ChallengeSuggestion>> {
  List<ChallengeSuggestion> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<List<ChallengeSuggestion>, List<ChallengeSuggestion>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ChallengeSuggestion>, List<ChallengeSuggestion>>,
              List<ChallengeSuggestion>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/challenges/my` — the current user's own challenge progress
/// (active, completed, abandoned, expired) — and owns join/leave, which
/// always re-syncs both this and [SuggestedChallenges] afterward so a
/// just-joined challenge disappears from "Suggested" and appears under
/// "My active challenges" without a manual refresh.

@ProviderFor(MyChallenges)
final myChallengesProvider = MyChallengesProvider._();

/// Loads `/api/challenges/my` — the current user's own challenge progress
/// (active, completed, abandoned, expired) — and owns join/leave, which
/// always re-syncs both this and [SuggestedChallenges] afterward so a
/// just-joined challenge disappears from "Suggested" and appears under
/// "My active challenges" without a manual refresh.
final class MyChallengesProvider
    extends $NotifierProvider<MyChallenges, List<ChallengeProgressItem>> {
  /// Loads `/api/challenges/my` — the current user's own challenge progress
  /// (active, completed, abandoned, expired) — and owns join/leave, which
  /// always re-syncs both this and [SuggestedChallenges] afterward so a
  /// just-joined challenge disappears from "Suggested" and appears under
  /// "My active challenges" without a manual refresh.
  MyChallengesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myChallengesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myChallengesHash();

  @$internal
  @override
  MyChallenges create() => MyChallenges();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ChallengeProgressItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ChallengeProgressItem>>(value),
    );
  }
}

String _$myChallengesHash() => r'2f96a7a00a779051cb31893589424dacde77368e';

/// Loads `/api/challenges/my` — the current user's own challenge progress
/// (active, completed, abandoned, expired) — and owns join/leave, which
/// always re-syncs both this and [SuggestedChallenges] afterward so a
/// just-joined challenge disappears from "Suggested" and appears under
/// "My active challenges" without a manual refresh.

abstract class _$MyChallenges extends $Notifier<List<ChallengeProgressItem>> {
  List<ChallengeProgressItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<List<ChallengeProgressItem>, List<ChallengeProgressItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<ChallengeProgressItem>,
                List<ChallengeProgressItem>
              >,
              List<ChallengeProgressItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Loads `/api/posts/:id/comments` for one thread.

@ProviderFor(ForumComments)
final forumCommentsProvider = ForumCommentsFamily._();

/// Loads `/api/posts/:id/comments` for one thread.
final class ForumCommentsProvider
    extends $NotifierProvider<ForumComments, List<ForumComment>> {
  /// Loads `/api/posts/:id/comments` for one thread.
  ForumCommentsProvider._({
    required ForumCommentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'forumCommentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$forumCommentsHash();

  @override
  String toString() {
    return r'forumCommentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ForumComments create() => ForumComments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ForumComment> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ForumComment>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ForumCommentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$forumCommentsHash() => r'9dc16b3d3d541d3fd27895f5ba9a105f4cd83757';

/// Loads `/api/posts/:id/comments` for one thread.

final class ForumCommentsFamily extends $Family
    with
        $ClassFamilyOverride<
          ForumComments,
          List<ForumComment>,
          List<ForumComment>,
          List<ForumComment>,
          String
        > {
  ForumCommentsFamily._()
    : super(
        retry: null,
        name: r'forumCommentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Loads `/api/posts/:id/comments` for one thread.

  ForumCommentsProvider call(String postId) =>
      ForumCommentsProvider._(argument: postId, from: this);

  @override
  String toString() => r'forumCommentsProvider';
}

/// Loads `/api/posts/:id/comments` for one thread.

abstract class _$ForumComments extends $Notifier<List<ForumComment>> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  List<ForumComment> build(String postId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ForumComment>, List<ForumComment>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ForumComment>, List<ForumComment>>,
              List<ForumComment>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
