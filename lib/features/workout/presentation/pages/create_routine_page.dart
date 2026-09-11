import 'package:go_router/go_router.dart';
import '../providers/workout_request_providers.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_surface.dart';
import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/responsive/app_responsive.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:nabvera/features/workout/presentation/providers/create_routine_controller.dart';
import 'package:nabvera/features/workout/presentation/providers/your_routine_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/difficulty_selector.dart';
import 'package:nabvera/features/workout/presentation/widgets/exercise_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/goal_selector.dart';
import 'package:nabvera/features/workout/presentation/widgets/routine_bottom_bar.dart';
import 'package:nabvera/features/workout/presentation/widgets/routine_header.dart';
import 'package:nabvera/features/workout/presentation/widgets/selected_exercise_item.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Redesigned Create Routine screen — every section (details, days,
/// exercise library, selected list) is laid out flat, directly on the
/// page background, with a hairline divider between rows/sections rather
/// than each piece living inside its own boxed card. The routine summary
/// and the "Create" action are pinned in a sticky bottom bar instead of
/// sitting in a card at the end of the scroll.
class CreateRoutinePage extends ConsumerStatefulWidget {
  const CreateRoutinePage({super.key});

  @override
  ConsumerState<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends ConsumerState<CreateRoutinePage> {
  late final TextEditingController _nameController;
  bool _creating = false;
  String _query = '';
  MuscleGroup _muscleFilter = MuscleGroup.all;
  bool _saveFailed = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _goalLabel(RoutineGoal goal, AppLocalizations l10n) {
    switch (goal) {
      case RoutineGoal.muscleGain:
        return l10n.routineGoalMuscleGain;
      case RoutineGoal.fatLoss:
        return l10n.routineGoalFatLoss;
      case RoutineGoal.strength:
        return l10n.routineGoalStrength;
      case RoutineGoal.endurance:
        return l10n.routineGoalEndurance;
    }
  }

  String _difficultyLabel(WorkoutLevel level, AppLocalizations l10n) {
    switch (level) {
      case WorkoutLevel.beginner:
        return l10n.workoutLevelBeginner;
      case WorkoutLevel.intermediate:
        return l10n.workoutLevelIntermediate;
      case WorkoutLevel.advanced:
        return l10n.workoutLevelAdvanced;
    }
  }

  String _muscleGroupLabel(MuscleGroup group, AppLocalizations l10n) {
    switch (group) {
      case MuscleGroup.all:
        return l10n.workoutCategoryAll;
      case MuscleGroup.chest:
        return l10n.workoutCategoryChest;
      case MuscleGroup.back:
        return l10n.workoutCategoryBack;
      case MuscleGroup.legs:
        return l10n.workoutCategoryLegs;
      case MuscleGroup.arms:
        return l10n.workoutCategoryArms;
      case MuscleGroup.cardio:
        return l10n.workoutCategoryCardio;
      case MuscleGroup.strength:
        return l10n.workoutCategoryStrength;
    }
  }

  String _dayShortLabel(Weekday day, AppLocalizations l10n) {
    switch (day) {
      case Weekday.monday:
        return l10n.weekdayMondayShort;
      case Weekday.tuesday:
        return l10n.weekdayTuesdayShort;
      case Weekday.wednesday:
        return l10n.weekdayWednesdayShort;
      case Weekday.thursday:
        return l10n.weekdayThursdayShort;
      case Weekday.friday:
        return l10n.weekdayFridayShort;
      case Weekday.saturday:
        return l10n.weekdaySaturdayShort;
      case Weekday.sunday:
        return l10n.weekdaySundayShort;
    }
  }

  Future<void> _handleCreate(
    CreateRoutineController controller,
    CreateRoutineState state,
    AppLocalizations l10n,
  ) async {
    if (_creating) return;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _validationError = l10n.createRoutineNameValidation);
      return;
    }
    if (state.selected.isEmpty) {
      setState(() => _validationError = l10n.createRoutineExerciseValidation);
      return;
    }
    setState(() {
      _validationError = null;
      _creating = true;
      _saveFailed = false;
    });
    try {
      await controller.create(name);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.createRoutineSuccessMessage)));
      ref.invalidate(yourRoutineControllerProvider);
      ref.invalidate(routinesRequestProvider);
      if (context.canPop()) context.pop();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _validationError = workoutError(context, error);
        _saveFailed = true;
      });
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createRoutineControllerProvider);
    final controller = ref.read(createRoutineControllerProvider.notifier);
    final theme = Theme.of(context);
    final ext = theme.extension<AppThemeExtension>()!;
    final l10n = AppLocalizations.of(context);

    return WorkoutScaffold(
      padding: EdgeInsets.zero,
      bottomBar: RoutineBottomBar(
        stats: [
          RoutineStat(
            icon: Icons.fitness_center_rounded,
            value: '${state.selected.length}',
            label: l10n.createRoutineSummaryExercises,
          ),
          RoutineStat(
            icon: Icons.timer_outlined,
            value: '${state.totalDurationMinutes}',
            label: l10n.createRoutineSummaryDuration,
          ),
          RoutineStat(
            icon: Icons.local_fire_department_rounded,
            value: '${state.estimatedCalories}',
            label: l10n.createRoutineSummaryCalories,
          ),
          RoutineStat(
            icon: Icons.calendar_month_rounded,
            value: '${state.selectedDays.length}',
            label: l10n.createRoutineSummaryDays,
          ),
        ],
        buttonLabel: _saveFailed ? l10n.actionRetry : l10n.workoutCreateRoutine,
        isLoading: _creating,
        errorText: _validationError,
        onPressed: () => _handleCreate(controller, state, l10n),
      ),
      child: AbsorbPointer(
        absorbing: _creating,
        child: SafeArea(
          top: false,
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final horizontalPadding = responsiveValue(
                width,
                compact: 16.0,
                standard: 20.0,
                medium: 24.0,
                expanded: 32.0,
              );
              final maxContentWidth = responsiveValue(
                width,
                compact: double.infinity,
                expanded: 720.0,
              );

              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: _buildScrollView(
                    state: state,
                    controller: controller,
                    theme: theme,
                    ext: ext,
                    l10n: l10n,
                    horizontalPadding: horizontalPadding,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildScrollView({
    required CreateRoutineState state,
    required CreateRoutineController controller,
    required ThemeData theme,
    required AppThemeExtension ext,
    required AppLocalizations l10n,
    required double horizontalPadding,
  }) {
    final divider = Divider(height: 1, thickness: .5, color: ext.glassBorder);
    final request = ref.watch(exerciseLibraryRequestProvider);
    final library =
        state.library
            .where(
              (entry) =>
                  (_muscleFilter == MuscleGroup.all ||
                      entry.muscleGroup == _muscleFilter) &&
                  entry.name.toLowerCase().contains(
                    _query.trim().toLowerCase(),
                  ),
            )
            .toList();

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            16,
          ),
          sliver: SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: RoutineHeader(
                  title: l10n.workoutCreateRoutine,
                  subtitle: l10n.createRoutineSubtitle,
                  motivation: l10n.createRoutineMotivation,
                ),
              ),

              // --- Routine details -------------------------------------
              SliverToBoxAdapter(
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SectionLabel(
                          '1. ${l10n.createRoutineNameLabel}',
                          ext: ext,
                        ),
                        const SizedBox(height: 10),
                        _UnderlinedField(
                          controller: _nameController,
                          hint: l10n.createRoutineNameHint,
                          ext: ext,
                          onChanged: (value) {
                            controller.setName(value);
                            if (_validationError != null) {
                              setState(() => _validationError = null);
                            }
                          },
                        ),
                        const SizedBox(height: 22),
                        _SectionLabel(l10n.createRoutineGoalLabel, ext: ext),
                        const SizedBox(height: 10),
                        GoalSelector(
                          selected: state.goal,
                          onChanged: controller.setGoal,
                          labelBuilder: (g) => _goalLabel(g, l10n),
                        ),
                        const SizedBox(height: 22),
                        _SectionLabel(l10n.workoutDifficultyLabel, ext: ext),
                        const SizedBox(height: 10),
                        DifficultySelector(
                          selected: state.difficulty,
                          onChanged: controller.setDifficulty,
                          labelBuilder: (l) => _difficultyLabel(l, l10n),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: divider,
                ),
              ),

              // --- Training days ----------------------------------------
              SliverToBoxAdapter(
                child: _SectionTitle(
                  l10n.createRoutineDaysLabel,
                  ext: ext,
                  theme: theme,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: WorkoutDayPicker(
                    selectedDays: state.selectedDays,
                    onToggle: controller.toggleDay,
                    shortLabelBuilder: (d) => _dayShortLabel(d, l10n),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: divider,
                ),
              ),

              // --- Exercise library --------------------------------------
              SliverToBoxAdapter(
                child: _SectionTitle(
                  '2. ${l10n.createRoutineChooseExercises}',
                  ext: ext,
                  theme: theme,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) => setState(() => _query = value),
                        decoration: InputDecoration(
                          hintText: l10n.searchHint,
                          prefixIcon: const Icon(Icons.search_rounded),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: MuscleGroup.values.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final group = MuscleGroup.values[index];
                            return WorkoutPill(
                              label: _muscleGroupLabel(group, l10n),
                              selected: _muscleFilter == group,
                              onTap:
                                  () => setState(() => _muscleFilter = group),
                              appearance: WorkoutPillAppearance.filter,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (request.isLoading || request.hasError || library.isEmpty)
                SliverToBoxAdapter(
                  child: WorkoutStatus(
                    loading: request.isLoading,
                    error: request.error,
                    onRetry: controller.retryLibrary,
                  ),
                ),
              SliverList.separated(
                itemCount: library.length,
                separatorBuilder: (context, index) => divider,
                itemBuilder: (context, index) {
                  final entry = library[index];
                  final isAdded = controller.isSelected(entry.id);
                  return ExerciseListTile(
                    image: entry.image,
                    name: entry.localizedName(context),
                    muscleGroup: _muscleGroupLabel(entry.muscleGroup, l10n),
                    setsRepsLabel: l10n.createRoutineSetsReps(
                      entry.defaultSets,
                      entry.defaultReps,
                    ),
                    isFavorite: entry.isFavorite,
                    isAdded: isAdded,
                    onFavoriteTap: () => controller.toggleFavorite(entry.id),
                    onAddTap: () => controller.toggleExercise(entry.id),
                  );
                },
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: divider,
                ),
              ),

              // --- My routine ---------------------------------------------
              SliverToBoxAdapter(
                child: _SectionTitle(
                  '3. ${l10n.createRoutineMyRoutineTitle}',
                  ext: ext,
                  theme: theme,
                ),
              ),
              if (state.selected.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        l10n.createRoutineMyRoutineEmpty,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ext.textMuted, fontSize: 12.5),
                      ),
                    ),
                  ),
                )
              else
                SliverReorderableList(
                  itemCount: state.selected.length,
                  onReorderItem: controller.reorder,
                  itemBuilder: (context, index) {
                    final selection = state.selected[index];
                    final entry = state.libraryEntry(selection.exerciseId);
                    return Container(
                      key: ValueKey(selection.exerciseId),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              index == state.selected.length - 1
                                  ? BorderSide.none
                                  : BorderSide(color: ext.glassBorder),
                        ),
                      ),
                      child: SelectedExerciseItem(
                        image: entry.image,
                        name: '${index + 1}. ${entry.localizedName(context)}',
                        sets: selection.sets,
                        reps: selection.reps,
                        setsLabel: l10n.createRoutineSetsLabel,
                        repsLabel: l10n.createRoutineRepsLabel,
                        onSetsChanged:
                            (delta) => controller.updateSets(
                              selection.exerciseId,
                              delta,
                            ),
                        onRepsChanged:
                            (delta) => controller.updateReps(
                              selection.exerciseId,
                              delta,
                            ),
                        onRemove:
                            () =>
                                controller.removeExercise(selection.exerciseId),
                        dragHandle: ReorderableDragStartListener(
                          index: index,
                          child: Icon(
                            Icons.drag_handle_rounded,
                            color: ext.textMuted,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text, {required this.ext, required this.theme});

  final String text;
  final AppThemeExtension ext;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.titleLarge?.copyWith(
        color: ext.textPrimary,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {required this.ext});

  final String text;
  final AppThemeExtension ext;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: ext.textMuted,
        fontWeight: FontWeight.w800,
        fontSize: 12.5,
        letterSpacing: 0.2,
      ),
    );
  }
}

/// A borderless, underline-only text field — replaces the filled/boxed
/// input the previous card-based design used, matching the flatter,
/// more editorial feel of the redesigned page.
class _UnderlinedField extends StatelessWidget {
  const _UnderlinedField({
    required this.controller,
    required this.hint,
    required this.ext,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final AppThemeExtension ext;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(
        color: ext.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
      cursorColor: ext.accentGlow,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: ext.textMuted, fontWeight: FontWeight.w500),
        isDense: true,
        contentPadding: const EdgeInsets.only(bottom: 10),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: ext.glassBorder),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ext.glassBorder),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ext.accentGlow, width: 2),
        ),
      ),
    );
  }
}
