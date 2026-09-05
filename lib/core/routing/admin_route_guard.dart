import 'package:nabvera/core/routing/app_routes.dart';

/// Pure decision function behind the Admin console's structural route
/// guard — kept free of `GoRouterState`/`BuildContext` so it's directly
/// unit-testable (see `test/core/routing/admin_route_guard_test.dart`).
///
/// Returns the path to redirect to, or `null` to allow the navigation
/// through unchanged. This is the *only* thing standing between a
/// non-admin user and an Admin page — Admin nav entries also hide
/// themselves for a non-admin, but that's a convenience, not the guard:
/// a direct/typed navigation to an admin path is blocked here regardless
/// of what the UI shows.
String? adminRouteGuard({required String location, required bool isAdmin}) {
  final isAdminRoute = location.startsWith(AppRoutes.adminPrefix);
  if (!isAdminRoute) return null;
  if (isAdmin) return null;
  return AppRoutes.unauthorized;
}
