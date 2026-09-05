import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'weekly_challenge_controller.g.dart';

@riverpod
List<WeeklyRound> weeklyChallengeRoundOne(Ref ref) => const [
  WeeklyRound(name: 'Endurance Ride', time: '10:30', intensity: 'Moderate'),
  WeeklyRound(name: 'Hill Climbs', time: '05:00', intensity: 'High'),
  WeeklyRound(name: 'Interval Sprint', time: '07:00', intensity: 'High'),
];

@riverpod
List<WeeklyRound> weeklyChallengeRoundTwo(Ref ref) => const [
  WeeklyRound(name: 'Tempo Ride', time: '8:00', intensity: 'Moderate'),
  WeeklyRound(name: 'Cadence Drill', time: '06:00', intensity: 'Moderate'),
];
