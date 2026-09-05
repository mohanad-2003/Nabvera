import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/presentation/providers/workout_schedule_controller.dart';
import 'package:nabvera/features/profile/presentation/widgets/workout_schedule_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Quick-edit entry point for the workout schedule, reachable straight from
/// Home's schedule card — same [WorkoutScheduleForm] Edit Profile uses, in
/// a modal sheet, so both places save/reschedule identically (see
/// `saveWorkoutSchedule`).
Future<void> showWorkoutScheduleSheet(
  BuildContext context,
  WidgetRef ref,
  UserProfile profile,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _WorkoutScheduleSheet(profile: profile),
  );
}

class _WorkoutScheduleSheet extends ConsumerWidget {
  const _WorkoutScheduleSheet({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.82,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: ext.cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: ext.glassBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.workoutScheduleSheetTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ext.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                WorkoutScheduleForm(
                  profile: profile,
                  onSave: (patch, previousReminderEnabled) async {
                    try {
                      await saveWorkoutSchedule(
                        ref,
                        patch: patch,
                        previousReminderEnabled: previousReminderEnabled,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                    } catch (_) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.workoutScheduleSaveFailed)),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
