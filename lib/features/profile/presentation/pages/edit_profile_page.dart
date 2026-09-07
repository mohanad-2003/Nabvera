import 'dart:async';

import 'dart:typed_data';

import 'package:nabvera/core/analytics/analytics_service.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/app_text_field.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/core/widgets/selectable_option_card.dart';
import 'package:nabvera/core/widgets/user_avatar.dart';
import 'package:nabvera/features/home/presentation/providers/home_dashboard_controller.dart'
    show refreshHomeProviders;
import 'package:nabvera/features/onboarding/presentation/providers/onboarding_profile_controller.dart';
import 'package:nabvera/features/profile/presentation/providers/profile_controller.dart';
import 'package:nabvera/features/profile/data/user_repository.dart';
import 'package:nabvera/features/profile/presentation/providers/workout_schedule_controller.dart';
import 'package:nabvera/features/profile/presentation/widgets/profile_stat_row.dart';
import 'package:nabvera/features/profile/presentation/widgets/workout_schedule_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

enum _Gender { male, female, other }

String _goalLabel(AppLocalizations l10n, FitnessGoal goal) => switch (goal) {
  FitnessGoal.loseWeight => l10n.goalLoseWeight,
  FitnessGoal.gainWeight => l10n.goalGainWeight,
  FitnessGoal.muscleMassGain => l10n.goalMuscleMassGain,
  FitnessGoal.shapeBody => l10n.goalShapeBody,
  FitnessGoal.others => l10n.goalOthers,
};

String _levelLabel(AppLocalizations l10n, ActivityLevel level) =>
    switch (level) {
      ActivityLevel.beginner => l10n.workoutLevelBeginner,
      ActivityLevel.intermediate => l10n.workoutLevelIntermediate,
      ActivityLevel.advanced => l10n.workoutLevelAdvanced,
    };

String _equipmentLabel(AppLocalizations l10n, AvailableEquipment equipment) =>
    switch (equipment) {
      AvailableEquipment.none => l10n.onboardingEquipmentNone,
      AvailableEquipment.dumbbell => l10n.onboardingEquipmentDumbbell,
      AvailableEquipment.barbell => l10n.onboardingEquipmentBarbell,
      AvailableEquipment.machine => l10n.onboardingEquipmentMachine,
      AvailableEquipment.resistanceBand => l10n.onboardingEquipmentBand,
      AvailableEquipment.kettlebell => l10n.onboardingEquipmentKettlebell,
    };

String _timeLabel(AppLocalizations l10n, AvailableTime time) => switch (time) {
  AvailableTime.minutes15 => l10n.onboardingTime15,
  AvailableTime.minutes30 => l10n.onboardingTime30,
  AvailableTime.minutes45 => l10n.onboardingTime45,
  AvailableTime.minutes60 => l10n.onboardingTime60,
};

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _dobController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  _Gender _gender = _Gender.female;
  bool _saving = false;
  String? _nameError;
  bool _initialized = false;

  XFile? _pendingAvatar;
  Uint8List? _avatarPreviewBytes;
  // Workout-preferences section — separate save action/state from the
  // identity fields above, since these map onto the recommendation engine
  // rather than the profile card.
  FitnessGoal? _goal;
  ActivityLevel? _activityLevel;
  Set<AvailableEquipment> _equipment = {AvailableEquipment.none};
  AvailableTime _availableTime = AvailableTime.minutes30;
  bool _preferencesInitialized = false;
  bool _savingPreferences = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController(text: '+123 567 89000');
    _dobController = TextEditingController();
    _weightController = TextEditingController();
    _heightController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  String _genderLabel(_Gender gender, AppLocalizations l10n) =>
      switch (gender) {
        _Gender.male => l10n.editProfileGenderMale,
        _Gender.female => l10n.editProfileGenderFemale,
        _Gender.other => l10n.editProfileGenderOther,
      };

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1996, 4, 1),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')} / '
          '${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
    }
  }

  /// Opens the gallery picker and shows the picked photo immediately (via
  /// [UserAvatar]'s `imageBytes`) — it isn't uploaded yet. The actual
  /// upload happens in [_handleSave], alongside every other field, so
  /// tapping the avatar and then backing out of the whole edit without
  /// pressing Update never partially saves just the photo.
  Future<void> _pickAvatar() async {
    try {
      final selected = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (selected == null) return;
      final bytes = await selected.readAsBytes();
      if (!mounted) return;
      setState(() {
        _pendingAvatar = selected;
        _avatarPreviewBytes = bytes;
      });
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.editProfileAvatarPickFailed)));
    }
  }

  Future<void> _handleSave(AppLocalizations l10n) async {
    if (_nameController.text.trim().isEmpty) {
      setState(() => _nameError = l10n.editProfileNameValidation);
      return;
    }
    setState(() {
      _nameError = null;
      _saving = true;
    });

    final patch = <String, dynamic>{
      'name': _nameController.text.trim(),
      'gender': _gender.name,
    };
    final weight = num.tryParse(_weightController.text.trim());
    if (weight != null) patch['weightKg'] = weight;
    final height = num.tryParse(_heightController.text.trim());
    if (height != null) patch['heightCm'] = height;
    final dob = _parseDob(_dobController.text.trim());
    if (dob != null) patch['dateOfBirth'] = dob.toIso8601String();

    final pendingAvatar = _pendingAvatar;
    try {
      if (pendingAvatar != null) {
        // Uploaded first, and any failure here aborts the whole save (no
        // ApiException swallowed into a fake "success") — a half-applied
        // update (every field but the photo) would be confusing, not just
        // a missing photo.
        final avatarUrl = await ref
            .read(userRepositoryProvider)
            .uploadAvatar(
              bytes: _avatarPreviewBytes!,
              filename: pendingAvatar.name,
              contentType: pendingAvatar.mimeType,
            );
        patch['avatarUrl'] = avatarUrl;
      }
      await ref.read(currentUserProfileProvider.notifier).update(patch);
      if (!mounted) return;
      setState(() {
        _pendingAvatar = null;
        _avatarPreviewBytes = null;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.editProfileSuccessMessage)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            pendingAvatar != null
                ? l10n.editProfileAvatarUploadFailed
                : l10n.authErrorGeneric,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Saves the workout-preferences section only — kept independent of
  /// [_handleSave] since these fields (goal/level/equipment/time) feed the
  /// recommendation engine, not the profile card, and a user editing one
  /// shouldn't be forced to also submit the other.
  Future<void> _handleSavePreferences(AppLocalizations l10n) async {
    setState(() => _savingPreferences = true);
    final goal = _goal;
    final level = _activityLevel;
    final minutes = timeToMinutes(_availableTime);
    final equipment = _equipment.map(equipmentToApi).toList();
    final patch = <String, dynamic>{
      if (goal != null) 'goal': goalToApi(goal),
      if (level != null) 'activityLevel': level.name,
      'availableEquipment': equipment,
      'availableMinutes': minutes,
    };
    try {
      await ref.read(currentUserProfileProvider.notifier).update(patch);
      // The Home recommendation, recovery map, and next-step card don't
      // watch the profile provider directly — refresh them explicitly so
      // Home reflects the new preferences the moment the user goes back,
      // with no restart or manual navigation needed.
      refreshHomeProviders(ref);
      unawaited(
        ref
            .read(analyticsServiceProvider)
            .logEvent(AnalyticsEvent.workoutPreferencesUpdated, {
              if (goal != null) 'goal': goalToApi(goal),
              if (level != null) 'activityLevel': level.name,
              'availableEquipment': equipment,
              'availableMinutes': minutes,
            }),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.editProfileSuccessMessage)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authErrorGeneric)));
    } finally {
      if (mounted) setState(() => _savingPreferences = false);
    }
  }

  /// Parses the "dd / MM / yyyy" text the date picker writes back.
  DateTime? _parseDob(String text) {
    final parts = text.split('/').map((p) => p.trim()).toList();
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(currentUserProfileProvider);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    if (!_initialized && profile.email.isNotEmpty) {
      _initialized = true;
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      if (profile.weightKgRaw != null) {
        _weightController.text = profile.weightKgRaw!.round().toString();
      }
      if (profile.heightCmRaw != null) {
        _heightController.text = profile.heightCmRaw!.round().toString();
      }
      final dob = profile.dateOfBirth;
      if (dob != null) {
        _dobController.text =
            '${dob.day.toString().padLeft(2, '0')} / '
            '${dob.month.toString().padLeft(2, '0')} / ${dob.year}';
      }
      _gender = switch (profile.gender) {
        'male' => _Gender.male,
        'female' => _Gender.female,
        _ => _Gender.other,
      };
    }

    if (!_preferencesInitialized && profile.email.isNotEmpty) {
      _preferencesInitialized = true;
      _goal = goalFromApi(profile.goal);
      _activityLevel = activityLevelFromApi(profile.activityLevel);
      final savedEquipment =
          profile.availableEquipment
              .map(equipmentFromApi)
              .whereType<AvailableEquipment>()
              .toSet();
      _equipment =
          savedEquipment.isEmpty ? {AvailableEquipment.none} : savedEquipment;
      _availableTime = minutesToTime(profile.availableMinutes);
    }

    return PremiumScaffold(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeSlideIn(
              offset: const Offset(0, -0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (context.canPop())
                        PremiumIconButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          onTap: () => context.pop(),
                        ),
                      const Spacer(),
                      Text(
                        l10n.editProfileTitle,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
                          color: ext.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(width: 44),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          UserAvatar(
                            radius: 52,
                            imageUrl: profile.avatarUrl,
                            imageBytes: _avatarPreviewBytes,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: ext.cardColor,
                                border: Border.all(
                                  color: ext.glassBorder,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Text(
                      profile.name,
                      style: TextStyle(
                        fontSize: 20,
                        color: ext.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      profile.email,
                      style: TextStyle(fontSize: 13, color: ext.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            FadeSlideIn(
              delay: const Duration(milliseconds: 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: ProfileStatRow(profile: profile),
              ),
            ),
            const SizedBox(height: 26),
            FadeSlideIn(
              delay: const Duration(milliseconds: 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: _nameController,
                    label: l10n.editProfileFullName,
                    prefixIcon: Icons.person_outline_rounded,
                    flat: true,
                    onChanged: (_) {
                      if (_nameError != null) {
                        setState(() => _nameError = null);
                      }
                    },
                  ),
                  if (_nameError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _nameError!,
                      style: TextStyle(color: ext.danger, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 15),
                  AppTextField(
                    controller: _emailController,
                    label: l10n.authEmail,
                    prefixIcon: Icons.alternate_email_rounded,
                    flat: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    controller: _mobileController,
                    label: l10n.editProfileMobileNumber,
                    prefixIcon: Icons.phone_outlined,
                    flat: true,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: AppTextField(
                        controller: _dobController,
                        label: l10n.editProfileDateOfBirth,
                        prefixIcon: Icons.cake_outlined,
                        flat: true,
                        suffixIcon: const Icon(Icons.calendar_today_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    controller: _weightController,
                    label: l10n.editProfileWeight,
                    prefixIcon: Icons.monitor_weight_outlined,
                    flat: true,
                  ),
                  const SizedBox(height: 15),
                  AppTextField(
                    controller: _heightController,
                    label: l10n.editProfileHeight,
                    prefixIcon: Icons.height_rounded,
                    flat: true,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.editProfileGenderLabel,
                    style: TextStyle(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final gender in _Gender.values) ...[
                        if (gender != _Gender.values.first)
                          const SizedBox(width: 8),
                        Expanded(
                          child: _GenderChip(
                            label: _genderLabel(gender, l10n),
                            selected: _gender == gender,
                            onTap: () => setState(() => _gender = gender),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            FadeSlideIn(
              delay: const Duration(milliseconds: 180),
              child: PrimaryButton(
                label: l10n.editProfileUpdate,
                isLoading: _saving,
                onPressed: () => _handleSave(l10n),
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: ext.glassBorder),
            const SizedBox(height: 22),
            FadeSlideIn(
              delay: const Duration(milliseconds: 220),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.editProfilePreferencesTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.editProfilePreferencesSubtitle,
                    style: TextStyle(color: ext.textMuted, fontSize: 12.5),
                  ),
                  const SizedBox(height: 18),
                  _SectionLabel(l10n.editProfilePreferencesGoalLabel, ext),
                  const SizedBox(height: 8),
                  for (final goal in FitnessGoal.values) ...[
                    SelectableOptionCard(
                      label: _goalLabel(l10n, goal),
                      isSelected: _goal == goal,
                      showCheckmark: true,
                      onTap: () => setState(() => _goal = goal),
                    ),
                    if (goal != FitnessGoal.values.last)
                      const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 18),
                  _SectionLabel(l10n.editProfilePreferencesLevelLabel, ext),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final level in ActivityLevel.values) ...[
                        if (level != ActivityLevel.values.first)
                          const SizedBox(width: 8),
                        Expanded(
                          child: _GenderChip(
                            label: _levelLabel(l10n, level),
                            selected: _activityLevel == level,
                            onTap: () => setState(() => _activityLevel = level),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionLabel(l10n.editProfilePreferencesEquipmentLabel, ext),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final equipment in AvailableEquipment.values)
                        _EquipmentChip(
                          label: _equipmentLabel(l10n, equipment),
                          selected: _equipment.contains(equipment),
                          onTap:
                              () => setState(() {
                                final selected = {..._equipment};
                                if (equipment == AvailableEquipment.none) {
                                  selected
                                    ..clear()
                                    ..add(equipment);
                                } else {
                                  selected.remove(AvailableEquipment.none);
                                  if (!selected.add(equipment)) {
                                    selected.remove(equipment);
                                  }
                                  if (selected.isEmpty) {
                                    selected.add(AvailableEquipment.none);
                                  }
                                }
                                _equipment = selected;
                              }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _SectionLabel(l10n.editProfilePreferencesTimeLabel, ext),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      for (final time in AvailableTime.values) ...[
                        if (time != AvailableTime.values.first)
                          const SizedBox(width: 8),
                        Expanded(
                          child: _GenderChip(
                            label: _timeLabel(l10n, time),
                            selected: _availableTime == time,
                            onTap: () => setState(() => _availableTime = time),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    label: l10n.editProfilePreferencesSave,
                    isLoading: _savingPreferences,
                    onPressed: () => _handleSavePreferences(l10n),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: ext.glassBorder),
            const SizedBox(height: 22),
            FadeSlideIn(
              delay: const Duration(milliseconds: 260),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.workoutScheduleTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.workoutScheduleSubtitle,
                    style: TextStyle(color: ext.textMuted, fontSize: 12.5),
                  ),
                  const SizedBox(height: 18),
                  WorkoutScheduleForm(
                    // Rebuilds the form (and its internal state) fresh
                    // whenever a save below completes and the profile
                    // refreshes — otherwise its `initState` snapshot would
                    // go stale after the very first successful save.
                    key: ValueKey(
                      '${profile.workoutDays.join(',')}|'
                      '${profile.workoutReminderTime}|${profile.reminderEnabled}',
                    ),
                    profile: profile,
                    onSave: (patch, previousReminderEnabled) async {
                      try {
                        await saveWorkoutSchedule(
                          ref,
                          patch: patch,
                          previousReminderEnabled: previousReminderEnabled,
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.editProfileSuccessMessage),
                          ),
                        );
                      } catch (_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.workoutScheduleSaveFailed),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label, this.ext);

  final String label;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(
      color: ext.textPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 13,
    ),
  );
}

class _EquipmentChip extends StatelessWidget {
  const _EquipmentChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          gradient: selected ? ext.accentGradient : null,
          color: selected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? ext.onAccent : ext.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  const _GenderChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: selected ? ext.accentGradient : null,
          color: selected ? null : ext.glassFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? Colors.transparent : ext.glassBorder,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: selected ? ext.onAccent : ext.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 12.5,
          ),
        ),
      ),
    );
  }
}
