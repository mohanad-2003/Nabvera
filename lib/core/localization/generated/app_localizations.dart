import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Bottom nav label for the Home tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom nav label for the Workout tab
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navWorkout;

  /// Bottom nav label for the Nutrition tab
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get navNutrition;

  /// Bottom nav label for the Community tab
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// Bottom nav label for the Profile tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// No description provided for @actionSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @errorGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGenericTitle;

  /// No description provided for @emptyGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyGenericTitle;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingLabel;

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get authLoginTitle;

  /// No description provided for @authWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get authWelcomeTitle;

  /// No description provided for @authWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to continue and track your fitness journey'**
  String get authWelcomeSubtitle;

  /// No description provided for @authForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPassword;

  /// No description provided for @authWelcomeBackTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, athlete.'**
  String get authWelcomeBackTitle;

  /// No description provided for @authWelcomeBackBody.
  ///
  /// In en, this message translates to:
  /// **'Pick up your streak, review your progress, and make today count.'**
  String get authWelcomeBackBody;

  /// No description provided for @authOrContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get authOrContinueWith;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authCreateAccount;

  /// No description provided for @authTrainingMode.
  ///
  /// In en, this message translates to:
  /// **'TRAINING MODE'**
  String get authTrainingMode;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get authEmailHint;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get authPasswordHint;

  /// No description provided for @authSignupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authSignupTitle;

  /// No description provided for @authSignupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start!'**
  String get authSignupSubtitle;

  /// No description provided for @authOrSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'or sign up with'**
  String get authOrSignUpWith;

  /// No description provided for @authNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get authNoAccount;

  /// No description provided for @authHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get authHaveAccount;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get authSignUp;

  /// No description provided for @authLogIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get authLogIn;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgotten Password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordHeading.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get authForgotPasswordHeading;

  /// No description provided for @authForgotPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive instructions on how to reset your password.'**
  String get authForgotPasswordBody;

  /// No description provided for @authSetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get authSetPasswordTitle;

  /// No description provided for @authSetPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'Set your new password to secure your account and continue your fitness journey.'**
  String get authSetPasswordBody;

  /// No description provided for @authResetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get authResetPassword;

  /// No description provided for @authStartTraining.
  ///
  /// In en, this message translates to:
  /// **'Start Training'**
  String get authStartTraining;

  /// No description provided for @authNewSeason.
  ///
  /// In en, this message translates to:
  /// **'NEW SEASON'**
  String get authNewSeason;

  /// No description provided for @authSignupHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build your strongest routine.'**
  String get authSignupHeroTitle;

  /// No description provided for @authSignupHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Create your profile and unlock plans shaped around your goals.'**
  String get authSignupHeroBody;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get authFullNameHint;

  /// No description provided for @authPasswordCreateHint.
  ///
  /// In en, this message translates to:
  /// **'Create a strong password'**
  String get authPasswordCreateHint;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authRecoveryHeadline.
  ///
  /// In en, this message translates to:
  /// **'Reset without losing momentum.'**
  String get authRecoveryHeadline;

  /// No description provided for @authRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we will guide you through creating a new secure password.'**
  String get authRecoveryBody;

  /// No description provided for @authSetPasswordHeadline.
  ///
  /// In en, this message translates to:
  /// **'Create your new training key.'**
  String get authSetPasswordHeadline;

  /// No description provided for @authNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get authNewPassword;

  /// No description provided for @authNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get authNewPasswordHint;

  /// No description provided for @authConfirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get authConfirmNewPasswordHint;

  /// No description provided for @authBiometricTitle.
  ///
  /// In en, this message translates to:
  /// **'Biometric Access'**
  String get authBiometricTitle;

  /// No description provided for @authBiometricHeadline.
  ///
  /// In en, this message translates to:
  /// **'Unlock your plan faster.'**
  String get authBiometricHeadline;

  /// No description provided for @authBiometricBody.
  ///
  /// In en, this message translates to:
  /// **'Add fingerprint access for a secure, frictionless start before every workout.'**
  String get authBiometricBody;

  /// No description provided for @authEnableFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Enable Fingerprint'**
  String get authEnableFingerprint;

  /// No description provided for @authSkipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get authSkipForNow;

  /// No description provided for @authErrorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'That email address looks invalid'**
  String get authErrorInvalidEmail;

  /// No description provided for @authErrorUserNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with that email'**
  String get authErrorUserNotFound;

  /// No description provided for @authErrorWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password'**
  String get authErrorWrongPassword;

  /// No description provided for @authErrorEmailInUse.
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email'**
  String get authErrorEmailInUse;

  /// No description provided for @authErrorWeakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get authErrorWeakPassword;

  /// No description provided for @authErrorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your connection'**
  String get authErrorNetwork;

  /// No description provided for @authErrorGoogleCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in was cancelled'**
  String get authErrorGoogleCancelled;

  /// No description provided for @authErrorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, please try again'**
  String get authErrorGeneric;

  /// No description provided for @authResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent — check your inbox'**
  String get authResetEmailSent;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authRememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get authRememberMe;

  /// No description provided for @authAgreeTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get authAgreeTermsPrefix;

  /// No description provided for @authAgreeTermsAnd.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get authAgreeTermsAnd;

  /// No description provided for @authTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms and Privacy Policy to continue'**
  String get authTermsRequired;

  /// No description provided for @authCheckYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get authCheckYourEmail;

  /// No description provided for @authResetLinkSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to {email}'**
  String authResetLinkSentTo(String email);

  /// No description provided for @authResendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend link'**
  String get authResendLink;

  /// No description provided for @authResendLinkIn.
  ///
  /// In en, this message translates to:
  /// **'Resend in {seconds}s'**
  String authResendLinkIn(int seconds);

  /// No description provided for @authChangeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change email'**
  String get authChangeEmail;

  /// No description provided for @authBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get authBackToLogin;

  /// No description provided for @authBiometricEnableSuccess.
  ///
  /// In en, this message translates to:
  /// **'Biometric unlock enabled'**
  String get authBiometricEnableSuccess;

  /// No description provided for @authBiometricEnableFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t verify your biometrics — try again'**
  String get authBiometricEnableFailed;

  /// No description provided for @authBiometricUnlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock Nabvera'**
  String get authBiometricUnlockTitle;

  /// No description provided for @authBiometricUnlockBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm it\'s you to continue.'**
  String get authBiometricUnlockBody;

  /// No description provided for @authBiometricUnlockCta.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get authBiometricUnlockCta;

  /// No description provided for @authBiometricLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out instead'**
  String get authBiometricLogout;

  /// No description provided for @authBiometricRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get authBiometricRetry;

  /// No description provided for @onboardingSetupTimeNote.
  ///
  /// In en, this message translates to:
  /// **'Personal setup takes less than a minute'**
  String get onboardingSetupTimeNote;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get validationPasswordTooShort;

  /// No description provided for @validationFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationFieldRequired;

  /// No description provided for @validationFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get validationFullNameRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get validationPasswordMismatch;

  /// No description provided for @splashBrandName.
  ///
  /// In en, this message translates to:
  /// **'Nabvera'**
  String get splashBrandName;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Fitness + strength + health + progress.'**
  String get splashTagline;

  /// No description provided for @splashMetricWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get splashMetricWorkouts;

  /// No description provided for @splashMetricPlans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get splashMetricPlans;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your premium training dashboard is ready.'**
  String get welcomeTagline;

  /// No description provided for @welcomeBadgeEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get welcomeBadgeEnergy;

  /// No description provided for @welcomeBadgeProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get welcomeBadgeProgress;

  /// No description provided for @welcomeCtaStart.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get welcomeCtaStart;

  /// No description provided for @welcomeHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I have an account, log in'**
  String get welcomeHaveAccount;

  /// No description provided for @onboardingBrand.
  ///
  /// In en, this message translates to:
  /// **'NABVERA'**
  String get onboardingBrand;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingSlide1Kicker.
  ///
  /// In en, this message translates to:
  /// **'START STRONG'**
  String get onboardingSlide1Kicker;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Build a body that keeps up with your ambition.'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Description.
  ///
  /// In en, this message translates to:
  /// **'Personalized training flows help you start today and stay consistent tomorrow.'**
  String get onboardingSlide1Description;

  /// No description provided for @onboardingSlide2Kicker.
  ///
  /// In en, this message translates to:
  /// **'TRAIN SMARTER'**
  String get onboardingSlide2Kicker;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Find strength, cardio, and functional sessions fast.'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Description.
  ///
  /// In en, this message translates to:
  /// **'Choose the right intensity for your day and move with confidence.'**
  String get onboardingSlide2Description;

  /// No description provided for @onboardingSlide3Kicker.
  ///
  /// In en, this message translates to:
  /// **'TRACK EVERY REP'**
  String get onboardingSlide3Kicker;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'See your workouts, streaks, and progress in one place.'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Description.
  ///
  /// In en, this message translates to:
  /// **'Turn effort into insight with daily metrics and clear performance feedback.'**
  String get onboardingSlide3Description;

  /// No description provided for @onboardingSlide4Kicker.
  ///
  /// In en, this message translates to:
  /// **'REACH GOALS'**
  String get onboardingSlide4Kicker;

  /// No description provided for @onboardingSlide4Title.
  ///
  /// In en, this message translates to:
  /// **'Healthy habits become your unfair advantage.'**
  String get onboardingSlide4Title;

  /// No description provided for @onboardingSlide4Description.
  ///
  /// In en, this message translates to:
  /// **'Stay motivated with progress milestones, challenges, and routines built for real life.'**
  String get onboardingSlide4Description;

  /// No description provided for @onboardingGenderTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s Your Gender'**
  String get onboardingGenderTitle;

  /// No description provided for @onboardingGenderBody.
  ///
  /// In en, this message translates to:
  /// **'Select your gender to personalize your fitness plan and track your progress more accurately.'**
  String get onboardingGenderBody;

  /// No description provided for @onboardingAgeTitle.
  ///
  /// In en, this message translates to:
  /// **'How Old Are You?'**
  String get onboardingAgeTitle;

  /// No description provided for @onboardingAgeBody.
  ///
  /// In en, this message translates to:
  /// **'Select your age to personalize your fitness plan and track your progress.'**
  String get onboardingAgeBody;

  /// No description provided for @onboardingWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Weight?'**
  String get onboardingWeightTitle;

  /// No description provided for @onboardingWeightBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your weight to personalize your fitness plan and track your progress accurately.'**
  String get onboardingWeightBody;

  /// No description provided for @onboardingHeightTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Height'**
  String get onboardingHeightTitle;

  /// No description provided for @onboardingHeightBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your height to personalize your fitness plan and track your progress accurately.'**
  String get onboardingHeightBody;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Goal?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalBody.
  ///
  /// In en, this message translates to:
  /// **'Choose your fitness goal to personalize your workout and diet plan.'**
  String get onboardingGoalBody;

  /// No description provided for @onboardingPhysicalTitle.
  ///
  /// In en, this message translates to:
  /// **'Physical Activity Level'**
  String get onboardingPhysicalTitle;

  /// No description provided for @onboardingPhysicalBody.
  ///
  /// In en, this message translates to:
  /// **'Select your physical activity level to personalize your fitness plan.'**
  String get onboardingPhysicalBody;

  /// No description provided for @onboardingEquipmentTitle.
  ///
  /// In en, this message translates to:
  /// **'What equipment do you have?'**
  String get onboardingEquipmentTitle;

  /// No description provided for @onboardingEquipmentBody.
  ///
  /// In en, this message translates to:
  /// **'Choose everything available to you. We will avoid workouts that need equipment you do not have.'**
  String get onboardingEquipmentBody;

  /// No description provided for @onboardingEquipmentNone.
  ///
  /// In en, this message translates to:
  /// **'No equipment / bodyweight only'**
  String get onboardingEquipmentNone;

  /// No description provided for @onboardingEquipmentDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get onboardingEquipmentDumbbell;

  /// No description provided for @onboardingEquipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get onboardingEquipmentBarbell;

  /// No description provided for @onboardingEquipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Gym machines'**
  String get onboardingEquipmentMachine;

  /// No description provided for @onboardingEquipmentBand.
  ///
  /// In en, this message translates to:
  /// **'Resistance bands'**
  String get onboardingEquipmentBand;

  /// No description provided for @onboardingEquipmentKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get onboardingEquipmentKettlebell;

  /// No description provided for @onboardingTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'How much time do you have?'**
  String get onboardingTimeTitle;

  /// No description provided for @onboardingTimeBody.
  ///
  /// In en, this message translates to:
  /// **'We will fit your daily workout into this time.'**
  String get onboardingTimeBody;

  /// No description provided for @onboardingTime15.
  ///
  /// In en, this message translates to:
  /// **'15 minutes'**
  String get onboardingTime15;

  /// No description provided for @onboardingTime30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get onboardingTime30;

  /// No description provided for @onboardingTime45.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get onboardingTime45;

  /// No description provided for @onboardingTime60.
  ///
  /// In en, this message translates to:
  /// **'60 minutes'**
  String get onboardingTime60;

  /// No description provided for @onboardingFillProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill Your Profile'**
  String get onboardingFillProfileTitle;

  /// No description provided for @onboardingFillProfileBody.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile information to personalize your experience.'**
  String get onboardingFillProfileBody;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// No description provided for @onboardingMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get onboardingMale;

  /// No description provided for @onboardingFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get onboardingFemale;

  /// No description provided for @onboardingNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get onboardingNickname;

  /// No description provided for @onboardingNicknameHint.
  ///
  /// In en, this message translates to:
  /// **'How should we call you?'**
  String get onboardingNicknameHint;

  /// No description provided for @onboardingMobileHint.
  ///
  /// In en, this message translates to:
  /// **'+123 567 89000'**
  String get onboardingMobileHint;

  /// No description provided for @setupIntroHeadline.
  ///
  /// In en, this message translates to:
  /// **'Consistency Is\nthe Key To Progress.\nDon\'t Give Up!'**
  String get setupIntroHeadline;

  /// No description provided for @setupIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Start your fitness journey today!\nTrack your progress, stay consistent, and achieve your goals step by step.'**
  String get setupIntroBody;

  /// No description provided for @setupIntroCta.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Get Started'**
  String get setupIntroCta;

  /// No description provided for @goalLoseWeight.
  ///
  /// In en, this message translates to:
  /// **'Lose Weight'**
  String get goalLoseWeight;

  /// No description provided for @goalGainWeight.
  ///
  /// In en, this message translates to:
  /// **'Gain Weight'**
  String get goalGainWeight;

  /// No description provided for @goalMuscleMassGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle Mass Gain'**
  String get goalMuscleMassGain;

  /// No description provided for @goalShapeBody.
  ///
  /// In en, this message translates to:
  /// **'Shape Body'**
  String get goalShapeBody;

  /// No description provided for @goalOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get goalOthers;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'Kg'**
  String get unitKg;

  /// No description provided for @unitCm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get unitCm;

  /// Home screen header greeting
  ///
  /// In en, this message translates to:
  /// **'Good Morning, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, {name}'**
  String homeGreetingMorning(String name);

  /// No description provided for @homeGreetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon, {name}'**
  String homeGreetingAfternoon(String name);

  /// No description provided for @homeGreetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening, {name}'**
  String homeGreetingEvening(String name);

  /// No description provided for @homeGreetingMorningPlain.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get homeGreetingMorningPlain;

  /// No description provided for @homeGreetingAfternoonPlain.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get homeGreetingAfternoonPlain;

  /// No description provided for @homeGreetingEveningPlain.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get homeGreetingEveningPlain;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Train hard. Recover smart. Repeat.'**
  String get homeTagline;

  /// No description provided for @homeStreakDays.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak'**
  String homeStreakDays(int days);

  /// No description provided for @homeTodayPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'TODAY PLAN'**
  String get homeTodayPlanLabel;

  /// No description provided for @homeWorkoutCategories.
  ///
  /// In en, this message translates to:
  /// **'Workout Categories'**
  String get homeWorkoutCategories;

  /// No description provided for @actionExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get actionExplore;

  /// No description provided for @homeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get homeRecommended;

  /// No description provided for @actionSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get actionSeeAll;

  /// No description provided for @homeRecommendedBadge.
  ///
  /// In en, this message translates to:
  /// **'RECOMMENDED'**
  String get homeRecommendedBadge;

  /// No description provided for @homeWeeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get homeWeeklyProgress;

  /// Weekly progress card subtitle
  ///
  /// In en, this message translates to:
  /// **'{workouts} workouts completed · {sessions} recovery sessions planned'**
  String homeWeeklyProgressSummary(int workouts, int sessions);

  /// No description provided for @homeArticlesAndTips.
  ///
  /// In en, this message translates to:
  /// **'Articles & Tips'**
  String get homeArticlesAndTips;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Upper Body Strength'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroPersonalizedReason.
  ///
  /// In en, this message translates to:
  /// **'Picked for your goal, level, equipment, and {minutes}-minute schedule.'**
  String homeHeroPersonalizedReason(int minutes);

  /// No description provided for @homeHeroFallbackReason.
  ///
  /// In en, this message translates to:
  /// **'A balanced session selected from the current workout library.'**
  String get homeHeroFallbackReason;

  /// No description provided for @homeHeroTooHard.
  ///
  /// In en, this message translates to:
  /// **'Too intense? Show an easier workout'**
  String get homeHeroTooHard;

  /// No description provided for @homeReasonLastWorkoutTooHard.
  ///
  /// In en, this message translates to:
  /// **'We eased up the difficulty after your last session felt tough.'**
  String get homeReasonLastWorkoutTooHard;

  /// No description provided for @homeReasonTwoEasyInARow.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been crushing it — we bumped up the difficulty.'**
  String get homeReasonTwoEasyInARow;

  /// No description provided for @homeReasonOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Right at your level — keep the momentum going.'**
  String get homeReasonOnTrack;

  /// No description provided for @homeReasonUserRequestedEasier.
  ///
  /// In en, this message translates to:
  /// **'Here\'s an easier option for today.'**
  String get homeReasonUserRequestedEasier;

  /// No description provided for @homeReasonNoWorkoutsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No workout matches your setup yet — check back soon.'**
  String get homeReasonNoWorkoutsAvailable;

  /// No description provided for @homeRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get homeRecoveryTitle;

  /// No description provided for @homeRecoveryReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get homeRecoveryReady;

  /// No description provided for @homeRecoveryNeedsRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovering'**
  String get homeRecoveryNeedsRecovery;

  /// No description provided for @homeAlternativeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Those muscles need recovery — try this instead:'**
  String get homeAlternativeAvailable;

  /// No description provided for @homeSwitchToAlternative.
  ///
  /// In en, this message translates to:
  /// **'Switch workout'**
  String get homeSwitchToAlternative;

  /// No description provided for @muscleGroupChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get muscleGroupChest;

  /// No description provided for @muscleGroupBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get muscleGroupBack;

  /// No description provided for @muscleGroupLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get muscleGroupLegs;

  /// No description provided for @muscleGroupShoulders.
  ///
  /// In en, this message translates to:
  /// **'Shoulders'**
  String get muscleGroupShoulders;

  /// No description provided for @muscleGroupArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get muscleGroupArms;

  /// No description provided for @muscleGroupCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get muscleGroupCore;

  /// No description provided for @muscleGroupFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get muscleGroupFullBody;

  /// No description provided for @muscleGroupCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get muscleGroupCardio;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min · {moves} movements · {level} intensity'**
  String homeHeroSubtitle(int minutes, int moves, String level);

  /// No description provided for @homeHeroDuration.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String homeHeroDuration(int minutes);

  /// No description provided for @homeHeroCalories.
  ///
  /// In en, this message translates to:
  /// **'~{kcal} kcal'**
  String homeHeroCalories(int kcal);

  /// No description provided for @homeWeeklyProgressPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String homeWeeklyProgressPercent(int percent);

  /// No description provided for @homeMetricCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get homeMetricCalories;

  /// No description provided for @homeMetricSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get homeMetricSteps;

  /// No description provided for @homeMetricDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get homeMetricDuration;

  /// No description provided for @homeUnitKcal.
  ///
  /// In en, this message translates to:
  /// **'kcal'**
  String get homeUnitKcal;

  /// No description provided for @homeUnitToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get homeUnitToday;

  /// No description provided for @homeUnitMin.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get homeUnitMin;

  /// No description provided for @homeCtaStart.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get homeCtaStart;

  /// No description provided for @homeCtaContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue Workout'**
  String get homeCtaContinue;

  /// No description provided for @homeCtaCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed'**
  String get homeCtaCompleted;

  /// No description provided for @homeHeroCompletionPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}% done'**
  String homeHeroCompletionPercent(int percent);

  /// No description provided for @homeHeroExercises.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String homeHeroExercises(int count);

  /// No description provided for @homeCaloriesConsumedOf.
  ///
  /// In en, this message translates to:
  /// **'{consumed} of {goal} kcal'**
  String homeCaloriesConsumedOf(int consumed, int goal);

  /// No description provided for @homeCaloriesRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} kcal left'**
  String homeCaloriesRemaining(int remaining);

  /// No description provided for @homeCaloriesGoalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached'**
  String get homeCaloriesGoalReached;

  /// No description provided for @homeActivityProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {goal} min'**
  String homeActivityProgress(int done, int goal);

  /// No description provided for @homeStreakStartMessage.
  ///
  /// In en, this message translates to:
  /// **'Start your streak today'**
  String get homeStreakStartMessage;

  /// No description provided for @homeStreakKeepGoing.
  ///
  /// In en, this message translates to:
  /// **'Keep it going!'**
  String get homeStreakKeepGoing;

  /// No description provided for @homeStreakOnFire.
  ///
  /// In en, this message translates to:
  /// **'You\'re on fire!'**
  String get homeStreakOnFire;

  /// No description provided for @homeNextStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Next Step'**
  String get homeNextStepTitle;

  /// No description provided for @homeNextStepDrinkWater.
  ///
  /// In en, this message translates to:
  /// **'Drink a glass of water'**
  String get homeNextStepDrinkWater;

  /// No description provided for @homeNextStepStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start today\'s workout'**
  String get homeNextStepStartWorkout;

  /// No description provided for @homeNextStepLogMeal.
  ///
  /// In en, this message translates to:
  /// **'Log your next meal'**
  String get homeNextStepLogMeal;

  /// No description provided for @homeNextStepAllDone.
  ///
  /// In en, this message translates to:
  /// **'You crushed today — keep it up!'**
  String get homeNextStepAllDone;

  /// No description provided for @homeNextStepGo.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get homeNextStepGo;

  /// No description provided for @homeWeeklyGoalSummary.
  ///
  /// In en, this message translates to:
  /// **'{done} of {goal} workouts this week'**
  String homeWeeklyGoalSummary(int done, int goal);

  /// No description provided for @homeWeeklyRestDay.
  ///
  /// In en, this message translates to:
  /// **'Rest day'**
  String get homeWeeklyRestDay;

  /// No description provided for @homeWeeklyTotalMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min this week'**
  String homeWeeklyTotalMinutes(int minutes);

  /// No description provided for @homeWeeklyMoreThanLastWeek.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min more than last week'**
  String homeWeeklyMoreThanLastWeek(int minutes);

  /// No description provided for @homeWeeklyLessThanLastWeek.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min less than last week'**
  String homeWeeklyLessThanLastWeek(int minutes);

  /// No description provided for @homeWeeklySameAsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'Same as last week'**
  String get homeWeeklySameAsLastWeek;

  /// No description provided for @homeWeeklyNoLastWeekData.
  ///
  /// In en, this message translates to:
  /// **'No data from last week yet'**
  String get homeWeeklyNoLastWeekData;

  /// No description provided for @homeWeeklyLongestStreak.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{No streak yet} =1{1-day streak} other{{days}-day streak}}'**
  String homeWeeklyLongestStreak(int days);

  /// No description provided for @homeWeeklyEmptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No workouts logged yet'**
  String get homeWeeklyEmptyStateTitle;

  /// No description provided for @homeWeeklyEmptyStateBody.
  ///
  /// In en, this message translates to:
  /// **'Finish your first workout to start seeing your weekly progress here.'**
  String get homeWeeklyEmptyStateBody;

  /// No description provided for @homeDayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get homeDayMon;

  /// No description provided for @homeDayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get homeDayTue;

  /// No description provided for @homeDayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get homeDayWed;

  /// No description provided for @homeDayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get homeDayThu;

  /// No description provided for @homeDayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get homeDayFri;

  /// No description provided for @homeDaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get homeDaySat;

  /// No description provided for @homeDaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get homeDaySun;

  /// No description provided for @homeRecommendedError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load recommendations'**
  String get homeRecommendedError;

  /// No description provided for @homeArticlesError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load articles'**
  String get homeArticlesError;

  /// No description provided for @homeRecommendedEmpty.
  ///
  /// In en, this message translates to:
  /// **'No recommendations yet'**
  String get homeRecommendedEmpty;

  /// No description provided for @homeArticlesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No articles yet'**
  String get homeArticlesEmpty;

  /// No description provided for @workoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get workoutTitle;

  /// No description provided for @workoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your level and move with purpose.'**
  String get workoutSubtitle;

  /// No description provided for @workoutYourRoutine.
  ///
  /// In en, this message translates to:
  /// **'Your Routine'**
  String get workoutYourRoutine;

  /// No description provided for @workoutCreateRoutine.
  ///
  /// In en, this message translates to:
  /// **'Create Routine'**
  String get workoutCreateRoutine;

  /// No description provided for @workoutTrainingOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'training of the day'**
  String get workoutTrainingOfTheDay;

  /// No description provided for @workoutStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get workoutStartWorkout;

  /// No description provided for @workoutNoVideoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No video available for this exercise yet'**
  String get workoutNoVideoAvailable;

  /// No description provided for @workoutFinishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish Workout'**
  String get workoutFinishWorkout;

  /// No description provided for @workoutRatingTitle.
  ///
  /// In en, this message translates to:
  /// **'How was this workout?'**
  String get workoutRatingTitle;

  /// No description provided for @workoutRatingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps tune tomorrow\'s suggestion.'**
  String get workoutRatingSubtitle;

  /// No description provided for @workoutRatingTooEasy.
  ///
  /// In en, this message translates to:
  /// **'Too Easy'**
  String get workoutRatingTooEasy;

  /// No description provided for @workoutRatingAppropriate.
  ///
  /// In en, this message translates to:
  /// **'Just Right'**
  String get workoutRatingAppropriate;

  /// No description provided for @workoutRatingHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get workoutRatingHard;

  /// No description provided for @workoutRatingTooHard.
  ///
  /// In en, this message translates to:
  /// **'Too Hard'**
  String get workoutRatingTooHard;

  /// No description provided for @workoutLogSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Workout saved — great job!'**
  String get workoutLogSavedSuccess;

  /// No description provided for @workoutLogSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your workout — check your connection.'**
  String get workoutLogSaveFailed;

  /// No description provided for @workoutDifficultyLabel.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get workoutDifficultyLabel;

  /// No description provided for @workoutMuscleGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Muscle Group'**
  String get workoutMuscleGroupLabel;

  /// No description provided for @workoutEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get workoutEquipmentLabel;

  /// No description provided for @workoutCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get workoutCategoryAll;

  /// No description provided for @workoutCategoryChest.
  ///
  /// In en, this message translates to:
  /// **'Chest'**
  String get workoutCategoryChest;

  /// No description provided for @workoutCategoryBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get workoutCategoryBack;

  /// No description provided for @workoutCategoryLegs.
  ///
  /// In en, this message translates to:
  /// **'Legs'**
  String get workoutCategoryLegs;

  /// No description provided for @workoutCategoryArms.
  ///
  /// In en, this message translates to:
  /// **'Arms'**
  String get workoutCategoryArms;

  /// No description provided for @workoutCategoryCardio.
  ///
  /// In en, this message translates to:
  /// **'Cardio'**
  String get workoutCategoryCardio;

  /// No description provided for @workoutCategoryStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get workoutCategoryStrength;

  /// No description provided for @workoutBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'🔥 Keep your consistency'**
  String get workoutBannerTitle;

  /// No description provided for @workoutBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Every workout makes you stronger'**
  String get workoutBannerBody;

  /// No description provided for @workoutBannerCta.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get workoutBannerCta;

  /// No description provided for @workoutLevelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get workoutLevelBeginner;

  /// No description provided for @workoutLevelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get workoutLevelIntermediate;

  /// No description provided for @workoutLevelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get workoutLevelAdvanced;

  /// No description provided for @workoutRecommendationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get workoutRecommendationsTitle;

  /// No description provided for @workoutMostPopular.
  ///
  /// In en, this message translates to:
  /// **'Most Popular'**
  String get workoutMostPopular;

  /// No description provided for @workoutWeeklyChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Challenge'**
  String get workoutWeeklyChallengeTitle;

  /// No description provided for @workoutRoundNumber.
  ///
  /// In en, this message translates to:
  /// **'Round {number}'**
  String workoutRoundNumber(int number);

  /// No description provided for @workoutCreateRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your routine'**
  String get workoutCreateRoutineTitle;

  /// No description provided for @workoutCreateRoutineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick exercises and build your next training flow.'**
  String get workoutCreateRoutineSubtitle;

  /// No description provided for @workoutYourRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Routine'**
  String get workoutYourRoutineTitle;

  /// No description provided for @workoutYourRoutineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap any exercise to preview details and start moving.'**
  String get workoutYourRoutineSubtitle;

  /// No description provided for @workoutProfileAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get workoutProfileAge;

  /// No description provided for @workoutProfileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get workoutProfileWeight;

  /// No description provided for @workoutProfileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get workoutProfileHeight;

  /// No description provided for @createRoutineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Build your personalized workout plan'**
  String get createRoutineSubtitle;

  /// No description provided for @createRoutineMotivation.
  ///
  /// In en, this message translates to:
  /// **'🔥 Every great transformation starts with a plan'**
  String get createRoutineMotivation;

  /// No description provided for @createRoutineNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Routine Name'**
  String get createRoutineNameLabel;

  /// No description provided for @createRoutineNameHint.
  ///
  /// In en, this message translates to:
  /// **'Push Day Workout'**
  String get createRoutineNameHint;

  /// No description provided for @createRoutineGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get createRoutineGoalLabel;

  /// No description provided for @routineGoalMuscleGain.
  ///
  /// In en, this message translates to:
  /// **'Muscle Gain'**
  String get routineGoalMuscleGain;

  /// No description provided for @routineGoalFatLoss.
  ///
  /// In en, this message translates to:
  /// **'Fat Loss'**
  String get routineGoalFatLoss;

  /// No description provided for @routineGoalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get routineGoalStrength;

  /// No description provided for @routineGoalEndurance.
  ///
  /// In en, this message translates to:
  /// **'Endurance'**
  String get routineGoalEndurance;

  /// No description provided for @createRoutineDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Workout Days'**
  String get createRoutineDaysLabel;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @weekdayMondayShort.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMondayShort;

  /// No description provided for @weekdayTuesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTuesdayShort;

  /// No description provided for @weekdayWednesdayShort.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWednesdayShort;

  /// No description provided for @weekdayThursdayShort.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThursdayShort;

  /// No description provided for @weekdayFridayShort.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFridayShort;

  /// No description provided for @weekdaySaturdayShort.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySaturdayShort;

  /// No description provided for @weekdaySundayShort.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySundayShort;

  /// No description provided for @createRoutineChooseExercises.
  ///
  /// In en, this message translates to:
  /// **'Choose Exercises'**
  String get createRoutineChooseExercises;

  /// No description provided for @createRoutineMyRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'My Routine'**
  String get createRoutineMyRoutineTitle;

  /// No description provided for @createRoutineMyRoutineEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercises added yet. Tap + on any exercise to add it here.'**
  String get createRoutineMyRoutineEmpty;

  /// No description provided for @createRoutineSetsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get createRoutineSetsLabel;

  /// No description provided for @createRoutineRepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get createRoutineRepsLabel;

  /// No description provided for @createRoutineSetsReps.
  ///
  /// In en, this message translates to:
  /// **'{sets} Sets × {reps} Reps'**
  String createRoutineSetsReps(int sets, int reps);

  /// No description provided for @createRoutineSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Routine Summary'**
  String get createRoutineSummaryTitle;

  /// No description provided for @createRoutineSummaryExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get createRoutineSummaryExercises;

  /// No description provided for @createRoutineSummaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get createRoutineSummaryDuration;

  /// No description provided for @createRoutineSummaryCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get createRoutineSummaryCalories;

  /// No description provided for @createRoutineSummaryDays.
  ///
  /// In en, this message translates to:
  /// **'Training Days'**
  String get createRoutineSummaryDays;

  /// No description provided for @createRoutineNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter a routine name'**
  String get createRoutineNameValidation;

  /// No description provided for @createRoutineExerciseValidation.
  ///
  /// In en, this message translates to:
  /// **'Add at least one exercise'**
  String get createRoutineExerciseValidation;

  /// No description provided for @createRoutineSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Routine created successfully!'**
  String get createRoutineSuccessMessage;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress Tracking'**
  String get progressTitle;

  /// No description provided for @progressTabLogs.
  ///
  /// In en, this message translates to:
  /// **'Workout Log'**
  String get progressTabLogs;

  /// No description provided for @progressTabCharts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get progressTabCharts;

  /// No description provided for @progressActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get progressActivities;

  /// No description provided for @progressEmptyState.
  ///
  /// In en, this message translates to:
  /// **'No activity logged yet.'**
  String get progressEmptyState;

  /// No description provided for @progressChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get progressChooseDate;

  /// No description provided for @progressMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get progressMonth;

  /// No description provided for @progressDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get progressDuration;

  /// No description provided for @progressMyProgress.
  ///
  /// In en, this message translates to:
  /// **'My Progress'**
  String get progressMyProgress;

  /// No description provided for @progressSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get progressSteps;

  /// No description provided for @progressWeeklyOverview.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get progressWeeklyOverview;

  /// No description provided for @progressStatSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get progressStatSessions;

  /// No description provided for @progressStatMinutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get progressStatMinutes;

  /// No description provided for @progressStatAvgSession.
  ///
  /// In en, this message translates to:
  /// **'Avg / Session'**
  String get progressStatAvgSession;

  /// No description provided for @progressRecentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent Sessions'**
  String get progressRecentSessions;

  /// No description provided for @progressNoSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions this week'**
  String get progressNoSessionsYet;

  /// No description provided for @notificationActionStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get notificationActionStart;

  /// No description provided for @notificationActionView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get notificationActionView;

  /// No description provided for @notificationWorkoutCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout completed!'**
  String get notificationWorkoutCompletedTitle;

  /// No description provided for @notificationWorkoutCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'{calories} kcal burned. Great job!'**
  String notificationWorkoutCompletedBody(int calories);

  /// No description provided for @notificationStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'{days}-day streak!'**
  String notificationStreakTitle(int days);

  /// No description provided for @notificationStreakBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve worked out {days} days in a row. Keep it up!'**
  String notificationStreakBody(int days);

  /// No description provided for @notificationWorkoutReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Haven\'t trained today yet'**
  String get notificationWorkoutReminderTitle;

  /// No description provided for @notificationWorkoutReminderBody.
  ///
  /// In en, this message translates to:
  /// **'A few minutes now still counts — pick up where you left off.'**
  String get notificationWorkoutReminderBody;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay motivated. Never miss your fitness journey.'**
  String get notificationsSubtitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsMarkAllReadDone.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get notificationsMarkAllReadDone;

  /// No description provided for @notificationsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get notificationsFilterAll;

  /// No description provided for @notificationsFilterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notificationsFilterUnread;

  /// No description provided for @notificationsFilterWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get notificationsFilterWorkouts;

  /// No description provided for @notificationsFilterChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get notificationsFilterChallenges;

  /// No description provided for @notificationsFilterAchievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get notificationsFilterAchievements;

  /// No description provided for @notificationsFilterNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get notificationsFilterNutrition;

  /// No description provided for @notificationsFilterReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationsFilterReminders;

  /// No description provided for @notificationsFilterCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get notificationsFilterCommunity;

  /// No description provided for @notificationsGroupToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notificationsGroupToday;

  /// No description provided for @notificationsGroupYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get notificationsGroupYesterday;

  /// No description provided for @notificationsGroupEarlierThisWeek.
  ///
  /// In en, this message translates to:
  /// **'Earlier This Week'**
  String get notificationsGroupEarlierThisWeek;

  /// No description provided for @notificationsGroupOlder.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get notificationsGroupOlder;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your workout reminders, achievements, nutrition updates, and progress will appear here.'**
  String get notificationsEmptyBody;

  /// No description provided for @notificationsStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get notificationsStartWorkout;

  /// No description provided for @notificationsSwipeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationsSwipeDeleted;

  /// No description provided for @notificationsSwipeMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'Marked as read'**
  String get notificationsSwipeMarkedRead;

  /// No description provided for @notificationsUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get notificationsUndo;

  /// No description provided for @notificationsTimeJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notificationsTimeJustNow;

  /// No description provided for @notificationsTimeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String notificationsTimeMinutesAgo(int minutes);

  /// No description provided for @notificationsTimeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String notificationsTimeHoursAgo(int hours);

  /// No description provided for @notificationsTimeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String notificationsTimeDaysAgo(int days);

  /// No description provided for @navSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search workouts, meals, articles…'**
  String get searchHint;

  /// No description provided for @searchTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get searchTabAll;

  /// No description provided for @searchTabWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get searchTabWorkout;

  /// No description provided for @searchTabNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get searchTabNutrition;

  /// No description provided for @searchWorkoutSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Workout Suggestions'**
  String get searchWorkoutSuggestions;

  /// No description provided for @searchNutritionSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Suggestions'**
  String get searchNutritionSuggestions;

  /// No description provided for @searchNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResultsTitle;

  /// No description provided for @searchNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different keyword or browse a category instead.'**
  String get searchNoResultsBody;

  /// No description provided for @navFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get navFavorites;

  /// No description provided for @favoriteFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get favoriteFilterAll;

  /// No description provided for @favoriteFilterWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get favoriteFilterWorkouts;

  /// No description provided for @favoriteFilterNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get favoriteFilterNutrition;

  /// No description provided for @favoriteTagWorkout.
  ///
  /// In en, this message translates to:
  /// **'WORKOUT'**
  String get favoriteTagWorkout;

  /// No description provided for @favoriteTagNutrition.
  ///
  /// In en, this message translates to:
  /// **'NUTRITION'**
  String get favoriteTagNutrition;

  /// No description provided for @favoriteEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoriteEmptyTitle;

  /// No description provided for @favoriteEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the star on any workout or meal to save it here for quick access later.'**
  String get favoriteEmptyBody;

  /// No description provided for @favoriteBrowseWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Browse Workouts'**
  String get favoriteBrowseWorkouts;

  /// No description provided for @favoriteBrowseNutrition.
  ///
  /// In en, this message translates to:
  /// **'Browse Nutrition'**
  String get favoriteBrowseNutrition;

  /// No description provided for @profileMyProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileMyProfile;

  /// No description provided for @profileBirthdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Birthday: '**
  String get profileBirthdayLabel;

  /// No description provided for @profileMotivation.
  ///
  /// In en, this message translates to:
  /// **'Keep pushing, your journey continues 🔥'**
  String get profileMotivation;

  /// No description provided for @profileStatWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get profileStatWorkouts;

  /// No description provided for @profileStatCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get profileStatCalories;

  /// No description provided for @profileStatDays.
  ///
  /// In en, this message translates to:
  /// **'Training Days'**
  String get profileStatDays;

  /// No description provided for @profileStatStreak.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
  String get profileStatStreak;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get profileSectionPreferences;

  /// No description provided for @profileMenuProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileMenuProfile;

  /// No description provided for @profileMenuProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get profileMenuProfileSubtitle;

  /// No description provided for @profileMenuFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get profileMenuFavorite;

  /// No description provided for @profileMenuFavoriteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your saved workouts and meals'**
  String get profileMenuFavoriteSubtitle;

  /// No description provided for @profileMenuPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profileMenuPrivacyPolicy;

  /// No description provided for @profileMenuPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data, permissions & legal'**
  String get profileMenuPrivacyPolicySubtitle;

  /// No description provided for @profileMenuSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get profileMenuSetting;

  /// No description provided for @profileMenuSettingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get profileMenuSettingSubtitle;

  /// No description provided for @profileMenuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get profileMenuHelp;

  /// No description provided for @profileMenuHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FAQs & contact support'**
  String get profileMenuHelpSubtitle;

  /// No description provided for @profileMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get profileMenuLogout;

  /// No description provided for @profileMenuLogoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get profileMenuLogoutSubtitle;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to\nlog out?'**
  String get profileLogoutConfirm;

  /// No description provided for @profileLogoutYes.
  ///
  /// In en, this message translates to:
  /// **'Yes, logout'**
  String get profileLogoutYes;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get editProfileFullName;

  /// No description provided for @editProfileMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get editProfileMobileNumber;

  /// No description provided for @editProfileDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get editProfileDateOfBirth;

  /// No description provided for @editProfileWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get editProfileWeight;

  /// No description provided for @editProfileHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get editProfileHeight;

  /// No description provided for @editProfileGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get editProfileGenderLabel;

  /// No description provided for @editProfileGenderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get editProfileGenderMale;

  /// No description provided for @editProfileGenderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get editProfileGenderFemale;

  /// No description provided for @editProfileGenderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get editProfileGenderOther;

  /// No description provided for @editProfileUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get editProfileUpdate;

  /// No description provided for @editProfileNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get editProfileNameValidation;

  /// No description provided for @editProfileSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfileSuccessMessage;

  /// No description provided for @editProfilePreferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Preferences'**
  String get editProfilePreferencesTitle;

  /// No description provided for @editProfilePreferencesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update these any time to get better-matched workout recommendations.'**
  String get editProfilePreferencesSubtitle;

  /// No description provided for @editProfilePreferencesGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get editProfilePreferencesGoalLabel;

  /// No description provided for @editProfilePreferencesLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity Level'**
  String get editProfilePreferencesLevelLabel;

  /// No description provided for @editProfilePreferencesEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Equipment'**
  String get editProfilePreferencesEquipmentLabel;

  /// No description provided for @editProfilePreferencesTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Time'**
  String get editProfilePreferencesTimeLabel;

  /// No description provided for @editProfilePreferencesSave.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get editProfilePreferencesSave;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacySectionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get privacySectionLegal;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'How we handle your data'**
  String get privacyPolicySubtitle;

  /// No description provided for @privacyTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get privacyTerms;

  /// No description provided for @privacyTermsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rules for using the app'**
  String get privacyTermsSubtitle;

  /// No description provided for @privacySectionYourData.
  ///
  /// In en, this message translates to:
  /// **'Your Data'**
  String get privacySectionYourData;

  /// No description provided for @privacyManagePersonalData.
  ///
  /// In en, this message translates to:
  /// **'Manage Personal Data'**
  String get privacyManagePersonalData;

  /// No description provided for @privacyManagePersonalDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permissions & data collection'**
  String get privacyManagePersonalDataSubtitle;

  /// No description provided for @privacyAppPermissions.
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get privacyAppPermissions;

  /// No description provided for @privacyAppPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Camera, location & notifications'**
  String get privacyAppPermissionsSubtitle;

  /// No description provided for @privacyDataCollection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get privacyDataCollection;

  /// No description provided for @privacyDataCollectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control what we track'**
  String get privacyDataCollectionSubtitle;

  /// No description provided for @privacyDownloadMyData.
  ///
  /// In en, this message translates to:
  /// **'Download My Data'**
  String get privacyDownloadMyData;

  /// No description provided for @privacyDownloadMyDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export a copy of your data'**
  String get privacyDownloadMyDataSubtitle;

  /// No description provided for @privacySectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get privacySectionAccount;

  /// No description provided for @privacyDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get privacyDeleteAccount;

  /// No description provided for @privacyDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account'**
  String get privacyDeleteAccountSubtitle;

  /// No description provided for @privacyContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get privacyContactSupport;

  /// No description provided for @privacyContactSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help from our team'**
  String get privacyContactSupportSubtitle;

  /// No description provided for @privacyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon'**
  String privacyComingSoon(String feature);

  /// No description provided for @privacyDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account?'**
  String get privacyDeleteConfirmTitle;

  /// No description provided for @privacyDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently removes your profile, workout history, and saved data. This action cannot be undone.'**
  String get privacyDeleteConfirmBody;

  /// No description provided for @privacyDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get privacyDelete;

  /// No description provided for @legalPrivacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'We collect only the information needed to run your training plan: your profile details, workout and nutrition activity, and device settings like theme and language. This data is stored securely and is never sold to third parties.\n\nYou can review, export, or delete your data at any time from Profile → Privacy → Manage Your Data. Analytics are aggregated and anonymized before use, and you can opt out at any time from the same screen.\n\nIf you have questions about how your data is handled, reach out from Profile → Help & FAQs → Contact Us.'**
  String get legalPrivacyPolicyBody;

  /// No description provided for @legalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'By using Nabvera you agree to use the app for personal fitness tracking only, keep your account credentials secure, and respect the community guidelines when posting in Community.\n\nWorkout and nutrition guidance in this app is for general informational purposes and is not a substitute for professional medical advice — consult a physician before starting a new fitness or nutrition program.\n\nWe may update these terms as the app evolves; continued use after an update means you accept the revised terms. You can delete your account at any time from Profile → Delete My Account.'**
  String get legalTermsBody;

  /// No description provided for @manageDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Your Data'**
  String get manageDataTitle;

  /// No description provided for @manageDataPermissionsSection.
  ///
  /// In en, this message translates to:
  /// **'App Permissions'**
  String get manageDataPermissionsSection;

  /// No description provided for @manageDataCameraAccess.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get manageDataCameraAccess;

  /// No description provided for @manageDataCameraAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Used to update your profile picture.'**
  String get manageDataCameraAccessBody;

  /// No description provided for @manageDataLocationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get manageDataLocationAccess;

  /// No description provided for @manageDataLocationAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Used to suggest nearby outdoor routes.'**
  String get manageDataLocationAccessBody;

  /// No description provided for @manageDataNotificationsAccess.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get manageDataNotificationsAccess;

  /// No description provided for @manageDataNotificationsAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Used for reminders and progress updates.'**
  String get manageDataNotificationsAccessBody;

  /// No description provided for @manageDataCollectionSection.
  ///
  /// In en, this message translates to:
  /// **'Data Collection'**
  String get manageDataCollectionSection;

  /// No description provided for @manageDataAnalyticsToggle.
  ///
  /// In en, this message translates to:
  /// **'Usage Analytics'**
  String get manageDataAnalyticsToggle;

  /// No description provided for @manageDataAnalyticsToggleBody.
  ///
  /// In en, this message translates to:
  /// **'Helps us improve workouts and recommendations.'**
  String get manageDataAnalyticsToggleBody;

  /// No description provided for @manageDataPersonalizedToggle.
  ///
  /// In en, this message translates to:
  /// **'Personalized Recommendations'**
  String get manageDataPersonalizedToggle;

  /// No description provided for @manageDataPersonalizedToggleBody.
  ///
  /// In en, this message translates to:
  /// **'Uses your activity to tailor suggested workouts.'**
  String get manageDataPersonalizedToggleBody;

  /// No description provided for @manageDataExportSection.
  ///
  /// In en, this message translates to:
  /// **'Your Data'**
  String get manageDataExportSection;

  /// No description provided for @manageDataExportBody.
  ///
  /// In en, this message translates to:
  /// **'Download a copy of your profile, workout history, and nutrition logs.'**
  String get manageDataExportBody;

  /// No description provided for @manageDataExportAction.
  ///
  /// In en, this message translates to:
  /// **'Request Export'**
  String get manageDataExportAction;

  /// No description provided for @manageDataExportConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Your data export has been requested. We\'ll notify you when it\'s ready.'**
  String get manageDataExportConfirmation;

  /// No description provided for @helpContactCustomerService.
  ///
  /// In en, this message translates to:
  /// **'Customer Service'**
  String get helpContactCustomerService;

  /// No description provided for @helpContactWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get helpContactWebsite;

  /// No description provided for @helpContactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get helpContactWhatsapp;

  /// No description provided for @helpContactFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get helpContactFacebook;

  /// No description provided for @helpContactInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get helpContactInstagram;

  /// No description provided for @helpContactCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied: {value}'**
  String helpContactCopied(String value);

  /// No description provided for @helpFaqQ1.
  ///
  /// In en, this message translates to:
  /// **'How do I create a custom workout routine?'**
  String get helpFaqQ1;

  /// No description provided for @helpFaqA1.
  ///
  /// In en, this message translates to:
  /// **'Go to Workout → Create Routine, then pick exercises from the list to build your own routine. Tap the star to favorite exercises you use often.'**
  String get helpFaqA1;

  /// No description provided for @helpFaqQ2.
  ///
  /// In en, this message translates to:
  /// **'How is my daily calorie goal calculated?'**
  String get helpFaqQ2;

  /// No description provided for @helpFaqA2.
  ///
  /// In en, this message translates to:
  /// **'We use the age, weight, height, and activity level you entered during setup. You can update these anytime from Profile → Edit Profile.'**
  String get helpFaqA2;

  /// No description provided for @helpFaqQ3.
  ///
  /// In en, this message translates to:
  /// **'Can I switch between light and dark mode?'**
  String get helpFaqQ3;

  /// No description provided for @helpFaqA3.
  ///
  /// In en, this message translates to:
  /// **'Yes — go to Profile → Settings → Theme and choose Light, Dark, or System to follow your device automatically.'**
  String get helpFaqA3;

  /// No description provided for @helpFaqQ4.
  ///
  /// In en, this message translates to:
  /// **'How do I change the app language?'**
  String get helpFaqQ4;

  /// No description provided for @helpFaqA4.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Settings → Language, or use the language toggle shown on the sign-in and onboarding screens.'**
  String get helpFaqA4;

  /// No description provided for @helpFaqQ5.
  ///
  /// In en, this message translates to:
  /// **'How do I delete my account?'**
  String get helpFaqQ5;

  /// No description provided for @helpFaqA5.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Privacy Policy → Delete My Account. This permanently removes your profile, workout history, and saved data.'**
  String get helpFaqA5;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Setting'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how Nabvera keeps you in the loop'**
  String get notificationSettingsSubtitle;

  /// No description provided for @notificationToggleGeneral.
  ///
  /// In en, this message translates to:
  /// **'General Notification'**
  String get notificationToggleGeneral;

  /// No description provided for @notificationToggleGeneralBody.
  ///
  /// In en, this message translates to:
  /// **'Workout, nutrition & community updates'**
  String get notificationToggleGeneralBody;

  /// No description provided for @notificationToggleSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get notificationToggleSound;

  /// No description provided for @notificationToggleSoundBody.
  ///
  /// In en, this message translates to:
  /// **'Play a sound for new notifications'**
  String get notificationToggleSoundBody;

  /// No description provided for @notificationToggleDoNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Disturb Mode'**
  String get notificationToggleDoNotDisturb;

  /// No description provided for @notificationToggleDoNotDisturbBody.
  ///
  /// In en, this message translates to:
  /// **'Silence notifications during quiet hours'**
  String get notificationToggleDoNotDisturbBody;

  /// No description provided for @notificationToggleVibrate.
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get notificationToggleVibrate;

  /// No description provided for @notificationToggleVibrateBody.
  ///
  /// In en, this message translates to:
  /// **'Vibrate the device on new alerts'**
  String get notificationToggleVibrateBody;

  /// No description provided for @notificationToggleLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen'**
  String get notificationToggleLockScreen;

  /// No description provided for @notificationToggleLockScreenBody.
  ///
  /// In en, this message translates to:
  /// **'Show previews on the lock screen'**
  String get notificationToggleLockScreenBody;

  /// No description provided for @notificationToggleReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationToggleReminders;

  /// No description provided for @notificationToggleRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'Daily workout & meal reminders'**
  String get notificationToggleRemindersBody;

  /// No description provided for @passwordSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Setting'**
  String get passwordSettingsTitle;

  /// No description provided for @passwordSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your account safe with a strong password'**
  String get passwordSettingsSubtitle;

  /// No description provided for @passwordCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get passwordCurrentPassword;

  /// No description provided for @passwordForgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get passwordForgot;

  /// No description provided for @passwordNew.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get passwordNew;

  /// No description provided for @passwordConfirmNew.
  ///
  /// In en, this message translates to:
  /// **'Confirm New password'**
  String get passwordConfirmNew;

  /// No description provided for @passwordCurrentValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get passwordCurrentValidation;

  /// No description provided for @passwordNewValidation.
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get passwordNewValidation;

  /// No description provided for @passwordMinLengthValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLengthValidation;

  /// No description provided for @passwordMismatchValidation.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatchValidation;

  /// No description provided for @passwordStrengthWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get passwordStrengthWeak;

  /// No description provided for @passwordStrengthMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get passwordStrengthMedium;

  /// No description provided for @passwordStrengthStrong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get passwordStrengthStrong;

  /// No description provided for @passwordUpdateAction.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get passwordUpdateAction;

  /// No description provided for @passwordUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully!'**
  String get passwordUpdateSuccess;

  /// No description provided for @documentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get settingsSubtitle;

  /// No description provided for @settingsSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsSectionAccount;

  /// No description provided for @settingsNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification Setting'**
  String get settingsNotification;

  /// No description provided for @settingsNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your workout reminders'**
  String get settingsNotificationSubtitle;

  /// No description provided for @settingsPassword.
  ///
  /// In en, this message translates to:
  /// **'Password Setting'**
  String get settingsPassword;

  /// No description provided for @settingsPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your account password'**
  String get settingsPasswordSubtitle;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove your account'**
  String get settingsDeleteAccountSubtitle;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQs'**
  String get helpTitle;

  /// No description provided for @helpHowCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get helpHowCanWeHelp;

  /// No description provided for @helpFaqTab.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get helpFaqTab;

  /// No description provided for @helpContactUsTab.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get helpContactUsTab;

  /// No description provided for @helpTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get helpTabGeneral;

  /// No description provided for @helpTabAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get helpTabAccount;

  /// No description provided for @helpTabServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get helpTabServices;

  /// No description provided for @helpSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get helpSearchHint;

  /// No description provided for @helpFaqPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Lorem ipsum dolor sit amet?'**
  String get helpFaqPlaceholder;

  /// No description provided for @nutritionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel your training with meals that actually fit your day.'**
  String get nutritionSubtitle;

  /// No description provided for @nutritionTabMealPlans.
  ///
  /// In en, this message translates to:
  /// **'Meal Plans'**
  String get nutritionTabMealPlans;

  /// No description provided for @nutritionTabMealIdeas.
  ///
  /// In en, this message translates to:
  /// **'Meal Ideas'**
  String get nutritionTabMealIdeas;

  /// No description provided for @nutritionRecipeOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Recipe of the day'**
  String get nutritionRecipeOfTheDay;

  /// No description provided for @nutritionFeaturedRecipeName.
  ///
  /// In en, this message translates to:
  /// **'Carrot and orange smoothie'**
  String get nutritionFeaturedRecipeName;

  /// No description provided for @nutritionFeaturedRecipeDuration.
  ///
  /// In en, this message translates to:
  /// **'10 Minutes'**
  String get nutritionFeaturedRecipeDuration;

  /// No description provided for @nutritionFeaturedRecipeCalories.
  ///
  /// In en, this message translates to:
  /// **'70 Cal'**
  String get nutritionFeaturedRecipeCalories;

  /// No description provided for @nutritionRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get nutritionRecommended;

  /// No description provided for @nutritionRecipesForYou.
  ///
  /// In en, this message translates to:
  /// **'Recipes for you'**
  String get nutritionRecipesForYou;

  /// No description provided for @nutritionDailySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Nutrition'**
  String get nutritionDailySummary;

  /// No description provided for @nutritionDailySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your intake at a glance'**
  String get nutritionDailySummarySubtitle;

  /// No description provided for @nutritionProteinLabel.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutritionProteinLabel;

  /// No description provided for @nutritionCarbsLabel.
  ///
  /// In en, this message translates to:
  /// **'Carbs'**
  String get nutritionCarbsLabel;

  /// No description provided for @nutritionFatLabel.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutritionFatLabel;

  /// No description provided for @nutritionWaterIntakeLabel.
  ///
  /// In en, this message translates to:
  /// **'Water Intake'**
  String get nutritionWaterIntakeLabel;

  /// No description provided for @nutritionNutritionFacts.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Facts'**
  String get nutritionNutritionFacts;

  /// No description provided for @nutritionCookingSteps.
  ///
  /// In en, this message translates to:
  /// **'Cooking Steps'**
  String get nutritionCookingSteps;

  /// No description provided for @nutritionTips.
  ///
  /// In en, this message translates to:
  /// **'Chef\'s Tips'**
  String get nutritionTips;

  /// No description provided for @nutritionBenefits.
  ///
  /// In en, this message translates to:
  /// **'Health Benefits'**
  String get nutritionBenefits;

  /// No description provided for @nutritionSimilarRecipes.
  ///
  /// In en, this message translates to:
  /// **'Similar Recipes'**
  String get nutritionSimilarRecipes;

  /// No description provided for @nutritionSaveRecipe.
  ///
  /// In en, this message translates to:
  /// **'Save Recipe'**
  String get nutritionSaveRecipe;

  /// No description provided for @nutritionRecipeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Favorites'**
  String get nutritionRecipeSaved;

  /// No description provided for @nutritionServingsShort.
  ///
  /// In en, this message translates to:
  /// **'Servings'**
  String get nutritionServingsShort;

  /// No description provided for @nutritionMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} Minutes'**
  String nutritionMinutesValue(int minutes);

  /// No description provided for @nutritionCaloriesValue.
  ///
  /// In en, this message translates to:
  /// **'{calories} Cal'**
  String nutritionCaloriesValue(int calories);

  /// No description provided for @nutritionDifficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get nutritionDifficultyEasy;

  /// No description provided for @nutritionDifficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get nutritionDifficultyMedium;

  /// No description provided for @nutritionDifficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get nutritionDifficultyHard;

  /// No description provided for @mealIdeaTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Idea'**
  String get mealIdeaTitle;

  /// No description provided for @mealCategoryBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealCategoryBreakfast;

  /// No description provided for @mealCategoryLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealCategoryLunch;

  /// No description provided for @mealCategoryDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealCategoryDinner;

  /// No description provided for @mealIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get mealIngredients;

  /// No description provided for @mealPreparation.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get mealPreparation;

  /// No description provided for @mealIdeasDiscoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Ideas'**
  String get mealIdeasDiscoverTitle;

  /// No description provided for @mealIdeasDiscoverBody.
  ///
  /// In en, this message translates to:
  /// **'Browse a curated set of recipes matched to your goals — from quick smoothies to full dinners, all with clear prep steps and macros.'**
  String get mealIdeasDiscoverBody;

  /// No description provided for @actionDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get actionDiscover;

  /// No description provided for @mealPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Meal Plan'**
  String get mealPlanTitle;

  /// No description provided for @mealPlanIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Answer a few quick questions about your diet and goals, and we\'ll put together a personalized meal plan for your week.'**
  String get mealPlanIntroBody;

  /// No description provided for @mealPlanKnowYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Know Your Plan'**
  String get mealPlanKnowYourPlan;

  /// No description provided for @mealPlanDietaryPreferences.
  ///
  /// In en, this message translates to:
  /// **'Dietary Preferences'**
  String get mealPlanDietaryPreferences;

  /// No description provided for @mealPlanDietaryPreferencesQuestion.
  ///
  /// In en, this message translates to:
  /// **'What are your dietary preferences?'**
  String get mealPlanDietaryPreferencesQuestion;

  /// No description provided for @mealPlanAllergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get mealPlanAllergies;

  /// No description provided for @mealPlanAllergiesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you have any food allergies we should know about?'**
  String get mealPlanAllergiesQuestion;

  /// No description provided for @mealPlanMealTypes.
  ///
  /// In en, this message translates to:
  /// **'Meal Types'**
  String get mealPlanMealTypes;

  /// No description provided for @mealPlanMealTypesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Which meals do you want to plan?'**
  String get mealPlanMealTypesQuestion;

  /// No description provided for @mealPlanCaloricGoal.
  ///
  /// In en, this message translates to:
  /// **'Caloric Goal'**
  String get mealPlanCaloricGoal;

  /// No description provided for @mealPlanCaloricGoalQuestion.
  ///
  /// In en, this message translates to:
  /// **'What is your daily caloric intake goal?'**
  String get mealPlanCaloricGoalQuestion;

  /// No description provided for @mealPlanCookingTime.
  ///
  /// In en, this message translates to:
  /// **'Cooking Time Preference'**
  String get mealPlanCookingTime;

  /// No description provided for @mealPlanCookingTimeQuestion.
  ///
  /// In en, this message translates to:
  /// **'How much time are you willing to spend cooking each meal?'**
  String get mealPlanCookingTimeQuestion;

  /// No description provided for @mealPlanServings.
  ///
  /// In en, this message translates to:
  /// **'Number of Servings'**
  String get mealPlanServings;

  /// No description provided for @mealPlanServingsQuestion.
  ///
  /// In en, this message translates to:
  /// **'How many servings do you need per meal?'**
  String get mealPlanServingsQuestion;

  /// No description provided for @mealPlanCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get mealPlanCreate;

  /// No description provided for @mealPlanGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a plan for you'**
  String get mealPlanGeneratingTitle;

  /// No description provided for @mealPlanBreakfastTitle.
  ///
  /// In en, this message translates to:
  /// **'Breakfast plan for you'**
  String get mealPlanBreakfastTitle;

  /// No description provided for @mealPlanBreakfastBody.
  ///
  /// In en, this message translates to:
  /// **'Hand-picked breakfast options based on your dietary preferences and caloric goal.'**
  String get mealPlanBreakfastBody;

  /// No description provided for @mealPlanSeeRecipe.
  ///
  /// In en, this message translates to:
  /// **'See Recipe'**
  String get mealPlanSeeRecipe;

  /// No description provided for @navCommunityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunityTitle;

  /// No description provided for @communitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Train together, share wins, and join challenges.'**
  String get communitySubtitle;

  /// No description provided for @communityTabForum.
  ///
  /// In en, this message translates to:
  /// **'Discussion Forum'**
  String get communityTabForum;

  /// No description provided for @communityTabChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get communityTabChallenges;

  /// No description provided for @communityForums.
  ///
  /// In en, this message translates to:
  /// **'Forums'**
  String get communityForums;

  /// No description provided for @communityChallengesAndCompetitions.
  ///
  /// In en, this message translates to:
  /// **'Challenges and competitions'**
  String get communityChallengesAndCompetitions;

  /// No description provided for @communityStartNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get communityStartNow;

  /// No description provided for @communityFeaturedChallengeName.
  ///
  /// In en, this message translates to:
  /// **'Cycling Challenge'**
  String get communityFeaturedChallengeName;

  /// No description provided for @communityFeaturedChallengeDuration.
  ///
  /// In en, this message translates to:
  /// **'15 Minutes'**
  String get communityFeaturedChallengeDuration;

  /// No description provided for @communityFeaturedChallengeCalories.
  ///
  /// In en, this message translates to:
  /// **'100 Kcal'**
  String get communityFeaturedChallengeCalories;

  /// No description provided for @communityChallengeBadge.
  ///
  /// In en, this message translates to:
  /// **'Community challenge'**
  String get communityChallengeBadge;

  /// No description provided for @communityTopContribution.
  ///
  /// In en, this message translates to:
  /// **'Top contribution'**
  String get communityTopContribution;

  /// No description provided for @communityMember.
  ///
  /// In en, this message translates to:
  /// **'Community member'**
  String get communityMember;

  /// No description provided for @communityPost1.
  ///
  /// In en, this message translates to:
  /// **'Just finished week 3 of the strength plan — the incline bench sit-ups are finally starting to feel manageable! Anyone else on the beginner track?'**
  String get communityPost1;

  /// No description provided for @communityPost2.
  ///
  /// In en, this message translates to:
  /// **'Swapped my rest day walk for a 20-minute cardio session today and felt great afterward. Small wins add up.'**
  String get communityPost2;

  /// No description provided for @communityPost3.
  ///
  /// In en, this message translates to:
  /// **'Question for the group: how do you stay consistent with meal prep on busy weeks? Looking for quick high-protein ideas.'**
  String get communityPost3;

  /// No description provided for @communityPost4.
  ///
  /// In en, this message translates to:
  /// **'Hit a new personal best on kettlebell swings this morning. The weekly challenge really pushed me to show up.'**
  String get communityPost4;

  /// No description provided for @communityPost5.
  ///
  /// In en, this message translates to:
  /// **'Loving the new routine builder — put together a full upper-body session in under two minutes.'**
  String get communityPost5;

  /// No description provided for @profileMenuAdminConsole.
  ///
  /// In en, this message translates to:
  /// **'Admin Console'**
  String get profileMenuAdminConsole;

  /// No description provided for @profileMenuAdminConsoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage workouts, recipes, and content'**
  String get profileMenuAdminConsoleSubtitle;

  /// No description provided for @adminNavDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get adminNavDashboard;

  /// No description provided for @adminNavWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get adminNavWorkouts;

  /// No description provided for @adminNavExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get adminNavExercises;

  /// No description provided for @adminNavRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get adminNavRecipes;

  /// No description provided for @adminNavArticles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get adminNavArticles;

  /// No description provided for @adminNavChallenges.
  ///
  /// In en, this message translates to:
  /// **'Challenges'**
  String get adminNavChallenges;

  /// No description provided for @adminNavProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get adminNavProfile;

  /// No description provided for @adminNavMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get adminNavMore;

  /// No description provided for @adminActionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get adminActionEdit;

  /// No description provided for @adminActionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get adminActionDelete;

  /// No description provided for @adminActionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get adminActionRetry;

  /// No description provided for @adminSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get adminSearchHint;

  /// No description provided for @adminNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get adminNoResultsTitle;

  /// No description provided for @adminNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term or filter.'**
  String get adminNoResultsMessage;

  /// No description provided for @adminFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get adminFilterAll;

  /// No description provided for @adminUnauthorizedTitle.
  ///
  /// In en, this message translates to:
  /// **'Admins only'**
  String get adminUnauthorizedTitle;

  /// No description provided for @adminUnauthorizedBody.
  ///
  /// In en, this message translates to:
  /// **'Your account doesn\'t have access to the Admin console.'**
  String get adminUnauthorizedBody;

  /// No description provided for @adminUnauthorizedAction.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get adminUnauthorizedAction;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboardTitle;

  /// No description provided for @adminDashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick look at your content library.'**
  String get adminDashboardSubtitle;

  /// No description provided for @adminStatUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get adminStatUnavailable;

  /// No description provided for @adminRoleBadge.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get adminRoleBadge;

  /// No description provided for @adminBackToApp.
  ///
  /// In en, this message translates to:
  /// **'Back to the app'**
  String get adminBackToApp;

  /// No description provided for @adminLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this list'**
  String get adminLoadErrorTitle;

  /// No description provided for @adminSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save — check your connection and try again.'**
  String get adminSaveFailed;

  /// No description provided for @adminSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get adminSave;

  /// No description provided for @adminDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get adminDeleteConfirmTitle;

  /// No description provided for @adminDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be permanently removed. This can\'t be undone.'**
  String adminDeleteConfirmBody(String name);

  /// No description provided for @adminFeaturedBadge.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get adminFeaturedBadge;

  /// No description provided for @adminWorkoutsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No workouts yet'**
  String get adminWorkoutsEmptyTitle;

  /// No description provided for @adminWorkoutsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first workout to get started.'**
  String get adminWorkoutsEmptyMessage;

  /// No description provided for @adminExercisesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No exercises yet'**
  String get adminExercisesEmptyTitle;

  /// No description provided for @adminExercisesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first exercise to get started.'**
  String get adminExercisesEmptyMessage;

  /// No description provided for @adminRecipesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get adminRecipesEmptyTitle;

  /// No description provided for @adminRecipesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first recipe to get started.'**
  String get adminRecipesEmptyMessage;

  /// No description provided for @adminArticlesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No articles yet'**
  String get adminArticlesEmptyTitle;

  /// No description provided for @adminArticlesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first article to get started.'**
  String get adminArticlesEmptyMessage;

  /// No description provided for @adminChallengesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No challenges yet'**
  String get adminChallengesEmptyTitle;

  /// No description provided for @adminChallengesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first challenge to get started.'**
  String get adminChallengesEmptyMessage;

  /// No description provided for @adminEditWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Workout'**
  String get adminEditWorkoutTitle;

  /// No description provided for @adminAddWorkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Workout'**
  String get adminAddWorkoutTitle;

  /// No description provided for @adminEditExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Exercise'**
  String get adminEditExerciseTitle;

  /// No description provided for @adminAddExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Exercise'**
  String get adminAddExerciseTitle;

  /// No description provided for @adminEditRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Recipe'**
  String get adminEditRecipeTitle;

  /// No description provided for @adminAddRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Recipe'**
  String get adminAddRecipeTitle;

  /// No description provided for @adminAddArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Article'**
  String get adminAddArticleTitle;

  /// No description provided for @adminAddChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Challenge'**
  String get adminAddChallengeTitle;

  /// No description provided for @adminFieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get adminFieldTitle;

  /// No description provided for @adminFieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get adminFieldName;

  /// No description provided for @adminFieldDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get adminFieldDescription;

  /// No description provided for @adminFieldImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get adminFieldImageUrl;

  /// No description provided for @adminFieldVideoUrl.
  ///
  /// In en, this message translates to:
  /// **'Video URL'**
  String get adminFieldVideoUrl;

  /// No description provided for @adminFieldDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get adminFieldDurationMinutes;

  /// No description provided for @adminFieldCalories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get adminFieldCalories;

  /// No description provided for @adminFieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get adminFieldCategory;

  /// No description provided for @adminFieldDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get adminFieldDifficulty;

  /// No description provided for @adminFieldMuscleGroup.
  ///
  /// In en, this message translates to:
  /// **'Muscle Group'**
  String get adminFieldMuscleGroup;

  /// No description provided for @adminFieldEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get adminFieldEquipment;

  /// No description provided for @adminFieldFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get adminFieldFeatured;

  /// No description provided for @adminFieldPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get adminFieldPopular;

  /// No description provided for @adminFieldPrepTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Prep Time (minutes)'**
  String get adminFieldPrepTimeMinutes;

  /// No description provided for @adminFieldNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get adminFieldNutrition;

  /// No description provided for @adminFieldProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein (g)'**
  String get adminFieldProtein;

  /// No description provided for @adminFieldCarbs.
  ///
  /// In en, this message translates to:
  /// **'Carbs (g)'**
  String get adminFieldCarbs;

  /// No description provided for @adminFieldFat.
  ///
  /// In en, this message translates to:
  /// **'Fat (g)'**
  String get adminFieldFat;

  /// No description provided for @adminFieldIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get adminFieldIngredients;

  /// No description provided for @adminFieldSteps.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get adminFieldSteps;

  /// No description provided for @adminFieldOnePerLine.
  ///
  /// In en, this message translates to:
  /// **'One per line'**
  String get adminFieldOnePerLine;

  /// No description provided for @adminFieldContent.
  ///
  /// In en, this message translates to:
  /// **'Content (paragraphs)'**
  String get adminFieldContent;

  /// No description provided for @adminFieldReadTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'Read Time (minutes)'**
  String get adminFieldReadTimeMinutes;

  /// No description provided for @adminFieldGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get adminFieldGoal;

  /// No description provided for @adminFieldDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get adminFieldDuration;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
