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

  /// No description provided for @actionIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get actionIncrease;

  /// No description provided for @actionDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get actionDecrease;

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

  /// No description provided for @authPasswordResetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed successfully. Sign in with your new password.'**
  String get authPasswordResetSuccess;

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

  /// No description provided for @onboardingStepCounter.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepCounter(int current, int total);

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

  /// No description provided for @onboardingGenderRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a gender to continue'**
  String get onboardingGenderRequired;

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

  /// No description provided for @onboardingGoalRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose a goal to continue'**
  String get onboardingGoalRequired;

  /// No description provided for @goalLoseWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Trim down with a calorie-focused plan'**
  String get goalLoseWeightHint;

  /// No description provided for @goalGainWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Build up with a surplus-focused plan'**
  String get goalGainWeightHint;

  /// No description provided for @goalMuscleMassGainHint.
  ///
  /// In en, this message translates to:
  /// **'Prioritize strength and hypertrophy'**
  String get goalMuscleMassGainHint;

  /// No description provided for @goalShapeBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Tone up and stay consistently active'**
  String get goalShapeBodyHint;

  /// No description provided for @goalOthersHint.
  ///
  /// In en, this message translates to:
  /// **'A general, balanced plan'**
  String get goalOthersHint;

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

  /// No description provided for @onboardingPhysicalRequired.
  ///
  /// In en, this message translates to:
  /// **'Choose your activity level to continue'**
  String get onboardingPhysicalRequired;

  /// No description provided for @workoutLevelBeginnerHint.
  ///
  /// In en, this message translates to:
  /// **'New to structured training'**
  String get workoutLevelBeginnerHint;

  /// No description provided for @workoutLevelIntermediateHint.
  ///
  /// In en, this message translates to:
  /// **'Train a few times a week already'**
  String get workoutLevelIntermediateHint;

  /// No description provided for @workoutLevelAdvancedHint.
  ///
  /// In en, this message translates to:
  /// **'Train often and push hard'**
  String get workoutLevelAdvancedHint;

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

  /// No description provided for @onboardingEquipmentNoneHint.
  ///
  /// In en, this message translates to:
  /// **'Push-ups, squats, and more'**
  String get onboardingEquipmentNoneHint;

  /// No description provided for @onboardingEquipmentDumbbell.
  ///
  /// In en, this message translates to:
  /// **'Dumbbells'**
  String get onboardingEquipmentDumbbell;

  /// No description provided for @onboardingEquipmentDumbbellHint.
  ///
  /// In en, this message translates to:
  /// **'Adjustable or fixed pairs'**
  String get onboardingEquipmentDumbbellHint;

  /// No description provided for @onboardingEquipmentBarbell.
  ///
  /// In en, this message translates to:
  /// **'Barbell'**
  String get onboardingEquipmentBarbell;

  /// No description provided for @onboardingEquipmentBarbellHint.
  ///
  /// In en, this message translates to:
  /// **'With plates and a rack'**
  String get onboardingEquipmentBarbellHint;

  /// No description provided for @onboardingEquipmentMachine.
  ///
  /// In en, this message translates to:
  /// **'Gym machines'**
  String get onboardingEquipmentMachine;

  /// No description provided for @onboardingEquipmentMachineHint.
  ///
  /// In en, this message translates to:
  /// **'Full gym access'**
  String get onboardingEquipmentMachineHint;

  /// No description provided for @onboardingEquipmentBand.
  ///
  /// In en, this message translates to:
  /// **'Resistance bands'**
  String get onboardingEquipmentBand;

  /// No description provided for @onboardingEquipmentBandHint.
  ///
  /// In en, this message translates to:
  /// **'Light and portable'**
  String get onboardingEquipmentBandHint;

  /// No description provided for @onboardingEquipmentKettlebell.
  ///
  /// In en, this message translates to:
  /// **'Kettlebell'**
  String get onboardingEquipmentKettlebell;

  /// No description provided for @onboardingEquipmentKettlebellHint.
  ///
  /// In en, this message translates to:
  /// **'One or more weights'**
  String get onboardingEquipmentKettlebellHint;

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

  /// No description provided for @onboardingTime15Hint.
  ///
  /// In en, this message translates to:
  /// **'A quick, focused session'**
  String get onboardingTime15Hint;

  /// No description provided for @onboardingTime30.
  ///
  /// In en, this message translates to:
  /// **'30 minutes'**
  String get onboardingTime30;

  /// No description provided for @onboardingTime30Hint.
  ///
  /// In en, this message translates to:
  /// **'A balanced, everyday session'**
  String get onboardingTime30Hint;

  /// No description provided for @onboardingTime45.
  ///
  /// In en, this message translates to:
  /// **'45 minutes'**
  String get onboardingTime45;

  /// No description provided for @onboardingTime45Hint.
  ///
  /// In en, this message translates to:
  /// **'A fuller, standard session'**
  String get onboardingTime45Hint;

  /// No description provided for @onboardingTime60.
  ///
  /// In en, this message translates to:
  /// **'60 minutes'**
  String get onboardingTime60;

  /// No description provided for @onboardingTime60Hint.
  ///
  /// In en, this message translates to:
  /// **'An extended session'**
  String get onboardingTime60Hint;

  /// No description provided for @onboardingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your profile. Please try again.'**
  String get onboardingSaveFailed;

  /// No description provided for @onboardingSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving your profile…'**
  String get onboardingSaving;

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

  /// No description provided for @profileWeightValue.
  ///
  /// In en, this message translates to:
  /// **'{weight} Kg'**
  String profileWeightValue(int weight);

  /// No description provided for @profileHeightValue.
  ///
  /// In en, this message translates to:
  /// **'{height} m'**
  String profileHeightValue(String height);

  /// No description provided for @onboardingAgeValue.
  ///
  /// In en, this message translates to:
  /// **'Age: {value} years'**
  String onboardingAgeValue(int value);

  /// No description provided for @onboardingHeightValue.
  ///
  /// In en, this message translates to:
  /// **'Height: {value} centimeters'**
  String onboardingHeightValue(int value);

  /// No description provided for @onboardingWeightValue.
  ///
  /// In en, this message translates to:
  /// **'Weight: {value} kilograms'**
  String onboardingWeightValue(int value);

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

  /// No description provided for @articleCategoryNutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get articleCategoryNutrition;

  /// No description provided for @articleCategoryWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get articleCategoryWorkout;

  /// No description provided for @articleCategoryRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get articleCategoryRecovery;

  /// No description provided for @articleCategoryMindset.
  ///
  /// In en, this message translates to:
  /// **'Mindset'**
  String get articleCategoryMindset;

  /// No description provided for @articleReadTimeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min read'**
  String articleReadTimeMinutes(int minutes);

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

  /// No description provided for @workoutExerciseSets.
  ///
  /// In en, this message translates to:
  /// **'{sets} Sets'**
  String workoutExerciseSets(int sets);

  /// No description provided for @workoutExerciseCalories.
  ///
  /// In en, this message translates to:
  /// **'{kcal} Kcal'**
  String workoutExerciseCalories(int kcal);

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

  /// No description provided for @workoutSetNumber.
  ///
  /// In en, this message translates to:
  /// **'Set {number}'**
  String workoutSetNumber(int number);

  /// No description provided for @workoutSetsProgress.
  ///
  /// In en, this message translates to:
  /// **'{done}/{total} sets'**
  String workoutSetsProgress(int done, int total);

  /// No description provided for @workoutRestTitle.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get workoutRestTitle;

  /// No description provided for @workoutRestSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get workoutRestSkip;

  /// No description provided for @workoutRestAddSeconds.
  ///
  /// In en, this message translates to:
  /// **'+15s'**
  String get workoutRestAddSeconds;

  /// No description provided for @workoutWeightKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get workoutWeightKgLabel;

  /// No description provided for @workoutRepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get workoutRepsLabel;

  /// No description provided for @workoutHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get workoutHistoryTitle;

  /// No description provided for @workoutHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Log a set to start tracking your progress on this exercise.'**
  String get workoutHistoryEmpty;

  /// No description provided for @workoutHistorySetSummary.
  ///
  /// In en, this message translates to:
  /// **'{weight} kg × {reps}'**
  String workoutHistorySetSummary(String weight, int reps);

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

  /// No description provided for @workoutIronSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Iron Training'**
  String get workoutIronSectionLabel;

  /// No description provided for @workoutFitnessSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'General Fitness'**
  String get workoutFitnessSectionLabel;

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

  /// No description provided for @workoutCategoryYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get workoutCategoryYoga;

  /// No description provided for @workoutCategoryHiit.
  ///
  /// In en, this message translates to:
  /// **'HIIT'**
  String get workoutCategoryHiit;

  /// No description provided for @workoutCategoryStretching.
  ///
  /// In en, this message translates to:
  /// **'Stretching'**
  String get workoutCategoryStretching;

  /// No description provided for @workoutCategoryFullBody.
  ///
  /// In en, this message translates to:
  /// **'Full Body'**
  String get workoutCategoryFullBody;

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

  /// No description provided for @notificationChallengeExpiringTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge ending soon'**
  String get notificationChallengeExpiringTitle;

  /// No description provided for @notificationChallengeExpiringBody.
  ///
  /// In en, this message translates to:
  /// **'One of your challenges ends within 24 hours — finish strong!'**
  String get notificationChallengeExpiringBody;

  /// No description provided for @notificationChallengeCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge completed!'**
  String get notificationChallengeCompletedTitle;

  /// No description provided for @notificationChallengeCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'You finished a challenge. Great work!'**
  String get notificationChallengeCompletedBody;

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

  /// No description provided for @searchStartTypingTitle.
  ///
  /// In en, this message translates to:
  /// **'Search for anything'**
  String get searchStartTypingTitle;

  /// No description provided for @searchStartTypingBody.
  ///
  /// In en, this message translates to:
  /// **'Find workouts and meals by name — start typing above.'**
  String get searchStartTypingBody;

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

  /// No description provided for @editProfileAvatarPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t select an image. Please try again.'**
  String get editProfileAvatarPickFailed;

  /// No description provided for @editProfileAvatarUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload your photo. Please try again.'**
  String get editProfileAvatarUploadFailed;

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

  /// No description provided for @workoutScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout Schedule'**
  String get workoutScheduleTitle;

  /// No description provided for @workoutScheduleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick your workout days and a reminder time — we\'ll nudge you locally, right on your device.'**
  String get workoutScheduleSubtitle;

  /// No description provided for @workoutScheduleDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Workout days'**
  String get workoutScheduleDaysLabel;

  /// No description provided for @workoutScheduleTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get workoutScheduleTimeLabel;

  /// No description provided for @workoutScheduleTimeNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get workoutScheduleTimeNotSet;

  /// No description provided for @workoutScheduleReminderToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Workout reminders'**
  String get workoutScheduleReminderToggleTitle;

  /// No description provided for @workoutScheduleReminderToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A local reminder on your chosen days and time'**
  String get workoutScheduleReminderToggleSubtitle;

  /// No description provided for @workoutScheduleQuietHoursToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Quiet hours'**
  String get workoutScheduleQuietHoursToggleTitle;

  /// No description provided for @workoutScheduleQuietHoursToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Never remind you during this window'**
  String get workoutScheduleQuietHoursToggleSubtitle;

  /// No description provided for @workoutScheduleQuietStartLabel.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get workoutScheduleQuietStartLabel;

  /// No description provided for @workoutScheduleQuietEndLabel.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get workoutScheduleQuietEndLabel;

  /// No description provided for @workoutScheduleChallengeToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge reminders'**
  String get workoutScheduleChallengeToggleTitle;

  /// No description provided for @workoutScheduleChallengeToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Completion and ending-soon alerts'**
  String get workoutScheduleChallengeToggleSubtitle;

  /// No description provided for @workoutScheduleSave.
  ///
  /// In en, this message translates to:
  /// **'Save Schedule'**
  String get workoutScheduleSave;

  /// No description provided for @workoutScheduleSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save your schedule. Try again.'**
  String get workoutScheduleSaveFailed;

  /// No description provided for @workoutScheduleQuietHoursAllDayWarning.
  ///
  /// In en, this message translates to:
  /// **'Same start and end time means quiet hours all day — no reminder will ever fire.'**
  String get workoutScheduleQuietHoursAllDayWarning;

  /// No description provided for @homeScheduleCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Schedule'**
  String get homeScheduleCardTitle;

  /// No description provided for @homeScheduleTodayWorkout.
  ///
  /// In en, this message translates to:
  /// **'Today\'s a workout day'**
  String get homeScheduleTodayWorkout;

  /// No description provided for @homeScheduleTodayRest.
  ///
  /// In en, this message translates to:
  /// **'Today\'s a rest day'**
  String get homeScheduleTodayRest;

  /// No description provided for @homeScheduleTodayCompleted.
  ///
  /// In en, this message translates to:
  /// **'Workout completed today 🎉'**
  String get homeScheduleTodayCompleted;

  /// No description provided for @homeScheduleEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No schedule set yet'**
  String get homeScheduleEmptyTitle;

  /// No description provided for @homeScheduleEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Pick your workout days to get local reminders.'**
  String get homeScheduleEmptyBody;

  /// No description provided for @homeScheduleSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get homeScheduleSetUp;

  /// No description provided for @homeScheduleEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get homeScheduleEdit;

  /// No description provided for @workoutScheduleSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Your Schedule'**
  String get workoutScheduleSheetTitle;

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

  /// No description provided for @privacyDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your account. Please try again.'**
  String get privacyDeleteFailed;

  /// No description provided for @legalPrivacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'Last updated: September 12, 2026. This Privacy Policy explains what information Nabvera (\"we\", \"us\") collects, how we use it, and the choices you have. Nabvera is built and operated by an individual developer, not a registered company.\n\nWhen you create an account, we collect your name, email address, and the profile details you choose to add — gender, date of birth, height, weight, fitness goal, activity level, and your available equipment and workout time. You can also add a profile picture from your device\'s photo library.\n\nWe store the workouts you complete, your logged sets and streaks, favorited workouts and recipes, challenge participation, and any nutrition preferences you set — dietary preferences like vegetarian or halal, allergies, disliked ingredients, and calorie/protein targets. These food preferences are self-reported by you and are not medical records.\n\nIf you choose to connect Apple Health or Health Connect, we only read the specific data types you turn on — steps, active minutes/calories, or sleep — and only after you explicitly enable syncing in Health Settings. This connection is off by default; you can disconnect it or turn off any individual data type at any time, and none of it is used for medical diagnosis or shared for advertising.\n\nSign-in is handled by Firebase Authentication (Google). If you enable Face ID or fingerprint unlock, your biometric data is processed entirely on your device by its operating system — it never reaches our servers; we only store whether you\'ve turned this feature on.\n\nIf you allow notifications, we store a device token (via Firebase Cloud Messaging) so we can send you the workout reminders and challenge updates you\'ve opted into. You can turn reminders off at any time from Settings.\n\nWe use our own first-party analytics — not a third-party tracking SDK — to understand which features are used (for example, that a workout was started or a meal plan was generated). These events never include your name, email, weight, or health data, and you can turn this off entirely from Profile → Privacy → Manage Your Data.\n\nWhen you use the AI meal planner, only your dietary preferences and calorie/protein targets are sent to our AI provider (Anthropic) to generate suggestions — never your name, email, or any other identifying information.\n\nWe do not sell your data. We share it only with the service providers that run the app on our behalf: Firebase (Google) for authentication and notifications, MongoDB Atlas for database hosting, Render for backend hosting, and Anthropic for AI meal suggestions as described above. These providers may process data outside your country.\n\nYou can view and edit most of your profile directly in the app, export a full copy of everything you\'ve stored with us at any time from Profile → Privacy → Manage Your Data → Export My Data, and delete your account at any time from Profile → Delete My Account — this permanently removes your workouts, nutrition data, posts, and profile within a short time.\n\nNabvera is not directed at children under 13, and we don\'t knowingly collect data from them. If you believe a child has created an account, contact us and we\'ll delete it.\n\nWe may update this policy as the app evolves; the date above will change when we do. Questions about this policy or your data? Email us at mohnadzakoot34@gmail.com.'**
  String get legalPrivacyPolicyBody;

  /// No description provided for @legalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'By creating an account or using Nabvera, you agree to these Terms. If you don\'t agree, please don\'t use the app.\n\nYou must be at least 13 years old to use Nabvera. You\'re responsible for keeping your account credentials secure and for all activity under your account.\n\nWorkout and nutrition content in Nabvera — including AI-generated meal suggestions — is for general informational purposes only and is not medical, dietary, or professional advice. Consult a physician or registered dietitian before starting a new fitness or nutrition program, especially if you have a health condition.\n\nAI-generated meal plans are a suggestion layer built from vetted recipes and your stated preferences — they are not reviewed by a nutrition professional and may occasionally be inaccurate or unsuitable for your needs. Use your own judgment.\n\nUse Nabvera for personal fitness and nutrition tracking only. Don\'t misuse the app, attempt to access other users\' accounts or data, or interfere with its normal operation.\n\nYou own the content you add to your profile, like your photo and preferences. We only use it to provide the app\'s features as described in our Privacy Policy.\n\nWe aim to keep Nabvera available and reliable but don\'t guarantee uninterrupted access — features may change, and we may suspend or discontinue parts of the service.\n\nYou can delete your account at any time from Profile → Delete My Account. This action is permanent and cannot be undone.\n\nWe may update these Terms as the app evolves. Continuing to use Nabvera after an update means you accept the revised Terms. Questions? Email us at mohnadzakoot34@gmail.com.'**
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
  /// **'Download a copy of your profile, workout history, and nutrition logs as a JSON file.'**
  String get manageDataExportBody;

  /// No description provided for @manageDataExportAction.
  ///
  /// In en, this message translates to:
  /// **'Export My Data'**
  String get manageDataExportAction;

  /// No description provided for @manageDataExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t export your data. Please try again.'**
  String get manageDataExportFailed;

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

  /// No description provided for @notificationOpenSystemSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound, Vibration & Lock Screen'**
  String get notificationOpenSystemSettingsTitle;

  /// No description provided for @notificationOpenSystemSettingsBody.
  ///
  /// In en, this message translates to:
  /// **'Controlled by your device settings — tap to open them'**
  String get notificationOpenSystemSettingsBody;

  /// No description provided for @notificationOpenSystemSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open system settings'**
  String get notificationOpenSystemSettingsFailed;

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

  /// No description provided for @passwordGoogleAccountError.
  ///
  /// In en, this message translates to:
  /// **'This account signs in with Google and has no password to change.'**
  String get passwordGoogleAccountError;

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

  /// No description provided for @waterLogSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Water'**
  String get waterLogSheetTitle;

  /// No description provided for @waterCupsProgress.
  ///
  /// In en, this message translates to:
  /// **'{consumed} / {goal} cups'**
  String waterCupsProgress(int consumed, int goal);

  /// No description provided for @waterLogAddCup.
  ///
  /// In en, this message translates to:
  /// **'+1 Cup (250ml)'**
  String get waterLogAddCup;

  /// No description provided for @waterLogAddTwoCups.
  ///
  /// In en, this message translates to:
  /// **'+2 Cups (500ml)'**
  String get waterLogAddTwoCups;

  /// No description provided for @waterLogAdded.
  ///
  /// In en, this message translates to:
  /// **'Water logged'**
  String get waterLogAdded;

  /// No description provided for @waterLogFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t log water, please try again'**
  String get waterLogFailed;

  /// No description provided for @nutritionSetGoalsCta.
  ///
  /// In en, this message translates to:
  /// **'This is an estimated target — set your own nutrition goals'**
  String get nutritionSetGoalsCta;

  /// No description provided for @mealMarkAsEaten.
  ///
  /// In en, this message translates to:
  /// **'Mark as eaten'**
  String get mealMarkAsEaten;

  /// No description provided for @mealLogged.
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get mealLogged;

  /// No description provided for @mealLogUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get mealLogUndo;

  /// No description provided for @nutritionRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh nutrition data. Showing the last saved data.'**
  String get nutritionRefreshFailed;

  /// No description provided for @mealLogAdded.
  ///
  /// In en, this message translates to:
  /// **'Meal logged'**
  String get mealLogAdded;

  /// No description provided for @mealLogFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t log this meal, please try again'**
  String get mealLogFailed;

  /// No description provided for @mealLogRemoved.
  ///
  /// In en, this message translates to:
  /// **'Log removed'**
  String get mealLogRemoved;

  /// No description provided for @mealLogUndoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t undo, please try again'**
  String get mealLogUndoFailed;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

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
  /// **'Any food allergies? Separate with commas.'**
  String get mealPlanAllergiesQuestion;

  /// No description provided for @mealPlanAllergiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. peanuts, shellfish'**
  String get mealPlanAllergiesHint;

  /// No description provided for @mealPlanDislikedIngredients.
  ///
  /// In en, this message translates to:
  /// **'Disliked Ingredients'**
  String get mealPlanDislikedIngredients;

  /// No description provided for @mealPlanDislikedIngredientsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Anything you\'d rather avoid? Separate with commas.'**
  String get mealPlanDislikedIngredientsQuestion;

  /// No description provided for @mealPlanDislikedIngredientsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. mushrooms, olives'**
  String get mealPlanDislikedIngredientsHint;

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

  /// No description provided for @mealPlanGeneratingTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a plan for you'**
  String get mealPlanGeneratingTitle;

  /// No description provided for @mealPlanGeneratingBody.
  ///
  /// In en, this message translates to:
  /// **'Arranging recipes that fit your targets and preferences into a 7-day plan…'**
  String get mealPlanGeneratingBody;

  /// No description provided for @mealPlanSeeRecipe.
  ///
  /// In en, this message translates to:
  /// **'See Recipe'**
  String get mealPlanSeeRecipe;

  /// No description provided for @mealPlanDietVegetarian.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get mealPlanDietVegetarian;

  /// No description provided for @mealPlanDietVegan.
  ///
  /// In en, this message translates to:
  /// **'Vegan'**
  String get mealPlanDietVegan;

  /// No description provided for @mealPlanDietHalal.
  ///
  /// In en, this message translates to:
  /// **'Halal'**
  String get mealPlanDietHalal;

  /// No description provided for @mealPlanDietGlutenFree.
  ///
  /// In en, this message translates to:
  /// **'Gluten-Free'**
  String get mealPlanDietGlutenFree;

  /// No description provided for @mealPlanDietLactoseFree.
  ///
  /// In en, this message translates to:
  /// **'Lactose-Free'**
  String get mealPlanDietLactoseFree;

  /// No description provided for @mealPlanCookingQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick (under 15 min)'**
  String get mealPlanCookingQuick;

  /// No description provided for @mealPlanCookingStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard (15-30 min)'**
  String get mealPlanCookingStandard;

  /// No description provided for @mealPlanCookingFlexible.
  ///
  /// In en, this message translates to:
  /// **'Flexible (30+ min)'**
  String get mealPlanCookingFlexible;

  /// No description provided for @mealPlanCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Calorie Target'**
  String get mealPlanCalorieTarget;

  /// No description provided for @mealPlanProteinTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Protein Target (g)'**
  String get mealPlanProteinTarget;

  /// No description provided for @mealPlanWeeklyBudget.
  ///
  /// In en, this message translates to:
  /// **'Weekly Food Budget (optional)'**
  String get mealPlanWeeklyBudget;

  /// No description provided for @mealPlanUseEstimate.
  ///
  /// In en, this message translates to:
  /// **'Use estimated target'**
  String get mealPlanUseEstimate;

  /// No description provided for @mealPlanEstimateDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is a rough estimate based on your profile, not medical advice. You can always adjust it yourself.'**
  String get mealPlanEstimateDisclaimer;

  /// No description provided for @mealPlanEstimateUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Add your age, height, and weight in your profile to get an estimated target.'**
  String get mealPlanEstimateUnavailable;

  /// No description provided for @mealPlanSavePreferences.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get mealPlanSavePreferences;

  /// No description provided for @mealPlanPreferencesSaved.
  ///
  /// In en, this message translates to:
  /// **'Nutrition preferences saved'**
  String get mealPlanPreferencesSaved;

  /// No description provided for @mealPlanEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No meal plan yet'**
  String get mealPlanEmptyTitle;

  /// No description provided for @mealPlanEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Set your nutrition preferences and generate a personalized weekly meal plan built from our recipes.'**
  String get mealPlanEmptyBody;

  /// No description provided for @mealPlanSetPreferences.
  ///
  /// In en, this message translates to:
  /// **'Set Nutrition Preferences'**
  String get mealPlanSetPreferences;

  /// No description provided for @mealPlanGenerateCta.
  ///
  /// In en, this message translates to:
  /// **'Generate My Weekly Plan'**
  String get mealPlanGenerateCta;

  /// No description provided for @mealPlanRegenerateDay.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Day'**
  String get mealPlanRegenerateDay;

  /// No description provided for @mealPlanReplaceMeal.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get mealPlanReplaceMeal;

  /// No description provided for @mealPlanDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String mealPlanDayLabel(int number);

  /// No description provided for @mealPlanSectionBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealPlanSectionBreakfast;

  /// No description provided for @mealPlanSectionLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealPlanSectionLunch;

  /// No description provided for @mealPlanSectionDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealPlanSectionDinner;

  /// No description provided for @mealPlanSectionSnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get mealPlanSectionSnacks;

  /// No description provided for @mealPlanSourceFallbackNote.
  ///
  /// In en, this message translates to:
  /// **'The AI planner wasn\'t available, so this plan was built with our rule-based planner instead.'**
  String get mealPlanSourceFallbackNote;

  /// No description provided for @mealPlanDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These suggestions are general and are not a substitute for consulting a nutrition professional.'**
  String get mealPlanDisclaimer;

  /// No description provided for @mealPlanGenerationFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t generate a plan'**
  String get mealPlanGenerationFailedTitle;

  /// No description provided for @mealPlanGenerationFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while generating your plan. Please try again.'**
  String get mealPlanGenerationFailedBody;

  /// No description provided for @mealPlanShoppingListTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get mealPlanShoppingListTitle;

  /// No description provided for @mealPlanShoppingListEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your shopping list will appear here once you generate a plan.'**
  String get mealPlanShoppingListEmpty;

  /// No description provided for @mealPlanViewShoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get mealPlanViewShoppingList;

  /// No description provided for @mealPlanViewHistory.
  ///
  /// In en, this message translates to:
  /// **'Past Plans'**
  String get mealPlanViewHistory;

  /// No description provided for @mealPlanHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No past meal plans yet.'**
  String get mealPlanHistoryEmpty;

  /// No description provided for @mealPlanReasonMatchesCalorieTarget.
  ///
  /// In en, this message translates to:
  /// **'Fits your calorie target'**
  String get mealPlanReasonMatchesCalorieTarget;

  /// No description provided for @mealPlanReasonMatchesProteinTarget.
  ///
  /// In en, this message translates to:
  /// **'Fits your protein target'**
  String get mealPlanReasonMatchesProteinTarget;

  /// No description provided for @mealPlanReasonQuickToCook.
  ///
  /// In en, this message translates to:
  /// **'Quick to cook'**
  String get mealPlanReasonQuickToCook;

  /// No description provided for @mealPlanReasonFitsDietaryPreference.
  ///
  /// In en, this message translates to:
  /// **'Matches your dietary preference'**
  String get mealPlanReasonFitsDietaryPreference;

  /// No description provided for @mealPlanReasonBudgetFriendly.
  ///
  /// In en, this message translates to:
  /// **'Budget friendly'**
  String get mealPlanReasonBudgetFriendly;

  /// No description provided for @mealPlanReasonVarietyBoost.
  ///
  /// In en, this message translates to:
  /// **'Adds some variety'**
  String get mealPlanReasonVarietyBoost;

  /// No description provided for @mealPlanReasonUsesFavoriteIngredients.
  ///
  /// In en, this message translates to:
  /// **'Uses ingredients you like'**
  String get mealPlanReasonUsesFavoriteIngredients;

  /// No description provided for @mealPlanReasonAllergySafeSubstitution.
  ///
  /// In en, this message translates to:
  /// **'Swapped to avoid an allergy/dislike'**
  String get mealPlanReasonAllergySafeSubstitution;

  /// No description provided for @mealPlanReasonFallbackDefaultMeal.
  ///
  /// In en, this message translates to:
  /// **'Picked by the rule-based planner'**
  String get mealPlanReasonFallbackDefaultMeal;

  /// No description provided for @mealPlanReasonRecipeUnavailablePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'No matching recipe yet — placeholder meal'**
  String get mealPlanReasonRecipeUnavailablePlaceholder;

  /// No description provided for @mealPlanReasonBalancedAcrossTargets.
  ///
  /// In en, this message translates to:
  /// **'Balanced across your targets'**
  String get mealPlanReasonBalancedAcrossTargets;

  /// No description provided for @mealPlanReasonHigherProteinDay.
  ///
  /// In en, this message translates to:
  /// **'A higher-protein day'**
  String get mealPlanReasonHigherProteinDay;

  /// No description provided for @mealPlanReasonLighterCalorieDay.
  ///
  /// In en, this message translates to:
  /// **'A lighter-calorie day'**
  String get mealPlanReasonLighterCalorieDay;

  /// No description provided for @mealPlanReasonFallbackRuleBasedPlan.
  ///
  /// In en, this message translates to:
  /// **'Built with the rule-based planner'**
  String get mealPlanReasonFallbackRuleBasedPlan;

  /// No description provided for @healthConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Health Data'**
  String get healthConnectionTitle;

  /// No description provided for @healthConnectionIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Optionally share steps, activity, and sleep from Health Connect or Apple Health to improve your progress stats and workout suggestions. This is never used for medical purposes, and you can disconnect at any time.'**
  String get healthConnectionIntroBody;

  /// No description provided for @healthConnectionDataStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get healthConnectionDataStepsLabel;

  /// No description provided for @healthConnectionDataStepsBody.
  ///
  /// In en, this message translates to:
  /// **'Your daily step count.'**
  String get healthConnectionDataStepsBody;

  /// No description provided for @healthConnectionDataActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get healthConnectionDataActivityLabel;

  /// No description provided for @healthConnectionDataActivityBody.
  ///
  /// In en, this message translates to:
  /// **'Active minutes and active calories, when available.'**
  String get healthConnectionDataActivityBody;

  /// No description provided for @healthConnectionDataSleepLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get healthConnectionDataSleepLabel;

  /// No description provided for @healthConnectionDataSleepBody.
  ///
  /// In en, this message translates to:
  /// **'Sleep duration, only if you grant it.'**
  String get healthConnectionDataSleepBody;

  /// No description provided for @healthConnectionSelectAtLeastOne.
  ///
  /// In en, this message translates to:
  /// **'Select at least one data type to continue'**
  String get healthConnectionSelectAtLeastOne;

  /// No description provided for @healthConnectionConnectButton.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get healthConnectionConnectButton;

  /// No description provided for @healthConnectionSkip.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get healthConnectionSkip;

  /// No description provided for @healthConnectionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted'**
  String get healthConnectionDeniedTitle;

  /// No description provided for @healthConnectionDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Nabvera can\'t sync your health data without permission. You can try again anytime from Health Data Settings — the rest of the app works normally either way.'**
  String get healthConnectionDeniedBody;

  /// No description provided for @healthConnectionUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Connect not available'**
  String get healthConnectionUnavailableTitle;

  /// No description provided for @healthConnectionUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'Install the Health Connect app to sync your health data. You can keep using Nabvera normally without it.'**
  String get healthConnectionUnavailableBody;

  /// No description provided for @healthConnectionInstallAction.
  ///
  /// In en, this message translates to:
  /// **'Install Health Connect'**
  String get healthConnectionInstallAction;

  /// No description provided for @healthConnectionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Health data connected'**
  String get healthConnectionSuccess;

  /// No description provided for @healthSettingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Data'**
  String get healthSettingsSectionTitle;

  /// No description provided for @healthSettingsSyncToggle.
  ///
  /// In en, this message translates to:
  /// **'Sync health data'**
  String get healthSettingsSyncToggle;

  /// No description provided for @healthSettingsSyncToggleBody.
  ///
  /// In en, this message translates to:
  /// **'Used only to improve your progress stats and workout suggestions — never for medical purposes.'**
  String get healthSettingsSyncToggleBody;

  /// No description provided for @healthSettingsStepsToggle.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get healthSettingsStepsToggle;

  /// No description provided for @healthSettingsActivityToggle.
  ///
  /// In en, this message translates to:
  /// **'Activity (minutes/calories)'**
  String get healthSettingsActivityToggle;

  /// No description provided for @healthSettingsSleepToggle.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get healthSettingsSleepToggle;

  /// No description provided for @healthSettingsLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String healthSettingsLastSynced(String time);

  /// No description provided for @healthSettingsLastSyncedNever.
  ///
  /// In en, this message translates to:
  /// **'Never synced'**
  String get healthSettingsLastSyncedNever;

  /// No description provided for @healthSettingsDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete health data'**
  String get healthSettingsDeleteButton;

  /// No description provided for @healthSettingsDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete health data?'**
  String get healthSettingsDeleteConfirmTitle;

  /// No description provided for @healthSettingsDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes every stored daily summary from Nabvera and disconnects sync. Your device\'s health app is unaffected.'**
  String get healthSettingsDeleteConfirmBody;

  /// No description provided for @healthSettingsDeleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Health data deleted'**
  String get healthSettingsDeleteSuccess;

  /// No description provided for @healthSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Activity'**
  String get healthSnapshotTitle;

  /// No description provided for @healthSnapshotStepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get healthSnapshotStepsLabel;

  /// No description provided for @healthSnapshotActiveMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Active min'**
  String get healthSnapshotActiveMinutesLabel;

  /// No description provided for @healthSnapshotNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Connect health data to see your daily activity here'**
  String get healthSnapshotNotConnected;

  /// No description provided for @healthSnapshotConnectCta.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get healthSnapshotConnectCta;

  /// No description provided for @healthInsightsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Health Insights'**
  String get healthInsightsSectionTitle;

  /// No description provided for @healthInsightsStepsAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg steps/day'**
  String get healthInsightsStepsAverage;

  /// No description provided for @healthInsightsNoData.
  ///
  /// In en, this message translates to:
  /// **'Connect health data to see weekly insights here.'**
  String get healthInsightsNoData;

  /// No description provided for @healthInsightsDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'These are general observations, not medical advice.'**
  String get healthInsightsDisclaimer;

  /// No description provided for @healthInsightActivityUp.
  ///
  /// In en, this message translates to:
  /// **'Your activity is trending up this week'**
  String get healthInsightActivityUp;

  /// No description provided for @healthInsightActivityDown.
  ///
  /// In en, this message translates to:
  /// **'Your activity is a bit lower than last week'**
  String get healthInsightActivityDown;

  /// No description provided for @healthInsightSleepConsistent.
  ///
  /// In en, this message translates to:
  /// **'Your sleep tracking has been consistent'**
  String get healthInsightSleepConsistent;

  /// No description provided for @healthInsightSleepLowData.
  ///
  /// In en, this message translates to:
  /// **'Not enough sleep data this week to say much'**
  String get healthInsightSleepLowData;

  /// No description provided for @healthInsightRestDaySuggested.
  ///
  /// In en, this message translates to:
  /// **'A lighter day might suit you today'**
  String get healthInsightRestDaySuggested;

  /// No description provided for @healthInsightKeepMomentum.
  ///
  /// In en, this message translates to:
  /// **'Keep up the momentum'**
  String get healthInsightKeepMomentum;

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

  /// No description provided for @communityForumsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to post'**
  String get communityForumsEmptyTitle;

  /// No description provided for @communityForumsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Share a workout win, a question, or a tip — your post could be the first thing someone else sees here.'**
  String get communityForumsEmptyMessage;

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

  /// No description provided for @communityReplyHint.
  ///
  /// In en, this message translates to:
  /// **'Write a reply…'**
  String get communityReplyHint;

  /// No description provided for @communityNewPostTitle.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get communityNewPostTitle;

  /// No description provided for @communityNewPostHint.
  ///
  /// In en, this message translates to:
  /// **'Share a workout win, a question, or a tip…'**
  String get communityNewPostHint;

  /// No description provided for @communityPostAction.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get communityPostAction;

  /// No description provided for @communityPostFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t publish your post. Please try again.'**
  String get communityPostFailed;

  /// No description provided for @communityForumsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get communityForumsEmptyAction;

  /// No description provided for @communityDeletePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete post?'**
  String get communityDeletePostTitle;

  /// No description provided for @communityDeletePostBody.
  ///
  /// In en, this message translates to:
  /// **'This removes it for everyone and can\'t be undone.'**
  String get communityDeletePostBody;

  /// No description provided for @communityDeletePostFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your post. Please try again.'**
  String get communityDeletePostFailed;

  /// No description provided for @communityDeleteCommentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete comment?'**
  String get communityDeleteCommentTitle;

  /// No description provided for @communityDeleteCommentBody.
  ///
  /// In en, this message translates to:
  /// **'This removes it for everyone and can\'t be undone.'**
  String get communityDeleteCommentBody;

  /// No description provided for @communityDeleteCommentFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t delete your comment. Please try again.'**
  String get communityDeleteCommentFailed;

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

  /// No description provided for @communitySuggestedForYou.
  ///
  /// In en, this message translates to:
  /// **'Suggested for you'**
  String get communitySuggestedForYou;

  /// No description provided for @communityMyActiveChallenges.
  ///
  /// In en, this message translates to:
  /// **'My active challenges'**
  String get communityMyActiveChallenges;

  /// No description provided for @communityCompletedChallenges.
  ///
  /// In en, this message translates to:
  /// **'Completed challenges'**
  String get communityCompletedChallenges;

  /// No description provided for @communityNoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions right now — check back after your next workout.'**
  String get communityNoSuggestions;

  /// No description provided for @communityNoActiveChallenges.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined any challenges yet.'**
  String get communityNoActiveChallenges;

  /// No description provided for @communityNoCompletedChallenges.
  ///
  /// In en, this message translates to:
  /// **'No completed challenges yet.'**
  String get communityNoCompletedChallenges;

  /// No description provided for @communityJoinChallenge.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get communityJoinChallenge;

  /// No description provided for @communityLeaveChallenge.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get communityLeaveChallenge;

  /// No description provided for @communityChallengeCompletedBadge.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get communityChallengeCompletedBadge;

  /// No description provided for @communityChallengeProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{value} / {target}'**
  String communityChallengeProgressLabel(int value, int target);

  /// No description provided for @communityChallengeGoalWorkoutsCount.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} workouts'**
  String communityChallengeGoalWorkoutsCount(int count);

  /// No description provided for @communityChallengeGoalActiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Reach {minutes} active minutes'**
  String communityChallengeGoalActiveMinutes(int minutes);

  /// No description provided for @communityChallengeGoalWorkoutStreak.
  ///
  /// In en, this message translates to:
  /// **'Train {days} days in a row'**
  String communityChallengeGoalWorkoutStreak(int days);

  /// No description provided for @communityChallengeGoalWeeklyConsistency.
  ///
  /// In en, this message translates to:
  /// **'Complete {count} workouts this week'**
  String communityChallengeGoalWeeklyConsistency(int count);

  /// No description provided for @communityChallengeGoalHeading.
  ///
  /// In en, this message translates to:
  /// **'Your goal'**
  String get communityChallengeGoalHeading;

  /// No description provided for @communityChallengeGoalHint.
  ///
  /// In en, this message translates to:
  /// **'Any workout you log counts toward this goal — no specific routine required.'**
  String get communityChallengeGoalHint;

  /// No description provided for @communityBrowseWorkouts.
  ///
  /// In en, this message translates to:
  /// **'Browse Workouts'**
  String get communityBrowseWorkouts;

  /// No description provided for @communityChallengeTimeLeftDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String communityChallengeTimeLeftDays(int days);

  /// No description provided for @communityChallengeTimeLeftHours.
  ///
  /// In en, this message translates to:
  /// **'{hours}h left'**
  String communityChallengeTimeLeftHours(int hours);

  /// No description provided for @communityChallengeExpired.
  ///
  /// In en, this message translates to:
  /// **'Window expired'**
  String get communityChallengeExpired;

  /// No description provided for @communityChallengeReasonWhy.
  ///
  /// In en, this message translates to:
  /// **'Why this challenge?'**
  String get communityChallengeReasonWhy;

  /// No description provided for @communityChallengeReasonGoodStartingChallenge.
  ///
  /// In en, this message translates to:
  /// **'A great first challenge to build momentum'**
  String get communityChallengeReasonGoodStartingChallenge;

  /// No description provided for @communityChallengeReasonBuildsOnCurrentStreak.
  ///
  /// In en, this message translates to:
  /// **'Builds on your current streak'**
  String get communityChallengeReasonBuildsOnCurrentStreak;

  /// No description provided for @communityChallengeReasonConsistentRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Matches how consistently you\'ve been training'**
  String get communityChallengeReasonConsistentRecentActivity;

  /// No description provided for @communityChallengeReasonMatchesActivityLevel.
  ///
  /// In en, this message translates to:
  /// **'Matches your current activity level'**
  String get communityChallengeReasonMatchesActivityLevel;

  /// No description provided for @communityYourBadges.
  ///
  /// In en, this message translates to:
  /// **'Your badges'**
  String get communityYourBadges;

  /// No description provided for @communityBadgeFirstChallenge.
  ///
  /// In en, this message translates to:
  /// **'First Challenge'**
  String get communityBadgeFirstChallenge;

  /// No description provided for @communityBadgeConsistencyBuilder.
  ///
  /// In en, this message translates to:
  /// **'Consistency Builder'**
  String get communityBadgeConsistencyBuilder;

  /// No description provided for @communityBadgeWeeklyWinner.
  ///
  /// In en, this message translates to:
  /// **'Weekly Winner'**
  String get communityBadgeWeeklyWinner;

  /// No description provided for @communityRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t refresh challenges. Showing the last saved data.'**
  String get communityRefreshFailed;

  /// No description provided for @communityChallengeJoinFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t join this challenge. Try again.'**
  String get communityChallengeJoinFailed;

  /// No description provided for @communityChallengeLeaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t leave this challenge. Try again.'**
  String get communityChallengeLeaveFailed;

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

  /// No description provided for @adminEditArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Article'**
  String get adminEditArticleTitle;

  /// No description provided for @adminAddArticleTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Article'**
  String get adminAddArticleTitle;

  /// No description provided for @adminEditChallengeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Challenge'**
  String get adminEditChallengeTitle;

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

  /// No description provided for @adminFieldIngredientsAr.
  ///
  /// In en, this message translates to:
  /// **'Ingredients (Arabic)'**
  String get adminFieldIngredientsAr;

  /// No description provided for @adminFieldStepsAr.
  ///
  /// In en, this message translates to:
  /// **'Steps (Arabic)'**
  String get adminFieldStepsAr;

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

  /// No description provided for @adminArabicTranslationHeading.
  ///
  /// In en, this message translates to:
  /// **'Arabic translation (optional)'**
  String get adminArabicTranslationHeading;

  /// No description provided for @adminArabicTranslationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown when the app is in Arabic; falls back to English above if left blank.'**
  String get adminArabicTranslationSubtitle;

  /// No description provided for @adminFieldTitleAr.
  ///
  /// In en, this message translates to:
  /// **'Title (Arabic)'**
  String get adminFieldTitleAr;

  /// No description provided for @adminFieldNameAr.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get adminFieldNameAr;

  /// No description provided for @adminFieldDetailsAr.
  ///
  /// In en, this message translates to:
  /// **'Details (Arabic)'**
  String get adminFieldDetailsAr;

  /// No description provided for @adminFieldDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get adminFieldDescriptionAr;

  /// No description provided for @adminFieldContentAr.
  ///
  /// In en, this message translates to:
  /// **'Content (Arabic)'**
  String get adminFieldContentAr;

  /// No description provided for @adminFieldChallengeType.
  ///
  /// In en, this message translates to:
  /// **'Challenge type'**
  String get adminFieldChallengeType;

  /// No description provided for @adminFieldTargetValue.
  ///
  /// In en, this message translates to:
  /// **'Target value'**
  String get adminFieldTargetValue;

  /// No description provided for @adminChallengeTypeNone.
  ///
  /// In en, this message translates to:
  /// **'Not tracked (view-only)'**
  String get adminChallengeTypeNone;

  /// No description provided for @adminChallengeTypeWorkoutsCount.
  ///
  /// In en, this message translates to:
  /// **'Workouts completed'**
  String get adminChallengeTypeWorkoutsCount;

  /// No description provided for @adminChallengeTypeActiveMinutes.
  ///
  /// In en, this message translates to:
  /// **'Active minutes'**
  String get adminChallengeTypeActiveMinutes;

  /// No description provided for @adminChallengeTypeWorkoutStreak.
  ///
  /// In en, this message translates to:
  /// **'Workout streak (days)'**
  String get adminChallengeTypeWorkoutStreak;

  /// No description provided for @adminChallengeTypeWeeklyConsistency.
  ///
  /// In en, this message translates to:
  /// **'Weekly consistency'**
  String get adminChallengeTypeWeeklyConsistency;

  /// No description provided for @favoriteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteTitle;

  /// No description provided for @subscriptionPaywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Nabvera Pro'**
  String get subscriptionPaywallTitle;

  /// No description provided for @subscriptionPaywallSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock your full training & nutrition potential'**
  String get subscriptionPaywallSubtitle;

  /// No description provided for @subscriptionFeatureAiMealPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI Meal Plans'**
  String get subscriptionFeatureAiMealPlanTitle;

  /// No description provided for @subscriptionFeatureAiMealPlanBody.
  ///
  /// In en, this message translates to:
  /// **'Generate a fresh personalized plan any day, no daily limit'**
  String get subscriptionFeatureAiMealPlanBody;

  /// No description provided for @subscriptionFeatureWorkoutsTitle.
  ///
  /// In en, this message translates to:
  /// **'Full Workout Library'**
  String get subscriptionFeatureWorkoutsTitle;

  /// No description provided for @subscriptionFeatureWorkoutsBody.
  ///
  /// In en, this message translates to:
  /// **'Every routine and difficulty level, unlocked'**
  String get subscriptionFeatureWorkoutsBody;

  /// No description provided for @subscriptionFeatureRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recovery & Progress Insights'**
  String get subscriptionFeatureRecoveryTitle;

  /// No description provided for @subscriptionFeatureRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'Track your recovery map and long-term trends'**
  String get subscriptionFeatureRecoveryBody;

  /// No description provided for @subscriptionFeatureSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Priority Support'**
  String get subscriptionFeatureSupportTitle;

  /// No description provided for @subscriptionFeatureSupportBody.
  ///
  /// In en, this message translates to:
  /// **'Get help from our team, faster'**
  String get subscriptionFeatureSupportBody;

  /// No description provided for @subscriptionPlanBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get subscriptionPlanBestValue;

  /// No description provided for @subscriptionContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get subscriptionContinueButton;

  /// No description provided for @subscriptionRestorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get subscriptionRestorePurchases;

  /// No description provided for @subscriptionRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has been restored'**
  String get subscriptionRestoreSuccess;

  /// No description provided for @subscriptionRestoreNothingFound.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found for this account'**
  String get subscriptionRestoreNothingFound;

  /// No description provided for @subscriptionRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t restore purchases. Please try again.'**
  String get subscriptionRestoreFailed;

  /// No description provided for @subscriptionPurchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed. Please try again.'**
  String get subscriptionPurchaseFailed;

  /// No description provided for @subscriptionAlreadySubscribed.
  ///
  /// In en, this message translates to:
  /// **'You\'re already a Pro member'**
  String get subscriptionAlreadySubscribed;

  /// No description provided for @subscriptionOfferingsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions aren\'t available right now. Please try again later.'**
  String get subscriptionOfferingsUnavailable;

  /// No description provided for @subscriptionLegalFooterPrefix.
  ///
  /// In en, this message translates to:
  /// **'Recurring billing, cancel anytime. By continuing you agree to our '**
  String get subscriptionLegalFooterPrefix;

  /// No description provided for @subscriptionManageSubscriptionCta.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get subscriptionManageSubscriptionCta;

  /// No description provided for @profileMenuSubscription.
  ///
  /// In en, this message translates to:
  /// **'Nabvera Pro'**
  String get profileMenuSubscription;

  /// No description provided for @profileMenuSubscriptionSubtitleFree.
  ///
  /// In en, this message translates to:
  /// **'Upgrade for full access'**
  String get profileMenuSubscriptionSubtitleFree;

  /// No description provided for @profileMenuSubscriptionSubtitlePro.
  ///
  /// In en, this message translates to:
  /// **'Manage your plan'**
  String get profileMenuSubscriptionSubtitlePro;

  /// No description provided for @mealPlanUpgradeRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'ve used today\'s free plan'**
  String get mealPlanUpgradeRequiredTitle;

  /// No description provided for @mealPlanUpgradeRequiredBody.
  ///
  /// In en, this message translates to:
  /// **'Free accounts get one AI meal plan per day. Upgrade to Nabvera Pro for unlimited plans, any time.'**
  String get mealPlanUpgradeRequiredBody;

  /// No description provided for @mealPlanUpgradeRequiredCta.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get mealPlanUpgradeRequiredCta;

  /// No description provided for @subscriptionActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re a Pro member'**
  String get subscriptionActiveTitle;

  /// No description provided for @subscriptionActiveTierMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly plan'**
  String get subscriptionActiveTierMonthly;

  /// No description provided for @subscriptionActiveTierYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly plan'**
  String get subscriptionActiveTierYearly;

  /// No description provided for @subscriptionActiveRenewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews on {date}'**
  String subscriptionActiveRenewsOn(String date);

  /// No description provided for @subscriptionActiveExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Access ends on {date}'**
  String subscriptionActiveExpiresOn(String date);

  /// No description provided for @subscriptionActiveGracePeriod.
  ///
  /// In en, this message translates to:
  /// **'There\'s a problem with your last payment — please update it to keep your Pro access.'**
  String get subscriptionActiveGracePeriod;

  /// No description provided for @subscriptionManageSubscriptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open subscription management. Please try again.'**
  String get subscriptionManageSubscriptionFailed;
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
