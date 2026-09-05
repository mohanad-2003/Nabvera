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

  group('UserProfile workout-schedule fields (Phase 5)', () {
    test('parses every schedule field from a full backend document', () {
      final profile = UserProfile.fromJson({
        'name': 'A',
        'email': 'a@a.com',
        'workoutDays': ['mon', 'wed', 'fri'],
        'workoutReminderTime': '18:30',
        'reminderEnabled': false,
        'quietHoursEnabled': true,
        'quietHoursStart': '22:00',
        'quietHoursEnd': '06:00',
        'challengeRemindersEnabled': false,
      });
      expect(profile.workoutDays, ['mon', 'wed', 'fri']);
      expect(profile.workoutReminderTime, '18:30');
      expect(profile.reminderEnabled, isFalse);
      expect(profile.quietHoursEnabled, isTrue);
      expect(profile.quietHoursStart, '22:00');
      expect(profile.quietHoursEnd, '06:00');
      expect(profile.challengeRemindersEnabled, isFalse);
    });

    test('defaults a pre-Phase-5 account (no schedule fields at all) safely', () {
      final legacy = UserProfile.fromJson({'name': 'A', 'email': 'a@a.com'});
      expect(legacy.workoutDays, isEmpty);
      expect(legacy.workoutReminderTime, isNull);
      expect(legacy.reminderEnabled, isTrue);
      expect(legacy.quietHoursEnabled, isFalse);
      expect(legacy.quietHoursStart, isNull);
      expect(legacy.quietHoursEnd, isNull);
      expect(legacy.challengeRemindersEnabled, isTrue);
    });

    test('UserProfile.empty defaults match a legacy account', () {
      expect(UserProfile.empty.workoutDays, isEmpty);
      expect(UserProfile.empty.reminderEnabled, isTrue);
      expect(UserProfile.empty.challengeRemindersEnabled, isTrue);
    });
  });
}
