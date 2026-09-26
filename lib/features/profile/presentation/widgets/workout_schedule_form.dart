import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/profile/domain/profile_models.dart';
import 'package:nabvera/features/profile/domain/workout_schedule.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_card.dart';
import 'package:nabvera/features/profile/presentation/widgets/settings_toggle_row.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart'
    show Weekday;
import 'package:nabvera/features/workout/presentation/widgets/workout_day_picker.dart';
import 'package:flutter/material.dart';

String weekdayShortLabel(Weekday day, AppLocalizations l10n) => switch (day) {
  Weekday.monday => l10n.weekdayMondayShort,
  Weekday.tuesday => l10n.weekdayTuesdayShort,
  Weekday.wednesday => l10n.weekdayWednesdayShort,
  Weekday.thursday => l10n.weekdayThursdayShort,
  Weekday.friday => l10n.weekdayFridayShort,
  Weekday.saturday => l10n.weekdaySaturdayShort,
  Weekday.sunday => l10n.weekdaySundayShort,
};

/// The Workout Schedule editor — days, reminder time, reminder/quiet-hours/
/// challenge-reminder toggles, and a Save button. Used both as a full
/// section on Edit Profile and inside the Home quick-edit bottom sheet, so
/// the two entry points can never drift apart (see each call site).
class WorkoutScheduleForm extends StatefulWidget {
  const WorkoutScheduleForm({
    super.key,
    required this.profile,
    required this.onSave,
  });

  final UserProfile profile;

  /// Called with the patch to send to `PATCH /users/me` and the
  /// `reminderEnabled` value *before* this save, so the caller can log an
  /// enabled/disabled analytics event only on a real transition.
  final Future<void> Function(
    Map<String, dynamic> patch,
    bool previousReminderEnabled,
  )
  onSave;

  @override
  State<WorkoutScheduleForm> createState() => _WorkoutScheduleFormState();
}

class _WorkoutScheduleFormState extends State<WorkoutScheduleForm> {
  late Set<Weekday> _days;
  TimeOfDay? _reminderTime;
  late bool _reminderEnabled;
  late bool _quietHoursEnabled;
  TimeOfDay? _quietStart;
  TimeOfDay? _quietEnd;
  late bool _challengeRemindersEnabled;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _days = workoutDaysFromApi(profile.workoutDays);
    _reminderTime = parseTimeOfDay(profile.workoutReminderTime);
    _reminderEnabled = profile.reminderEnabled;
    _quietHoursEnabled = profile.quietHoursEnabled;
    _quietStart =
        parseTimeOfDay(profile.quietHoursStart) ??
        const TimeOfDay(hour: 22, minute: 0);
    _quietEnd =
        parseTimeOfDay(profile.quietHoursEnd) ??
        const TimeOfDay(hour: 6, minute: 0);
    _challengeRemindersEnabled = profile.challengeRemindersEnabled;
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null && mounted) setState(() => _reminderTime = picked);
  }

  Future<void> _pickQuietTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          (isStart ? _quietStart : _quietEnd) ??
          const TimeOfDay(hour: 22, minute: 0),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _quietStart = picked;
      } else {
        _quietEnd = picked;
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final patch = <String, dynamic>{
      'workoutDays': workoutDaysToApi(_days),
      'workoutReminderTime':
          _reminderTime == null ? null : formatTimeOfDay(_reminderTime!),
      'reminderEnabled': _reminderEnabled,
      'quietHoursEnabled': _quietHoursEnabled,
      if (_quietStart != null) 'quietHoursStart': formatTimeOfDay(_quietStart!),
      if (_quietEnd != null) 'quietHoursEnd': formatTimeOfDay(_quietEnd!),
      'challengeRemindersEnabled': _challengeRemindersEnabled,
    };
    try {
      await widget.onSave(patch, widget.profile.reminderEnabled);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final quietHoursAllDay =
        _quietHoursEnabled &&
        _quietStart != null &&
        _quietEnd != null &&
        _quietStart!.hour == _quietEnd!.hour &&
        _quietStart!.minute == _quietEnd!.minute;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.workoutScheduleDaysLabel,
          style: TextStyle(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 10),
        WorkoutDayPicker(
          selectedDays: _days,
          shortLabelBuilder: (day) => weekdayShortLabel(day, l10n),
          onToggle:
              (day) => setState(() {
                if (!_days.remove(day)) _days.add(day);
              }),
        ),
        const SizedBox(height: 18),
        Text(
          l10n.workoutScheduleTimeLabel,
          style: TextStyle(
            color: ext.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        _TimePickerTile(
          label:
              _reminderTime == null
                  ? l10n.workoutScheduleTimeNotSet
                  : _reminderTime!.format(context),
          onTap: _pickReminderTime,
        ),
        const SizedBox(height: 18),
        SettingsCard(
          children: [
            SettingsToggleRow(
              icon: Icons.alarm_rounded,
              title: l10n.workoutScheduleReminderToggleTitle,
              subtitle: l10n.workoutScheduleReminderToggleSubtitle,
              value: _reminderEnabled,
              onChanged: (value) => setState(() => _reminderEnabled = value),
            ),
            SettingsToggleRow(
              icon: Icons.bedtime_outlined,
              title: l10n.workoutScheduleQuietHoursToggleTitle,
              subtitle: l10n.workoutScheduleQuietHoursToggleSubtitle,
              value: _quietHoursEnabled,
              onChanged: (value) => setState(() => _quietHoursEnabled = value),
            ),
            if (_quietHoursEnabled) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: _TimePickerTile(
                      label:
                          '${l10n.workoutScheduleQuietStartLabel}: '
                          '${_quietStart?.format(context) ?? l10n.workoutScheduleTimeNotSet}',
                      onTap: () => _pickQuietTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _TimePickerTile(
                      label:
                          '${l10n.workoutScheduleQuietEndLabel}: '
                          '${_quietEnd?.format(context) ?? l10n.workoutScheduleTimeNotSet}',
                      onTap: () => _pickQuietTime(isStart: false),
                    ),
                  ),
                ],
              ),
              if (quietHoursAllDay) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.workoutScheduleQuietHoursAllDayWarning,
                  style: TextStyle(color: ext.danger, fontSize: 11.5),
                ),
              ],
              const SizedBox(height: 4),
            ],
            SettingsToggleRow(
              icon: Icons.emoji_events_outlined,
              title: l10n.workoutScheduleChallengeToggleTitle,
              subtitle: l10n.workoutScheduleChallengeToggleSubtitle,
              value: _challengeRemindersEnabled,
              onChanged:
                  (value) => setState(() => _challengeRemindersEnabled = value),
            ),
          ],
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: l10n.workoutScheduleSave,
          isLoading: _saving,
          onPressed: _save,
        ),
      ],
    );
  }
}

class _TimePickerTile extends StatelessWidget {
  const _TimePickerTile({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: ext.glassFill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ext.glassBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded, size: 18, color: ext.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: ext.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
