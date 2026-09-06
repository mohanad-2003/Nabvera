/// Typed, centralized route paths. Never hardcode a path string at a call site.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const fingerprint = '/fingerprint';
  static const biometricUnlock = '/biometric-unlock';
  static const setup = '/setup';
  static const setupGender = '/setup/gender';
  static const setupAge = '/setup/age';
  static const setupWeight = '/setup/weight';
  static const setupHeight = '/setup/height';
  static const setupGoal = '/setup/goal';
  static const setupPhysical = '/setup/physical';
  static const setupEquipment = '/setup/equipment';
  static const setupTime = '/setup/time';
  static const search = '/search';
  static const notifications = '/notifications';
  static const home = '/home';
  static const workout = '/workout';
  static const nutrition = '/nutrition';
  static const community = '/community';
  static const profile = '/profile';
  static const workoutCategoryDetail = '/workout/category';
  static const exerciseDetail = '/workout/exercise';
  static const createRoutine = '/workout/create-routine';
  static const yourRoutine = '/workout/your-routine';
  static const workoutLogs = '/workout/logs';
  static const workoutCharts = '/workout/charts';
  static const workoutRecommended = '/workout/recommended';
  static const weeklyChallenge = '/workout/weekly-challenge';
  static const mealPlanHome = '/nutrition/meal-plan';
  static const mealPlanPreferences = '/nutrition/meal-plan/preferences';
  static const mealPlanGenerating = '/nutrition/meal-plan/generating';
  static const mealPlanShoppingList = '/nutrition/meal-plan/shopping-list';
  static const mealPlanHistory = '/nutrition/meal-plan/history';
  static const healthConnection = '/health/connect';
  static const mealDetail = '/nutrition/meal';
  static const mealIdea = '/nutrition/meal-idea';
  static const mealIdeaDiscover = '/nutrition/meal-idea/discover';
  static const communityChallenge = '/community/challenge';
  static const editProfile = '/profile/edit';
  static const privacy = '/profile/privacy';
  static const privacyPolicy = '/profile/privacy/policy';
  static const termsAndConditions = '/profile/privacy/terms';
  static const manageData = '/profile/privacy/manage-data';
  static const settings = '/profile/settings';
  static const passwordSettings = '/profile/settings/password';
  static const notificationSettings = '/profile/settings/notifications';
  static const help = '/profile/help';
  static const document = '/profile/document';
  static const favorite = '/favorite';
  static const articleDetail = '/home/article';

  // --- Admin console ----------------------------------------------------
  //
  // Every path below is guarded in app_router.dart by adminRouteGuard: a
  // signed-in user whose role isn't 'admin' is redirected away before any
  // of these pages ever build, not just hidden from the nav. `unauthorized`
  // is deliberately outside the '/admin' prefix so the guard doesn't also
  // block the page it redirects to.
  static const unauthorized = '/unauthorized';
  static const adminDashboard = '/admin';
  static const adminWorkouts = '/admin/workouts';
  static const adminWorkoutEditor = '/admin/workouts/editor';
  static const adminExercises = '/admin/exercises';
  static const adminExerciseEditor = '/admin/exercises/editor';
  static const adminRecipes = '/admin/recipes';
  static const adminRecipeEditor = '/admin/recipes/editor';
  static const adminArticles = '/admin/articles';
  static const adminArticleEditor = '/admin/articles/editor';
  static const adminChallenges = '/admin/challenges';
  static const adminChallengeEditor = '/admin/challenges/editor';
  static const adminProfile = '/admin/profile';

  /// Mobile-only hub listing Exercises/Recipes/Articles/Challenges — kept
  /// off the condensed bottom nav itself (see `AdminScaffold`'s "More" tab).
  static const adminMore = '/admin/more';

  /// Every route under the Admin console, used by the role guard to decide
  /// which navigations to check. Keep in sync with the constants above.
  static const adminPrefix = '/admin';
}
