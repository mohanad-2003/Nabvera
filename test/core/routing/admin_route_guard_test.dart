import 'package:fitness_app/core/routing/admin_route_guard.dart';
import 'package:fitness_app/core/routing/app_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('adminRouteGuard — non-admin routes', () {
    test('never redirects a plain user-facing route, admin or not', () {
      expect(adminRouteGuard(location: AppRoutes.home, isAdmin: false), isNull);
      expect(adminRouteGuard(location: AppRoutes.home, isAdmin: true), isNull);
      expect(
        adminRouteGuard(location: AppRoutes.profile, isAdmin: false),
        isNull,
      );
    });

    test('never redirects the unauthorized page itself (no redirect loop)', () {
      expect(
        adminRouteGuard(location: AppRoutes.unauthorized, isAdmin: false),
        isNull,
      );
    });
  });

  group('adminRouteGuard — admin routes, non-admin user', () {
    test(
      'blocks every admin route for a non-admin, redirecting to unauthorized',
      () {
        const adminRoutes = [
          AppRoutes.adminDashboard,
          AppRoutes.adminWorkouts,
          AppRoutes.adminWorkoutEditor,
          AppRoutes.adminExercises,
          AppRoutes.adminExerciseEditor,
          AppRoutes.adminRecipes,
          AppRoutes.adminRecipeEditor,
          AppRoutes.adminArticles,
          AppRoutes.adminArticleEditor,
          AppRoutes.adminChallenges,
          AppRoutes.adminChallengeEditor,
          AppRoutes.adminProfile,
          AppRoutes.adminMore,
        ];
        for (final route in adminRoutes) {
          expect(
            adminRouteGuard(location: route, isAdmin: false),
            AppRoutes.unauthorized,
            reason: '$route should redirect a non-admin to unauthorized',
          );
        }
      },
    );

    test(
      'blocks a sub-path under /admin even if not one of the known constants',
      () {
        expect(
          adminRouteGuard(location: '/admin/something-new', isAdmin: false),
          AppRoutes.unauthorized,
        );
      },
    );
  });

  group('adminRouteGuard — admin routes, admin user', () {
    test('allows every admin route through for an admin', () {
      const adminRoutes = [
        AppRoutes.adminDashboard,
        AppRoutes.adminWorkouts,
        AppRoutes.adminExercises,
        AppRoutes.adminRecipes,
        AppRoutes.adminArticles,
        AppRoutes.adminChallenges,
        AppRoutes.adminProfile,
      ];
      for (final route in adminRoutes) {
        expect(
          adminRouteGuard(location: route, isAdmin: true),
          isNull,
          reason: '$route should be reachable by an admin',
        );
      }
    });
  });
}
