// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navWorkout => 'Workout';

  @override
  String get navNutrition => 'Nutrition';

  @override
  String get navCommunity => 'Community';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionRetry => 'Retry';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get errorGenericTitle => 'Something went wrong';

  @override
  String get emptyGenericTitle => 'Nothing here yet';

  @override
  String get loadingLabel => 'Loading...';

  @override
  String get authLoginTitle => 'Log In';

  @override
  String get authWelcomeTitle => 'Welcome';

  @override
  String get authWelcomeSubtitle =>
      'Log in to continue and track your fitness journey';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authWelcomeBackTitle => 'Welcome back, athlete.';

  @override
  String get authWelcomeBackBody =>
      'Pick up your streak, review your progress, and make today count.';

  @override
  String get authOrContinueWith => 'or continue with';

  @override
  String get authCreateAccount => 'Create account';

  @override
  String get authTrainingMode => 'TRAINING MODE';

  @override
  String get authEmailHint => 'you@example.com';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authSignupTitle => 'Create Account';

  @override
  String get authSignupSubtitle => 'Let\'s Start!';

  @override
  String get authOrSignUpWith => 'or sign up with';

  @override
  String get authNoAccount => 'Don\'t have an account? ';

  @override
  String get authHaveAccount => 'Already have an account? ';

  @override
  String get authSignUp => 'Sign Up';

  @override
  String get authLogIn => 'Log in';

  @override
  String get authFullName => 'Full Name';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authForgotPasswordTitle => 'Forgotten Password';

  @override
  String get authForgotPasswordHeading => 'Forgot Password?';

  @override
  String get authForgotPasswordBody =>
      'Enter your email to receive instructions on how to reset your password.';

  @override
  String get authSetPasswordTitle => 'Set Password';

  @override
  String get authSetPasswordBody =>
      'Set your new password to secure your account and continue your fitness journey.';

  @override
  String get authResetPassword => 'Reset Password';

  @override
  String get authStartTraining => 'Start Training';

  @override
  String get authNewSeason => 'NEW SEASON';

  @override
  String get authSignupHeroTitle => 'Let\'s build your strongest routine.';

  @override
  String get authSignupHeroBody =>
      'Create your profile and unlock plans shaped around your goals.';

  @override
  String get authFullNameHint => 'Your full name';

  @override
  String get authPasswordCreateHint => 'Create a strong password';

  @override
  String get authConfirmPasswordHint => 'Re-enter your password';

  @override
  String get authRecoveryHeadline => 'Reset without losing momentum.';

  @override
  String get authRecoveryBody =>
      'Enter your email and we will guide you through creating a new secure password.';

  @override
  String get authSetPasswordHeadline => 'Create your new training key.';

  @override
  String get authNewPassword => 'New Password';

  @override
  String get authNewPasswordHint => 'Enter new password';

  @override
  String get authConfirmNewPasswordHint => 'Re-enter new password';

  @override
  String get authBiometricTitle => 'Biometric Access';

  @override
  String get authBiometricHeadline => 'Unlock your plan faster.';

  @override
  String get authBiometricBody =>
      'Add fingerprint access for a secure, frictionless start before every workout.';

  @override
  String get authEnableFingerprint => 'Enable Fingerprint';

  @override
  String get authSkipForNow => 'Skip for now';

  @override
  String get authErrorInvalidEmail => 'That email address looks invalid';

  @override
  String get authErrorUserNotFound => 'No account found with that email';

  @override
  String get authErrorWrongPassword => 'Incorrect email or password';

  @override
  String get authErrorEmailInUse => 'An account already exists with this email';

  @override
  String get authErrorWeakPassword => 'Password is too weak';

  @override
  String get authErrorNetwork => 'Network error, please check your connection';

  @override
  String get authErrorGoogleCancelled => 'Google sign-in was cancelled';

  @override
  String get authErrorGeneric => 'Something went wrong, please try again';

  @override
  String get authResetEmailSent =>
      'Password reset link sent — check your inbox';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authRememberMe => 'Remember me';

  @override
  String get authAgreeTermsPrefix => 'I agree to the ';

  @override
  String get authAgreeTermsAnd => ' and ';

  @override
  String get authTermsRequired =>
      'Please accept the Terms and Privacy Policy to continue';

  @override
  String get authCheckYourEmail => 'Check your email';

  @override
  String authResetLinkSentTo(String email) {
    return 'We sent a password reset link to $email';
  }

  @override
  String get authResendLink => 'Resend link';

  @override
  String authResendLinkIn(int seconds) {
    return 'Resend in ${seconds}s';
  }

  @override
  String get authChangeEmail => 'Change email';

  @override
  String get authBackToLogin => 'Back to login';

  @override
  String get authBiometricEnableSuccess => 'Biometric unlock enabled';

  @override
  String get authBiometricEnableFailed =>
      'Couldn\'t verify your biometrics — try again';

  @override
  String get authBiometricUnlockTitle => 'Unlock Nabvera';

  @override
  String get authBiometricUnlockBody => 'Confirm it\'s you to continue.';

  @override
  String get authBiometricUnlockCta => 'Unlock';

  @override
  String get authBiometricLogout => 'Log out instead';

  @override
  String get authBiometricRetry => 'Try again';

  @override
  String get onboardingSetupTimeNote =>
      'Personal setup takes less than a minute';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Please enter a valid email';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String get validationPasswordTooShort =>
      'Password must be at least 8 characters long';

  @override
  String get validationFieldRequired => 'This field is required';

  @override
  String get validationFullNameRequired => 'Full name is required';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get splashBrandName => 'Nabvera';

  @override
  String get splashTagline => 'Fitness + strength + health + progress.';

  @override
  String get splashMetricWorkouts => 'Workouts';

  @override
  String get splashMetricPlans => 'Plans';

  @override
  String get welcomeTagline => 'Your premium training dashboard is ready.';

  @override
  String get welcomeBadgeEnergy => 'Energy';

  @override
  String get welcomeBadgeProgress => 'Progress';

  @override
  String get welcomeCtaStart => 'Start Now';

  @override
  String get welcomeHaveAccount => 'I have an account, log in';

  @override
  String get onboardingBrand => 'NABVERA';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingSlide1Kicker => 'START STRONG';

  @override
  String get onboardingSlide1Title =>
      'Build a body that keeps up with your ambition.';

  @override
  String get onboardingSlide1Description =>
      'Personalized training flows help you start today and stay consistent tomorrow.';

  @override
  String get onboardingSlide2Kicker => 'TRAIN SMARTER';

  @override
  String get onboardingSlide2Title =>
      'Find strength, cardio, and functional sessions fast.';

  @override
  String get onboardingSlide2Description =>
      'Choose the right intensity for your day and move with confidence.';

  @override
  String get onboardingSlide3Kicker => 'TRACK EVERY REP';

  @override
  String get onboardingSlide3Title =>
      'See your workouts, streaks, and progress in one place.';

  @override
  String get onboardingSlide3Description =>
      'Turn effort into insight with daily metrics and clear performance feedback.';

  @override
  String get onboardingSlide4Kicker => 'REACH GOALS';

  @override
  String get onboardingSlide4Title =>
      'Healthy habits become your unfair advantage.';

  @override
  String get onboardingSlide4Description =>
      'Stay motivated with progress milestones, challenges, and routines built for real life.';

  @override
  String get onboardingGenderTitle => 'What\'s Your Gender';

  @override
  String get onboardingGenderBody =>
      'Select your gender to personalize your fitness plan and track your progress more accurately.';

  @override
  String get onboardingAgeTitle => 'How Old Are You?';

  @override
  String get onboardingAgeBody =>
      'Select your age to personalize your fitness plan and track your progress.';

  @override
  String get onboardingWeightTitle => 'What Is Your Weight?';

  @override
  String get onboardingWeightBody =>
      'Enter your weight to personalize your fitness plan and track your progress accurately.';

  @override
  String get onboardingHeightTitle => 'What Is Your Height';

  @override
  String get onboardingHeightBody =>
      'Enter your height to personalize your fitness plan and track your progress accurately.';

  @override
  String get onboardingGoalTitle => 'What Is Your Goal?';

  @override
  String get onboardingGoalBody =>
      'Choose your fitness goal to personalize your workout and diet plan.';

  @override
  String get onboardingPhysicalTitle => 'Physical Activity Level';

  @override
  String get onboardingPhysicalBody =>
      'Select your physical activity level to personalize your fitness plan.';

  @override
  String get onboardingFillProfileTitle => 'Fill Your Profile';

  @override
  String get onboardingFillProfileBody =>
      'Complete your profile information to personalize your experience.';

  @override
  String get onboardingStart => 'Start';

  @override
  String get onboardingMale => 'Male';

  @override
  String get onboardingFemale => 'Female';

  @override
  String get onboardingNickname => 'Nickname';

  @override
  String get onboardingNicknameHint => 'How should we call you?';

  @override
  String get onboardingMobileHint => '+123 567 89000';

  @override
  String get setupIntroHeadline =>
      'Consistency Is\nthe Key To Progress.\nDon\'t Give Up!';

  @override
  String get setupIntroBody =>
      'Start your fitness journey today!\nTrack your progress, stay consistent, and achieve your goals step by step.';

  @override
  String get setupIntroCta => 'Let\'s Get Started';

  @override
  String get goalLoseWeight => 'Lose Weight';

  @override
  String get goalGainWeight => 'Gain Weight';

  @override
  String get goalMuscleMassGain => 'Muscle Mass Gain';

  @override
  String get goalShapeBody => 'Shape Body';

  @override
  String get goalOthers => 'Others';

  @override
  String get unitKg => 'Kg';

  @override
  String get unitCm => 'cm';

  @override
  String homeGreeting(String name) {
    return 'Good Morning, $name';
  }

  @override
  String homeGreetingMorning(String name) {
    return 'Good Morning, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good Afternoon, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good Evening, $name';
  }

  @override
  String get homeGreetingMorningPlain => 'Good Morning';

  @override
  String get homeGreetingAfternoonPlain => 'Good Afternoon';

  @override
  String get homeGreetingEveningPlain => 'Good Evening';

  @override
  String get homeTagline => 'Train hard. Recover smart. Repeat.';

  @override
  String homeStreakDays(int days) {
    return '$days-day streak';
  }

  @override
  String get homeTodayPlanLabel => 'TODAY PLAN';

  @override
  String get homeWorkoutCategories => 'Workout Categories';

  @override
  String get actionExplore => 'Explore';

  @override
  String get homeRecommended => 'Recommended';

  @override
  String get actionSeeAll => 'See All';

  @override
  String get homeRecommendedBadge => 'RECOMMENDED';

  @override
  String get homeWeeklyProgress => 'Weekly Progress';

  @override
  String homeWeeklyProgressSummary(int workouts, int sessions) {
    return '$workouts workouts completed · $sessions recovery sessions planned';
  }

  @override
  String get homeArticlesAndTips => 'Articles & Tips';

  @override
  String get homeHeroTitle => 'Upper Body Strength';

  @override
  String homeHeroSubtitle(int minutes, int moves, String level) {
    return '$minutes min · $moves movements · $level intensity';
  }

  @override
  String homeHeroDuration(int minutes) {
    return '$minutes min';
  }

  @override
  String homeHeroCalories(int kcal) {
    return '~$kcal kcal';
  }

  @override
  String homeWeeklyProgressPercent(int percent) {
    return '$percent%';
  }

  @override
  String get homeMetricCalories => 'Calories';

  @override
  String get homeMetricSteps => 'Steps';

  @override
  String get homeMetricDuration => 'Duration';

  @override
  String get homeUnitKcal => 'kcal';

  @override
  String get homeUnitToday => 'today';

  @override
  String get homeUnitMin => 'min';

  @override
  String get homeCtaStart => 'Start Workout';

  @override
  String get homeCtaContinue => 'Continue Workout';

  @override
  String get homeCtaCompleted => 'Workout Completed';

  @override
  String homeHeroCompletionPercent(int percent) {
    return '$percent% done';
  }

  @override
  String homeHeroExercises(int count) {
    return '$count exercises';
  }

  @override
  String homeCaloriesConsumedOf(int consumed, int goal) {
    return '$consumed of $goal kcal';
  }

  @override
  String homeCaloriesRemaining(int remaining) {
    return '$remaining kcal left';
  }

  @override
  String get homeCaloriesGoalReached => 'Goal reached';

  @override
  String homeActivityProgress(int done, int goal) {
    return '$done of $goal min';
  }

  @override
  String get homeStreakStartMessage => 'Start your streak today';

  @override
  String get homeStreakKeepGoing => 'Keep it going!';

  @override
  String get homeStreakOnFire => 'You\'re on fire!';

  @override
  String get homeNextStepTitle => 'Your Next Step';

  @override
  String get homeNextStepDrinkWater => 'Drink a glass of water';

  @override
  String get homeNextStepStartWorkout => 'Start today\'s workout';

  @override
  String get homeNextStepLogMeal => 'Log your next meal';

  @override
  String get homeNextStepAllDone => 'You crushed today — keep it up!';

  @override
  String get homeNextStepGo => 'Go';

  @override
  String homeWeeklyGoalSummary(int done, int goal) {
    return '$done of $goal workouts this week';
  }

  @override
  String get homeWeeklyRestDay => 'Rest day';

  @override
  String get homeDayMon => 'Mon';

  @override
  String get homeDayTue => 'Tue';

  @override
  String get homeDayWed => 'Wed';

  @override
  String get homeDayThu => 'Thu';

  @override
  String get homeDayFri => 'Fri';

  @override
  String get homeDaySat => 'Sat';

  @override
  String get homeDaySun => 'Sun';

  @override
  String get homeRecommendedError => 'Couldn\'t load recommendations';

  @override
  String get homeArticlesError => 'Couldn\'t load articles';

  @override
  String get homeRecommendedEmpty => 'No recommendations yet';

  @override
  String get homeArticlesEmpty => 'No articles yet';

  @override
  String get workoutTitle => 'Train';

  @override
  String get workoutSubtitle => 'Pick your level and move with purpose.';

  @override
  String get workoutYourRoutine => 'Your Routine';

  @override
  String get workoutCreateRoutine => 'Create Routine';

  @override
  String get workoutTrainingOfTheDay => 'training of the day';

  @override
  String get workoutStartWorkout => 'Start Workout';

  @override
  String get workoutNoVideoAvailable =>
      'No video available for this exercise yet';

  @override
  String get workoutDifficultyLabel => 'Difficulty';

  @override
  String get workoutMuscleGroupLabel => 'Muscle Group';

  @override
  String get workoutEquipmentLabel => 'Equipment';

  @override
  String get workoutCategoryAll => 'All';

  @override
  String get workoutCategoryChest => 'Chest';

  @override
  String get workoutCategoryBack => 'Back';

  @override
  String get workoutCategoryLegs => 'Legs';

  @override
  String get workoutCategoryArms => 'Arms';

  @override
  String get workoutCategoryCardio => 'Cardio';

  @override
  String get workoutCategoryStrength => 'Strength';

  @override
  String get workoutBannerTitle => '🔥 Keep your consistency';

  @override
  String get workoutBannerBody => 'Every workout makes you stronger';

  @override
  String get workoutBannerCta => 'Start Now';

  @override
  String get workoutLevelBeginner => 'Beginner';

  @override
  String get workoutLevelIntermediate => 'Intermediate';

  @override
  String get workoutLevelAdvanced => 'Advanced';

  @override
  String get workoutRecommendationsTitle => 'Recommendations';

  @override
  String get workoutMostPopular => 'Most Popular';

  @override
  String get workoutWeeklyChallengeTitle => 'Weekly Challenge';

  @override
  String workoutRoundNumber(int number) {
    return 'Round $number';
  }

  @override
  String get workoutCreateRoutineTitle => 'Create your routine';

  @override
  String get workoutCreateRoutineSubtitle =>
      'Pick exercises and build your next training flow.';

  @override
  String get workoutYourRoutineTitle => 'Your Routine';

  @override
  String get workoutYourRoutineSubtitle =>
      'Tap any exercise to preview details and start moving.';

  @override
  String get workoutProfileAge => 'Age';

  @override
  String get workoutProfileWeight => 'Weight';

  @override
  String get workoutProfileHeight => 'Height';

  @override
  String get createRoutineSubtitle => 'Build your personalized workout plan';

  @override
  String get createRoutineMotivation =>
      '🔥 Every great transformation starts with a plan';

  @override
  String get createRoutineNameLabel => 'Routine Name';

  @override
  String get createRoutineNameHint => 'Push Day Workout';

  @override
  String get createRoutineGoalLabel => 'Goal';

  @override
  String get routineGoalMuscleGain => 'Muscle Gain';

  @override
  String get routineGoalFatLoss => 'Fat Loss';

  @override
  String get routineGoalStrength => 'Strength';

  @override
  String get routineGoalEndurance => 'Endurance';

  @override
  String get createRoutineDaysLabel => 'Workout Days';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayMondayShort => 'Mon';

  @override
  String get weekdayTuesdayShort => 'Tue';

  @override
  String get weekdayWednesdayShort => 'Wed';

  @override
  String get weekdayThursdayShort => 'Thu';

  @override
  String get weekdayFridayShort => 'Fri';

  @override
  String get weekdaySaturdayShort => 'Sat';

  @override
  String get weekdaySundayShort => 'Sun';

  @override
  String get createRoutineChooseExercises => 'Choose Exercises';

  @override
  String get createRoutineMyRoutineTitle => 'My Routine';

  @override
  String get createRoutineMyRoutineEmpty =>
      'No exercises added yet. Tap + on any exercise to add it here.';

  @override
  String get createRoutineSetsLabel => 'Sets';

  @override
  String get createRoutineRepsLabel => 'Reps';

  @override
  String createRoutineSetsReps(int sets, int reps) {
    return '$sets Sets × $reps Reps';
  }

  @override
  String get createRoutineSummaryTitle => 'Routine Summary';

  @override
  String get createRoutineSummaryExercises => 'Exercises';

  @override
  String get createRoutineSummaryDuration => 'Duration';

  @override
  String get createRoutineSummaryCalories => 'Calories';

  @override
  String get createRoutineSummaryDays => 'Training Days';

  @override
  String get createRoutineNameValidation => 'Please enter a routine name';

  @override
  String get createRoutineExerciseValidation => 'Add at least one exercise';

  @override
  String get createRoutineSuccessMessage => 'Routine created successfully!';

  @override
  String get progressTitle => 'Progress Tracking';

  @override
  String get progressTabLogs => 'Workout Log';

  @override
  String get progressTabCharts => 'Charts';

  @override
  String get progressActivities => 'Activities';

  @override
  String get progressEmptyState => 'No activity logged yet.';

  @override
  String get progressChooseDate => 'Choose Date';

  @override
  String get progressMonth => 'Month';

  @override
  String get progressDuration => 'Duration';

  @override
  String get progressMyProgress => 'My Progress';

  @override
  String get progressSteps => 'Steps';

  @override
  String get progressWeeklyOverview => 'This Week';

  @override
  String get progressStatSessions => 'Sessions';

  @override
  String get progressStatMinutes => 'Minutes';

  @override
  String get progressStatAvgSession => 'Avg / Session';

  @override
  String get progressRecentSessions => 'Recent Sessions';

  @override
  String get progressNoSessionsYet => 'No sessions this week';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsSubtitle =>
      'Stay motivated. Never miss your fitness journey.';

  @override
  String get notificationsMarkAllRead => 'Mark all as read';

  @override
  String get notificationsMarkAllReadDone => 'All notifications marked as read';

  @override
  String get notificationsFilterAll => 'All';

  @override
  String get notificationsFilterUnread => 'Unread';

  @override
  String get notificationsFilterWorkouts => 'Workouts';

  @override
  String get notificationsFilterChallenges => 'Challenges';

  @override
  String get notificationsFilterAchievements => 'Achievements';

  @override
  String get notificationsFilterNutrition => 'Nutrition';

  @override
  String get notificationsFilterReminders => 'Reminders';

  @override
  String get notificationsFilterCommunity => 'Community';

  @override
  String get notificationsGroupToday => 'Today';

  @override
  String get notificationsGroupYesterday => 'Yesterday';

  @override
  String get notificationsGroupEarlierThisWeek => 'Earlier This Week';

  @override
  String get notificationsGroupOlder => 'Older';

  @override
  String get notificationsEmptyTitle => 'No Notifications Yet';

  @override
  String get notificationsEmptyBody =>
      'Your workout reminders, achievements, nutrition updates, and progress will appear here.';

  @override
  String get notificationsStartWorkout => 'Start Workout';

  @override
  String get notificationsSwipeDeleted => 'Notification deleted';

  @override
  String get notificationsSwipeMarkedRead => 'Marked as read';

  @override
  String get notificationsUndo => 'Undo';

  @override
  String get notificationsTimeJustNow => 'Just now';

  @override
  String notificationsTimeMinutesAgo(int minutes) {
    return '${minutes}m ago';
  }

  @override
  String notificationsTimeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String notificationsTimeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get navSearch => 'Search';

  @override
  String get searchHint => 'Search workouts, meals, articles…';

  @override
  String get searchTabAll => 'All';

  @override
  String get searchTabWorkout => 'Workout';

  @override
  String get searchTabNutrition => 'Nutrition';

  @override
  String get searchWorkoutSuggestions => 'Workout Suggestions';

  @override
  String get searchNutritionSuggestions => 'Nutrition Suggestions';

  @override
  String get searchNoResultsTitle => 'No results found';

  @override
  String get searchNoResultsBody =>
      'Try a different keyword or browse a category instead.';

  @override
  String get navFavorites => 'Favorites';

  @override
  String get favoriteFilterAll => 'All';

  @override
  String get favoriteFilterWorkouts => 'Workouts';

  @override
  String get favoriteFilterNutrition => 'Nutrition';

  @override
  String get favoriteTagWorkout => 'WORKOUT';

  @override
  String get favoriteTagNutrition => 'NUTRITION';

  @override
  String get favoriteEmptyTitle => 'No favorites yet';

  @override
  String get favoriteEmptyBody =>
      'Tap the star on any workout or meal to save it here for quick access later.';

  @override
  String get favoriteBrowseWorkouts => 'Browse Workouts';

  @override
  String get favoriteBrowseNutrition => 'Browse Nutrition';

  @override
  String get profileMyProfile => 'My Profile';

  @override
  String get profileBirthdayLabel => 'Birthday: ';

  @override
  String get profileMotivation => 'Keep pushing, your journey continues 🔥';

  @override
  String get profileStatWorkouts => 'Workouts';

  @override
  String get profileStatCalories => 'Calories';

  @override
  String get profileStatDays => 'Training Days';

  @override
  String get profileStatStreak => 'Day Streak';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSectionPreferences => 'Preferences';

  @override
  String get profileMenuProfile => 'Profile';

  @override
  String get profileMenuProfileSubtitle => 'Update your personal information';

  @override
  String get profileMenuFavorite => 'Favorite';

  @override
  String get profileMenuFavoriteSubtitle => 'Your saved workouts and meals';

  @override
  String get profileMenuPrivacyPolicy => 'Privacy Policy';

  @override
  String get profileMenuPrivacyPolicySubtitle => 'Data, permissions & legal';

  @override
  String get profileMenuSetting => 'Setting';

  @override
  String get profileMenuSettingSubtitle => 'Customize your experience';

  @override
  String get profileMenuHelp => 'Help';

  @override
  String get profileMenuHelpSubtitle => 'FAQs & contact support';

  @override
  String get profileMenuLogout => 'Log out';

  @override
  String get profileMenuLogoutSubtitle => 'Sign out of your account';

  @override
  String get profileLogoutConfirm => 'Are you sure you want to\nlog out?';

  @override
  String get profileLogoutYes => 'Yes, logout';

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get editProfileFullName => 'Full Name';

  @override
  String get editProfileMobileNumber => 'Mobile Number';

  @override
  String get editProfileDateOfBirth => 'Date of Birth';

  @override
  String get editProfileWeight => 'Weight';

  @override
  String get editProfileHeight => 'Height';

  @override
  String get editProfileGenderLabel => 'Gender';

  @override
  String get editProfileGenderMale => 'Male';

  @override
  String get editProfileGenderFemale => 'Female';

  @override
  String get editProfileGenderOther => 'Other';

  @override
  String get editProfileUpdate => 'Update Profile';

  @override
  String get editProfileNameValidation => 'Please enter your name';

  @override
  String get editProfileSuccessMessage => 'Profile updated successfully!';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacySectionLegal => 'Legal';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicySubtitle => 'How we handle your data';

  @override
  String get privacyTerms => 'Terms & Conditions';

  @override
  String get privacyTermsSubtitle => 'Rules for using the app';

  @override
  String get privacySectionYourData => 'Your Data';

  @override
  String get privacyManagePersonalData => 'Manage Personal Data';

  @override
  String get privacyManagePersonalDataSubtitle =>
      'Permissions & data collection';

  @override
  String get privacyAppPermissions => 'App Permissions';

  @override
  String get privacyAppPermissionsSubtitle =>
      'Camera, location & notifications';

  @override
  String get privacyDataCollection => 'Data Collection';

  @override
  String get privacyDataCollectionSubtitle => 'Control what we track';

  @override
  String get privacyDownloadMyData => 'Download My Data';

  @override
  String get privacyDownloadMyDataSubtitle => 'Export a copy of your data';

  @override
  String get privacySectionAccount => 'Account';

  @override
  String get privacyDeleteAccount => 'Delete My Account';

  @override
  String get privacyDeleteAccountSubtitle => 'Permanently remove your account';

  @override
  String get privacyContactSupport => 'Contact Support';

  @override
  String get privacyContactSupportSubtitle => 'Get help from our team';

  @override
  String privacyComingSoon(String feature) {
    return '$feature coming soon';
  }

  @override
  String get privacyDeleteConfirmTitle => 'Delete your account?';

  @override
  String get privacyDeleteConfirmBody =>
      'This permanently removes your profile, workout history, and saved data. This action cannot be undone.';

  @override
  String get privacyDelete => 'Delete';

  @override
  String get legalPrivacyPolicyBody =>
      'We collect only the information needed to run your training plan: your profile details, workout and nutrition activity, and device settings like theme and language. This data is stored securely and is never sold to third parties.\n\nYou can review, export, or delete your data at any time from Profile → Privacy → Manage Your Data. Analytics are aggregated and anonymized before use, and you can opt out at any time from the same screen.\n\nIf you have questions about how your data is handled, reach out from Profile → Help & FAQs → Contact Us.';

  @override
  String get legalTermsBody =>
      'By using Nabvera you agree to use the app for personal fitness tracking only, keep your account credentials secure, and respect the community guidelines when posting in Community.\n\nWorkout and nutrition guidance in this app is for general informational purposes and is not a substitute for professional medical advice — consult a physician before starting a new fitness or nutrition program.\n\nWe may update these terms as the app evolves; continued use after an update means you accept the revised terms. You can delete your account at any time from Profile → Delete My Account.';

  @override
  String get manageDataTitle => 'Manage Your Data';

  @override
  String get manageDataPermissionsSection => 'App Permissions';

  @override
  String get manageDataCameraAccess => 'Camera';

  @override
  String get manageDataCameraAccessBody =>
      'Used to update your profile picture.';

  @override
  String get manageDataLocationAccess => 'Location';

  @override
  String get manageDataLocationAccessBody =>
      'Used to suggest nearby outdoor routes.';

  @override
  String get manageDataNotificationsAccess => 'Notifications';

  @override
  String get manageDataNotificationsAccessBody =>
      'Used for reminders and progress updates.';

  @override
  String get manageDataCollectionSection => 'Data Collection';

  @override
  String get manageDataAnalyticsToggle => 'Usage Analytics';

  @override
  String get manageDataAnalyticsToggleBody =>
      'Helps us improve workouts and recommendations.';

  @override
  String get manageDataPersonalizedToggle => 'Personalized Recommendations';

  @override
  String get manageDataPersonalizedToggleBody =>
      'Uses your activity to tailor suggested workouts.';

  @override
  String get manageDataExportSection => 'Your Data';

  @override
  String get manageDataExportBody =>
      'Download a copy of your profile, workout history, and nutrition logs.';

  @override
  String get manageDataExportAction => 'Request Export';

  @override
  String get manageDataExportConfirmation =>
      'Your data export has been requested. We\'ll notify you when it\'s ready.';

  @override
  String get helpContactCustomerService => 'Customer Service';

  @override
  String get helpContactWebsite => 'Website';

  @override
  String get helpContactWhatsapp => 'WhatsApp';

  @override
  String get helpContactFacebook => 'Facebook';

  @override
  String get helpContactInstagram => 'Instagram';

  @override
  String helpContactCopied(String value) {
    return 'Copied: $value';
  }

  @override
  String get helpFaqQ1 => 'How do I create a custom workout routine?';

  @override
  String get helpFaqA1 =>
      'Go to Workout → Create Routine, then pick exercises from the list to build your own routine. Tap the star to favorite exercises you use often.';

  @override
  String get helpFaqQ2 => 'How is my daily calorie goal calculated?';

  @override
  String get helpFaqA2 =>
      'We use the age, weight, height, and activity level you entered during setup. You can update these anytime from Profile → Edit Profile.';

  @override
  String get helpFaqQ3 => 'Can I switch between light and dark mode?';

  @override
  String get helpFaqA3 =>
      'Yes — go to Profile → Settings → Theme and choose Light, Dark, or System to follow your device automatically.';

  @override
  String get helpFaqQ4 => 'How do I change the app language?';

  @override
  String get helpFaqA4 =>
      'Go to Profile → Settings → Language, or use the language toggle shown on the sign-in and onboarding screens.';

  @override
  String get helpFaqQ5 => 'How do I delete my account?';

  @override
  String get helpFaqA5 =>
      'Go to Profile → Privacy Policy → Delete My Account. This permanently removes your profile, workout history, and saved data.';

  @override
  String get notificationSettingsTitle => 'Notification Setting';

  @override
  String get notificationSettingsSubtitle =>
      'Choose how Nabvera keeps you in the loop';

  @override
  String get notificationToggleGeneral => 'General Notification';

  @override
  String get notificationToggleGeneralBody =>
      'Workout, nutrition & community updates';

  @override
  String get notificationToggleSound => 'Sound';

  @override
  String get notificationToggleSoundBody =>
      'Play a sound for new notifications';

  @override
  String get notificationToggleDoNotDisturb => 'Don\'t Disturb Mode';

  @override
  String get notificationToggleDoNotDisturbBody =>
      'Silence notifications during quiet hours';

  @override
  String get notificationToggleVibrate => 'Vibrate';

  @override
  String get notificationToggleVibrateBody =>
      'Vibrate the device on new alerts';

  @override
  String get notificationToggleLockScreen => 'Lock Screen';

  @override
  String get notificationToggleLockScreenBody =>
      'Show previews on the lock screen';

  @override
  String get notificationToggleReminders => 'Reminders';

  @override
  String get notificationToggleRemindersBody =>
      'Daily workout & meal reminders';

  @override
  String get passwordSettingsTitle => 'Password Setting';

  @override
  String get passwordSettingsSubtitle =>
      'Keep your account safe with a strong password';

  @override
  String get passwordCurrentPassword => 'Current Password';

  @override
  String get passwordForgot => 'Forgot Password?';

  @override
  String get passwordNew => 'New password';

  @override
  String get passwordConfirmNew => 'Confirm New password';

  @override
  String get passwordCurrentValidation => 'Enter your current password';

  @override
  String get passwordNewValidation => 'Enter a new password';

  @override
  String get passwordMinLengthValidation =>
      'Password must be at least 8 characters';

  @override
  String get passwordMismatchValidation => 'Passwords do not match';

  @override
  String get passwordStrengthWeak => 'Weak';

  @override
  String get passwordStrengthMedium => 'Medium';

  @override
  String get passwordStrengthStrong => 'Strong';

  @override
  String get passwordUpdateAction => 'Update Password';

  @override
  String get passwordUpdateSuccess => 'Password updated successfully!';

  @override
  String get documentsTitle => 'Documents';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Customize your experience';

  @override
  String get settingsSectionAccount => 'Account';

  @override
  String get settingsNotification => 'Notification Setting';

  @override
  String get settingsNotificationSubtitle => 'Manage your workout reminders';

  @override
  String get settingsPassword => 'Password Setting';

  @override
  String get settingsPasswordSubtitle => 'Update your account password';

  @override
  String get settingsDeleteAccount => 'Delete Account';

  @override
  String get settingsDeleteAccountSubtitle => 'Permanently remove your account';

  @override
  String get helpTitle => 'Help & FAQs';

  @override
  String get helpHowCanWeHelp => 'How can we help you?';

  @override
  String get helpFaqTab => 'FAQ';

  @override
  String get helpContactUsTab => 'Contact Us';

  @override
  String get helpTabGeneral => 'General';

  @override
  String get helpTabAccount => 'Account';

  @override
  String get helpTabServices => 'Services';

  @override
  String get helpSearchHint => 'Search';

  @override
  String get helpFaqPlaceholder => 'Lorem ipsum dolor sit amet?';

  @override
  String get nutritionSubtitle =>
      'Fuel your training with meals that actually fit your day.';

  @override
  String get nutritionTabMealPlans => 'Meal Plans';

  @override
  String get nutritionTabMealIdeas => 'Meal Ideas';

  @override
  String get nutritionRecipeOfTheDay => 'Recipe of the day';

  @override
  String get nutritionFeaturedRecipeName => 'Carrot and orange smoothie';

  @override
  String get nutritionFeaturedRecipeDuration => '10 Minutes';

  @override
  String get nutritionFeaturedRecipeCalories => '70 Cal';

  @override
  String get nutritionRecommended => 'Recommended';

  @override
  String get nutritionRecipesForYou => 'Recipes for you';

  @override
  String get nutritionDailySummary => 'Today\'s Nutrition';

  @override
  String get nutritionDailySummarySubtitle => 'Track your intake at a glance';

  @override
  String get nutritionProteinLabel => 'Protein';

  @override
  String get nutritionCarbsLabel => 'Carbs';

  @override
  String get nutritionFatLabel => 'Fat';

  @override
  String get nutritionWaterIntakeLabel => 'Water Intake';

  @override
  String get nutritionNutritionFacts => 'Nutrition Facts';

  @override
  String get nutritionCookingSteps => 'Cooking Steps';

  @override
  String get nutritionTips => 'Chef\'s Tips';

  @override
  String get nutritionBenefits => 'Health Benefits';

  @override
  String get nutritionSimilarRecipes => 'Similar Recipes';

  @override
  String get nutritionSaveRecipe => 'Save Recipe';

  @override
  String get nutritionRecipeSaved => 'Saved to Favorites';

  @override
  String get nutritionServingsShort => 'Servings';

  @override
  String nutritionMinutesValue(int minutes) {
    return '$minutes Minutes';
  }

  @override
  String nutritionCaloriesValue(int calories) {
    return '$calories Cal';
  }

  @override
  String get nutritionDifficultyEasy => 'Easy';

  @override
  String get nutritionDifficultyMedium => 'Medium';

  @override
  String get nutritionDifficultyHard => 'Hard';

  @override
  String get mealIdeaTitle => 'Meal Idea';

  @override
  String get mealCategoryBreakfast => 'Breakfast';

  @override
  String get mealCategoryLunch => 'Lunch';

  @override
  String get mealCategoryDinner => 'Dinner';

  @override
  String get mealIngredients => 'Ingredients';

  @override
  String get mealPreparation => 'Preparation';

  @override
  String get mealIdeasDiscoverTitle => 'Meal Ideas';

  @override
  String get mealIdeasDiscoverBody =>
      'Browse a curated set of recipes matched to your goals — from quick smoothies to full dinners, all with clear prep steps and macros.';

  @override
  String get actionDiscover => 'Discover';

  @override
  String get mealPlanTitle => 'Meal Plan';

  @override
  String get mealPlanIntroBody =>
      'Answer a few quick questions about your diet and goals, and we\'ll put together a personalized meal plan for your week.';

  @override
  String get mealPlanKnowYourPlan => 'Know Your Plan';

  @override
  String get mealPlanDietaryPreferences => 'Dietary Preferences';

  @override
  String get mealPlanDietaryPreferencesQuestion =>
      'What are your dietary preferences?';

  @override
  String get mealPlanAllergies => 'Allergies';

  @override
  String get mealPlanAllergiesQuestion =>
      'Do you have any food allergies we should know about?';

  @override
  String get mealPlanMealTypes => 'Meal Types';

  @override
  String get mealPlanMealTypesQuestion => 'Which meals do you want to plan?';

  @override
  String get mealPlanCaloricGoal => 'Caloric Goal';

  @override
  String get mealPlanCaloricGoalQuestion =>
      'What is your daily caloric intake goal?';

  @override
  String get mealPlanCookingTime => 'Cooking Time Preference';

  @override
  String get mealPlanCookingTimeQuestion =>
      'How much time are you willing to spend cooking each meal?';

  @override
  String get mealPlanServings => 'Number of Servings';

  @override
  String get mealPlanServingsQuestion =>
      'How many servings do you need per meal?';

  @override
  String get mealPlanCreate => 'Create';

  @override
  String get mealPlanGeneratingTitle => 'Creating a plan for you';

  @override
  String get mealPlanBreakfastTitle => 'Breakfast plan for you';

  @override
  String get mealPlanBreakfastBody =>
      'Hand-picked breakfast options based on your dietary preferences and caloric goal.';

  @override
  String get mealPlanSeeRecipe => 'See Recipe';

  @override
  String get navCommunityTitle => 'Community';

  @override
  String get communitySubtitle =>
      'Train together, share wins, and join challenges.';

  @override
  String get communityTabForum => 'Discussion Forum';

  @override
  String get communityTabChallenges => 'Challenges';

  @override
  String get communityForums => 'Forums';

  @override
  String get communityChallengesAndCompetitions =>
      'Challenges and competitions';

  @override
  String get communityStartNow => 'Start Now';

  @override
  String get communityFeaturedChallengeName => 'Cycling Challenge';

  @override
  String get communityFeaturedChallengeDuration => '15 Minutes';

  @override
  String get communityFeaturedChallengeCalories => '100 Kcal';

  @override
  String get communityChallengeBadge => 'Community challenge';

  @override
  String get communityTopContribution => 'Top contribution';

  @override
  String get communityMember => 'Community member';

  @override
  String get communityPost1 =>
      'Just finished week 3 of the strength plan — the incline bench sit-ups are finally starting to feel manageable! Anyone else on the beginner track?';

  @override
  String get communityPost2 =>
      'Swapped my rest day walk for a 20-minute cardio session today and felt great afterward. Small wins add up.';

  @override
  String get communityPost3 =>
      'Question for the group: how do you stay consistent with meal prep on busy weeks? Looking for quick high-protein ideas.';

  @override
  String get communityPost4 =>
      'Hit a new personal best on kettlebell swings this morning. The weekly challenge really pushed me to show up.';

  @override
  String get communityPost5 =>
      'Loving the new routine builder — put together a full upper-body session in under two minutes.';
}
