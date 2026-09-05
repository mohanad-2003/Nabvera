import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile.isAdmin', () {
    test('is true only when the backend role is exactly "admin"', () {
      final admin = UserProfile.fromJson({
        'name': 'A',
        'email': 'a@a.com',
        'role': 'admin',
      });
      expect(admin.isAdmin, isTrue);
    });

    test('is false for the ordinary "user" role', () {
      final user = UserProfile.fromJson({
        'name': 'A',
        'email': 'a@a.com',
        'role': 'user',
      });
      expect(user.isAdmin, isFalse);
    });

    test('defaults to non-admin when role is missing from the response', () {
      final noRole = UserProfile.fromJson({'name': 'A', 'email': 'a@a.com'});
      expect(noRole.isAdmin, isFalse);
      expect(noRole.role, 'user');
    });

    test('UserProfile.empty is never an admin', () {
      expect(UserProfile.empty.isAdmin, isFalse);
    });
  });
}
