import 'package:nabvera/core/localization/generated/app_localizations.dart';
import 'package:nabvera/core/responsive/app_responsive.dart';
import 'package:nabvera/core/theme/app_colors.dart';
import 'package:nabvera/core/theme/app_spacing.dart';
import 'package:nabvera/core/theme/app_theme_extension.dart';
import 'package:nabvera/core/widgets/fade_slide_in.dart';
import 'package:nabvera/core/widgets/premium_scaffold.dart';
import 'package:nabvera/core/widgets/primary_button.dart';
import 'package:nabvera/features/workout/domain/workout_models.dart';
import 'package:nabvera/features/workout/presentation/providers/create_routine_controller.dart';
import 'package:nabvera/features/workout/presentation/providers/your_routine_controller.dart';
import 'package:nabvera/features/workout/presentation/widgets/difficulty_selector.dart';
import 'package:nabvera/features/workout/presentation/widgets/exercise_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/goal_selector.dart';
import 'package:nabvera/features/workout/presentation/widgets/routine_header.dart';
import 'package:nabvera/features/workout/presentation/widgets/routine_summary_card.dart';
import 'package:nabvera/features/workout/presentation/widgets/selected_exercise_item.dart';
import 'package:nabvera/features/workout/presentation/widgets/workout_day_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateRoutinePage extends ConsumerStatefulWidget {
  const CreateRoutinePage({super.key});

  @override
  ConsumerState<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends ConsumerState<CreateRoutinePage> {
  late final TextEditingController _nameController;
  bool _creating = false;
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

  Widget _buildExerciseCard({
    required CreateRoutineState state,
    required CreateRoutineController controller,
    required AppLocalizations l10n,
    required int index,
  }) {
    final entry = state.library[index];
    final isAdded = controller.isSelected(entry.id);
    return ExerciseCard(
      image: entry.image,
      name: entry.name,
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
  }

  Future<void> _handleCreate(
    CreateRoutineController controller,
    CreateRoutineState state,
    AppLocalizations l10n,
  ) async {
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
    });
    try {
      await controller.create(name);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.createRoutineSuccessMessage)),
      );
      ref.invalidate(yourRoutineControllerProvider);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authErrorGeneric)));
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

    return PremiumScaffold(
      padding: EdgeInsets.zero,
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
            // Two columns once there's enough room per card (tablets, or a
            // phone in landscape) so exercise rows don't stretch too wide.
            final exerciseColumns =
                (width - horizontalPadding * 2) >= 640 ? 2 : 1;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: _buildScrollView(
                  context: context,
                  state: state,
                  controller: controller,
                  theme: theme,
                  ext: ext,
                  l10n: l10n,
                  horizontalPadding: horizontalPadding,
                  exerciseColumns: exerciseColumns,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScrollView({
    required BuildContext context,
    required CreateRoutineState state,
    required CreateRoutineController controller,
    required ThemeData theme,
    required AppThemeExtension ext,
    required AppLocalizations l10n,
    required double horizontalPadding,
    required int exerciseColumns,
  }) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            18,
            horizontalPadding,
            20,
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
              SliverToBoxAdapter(
                child: FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: ext.glassFill,
                        borderRadius: BorderRadius.circular(AppRadius.card),
                        border: Border.all(color: ext.glassBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.createRoutineNameLabel,
                            style: TextStyle(
                              color: ext.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _nameController,
                            onChanged: (value) {
                              controller.setName(value);
                              if (_validationError != null) {
                                setState(() => _validationError = null);
                              }
                            },
                            style: TextStyle(color: ext.textPrimary),
                            decoration: InputDecoration(
                              hintText: l10n.createRoutineNameHint,
                              hintStyle: TextStyle(color: ext.textMuted),
                              filled: true,
                              fillColor: ext.cardColor,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: ext.glassBorder),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(color: ext.glassBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                  color: AppColors.seedLime,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.createRoutineGoalLabel,
                            style: TextStyle(
                              color: ext.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GoalSelector(
                            selected: state.goal,
                            onChanged: controller.setGoal,
                            labelBuilder: (g) => _goalLabel(g, l10n),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.workoutDifficultyLabel,
                            style: TextStyle(
                              color: ext.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 10),
                  child: Text(
                    l10n.createRoutineDaysLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: WorkoutDayPicker(
                  selectedDays: state.selectedDays,
                  onToggle: controller.toggleDay,
                  shortLabelBuilder: (d) => _dayShortLabel(d, l10n),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 10),
                  child: Text(
                    l10n.createRoutineChooseExercises,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (exerciseColumns == 1)
                SliverList.separated(
                  itemCount: state.library.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 10),
                  itemBuilder:
                      (context, index) => _buildExerciseCard(
                        state: state,
                        controller: controller,
                        l10n: l10n,
                        index: index,
                      ),
                )
              else
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 88,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildExerciseCard(
                      state: state,
                      controller: controller,
                      l10n: l10n,
                      index: index,
                    ),
                    childCount: state.library.length,
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 22, bottom: 10),
                  child: Text(
                    l10n.createRoutineMyRoutineTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ext.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (state.selected.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: ext.glassFill,
                      borderRadius: BorderRadius.circular(AppRadius.card),
                      border: Border.all(color: ext.glassBorder),
                    ),
                    child: Text(
                      l10n.createRoutineMyRoutineEmpty,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ext.textMuted, fontSize: 12.5),
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
                    return Padding(
                      key: ValueKey(selection.exerciseId),
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SelectedExerciseItem(
                        image: entry.image,
                        name: entry.name,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: RoutineSummaryCard(
                    title: l10n.createRoutineSummaryTitle,
                    exercisesLabel: l10n.createRoutineSummaryExercises,
                    exercisesValue: '${state.selected.length}',
                    durationLabel: l10n.createRoutineSummaryDuration,
                    durationValue: '${state.totalDurationMinutes} min',
                    caloriesLabel: l10n.createRoutineSummaryCalories,
                    caloriesValue: '${state.estimatedCalories}',
                    daysLabel: l10n.createRoutineSummaryDays,
                    daysValue: '${state.selectedDays.length}',
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_validationError != null) ...[
                      Text(
                        _validationError!,
                        style: TextStyle(color: ext.danger, fontSize: 12.5),
                      ),
                      const SizedBox(height: 10),
                    ],
                    PrimaryButton(
                      label: l10n.workoutCreateRoutine,
                      isLoading: _creating,
                      onPressed: () => _handleCreate(controller, state, l10n),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
