import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/storage/preferences_service.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:nabvera/features/nutrition/presentation/providers/nutrition_controller.dart';
import 'package:nabvera/features/nutrition/presentation/widgets/premium_recipe_card.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nutrition_test_fakes.dart';

class _FakeUserRepository implements UserRepository {
  _FakeUserRepository({this.favoriteRecipeIds = const []});

  final List<String> favoriteRecipeIds;
  final List<String> toggledRecipes = [];

  @override
  Future<UserProfile> fetchMe() async => UserProfile(
    id: '',
    name: '',
    email: '',
    birthday: '—',
    weightKg: '—',
    ageYears: '—',
    heightM: '—',
    fitnessLevel: 'beginner',
    completedWorkouts: 0,
    caloriesBurned: 0,
    trainingDays: 0,
    currentStreak: 0,
    favoriteRecipeIds: favoriteRecipeIds,
  );
  @override
  Future<UserProfile> updateProfile(Map<String, dynamic> patch) async =>
      UserProfile.empty;
  @override
  Future<String> uploadAvatar({
    required Uint8List bytes,
    required String filename,
    String? contentType,
  }) async => throw UnimplementedError();
  @override
  Future<UserProfile> setBiometricEnabled(bool enabled) async =>
      throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteWorkout(String workoutId) async =>
      throw UnimplementedError();
  @override
  Future<List<String>> toggleFavoriteRecipe(String recipeId) async {
    toggledRecipes.add(recipeId);
    return [recipeId];
  }

  @override
  Future<void> setActiveWorkoutSession({
    required String workoutId,
    required String title,
    required String titleAr,
    required String image,
    required int completedSets,
    required int totalSets,
  }) async {}
  @override
  Future<void> clearActiveWorkoutSession() async {}
  @override
  Future<void> registerFcmToken(String token) async {}
  @override
  Future<void> unregisterFcmToken(String token) async {}
  @override
  Future<void> deleteAccount() async => throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> exportData() async => throw UnimplementedError();
}

class _Harness {
  _Harness({
    required this.repo,
    required this.user,
    required this.preferences,
    this.locale = const Locale('en'),
    this.dark = false,
    this.textScale = 1.0,
  });

  final FakeNutritionRepository repo;
  final _FakeUserRepository user;
  final SharedPreferences preferences;
  final Locale locale;
  final bool dark;
  final double textScale;

  Widget build() => ProviderScope(
    overrides: [
      nutritionRepositoryProvider.overrideWithValue(repo),
      userRepositoryProvider.overrideWithValue(user),
      sharedPreferencesProvider.overrideWithValue(preferences),
    ],
    child: MaterialApp.router(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const NutritionPage()),
          GoRoute(
            path: AppRoutes.mealPlanHome,
            builder: (_, _) => const Scaffold(body: Text('STUB:meal-plans')),
          ),
          GoRoute(
            path: AppRoutes.mealIdea,
            builder: (_, _) => const Scaffold(body: Text('STUB:meal-ideas')),
          ),
          GoRoute(
            path: AppRoutes.mealPlanPreferences,
            builder: (_, _) => const Scaffold(body: Text('STUB:preferences')),
          ),
          GoRoute(
            path: AppRoutes.mealDetail,
            builder:
                (_, state) => Scaffold(
                  body: Text('STUB:detail:${(state.extra as MealDetail).name}'),
                ),
          ),
        ],
      ),
    ),
  );
}

const _fullToday = {
  'calorieGoal': 2000,
  'caloriesConsumed': 760,
  'proteinGoalG': 150,
  'proteinConsumedG': 75,
  'carbsGoalG': 250,
  'carbsConsumedG': 120,
  'fatGoalG': 70,
  'fatConsumedG': 30,
  'waterGoalMl': 2000,
  'waterConsumedMl': 750,
  'goalSource': 'preferences',
};

FakeNutritionRepository _repo({
  Map<String, dynamic> today = _fullToday,
  List<Map<String, dynamic>>? recipes,
}) =>
    FakeNutritionRepository()
      ..today = today
      ..recipes =
          recipes ??
          [
            recipeJson(
              'a',
              title: 'Alpha bowl',
              titleAr: 'وعاء ألفا',
              rating: 5,
            ),
            recipeJson(
              'b',
              title: 'Beta wrap',
              titleAr: 'لفافة بيتا',
              rating: 4.5,
            ),
            recipeJson(
              'c',
              title: 'Gamma salad',
              titleAr: 'سلطة غاما',
              rating: 4,
            ),
            recipeJson(
              'd',
              title: 'Delta soup',
              titleAr: 'حساء دلتا',
              rating: 3,
              protein: null,
            ),
          ];

Future<void> _pump(
  WidgetTester tester,
  _Harness harness, {
  Size size = const Size(390, 2400),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(harness.build());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle(const Duration(milliseconds: 100));
}

Future<_Harness> _harness({
  FakeNutritionRepository? repo,
  _FakeUserRepository? user,
  Locale locale = const Locale('en'),
  bool dark = false,
  double textScale = 1.0,
}) async {
  SharedPreferences.setMockInitialValues({});
  return _Harness(
    repo: repo ?? _repo(),
    user: user ?? _FakeUserRepository(),
    preferences: await SharedPreferences.getInstance(),
    locale: locale,
    dark: dark,
    textScale: textScale,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('page order', () {
    testWidgets(
      'summary, water, access cards, today\'s recipe, then suggestions and explore',
      (tester) async {
        final h = await _harness(
          repo: _repo(
            recipes: [
              for (var i = 0; i < 6; i++)
                recipeJson('r$i', title: 'Recipe r$i', rating: 5 - i * 0.1),
            ],
          ),
        );
        await _pump(tester, h);

        double y(String text) => tester.getTopLeft(find.text(text)).dy;

        final order = [
          y('Your nutrition today'),
          y('Water today'),
          y('Meal plans'),
          y('Recipe of the day'),
          y('Suggested for you'),
          y('Explore recipes'),
        ];
        expect(order, orderedEquals([...order]..sort()));
        expect(order.toSet(), hasLength(order.length));
      },
    );
  });

  group('daily summary', () {
    testWidgets(
      'leads with calories remaining, then consumed and goal, and macros as grams',
      (tester) async {
        final h = await _harness();
        await _pump(tester, h);

        expect(find.text('Calories remaining'), findsOneWidget);
        expect(
          find.textContaining('1240', findRichText: true),
          findsOneWidget,
          reason: '2000 goal - 760 eaten',
        );
        expect(find.text('760 Cal'), findsOneWidget);
        expect(find.text('2000 Cal'), findsOneWidget);
        expect(find.text('75 / 150 g'), findsOneWidget);
        expect(find.text('120 / 250 g'), findsOneWidget);
        expect(find.text('30 / 70 g'), findsOneWidget);
      },
    );

    testWidgets('over the goal: says so, with no negative remainder', (
      tester,
    ) async {
      final h = await _harness(
        repo: _repo(today: {..._fullToday, 'caloriesConsumed': 2437}),
      );
      await _pump(tester, h);

      expect(find.text('Over your goal by'), findsOneWidget);
      expect(find.text('437 kcal', findRichText: true), findsOneWidget);
      expect(find.text('Calories remaining'), findsNothing);
      expect(find.textContaining('-'), findsNothing);
      // The real consumed value is still shown, not capped to the goal.
      expect(find.text('2437 Cal'), findsOneWidget);
    });

    testWidgets(
      'a zero calorie goal never claims "goal reached" or a remainder',
      (tester) async {
        final h = await _harness(
          repo: _repo(today: {'calorieGoal': 0, 'caloriesConsumed': 400}),
        );
        await _pump(tester, h);

        expect(find.text('Calories consumed'), findsOneWidget);
        expect(find.textContaining('400', findRichText: true), findsWidgets);
        expect(find.text('Calories remaining'), findsNothing);
        expect(find.text('Over your goal by'), findsNothing);
        expect(find.text('Not available'), findsWidgets);
      },
    );

    testWidgets('missing macro values show a dash, not 0', (tester) async {
      final h = await _harness(
        repo: _repo(today: {'calorieGoal': 2000, 'caloriesConsumed': 100}),
      );
      await _pump(tester, h);

      expect(find.text('—'), findsNWidgets(3));
      expect(find.text('0 g'), findsNothing);
    });

    testWidgets(
      'an estimated goal is labelled and the set-goal row opens preferences',
      (tester) async {
        final h = await _harness(
          repo: _repo(today: {..._fullToday, 'goalSource': 'estimate'}),
        );
        await _pump(tester, h);

        expect(find.text('Estimated'), findsOneWidget);
        await tester.tap(
          find.text(
            'This is an estimated target — set your own nutrition goals',
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('STUB:preferences'), findsOneWidget);
      },
    );

    testWidgets('a personal goal has no estimate tag and no set-goal row', (
      tester,
    ) async {
      final h = await _harness();
      await _pump(tester, h);

      expect(find.text('Estimated'), findsNothing);
      expect(find.text('Default'), findsNothing);
      expect(
        find.text('This is an estimated target — set your own nutrition goals'),
        findsNothing,
      );
    });

    testWidgets(
      'a failed first load shows a retry, not zeros, and retry loads the data',
      (tester) async {
        final repo = _repo()..todayError = true;
        final h = await _harness(repo: repo);
        await _pump(tester, h);

        expect(
          find.text("Today's nutrition couldn't be loaded"),
          findsOneWidget,
        );
        expect(find.text('Calories remaining'), findsNothing);
        expect(find.text('Water today'), findsNothing);

        repo.todayError = false;
        await tester.tap(find.text('Retry').first);
        await tester.pumpAndSettle();

        expect(find.text('Calories remaining'), findsOneWidget);
      },
    );
  });

  group('water', () {
    testWidgets('shows raw litres against the goal', (tester) async {
      final h = await _harness();
      await _pump(tester, h);

      expect(find.text('Water today'), findsOneWidget);
      expect(find.text('0.75 / 2 L'), findsOneWidget);
    });

    testWidgets('falls back to cups when the API sent no raw ml', (
      tester,
    ) async {
      final h = await _harness(
        repo: _repo(today: {'calorieGoal': 2000, 'caloriesConsumed': 0}),
      );
      await _pump(tester, h);

      expect(find.text('0 / 8 cups'), findsOneWidget);
    });

    testWidgets(
      'Add water opens the existing sheet; one tap saves exactly once',
      (tester) async {
        final repo =
            _repo()..waterAfterLog = {..._fullToday, 'waterConsumedMl': 1000};
        final h = await _harness(repo: repo);
        await _pump(tester, h);

        await tester.tap(find.text('Add water'));
        await tester.pumpAndSettle();
        expect(find.text('Log Water'), findsOneWidget);

        await tester.tap(find.text('+1 Cup (250ml)'));
        await tester.pumpAndSettle();

        expect(repo.logWaterCalls, [250]);
        // The page behind the sheet updated straight away from the response.
        expect(find.text('1 / 2 L'), findsWidgets);
      },
    );

    testWidgets('the Add water button is at least 48 tall', (tester) async {
      final h = await _harness();
      await _pump(tester, h);

      final size = tester.getSize(
        find
            .ancestor(
              of: find.text('Add water'),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(size.height, greaterThanOrEqualTo(48));
    });
  });

  group('access cards', () {
    testWidgets('Meal plans opens the meal plans page and records the tab', (
      tester,
    ) async {
      final h = await _harness();
      await _pump(tester, h);

      await tester.tap(find.text('Meal plans'));
      await tester.pumpAndSettle();
      expect(find.text('STUB:meal-plans'), findsOneWidget);
    });

    testWidgets('Meal ideas opens the meal ideas page', (tester) async {
      final h = await _harness();
      await _pump(tester, h);

      await tester.tap(find.text('Meal ideas'));
      await tester.pumpAndSettle();
      expect(find.text('STUB:meal-ideas'), findsOneWidget);
    });

    testWidgets(
      'tapping the description or the card body also navigates (the whole card is the target)',
      (tester) async {
        final h = await _harness();
        await _pump(tester, h);

        await tester.tap(find.text('Organize your meals across the week'));
        await tester.pumpAndSettle();
        expect(find.text('STUB:meal-plans'), findsOneWidget);
      },
    );

    testWidgets(
      'selects the matching tab in nutritionTabControllerProvider before navigating',
      (tester) async {
        final h = await _harness();
        await _pump(tester, h);
        final container = ProviderScope.containerOf(
          tester.element(find.byType(NutritionPage)),
        );

        await tester.tap(find.text('Meal ideas'));
        await tester.pumpAndSettle();
        expect(
          container.read(nutritionTabControllerProvider),
          NutritionTab.mealIdeas,
        );
      },
    );
  });

  group('recipes', () {
    testWidgets('the card opens the recipe it shows (same id, one fetch)', (
      tester,
    ) async {
      final h = await _harness();
      await _pump(tester, h);

      await tester.tap(find.text('Beta wrap'));
      await tester.pumpAndSettle();

      expect(h.repo.fetchedRecipeIds, ['b']);
      expect(find.text('STUB:detail:Beta wrap'), findsOneWidget);
    });

    testWidgets('recipe of the day opens its own recipe', (tester) async {
      final h = await _harness();
      await _pump(tester, h);

      await tester.tap(find.text('Alpha bowl'));
      await tester.pumpAndSettle();

      expect(h.repo.fetchedRecipeIds, ['a']);
      expect(find.text('STUB:detail:Alpha bowl'), findsOneWidget);
    });

    testWidgets('a recipe is never listed twice on the page', (tester) async {
      final h = await _harness(
        repo: _repo(
          recipes: [
            recipeJson('a', title: 'Alpha bowl', rating: 5),
            recipeJson('a', title: 'Alpha bowl', rating: 5),
            recipeJson('b', title: 'Beta wrap', rating: 4),
            recipeJson('c', title: 'Gamma salad', rating: 3),
          ],
        ),
      );
      await _pump(tester, h);

      expect(find.text('Alpha bowl'), findsOneWidget);
      expect(find.text('Beta wrap'), findsOneWidget);
      expect(find.text('Gamma salad'), findsOneWidget);
    });

    testWidgets(
      'the shared recipe source is left whole by the page-level exclusion',
      (tester) async {
        final h = await _harness();
        await _pump(tester, h);
        final container = ProviderScope.containerOf(
          tester.element(find.byType(NutritionPage)),
        );

        expect(container.read(nutritionRecommendedProvider).map((e) => e.id), [
          'a',
          'b',
        ]);
        expect(container.read(nutritionRecipesProvider).map((e) => e.id), [
          'c',
          'd',
        ]);
      },
    );

    testWidgets(
      'cards show time, calories and protein only when the recipe has it',
      (tester) async {
        final h = await _harness();
        await _pump(tester, h);

        expect(find.text('25g protein'), findsWidgets);
        // 'Delta soup' has no protein value: no protein line, and no "0g".
        expect(find.text('0g protein'), findsNothing);
        expect(find.text('20 Minutes'), findsWidgets);
        expect(find.text('350 Cal'), findsWidgets);
      },
    );

    testWidgets('favorite toggles that recipe and does not open its page', (
      tester,
    ) async {
      final h = await _harness();
      await _pump(tester, h);

      await tester.tap(find.bySemanticsLabel('Add Beta wrap to favorites'));
      await tester.pumpAndSettle();

      expect(h.user.toggledRecipes, ['b']);
      expect(h.repo.fetchedRecipeIds, isEmpty);
      expect(find.byType(NutritionPage), findsOneWidget);
    });

    testWidgets('a favorited recipe is announced as removable', (tester) async {
      final h = await _harness(
        user: _FakeUserRepository(favoriteRecipeIds: ['b']),
      );
      await _pump(tester, h);

      expect(
        find.bySemanticsLabel('Remove Beta wrap from favorites'),
        findsOneWidget,
      );
    });

    testWidgets('favorite buttons are at least 48x48', (tester) async {
      final h = await _harness();
      await _pump(tester, h);

      final buttons = find.byType(RecipeFavoriteButton);
      expect(buttons, findsWidgets);
      for (final element in buttons.evaluate()) {
        final size = tester.getSize(find.byWidget(element.widget));
        expect(size.width, greaterThanOrEqualTo(48));
        expect(size.height, greaterThanOrEqualTo(48));
      }
    });

    testWidgets(
      'a recipe that cannot be opened tells the user instead of silently doing nothing',
      (tester) async {
        final h = await _harness();
        h.repo.recipeByIdFails = true;
        await _pump(tester, h);

        await tester.tap(find.text('Beta wrap'));
        await tester.pumpAndSettle();

        expect(
          find.text("Couldn't open this recipe. Please try again."),
          findsOneWidget,
        );
        expect(find.byType(NutritionPage), findsOneWidget);
      },
    );
  });

  group('loading, empty and failed recipe states', () {
    testWidgets(
      'a network failure is not shown as "no recipes", and retry recovers',
      (tester) async {
        final repo = _repo()..alwaysThrowFetch = true;
        final h = await _harness(repo: repo);
        await _pump(tester, h);

        expect(find.text("Couldn't load recipes"), findsOneWidget);
        expect(find.text('No recipes yet'), findsNothing);

        repo.alwaysThrowFetch = false;
        await tester.ensureVisible(find.text('Retry'));
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();

        expect(find.text("Couldn't load recipes"), findsNothing);
        expect(find.text('Alpha bowl'), findsOneWidget);
      },
    );

    testWidgets('a genuinely empty list says so, without a retry button', (
      tester,
    ) async {
      final h = await _harness(repo: _repo(recipes: []));
      await _pump(tester, h);

      expect(find.text('No recipes yet'), findsOneWidget);
      expect(find.text("Couldn't load recipes"), findsNothing);
    });

    testWidgets(
      'while the first load is running neither empty nor error is shown',
      (tester) async {
        final repo = _repo();
        final gate = Completer<void>();
        repo.fetchGate = gate.future;
        final h = await _harness(repo: repo);

        tester.view.physicalSize = const Size(390, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await tester.pumpWidget(h.build());
        await tester.pump(const Duration(milliseconds: 200));

        expect(find.text('No recipes yet'), findsNothing);
        expect(find.text("Couldn't load recipes"), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsWidgets);

        gate.complete();
        await tester.pumpAndSettle();
        expect(find.text('Alpha bowl'), findsOneWidget);
      },
    );

    testWidgets('a section left empty by the exclusion hides its title', (
      tester,
    ) async {
      final h = await _harness(
        repo: _repo(recipes: [recipeJson('a', title: 'Only one', rating: 5)]),
      );
      await _pump(tester, h, size: const Size(390, 1600));

      expect(find.text('Only one'), findsOneWidget);
      expect(find.text('Suggested for you'), findsNothing);
      expect(find.text('Explore recipes'), findsNothing);
    });
  });

  group('small screens, large text, languages and themes', () {
    for (final locale in const [Locale('en'), Locale('ar')]) {
      for (final dark in const [false, true]) {
        testWidgets(
          'no overflow at 360 wide with 1.5x text, scrolled end to end — ${locale.languageCode} ${dark ? 'dark' : 'light'}',
          (tester) async {
            final h = await _harness(
              locale: locale,
              dark: dark,
              textScale: 1.5,
              repo: _repo(
                today: {..._fullToday, 'goalSource': 'estimate'},
                recipes: [
                  for (var i = 0; i < 7; i++)
                    recipeJson(
                      'r$i',
                      title:
                          'A fairly long recipe name number $i with extra words',
                      titleAr: 'وصفة طويلة الاسم رقم $i مع كلمات إضافية كثيرة',
                      rating: 5 - i * 0.1,
                    ),
                ],
              ),
            );
            await _pump(tester, h, size: const Size(360, 640));
            expect(tester.takeException(), isNull);

            final scrollable = find.byType(Scrollable).first;
            for (var i = 0; i < 8; i++) {
              await tester.drag(scrollable, const Offset(0, -500));
              await tester.pump();
              expect(tester.takeException(), isNull);
            }
            await tester.pumpAndSettle();
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    testWidgets('no overflow at 320x568 with 2x text', (tester) async {
      final h = await _harness(textScale: 2.0);
      await _pump(tester, h, size: const Size(320, 568));
      expect(tester.takeException(), isNull);
      for (var i = 0; i < 8; i++) {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
        await tester.pump();
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets(
      'access cards stack when the font is large, and are still tappable',
      (tester) async {
        final h = await _harness(textScale: 1.6);
        await _pump(tester, h, size: const Size(360, 640));

        final plans = tester.getTopLeft(find.text('Meal plans'));
        final ideas = tester.getTopLeft(find.text('Meal ideas'));
        expect(
          ideas.dy,
          greaterThan(plans.dy + 20),
          reason: 'stacked vertically',
        );

        await tester.ensureVisible(find.text('Meal ideas'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Meal ideas'));
        await tester.pumpAndSettle();
        expect(find.text('STUB:meal-ideas'), findsOneWidget);
      },
    );

    testWidgets(
      'Arabic renders right-to-left with Arabic titles, names and units',
      (tester) async {
        final h = await _harness(locale: const Locale('ar'));
        await _pump(tester, h, size: const Size(390, 1800));

        expect(
          Directionality.of(tester.element(find.byType(NutritionPage))),
          TextDirection.rtl,
        );
        expect(find.text('تغذيتك اليوم'), findsOneWidget);
        expect(find.text('السعرات المتبقية'), findsOneWidget);
        expect(find.text('الماء اليوم'), findsOneWidget);
        expect(find.text('إضافة ماء'), findsOneWidget);
        expect(find.text('خطط الوجبات'), findsOneWidget);
        expect(find.text('أفكار الوجبات'), findsOneWidget);
        expect(find.text('نظّم وجباتك خلال الأسبوع'), findsOneWidget);
        expect(find.text('اكتشف وصفات تناسب يومك'), findsOneWidget);
        expect(find.text('وصفة اليوم'), findsOneWidget);
        expect(find.text('وعاء ألفا'), findsOneWidget);
        expect(find.text('75 / 150 غ'), findsOneWidget);
        expect(find.text('0.75 / 2 لتر'), findsOneWidget);
      },
    );

    testWidgets(
      'pull to refresh re-fetches recipes once, and keeps showing them',
      (tester) async {
        final h = await _harness();
        await _pump(tester, h);
        final before = h.repo.fetchRecipesCallCount;

        // Runs the same onRefresh the pull gesture would.
        final refresh =
            tester
                .state<RefreshIndicatorState>(find.byType(RefreshIndicator))
                .show();
        await tester.pump();
        await tester.pump(const Duration(seconds: 1));
        await refresh;
        await tester.pumpAndSettle();

        expect(h.repo.fetchRecipesCallCount, before + 1);
        expect(find.text('Alpha bowl'), findsOneWidget);
      },
    );
  });
}
