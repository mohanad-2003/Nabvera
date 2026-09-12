import 'package:nabvera/core/routing/admin_route_guard.dart';
import 'package:nabvera/core/routing/password_reset_redirect.dart';
import 'package:nabvera/core/widgets/app_bottom_nav.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_article_editor_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_articles_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_challenge_editor_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_challenges_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_dashboard_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_exercise_editor_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_exercises_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_more_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_profile_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_recipe_editor_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_recipes_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_unauthorized_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_workout_editor_page.dart';
import 'package:nabvera/features/admin/presentation/pages/admin_workouts_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/biometric_unlock_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/finger_print_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/login_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/onboarding_carousel_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/signup_page.dart';
import 'package:nabvera/features/authentication/presentation/pages/splash_page.dart';
import 'package:nabvera/features/community/domain/community_models.dart';
import 'package:nabvera/features/community/presentation/pages/challenge_page.dart';
import 'package:nabvera/features/community/presentation/pages/community_page.dart';
import 'package:nabvera/features/favorite/presentation/pages/favorite_page.dart';
import 'package:nabvera/features/home/domain/home_models.dart';
import 'package:nabvera/features/home/presentation/pages/article_detail_page.dart';
import 'package:nabvera/features/home/presentation/pages/home_page.dart';
import 'package:nabvera/features/notification/presentation/pages/notification_page.dart';
import 'package:nabvera/features/nutrition/domain/nutrition_models.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_detail_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_idea_discover_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_idea_page.dart';
import 'package:nabvera/features/health/presentation/pages/health_connection_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_plan_generating_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_plan_history_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_plan_home_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/meal_plan_shopping_list_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/nutrition_preferences_page.dart';
import 'package:nabvera/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/age_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/equipment_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/gender_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/goal_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/height_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/physical_activity_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/setup_intro_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/time_availability_page.dart';
import 'package:nabvera/features/onboarding/presentation/pages/weight_page.dart';
import 'package:nabvera/features/profile/presentation/pages/document_page.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:nabvera/features/profile/presentation/pages/help_page.dart';
import 'package:nabvera/features/profile/presentation/pages/legal_document_page.dart';
import 'package:nabvera/features/profile/presentation/pages/manage_data_page.dart';
import 'package:nabvera/features/profile/presentation/pages/notification_settings_page.dart';
import 'package:nabvera/features/profile/presentation/pages/password_settings_page.dart';
import 'package:nabvera/features/profile/presentation/pages/privacy_page.dart';
import 'package:nabvera/features/profile/presentation/pages/profile_page.dart';
import 'package:nabvera/features/profile/presentation/pages/settings_page.dart';
import 'package:nabvera/features/search/presentation/pages/search_page.dart';
import 'package:nabvera/features/workout/domain/exercise_detail_models.dart';
import 'package:nabvera/features/workout/presentation/pages/category_charts_page.dart';
import 'package:nabvera/features/workout/presentation/pages/category_detail_page.dart';
import 'package:nabvera/features/workout/presentation/pages/create_routine_page.dart';
import 'package:nabvera/features/workout/presentation/pages/exercise_detail_page.dart';
import 'package:nabvera/features/workout/presentation/pages/weekly_challenge_page.dart';
import 'package:nabvera/features/workout/presentation/pages/workout_logs_page.dart';
import 'package:nabvera/features/workout/presentation/pages/workout_page.dart';
import 'package:nabvera/features/workout/presentation/pages/workout_recommended_page.dart';
import 'package:nabvera/features/workout/presentation/pages/your_routine_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // A normal launcher-icon cold start reports "/" here; a cold start from
  // a verified Android App Link (e.g. the password-reset continue URL)
  // reports the link's real path instead — respecting it (rather than
  // always forcing `/splash`) is what lets `/reset-complete` work when the
  // app was fully closed. A backgrounded app doesn't go through this at
  // all: Flutter/go_router already route a new intent straight into the
  // running router via the platform's route information provider.
  final platformInitialLocation =
      WidgetsBinding.instance.platformDispatcher.defaultRouteName;
  final initialLocation =
      platformInitialLocation == '/' ? AppRoutes.splash : platformInitialLocation;

  return GoRouter(
    initialLocation: initialLocation,
    // The Admin console's structural role guard: evaluated on every
    // navigation (not just once at app start), so a direct/typed
    // navigation into an admin path is blocked here regardless of what
    // the Profile page's "Admin Console" entry point shows. See
    // `admin_route_guard.dart` for the pure decision logic this wraps.
    redirect:
        (context, state) => adminRouteGuard(
          location: state.matchedLocation,
          isAdmin: ref.read(currentUserProfileProvider).isAdmin,
        ),
    routes: [
      GoRoute(
        path: AppRoutes.unauthorized,
        builder: (context, state) => const AdminUnauthorizedPage(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.adminMore,
        builder: (context, state) => const AdminMorePage(),
      ),
      GoRoute(
        path: AppRoutes.adminWorkouts,
        builder: (context, state) => const AdminWorkoutsPage(),
      ),
      GoRoute(
        path: AppRoutes.adminWorkoutEditor,
        builder:
            (context, state) => AdminWorkoutEditorPage(
              existing: state.extra as Map<String, dynamic>?,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminExercises,
        builder: (context, state) => const AdminExercisesPage(),
      ),
      GoRoute(
        path: AppRoutes.adminExerciseEditor,
        builder:
            (context, state) => AdminExerciseEditorPage(
              existing: state.extra as Map<String, dynamic>?,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminRecipes,
        builder: (context, state) => const AdminRecipesPage(),
      ),
      GoRoute(
        path: AppRoutes.adminRecipeEditor,
        builder:
            (context, state) => AdminRecipeEditorPage(
              existing: state.extra as Map<String, dynamic>?,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminArticles,
        builder: (context, state) => const AdminArticlesPage(),
      ),
      GoRoute(
        path: AppRoutes.adminArticleEditor,
        builder:
            (context, state) => AdminArticleEditorPage(
              existing: state.extra as Map<String, dynamic>?,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminChallenges,
        builder: (context, state) => const AdminChallengesPage(),
      ),
      GoRoute(
        path: AppRoutes.adminChallengeEditor,
        builder:
            (context, state) => AdminChallengeEditorPage(
              existing: state.extra as Map<String, dynamic>?,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminProfile,
        builder: (context, state) => const AdminProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingCarouselPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder:
            (context, state) => LoginPage(
              showPasswordResetSuccess: isPasswordResetSuccess(
                state.uri.queryParameters,
              ),
            ),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.resetComplete,
        // No page ever actually builds here — see
        // `passwordResetRedirectTarget`'s doc comment for why a bare
        // redirect (no FirebaseAuth/session access at all) is the entire
        // handler for this route.
        redirect: (context, state) => passwordResetRedirectTarget(),
      ),
      GoRoute(
        path: AppRoutes.fingerprint,
        builder: (context, state) => const FingerPrintPage(),
      ),
      GoRoute(
        path: AppRoutes.biometricUnlock,
        builder: (context, state) => const BiometricUnlockPage(),
      ),
      GoRoute(
        path: AppRoutes.setup,
        builder: (context, state) => const SetupIntroPage(),
      ),
      GoRoute(
        path: AppRoutes.setupGender,
        builder: (context, state) => const GenderPage(),
      ),
      GoRoute(
        path: AppRoutes.setupAge,
        builder: (context, state) => const AgePage(),
      ),
      GoRoute(
        path: AppRoutes.setupWeight,
        builder: (context, state) => const WeightPage(),
      ),
      GoRoute(
        path: AppRoutes.setupHeight,
        builder: (context, state) => const HeightPage(),
      ),
      GoRoute(
        path: AppRoutes.setupGoal,
        builder: (context, state) => const GoalPage(),
      ),
      GoRoute(
        path: AppRoutes.setupPhysical,
        builder: (context, state) => const PhysicalActivityPage(),
      ),
      GoRoute(
        path: AppRoutes.setupEquipment,
        builder: (context, state) => const EquipmentPage(),
      ),
      GoRoute(
        path: AppRoutes.setupTime,
        builder: (context, state) => const TimeAvailabilityPage(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) => const PrivacyPage(),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder:
            (context, state) =>
                const LegalDocumentPage(type: LegalDocumentType.privacyPolicy),
      ),
      GoRoute(
        path: AppRoutes.termsAndConditions,
        builder:
            (context, state) =>
                const LegalDocumentPage(type: LegalDocumentType.terms),
      ),
      GoRoute(
        path: AppRoutes.manageData,
        builder: (context, state) => const ManageDataPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.passwordSettings,
        builder: (context, state) => const PasswordSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (context, state) => const NotificationSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.help,
        builder:
            (context, state) => HelpPage(
              args: (state.extra as HelpPageArgs?) ?? const HelpPageArgs(),
            ),
      ),
      GoRoute(
        path: AppRoutes.document,
        builder: (context, state) => const DocumentPage(),
      ),
      GoRoute(
        path: AppRoutes.favorite,
        builder: (context, state) => const FavoritePage(),
      ),
      GoRoute(
        path: AppRoutes.articleDetail,
        builder:
            (context, state) =>
                ArticleDetailPage(article: state.extra as ArticleTip),
      ),
      GoRoute(
        path: AppRoutes.workoutCategoryDetail,
        builder:
            (context, state) =>
                CategoryDetailPage(data: state.extra as CategoryDetailData),
      ),
      GoRoute(
        path: AppRoutes.exerciseDetail,
        builder:
            (context, state) =>
                ExerciseDetailPage(data: state.extra as ExerciseDetailData),
      ),
      GoRoute(
        path: AppRoutes.createRoutine,
        builder: (context, state) => const CreateRoutinePage(),
      ),
      GoRoute(
        path: AppRoutes.yourRoutine,
        builder: (context, state) => const YourRoutinePage(),
      ),
      GoRoute(
        path: AppRoutes.workoutLogs,
        builder: (context, state) => const WorkoutLogsPage(),
      ),
      GoRoute(
        path: AppRoutes.workoutCharts,
        builder: (context, state) => const CategoryChartsPage(),
      ),
      GoRoute(
        path: AppRoutes.workoutRecommended,
        builder: (context, state) => const WorkoutRecommendedPage(),
      ),
      GoRoute(
        path: AppRoutes.weeklyChallenge,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return WeeklyChallengePage(
            image: extra?['image'] ?? 'assets/comm.png',
            name: extra?['name'] ?? 'Weekly Challenge',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.mealPlanHome,
        builder: (context, state) => const MealPlanHomePage(),
      ),
      GoRoute(
        path: AppRoutes.mealPlanPreferences,
        builder: (context, state) => const NutritionPreferencesPage(),
      ),
      GoRoute(
        path: AppRoutes.mealPlanGenerating,
        builder: (context, state) => const MealPlanGeneratingPage(),
      ),
      GoRoute(
        path: AppRoutes.mealPlanShoppingList,
        builder: (context, state) => const MealPlanShoppingListPage(),
      ),
      GoRoute(
        path: AppRoutes.mealPlanHistory,
        builder: (context, state) => const MealPlanHistoryPage(),
      ),
      GoRoute(
        path: AppRoutes.healthConnection,
        builder: (context, state) => const HealthConnectionPage(),
      ),
      GoRoute(
        path: AppRoutes.mealDetail,
        builder:
            (context, state) => MealDetailPage(meal: state.extra as MealDetail),
      ),
      GoRoute(
        path: AppRoutes.mealIdea,
        builder: (context, state) => const MealIdeaPage(),
      ),
      GoRoute(
        path: AppRoutes.mealIdeaDiscover,
        builder: (context, state) => const MealIdeaDiscoverPage(),
      ),
      GoRoute(
        path: AppRoutes.communityChallenge,
        builder:
            (context, state) =>
                ChallengePage(challenge: state.extra as ChallengeItem),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workout,
                builder: (context, state) => const WorkoutPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.nutrition,
                builder: (context, state) => const NutritionPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.community,
                builder: (context, state) => const CommunityPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap:
            (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
      ),
    );
  }
}
