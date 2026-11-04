import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/routing/app_routes.dart';
import 'package:nabvera/core/theme/app_theme.dart';
import 'package:nabvera/features/nutrition/data/nutrition_repository.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_plan_generating_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_plan_home_page.dart';

import 'nutrition_test_fakes.dart';

Map<String, dynamic> _plan(String id, String breakfastName) => {
  '_id': id,
  'isActive': true,
  'weekStartDate': '2026-09-06T00:00:00.000Z',
  'goal': 'keep_fit',
  'calorieTarget': 2000,
  'proteinTargetGrams': 150,
  'servings': 1,
  'cookingTimePreference': 'standard',
  'generationSource': 'ai',
  'days': List.generate(
    7,
    (i) => {
      'dayIndex': i,
      'meals': {
        'breakfast': [
          {
            '_id': '$id-$i',
            'mealType': 'breakfast',
            'recipe': null,
            'isCustom': true,
            'customName': '$breakfastName $i',
            'servings': 1,
            'calories': 300,
            'proteinG': 20,
            'carbsG': 30,
            'fatG': 10,
            'explanationCode': 'recipe_unavailable_placeholder',
          },
        ],
        'lunch': [],
        'dinner': [],
        'snacks': [],
      },
      'dayExplanationCode': null,
    },
  ),
  'shoppingList': [],
  'disclaimerCode': 'general_nutrition_disclaimer',
};

class _NoopAnalytics implements AnalyticsService {
  @override
  Future<void> logEvent(
    AnalyticsEvent event, [
    Map<String, dynamic> properties = const {},
    String? dedupeKey,
  ]) async {}
}

class _PlanRepo extends FakeNutritionRepository {
  Map<String, dynamic> current = _plan('A', 'Old dish');
  Map<String, dynamic> generated = _plan('B', 'New dish');
  int generateCalls = 0;

  @override
  Future<Map<String, dynamic>?> fetchCurrentMealPlan() async => current;

  @override
  Future<Map<String, dynamic>> generateMealPlan([
    Map<String, dynamic> overrides = const {},
  ]) async {
    generateCalls++;
    current = generated;
    return generated;
  }
}

void main() {
  testWidgets('regenerating a plan shows the newly generated plan', (tester) async {
    final repo = _PlanRepo();
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(repo),
          analyticsServiceProvider.overrideWithValue(_NoopAnalytics()),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            initialLocation: AppRoutes.mealPlanHome,
            routes: [
              GoRoute(
                path: AppRoutes.mealPlanHome,
                builder: (_, _) => const MealPlanHomePage(),
              ),
              GoRoute(
                path: AppRoutes.mealPlanGenerating,
                builder: (_, _) => const MealPlanGeneratingPage(),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Old dish 0'), findsOneWidget);

    await tester.tap(find.byTooltip('Generate new plan'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Generate new plan'));
    await tester.pumpAndSettle();

    expect(repo.generateCalls, 1);
    expect(find.text('New dish 0'), findsOneWidget);
    expect(find.text('Old dish 0'), findsNothing);
  });
}
