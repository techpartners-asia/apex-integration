import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'sdk_localizations_en.dart';
import 'sdk_localizations_mn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SdkLocalizations
/// returned by `SdkLocalizations.of(context)`.
///
/// Applications need to include `SdkLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/sdk_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SdkLocalizations.localizationsDelegates,
///   supportedLocales: SdkLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the SdkLocalizations.supportedLocales
/// property.
abstract class SdkLocalizations {
  SdkLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SdkLocalizations of(BuildContext context) {
    return Localizations.of<SdkLocalizations>(context, SdkLocalizations)!;
  }

  static const LocalizationsDelegate<SdkLocalizations> delegate =
      _SdkLocalizationsDelegate();

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
    Locale('en'),
    Locale('mn'),
  ];

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get commonSubmit;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get commonPrevious;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get commonSelect;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @commonViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get commonViewDetails;

  /// No description provided for @commonAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonAmount;

  /// No description provided for @commonCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get commonCurrency;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get commonMessage;

  /// No description provided for @commonNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get commonNoData;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @errorsGenericTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorsGenericTitle;

  /// No description provided for @errorsServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Service is currently unavailable.'**
  String get errorsServiceUnavailable;

  /// No description provided for @errorsUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get errorsUnexpected;

  /// No description provided for @errorsNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please try again.'**
  String get errorsNetwork;

  /// No description provided for @errorsSession.
  ///
  /// In en, this message translates to:
  /// **'Your session is invalid. Please reopen the mini app.'**
  String get errorsSession;

  /// No description provided for @errorsConfig.
  ///
  /// In en, this message translates to:
  /// **'This mini app integration is not configured correctly.'**
  String get errorsConfig;

  /// No description provided for @errorsSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session is invalid or has expired.'**
  String get errorsSessionExpired;

  /// No description provided for @errorsUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to perform this action.'**
  String get errorsUnauthorized;

  /// No description provided for @errorsApiLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data from the backend.'**
  String get errorsApiLoadFailed;

  /// No description provided for @errorsActionFailed.
  ///
  /// In en, this message translates to:
  /// **'The action could not be completed.'**
  String get errorsActionFailed;

  /// No description provided for @errorsMissingIntegration.
  ///
  /// In en, this message translates to:
  /// **'Required host integration is missing.'**
  String get errorsMissingIntegration;

  /// No description provided for @errorsMissingContract.
  ///
  /// In en, this message translates to:
  /// **'Exact backend contract is not available yet.'**
  String get errorsMissingContract;

  /// No description provided for @errorsUnknownRoute.
  ///
  /// In en, this message translates to:
  /// **'The reqed flow route is not registered.'**
  String get errorsUnknownRoute;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get validationRequired;

  /// No description provided for @validationSelectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a value.'**
  String get validationSelectionRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validationInvalidEmail;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number.'**
  String get validationInvalidPhone;

  /// No description provided for @validationInvalidRegisterNo.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid register number.'**
  String get validationInvalidRegisterNo;

  /// No description provided for @validationInvalidIban.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid IBAN/account number.'**
  String get validationInvalidIban;

  /// No description provided for @validationMinLength.
  ///
  /// In en, this message translates to:
  /// **'Enter at least {count} characters.'**
  String validationMinLength(int count);

  /// No description provided for @validationMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Enter no more than {count} characters.'**
  String validationMaxLength(int count);

  /// No description provided for @validationMinQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity must be at least 1.'**
  String get validationMinQuantity;

  /// No description provided for @validationInvalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount.'**
  String get validationInvalidAmount;

  /// No description provided for @validationMinAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount is below the minimum allowed value.'**
  String get validationMinAmount;

  /// No description provided for @validationQuestionnaireIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please answer all questions before continuing.'**
  String get validationQuestionnaireIncomplete;

  /// No description provided for @validationMissingPackSelection.
  ///
  /// In en, this message translates to:
  /// **'Please choose a recommended pack first.'**
  String get validationMissingPackSelection;

  /// No description provided for @validationMissingSrcFiCode.
  ///
  /// In en, this message translates to:
  /// **'A valid srcFiCode is required before retrieving recommended packs.'**
  String get validationMissingSrcFiCode;

  /// No description provided for @validationMissingOrderId.
  ///
  /// In en, this message translates to:
  /// **'Order identifier is required.'**
  String get validationMissingOrderId;

  /// No description provided for @validationMissingAcntReference.
  ///
  /// In en, this message translates to:
  /// **'Acnt reference is required.'**
  String get validationMissingAcntReference;

  /// No description provided for @ipsHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'IPS Overview'**
  String get ipsHomeTitle;

  /// No description provided for @ipsHomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sec acnt bootstrap and IPS eligibility flow.'**
  String get ipsHomeSubtitle;

  /// No description provided for @ipsHomeOverviewCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Current state'**
  String get ipsHomeOverviewCardTitle;

  /// No description provided for @ipsHomeOpenAcntCta.
  ///
  /// In en, this message translates to:
  /// **'Acnt flow'**
  String get ipsHomeOpenAcntCta;

  /// No description provided for @ipsHomeQuestionnaireCta.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get ipsHomeQuestionnaireCta;

  /// No description provided for @ipsHomeRecommendedPackCta.
  ///
  /// In en, this message translates to:
  /// **'Recommended packs'**
  String get ipsHomeRecommendedPackCta;

  /// No description provided for @ipsHomePortfolioCta.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get ipsHomePortfolioCta;

  /// No description provided for @ipsHomeOrdersCta.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ipsHomeOrdersCta;

  /// No description provided for @ipsHomeNextStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Next steps'**
  String get ipsHomeNextStepsTitle;

  /// No description provided for @ipsHomeNextStepsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open the next IPS flow based on the current customer state.'**
  String get ipsHomeNextStepsSubtitle;

  /// No description provided for @ipsHomeSecAcntLabel.
  ///
  /// In en, this message translates to:
  /// **'Sec acnt'**
  String get ipsHomeSecAcntLabel;

  /// No description provided for @ipsHomeIpsAcntLabel.
  ///
  /// In en, this message translates to:
  /// **'IPS acnt'**
  String get ipsHomeIpsAcntLabel;

  /// No description provided for @ipsHomeAcntStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Acnt status'**
  String get ipsHomeAcntStatusLabel;

  /// No description provided for @ipsHomeIpsBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'IPS balance'**
  String get ipsHomeIpsBalanceLabel;

  /// Greeting shown on the IPS overview screen.
  ///
  /// In en, this message translates to:
  /// **'Hello, {displayName}'**
  String ipsHomeGreeting(Object displayName);

  /// No description provided for @ipsOverviewVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get ipsOverviewVerificationTitle;

  /// No description provided for @ipsOverviewVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete the steps below to unlock your first pack purchase.'**
  String get ipsOverviewVerificationSubtitle;

  /// No description provided for @ipsOverviewFinalStepLabel.
  ///
  /// In en, this message translates to:
  /// **'Final step'**
  String get ipsOverviewFinalStepLabel;

  /// No description provided for @ipsOverviewFirstPackTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy your first pack'**
  String get ipsOverviewFirstPackTitle;

  /// No description provided for @ipsOverviewActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Trading'**
  String get ipsOverviewActionTitle;

  /// No description provided for @ipsOverviewProfileVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get ipsOverviewProfileVerified;

  /// No description provided for @ipsOverviewProfileGuestName.
  ///
  /// In en, this message translates to:
  /// **'InvestX user'**
  String get ipsOverviewProfileGuestName;

  /// No description provided for @ipsOverviewProfileMenuPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get ipsOverviewProfileMenuPersonalInfo;

  /// No description provided for @ipsOverviewProfilePersonalInfoMissing.
  ///
  /// In en, this message translates to:
  /// **'Information missing'**
  String get ipsOverviewProfilePersonalInfoMissing;

  /// No description provided for @ipsOverviewProfileMenuLaw.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get ipsOverviewProfileMenuLaw;

  /// No description provided for @ipsOverviewProfileMenuPackInfo.
  ///
  /// In en, this message translates to:
  /// **'Pack details'**
  String get ipsOverviewProfileMenuPackInfo;

  /// No description provided for @ipsOverviewProfileMenuAchievements.
  ///
  /// In en, this message translates to:
  /// **'Your achievements'**
  String get ipsOverviewProfileMenuAchievements;

  /// No description provided for @ipsOverviewProfileMenuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get ipsOverviewProfileMenuTerms;

  /// No description provided for @ipsOverviewProfileMenuFeedback.
  ///
  /// In en, this message translates to:
  /// **'Complaints and feedback'**
  String get ipsOverviewProfileMenuFeedback;

  /// No description provided for @ipsOverviewProfileMenuContact.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get ipsOverviewProfileMenuContact;

  /// No description provided for @ipsOverviewDashboardGreetingLabel.
  ///
  /// In en, this message translates to:
  /// **'Greetings of the day'**
  String get ipsOverviewDashboardGreetingLabel;

  /// No description provided for @ipsOverviewDashboardProfitMessage.
  ///
  /// In en, this message translates to:
  /// **'{amount} in return'**
  String ipsOverviewDashboardProfitMessage(Object amount);

  /// No description provided for @ipsOverviewDashboardQuickRecharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge pack'**
  String get ipsOverviewDashboardQuickRecharge;

  /// No description provided for @ipsOverviewDashboardQuickWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw money'**
  String get ipsOverviewDashboardQuickWithdraw;

  /// No description provided for @ipsOverviewDashboardAllocationStocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks'**
  String get ipsOverviewDashboardAllocationStocks;

  /// No description provided for @ipsOverviewDashboardAllocationBonds.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get ipsOverviewDashboardAllocationBonds;

  /// No description provided for @ipsOverviewDashboardAllocationTotal.
  ///
  /// In en, this message translates to:
  /// **'Total investment'**
  String get ipsOverviewDashboardAllocationTotal;

  /// No description provided for @ipsOverviewDashboardYieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Your return'**
  String get ipsOverviewDashboardYieldLabel;

  /// No description provided for @ipsOverviewDashboardDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get ipsOverviewDashboardDetails;

  /// No description provided for @ipsOverviewDashboardReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get ipsOverviewDashboardReminderTitle;

  /// No description provided for @ipsOverviewDashboardReminderBody.
  ///
  /// In en, this message translates to:
  /// **'If you keep recharging your account every month, your selected pack will continue funding automatically. Securities-account transfers may take 2 to 4 business days before trading is executed.'**
  String get ipsOverviewDashboardReminderBody;

  /// No description provided for @ipsOverviewDashboardGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Target goal'**
  String get ipsOverviewDashboardGoalTitle;

  /// No description provided for @ipsOverviewDashboardGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get ipsOverviewDashboardGoalProgress;

  /// No description provided for @ipsOverviewDashboardRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Month {count} in a row!'**
  String ipsOverviewDashboardRewardTitle(int count);

  /// No description provided for @ipsOverviewDashboardRewardBody.
  ///
  /// In en, this message translates to:
  /// **'You have invested consistently, so you qualify for a 5000 Tino Coin reward.'**
  String get ipsOverviewDashboardRewardBody;

  /// No description provided for @ipsOverviewDashboardActionRecharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge pack'**
  String get ipsOverviewDashboardActionRecharge;

  /// No description provided for @ipsOverviewDashboardActionSell.
  ///
  /// In en, this message translates to:
  /// **'Close pack'**
  String get ipsOverviewDashboardActionSell;

  /// No description provided for @ipsAcntTitle.
  ///
  /// In en, this message translates to:
  /// **'Sec acnt'**
  String get ipsAcntTitle;

  /// No description provided for @ipsAcntSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Intro, agreement, acnt req, and QR creation.'**
  String get ipsAcntSubtitle;

  /// No description provided for @ipsAcntOpenAcnt.
  ///
  /// In en, this message translates to:
  /// **'Open sec acnt'**
  String get ipsAcntOpenAcnt;

  /// No description provided for @ipsAcntVerifyAcnt.
  ///
  /// In en, this message translates to:
  /// **'Verify acnt'**
  String get ipsAcntVerifyAcnt;

  /// No description provided for @ipsAcntGenerateQr.
  ///
  /// In en, this message translates to:
  /// **'Generate QR'**
  String get ipsAcntGenerateQr;

  /// No description provided for @ipsAcntQrValue.
  ///
  /// In en, this message translates to:
  /// **'QR value'**
  String get ipsAcntQrValue;

  /// No description provided for @ipsAcntOpeningFee.
  ///
  /// In en, this message translates to:
  /// **'Opening fee'**
  String get ipsAcntOpeningFee;

  /// No description provided for @ipsAcntMissingService.
  ///
  /// In en, this message translates to:
  /// **'Sec acnt integration is not configured.'**
  String get ipsAcntMissingService;

  /// No description provided for @ipsAcntHasAcnt.
  ///
  /// In en, this message translates to:
  /// **'Sec acnt available'**
  String get ipsAcntHasAcnt;

  /// No description provided for @ipsAcntNoAcnt.
  ///
  /// In en, this message translates to:
  /// **'Sec acnt missing'**
  String get ipsAcntNoAcnt;

  /// No description provided for @ipsAcntBalance.
  ///
  /// In en, this message translates to:
  /// **'Sec balance'**
  String get ipsAcntBalance;

  /// No description provided for @ipsAcntFlowBody.
  ///
  /// In en, this message translates to:
  /// **'Account opening flow'**
  String get ipsAcntFlowBody;

  /// No description provided for @ipsAcntPendingQrMessage.
  ///
  /// In en, this message translates to:
  /// **'Generate the QR to continue the sec-acnt opening flow.'**
  String get ipsAcntPendingQrMessage;

  /// No description provided for @ipsBootstrapMissingService.
  ///
  /// In en, this message translates to:
  /// **'Bootstrap service is not configured.'**
  String get ipsBootstrapMissingService;

  /// No description provided for @ipsBootstrapLoading.
  ///
  /// In en, this message translates to:
  /// **'Checking acnt bootstrap state.'**
  String get ipsBootstrapLoading;

  /// No description provided for @ipsSplashTitle.
  ///
  /// In en, this message translates to:
  /// **'InvestX Splash'**
  String get ipsSplashTitle;

  /// No description provided for @ipsSplashSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Launch startup flow for the current user, login session, and IPS state.'**
  String get ipsSplashSubtitle;

  /// No description provided for @ipsQuestionnaireTitle.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire'**
  String get ipsQuestionnaireTitle;

  /// No description provided for @ipsQuestionnaireSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Question list retrieval and score calculation.'**
  String get ipsQuestionnaireSubtitle;

  /// No description provided for @ipsQuestionnaireCalculateScore.
  ///
  /// In en, this message translates to:
  /// **'Calculate score'**
  String get ipsQuestionnaireCalculateScore;

  /// Label prefix for numbered questionnaire items.
  ///
  /// In en, this message translates to:
  /// **'Question {index}'**
  String ipsQuestionnaireQuestionPrefix(Object index);

  /// Fallback label for numbered questionnaire options.
  ///
  /// In en, this message translates to:
  /// **'Option {index}'**
  String ipsQuestionnaireOptionPrefix(Object index);

  /// No description provided for @ipsQuestionnaireResTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculated res'**
  String get ipsQuestionnaireResTitle;

  /// No description provided for @ipsQuestionnaireCustomerCode.
  ///
  /// In en, this message translates to:
  /// **'Customer code'**
  String get ipsQuestionnaireCustomerCode;

  /// No description provided for @ipsQuestionnaireViewPacks.
  ///
  /// In en, this message translates to:
  /// **'View recommended packs'**
  String get ipsQuestionnaireViewPacks;

  /// No description provided for @ipsQuestionnaireMissingService.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire service is not configured.'**
  String get ipsQuestionnaireMissingService;

  /// No description provided for @ipsQuestionnaireScore.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get ipsQuestionnaireScore;

  /// No description provided for @ipsQuestionnaireSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get ipsQuestionnaireSummary;

  /// No description provided for @ipsQuestionnaireLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading questionnaire.'**
  String get ipsQuestionnaireLoading;

  /// No description provided for @ipsQuestionnaireRecommendationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your trusted investment guide'**
  String get ipsQuestionnaireRecommendationTitle;

  /// No description provided for @ipsQuestionnaireRecommendationBody.
  ///
  /// In en, this message translates to:
  /// **'Answer a few short questions and we will match you with the most suitable INVESTX pack.'**
  String get ipsQuestionnaireRecommendationBody;

  /// No description provided for @ipsQuestionnaireCalculatingMessage.
  ///
  /// In en, this message translates to:
  /// **'Preparing the most suitable pack recommendation for you.'**
  String get ipsQuestionnaireCalculatingMessage;

  /// No description provided for @ipsQuestionnaireStaticQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Investment amount'**
  String get ipsQuestionnaireStaticQuestionTitle;

  /// No description provided for @ipsQuestionnaireStaticOption100k.
  ///
  /// In en, this message translates to:
  /// **'100,000'**
  String get ipsQuestionnaireStaticOption100k;

  /// No description provided for @ipsQuestionnaireStaticOption200k.
  ///
  /// In en, this message translates to:
  /// **'200,000'**
  String get ipsQuestionnaireStaticOption200k;

  /// No description provided for @ipsQuestionnaireStaticOption500k.
  ///
  /// In en, this message translates to:
  /// **'500,000'**
  String get ipsQuestionnaireStaticOption500k;

  /// No description provided for @ipsQuestionnaireStaticOption1000000Plus.
  ///
  /// In en, this message translates to:
  /// **'1,000,000+'**
  String get ipsQuestionnaireStaticOption1000000Plus;

  /// No description provided for @ipsQuestionnaireTargetGoalMissing.
  ///
  /// In en, this message translates to:
  /// **'Select your investment amount before continuing.'**
  String get ipsQuestionnaireTargetGoalMissing;

  /// No description provided for @ipsSignatureUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading your signature.'**
  String get ipsSignatureUploading;

  /// No description provided for @ipsPackTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended packs'**
  String get ipsPackTitle;

  /// No description provided for @ipsPackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended IPS pack retrieval and selection.'**
  String get ipsPackSubtitle;

  /// No description provided for @ipsPackRecommendedBadge.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get ipsPackRecommendedBadge;

  /// No description provided for @ipsPackChoosePack.
  ///
  /// In en, this message translates to:
  /// **'Choose pack'**
  String get ipsPackChoosePack;

  /// No description provided for @ipsPackAllocation.
  ///
  /// In en, this message translates to:
  /// **'Allocation'**
  String get ipsPackAllocation;

  /// No description provided for @ipsPackBondPercent.
  ///
  /// In en, this message translates to:
  /// **'Bond'**
  String get ipsPackBondPercent;

  /// No description provided for @ipsPackStockPercent.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get ipsPackStockPercent;

  /// No description provided for @ipsPackAssetPercent.
  ///
  /// In en, this message translates to:
  /// **'Asset'**
  String get ipsPackAssetPercent;

  /// No description provided for @ipsPackNoPacks.
  ///
  /// In en, this message translates to:
  /// **'No recommended packs were returned.'**
  String get ipsPackNoPacks;

  /// No description provided for @ipsPackMissingService.
  ///
  /// In en, this message translates to:
  /// **'Pack service is not configured.'**
  String get ipsPackMissingService;

  /// No description provided for @ipsPackSrcFiCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Questionnaire res with srcFiCode is required for the official pack API.'**
  String get ipsPackSrcFiCodeRequired;

  /// No description provided for @ipsPackCode.
  ///
  /// In en, this message translates to:
  /// **'Pack code'**
  String get ipsPackCode;

  /// No description provided for @ipsPackSecondaryName.
  ///
  /// In en, this message translates to:
  /// **'Secondary name'**
  String get ipsPackSecondaryName;

  /// No description provided for @ipsPackLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading recommended packs.'**
  String get ipsPackLoading;

  /// Allocation breakdown for an IPS pack.
  ///
  /// In en, this message translates to:
  /// **'Bond {bond}%, Stock {stock}%'**
  String ipsPackAllocationValue(Object bond, Object stock);

  /// No description provided for @ipsContractTitle.
  ///
  /// In en, this message translates to:
  /// **'Contract'**
  String get ipsContractTitle;

  /// No description provided for @ipsContractSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Contract creation and signing acknowledgement.'**
  String get ipsContractSubtitle;

  /// No description provided for @ipsContractCreate.
  ///
  /// In en, this message translates to:
  /// **'Create contract'**
  String get ipsContractCreate;

  /// No description provided for @ipsContractTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms and conditions'**
  String get ipsContractTermsTitle;

  /// No description provided for @ipsContractMissingPack.
  ///
  /// In en, this message translates to:
  /// **'Pack selection data is missing.'**
  String get ipsContractMissingPack;

  /// No description provided for @ipsContractMissingService.
  ///
  /// In en, this message translates to:
  /// **'Contract service is not configured.'**
  String get ipsContractMissingService;

  /// No description provided for @ipsContractCreated.
  ///
  /// In en, this message translates to:
  /// **'Contract created'**
  String get ipsContractCreated;

  /// No description provided for @ipsContractOpenPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Open portfolio'**
  String get ipsContractOpenPortfolio;

  /// No description provided for @ipsContractId.
  ///
  /// In en, this message translates to:
  /// **'Contract ID'**
  String get ipsContractId;

  /// No description provided for @ipsContractRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk score'**
  String get ipsContractRiskScore;

  /// No description provided for @ipsContractTermsBody.
  ///
  /// In en, this message translates to:
  /// **'Confirm the recommended pack, acknowledge the service terms, and create the IPS contract.'**
  String get ipsContractTermsBody;

  /// No description provided for @ipsContractPreparingAccounts.
  ///
  /// In en, this message translates to:
  /// **'Creating your IPS accounts and loading package details.'**
  String get ipsContractPreparingAccounts;

  /// No description provided for @ipsContractPackQuantityPrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the pack quantity you would like to purchase.'**
  String get ipsContractPackQuantityPrompt;

  /// No description provided for @ipsContractUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Price per pack'**
  String get ipsContractUnitPrice;

  /// No description provided for @ipsContractServiceFee.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get ipsContractServiceFee;

  /// No description provided for @ipsContractIpsAccountsMissing.
  ///
  /// In en, this message translates to:
  /// **'The required IPS accounts are not ready yet. Please try again.'**
  String get ipsContractIpsAccountsMissing;

  /// No description provided for @ipsContractPackPricingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The selected package pricing is currently unavailable. Please try again.'**
  String get ipsContractPackPricingUnavailable;

  /// No description provided for @ipsContractPreparingPayment.
  ///
  /// In en, this message translates to:
  /// **'Preparing your contract, payment request, and wallet checkout.'**
  String get ipsContractPreparingPayment;

  /// No description provided for @ipsPortfolioTitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get ipsPortfolioTitle;

  /// No description provided for @ipsPortfolioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'IPS acnt overview, holdings, yield, and profit.'**
  String get ipsPortfolioSubtitle;

  /// No description provided for @ipsPortfolioAvailableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available balance'**
  String get ipsPortfolioAvailableBalance;

  /// No description provided for @ipsPortfolioInvestedBalance.
  ///
  /// In en, this message translates to:
  /// **'Invested balance'**
  String get ipsPortfolioInvestedBalance;

  /// No description provided for @ipsPortfolioProfitLoss.
  ///
  /// In en, this message translates to:
  /// **'Profit/Loss'**
  String get ipsPortfolioProfitLoss;

  /// No description provided for @ipsPortfolioYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get ipsPortfolioYield;

  /// No description provided for @ipsPortfolioHoldings.
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get ipsPortfolioHoldings;

  /// No description provided for @ipsPortfolioNoHoldings.
  ///
  /// In en, this message translates to:
  /// **'No holdings data is available.'**
  String get ipsPortfolioNoHoldings;

  /// No description provided for @ipsPortfolioRecharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get ipsPortfolioRecharge;

  /// No description provided for @ipsPortfolioSellOrder.
  ///
  /// In en, this message translates to:
  /// **'Sell order'**
  String get ipsPortfolioSellOrder;

  /// No description provided for @ipsPortfolioOrderList.
  ///
  /// In en, this message translates to:
  /// **'Order list'**
  String get ipsPortfolioOrderList;

  /// No description provided for @ipsPortfolioStatements.
  ///
  /// In en, this message translates to:
  /// **'Statements'**
  String get ipsPortfolioStatements;

  /// No description provided for @ipsPortfolioMissingService.
  ///
  /// In en, this message translates to:
  /// **'Portfolio service is not configured.'**
  String get ipsPortfolioMissingService;

  /// No description provided for @ipsPortfolioLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading portfolio overview.'**
  String get ipsPortfolioLoading;

  /// No description provided for @ipsPortfolioHoldingQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get ipsPortfolioHoldingQuantity;

  /// No description provided for @ipsPortfolioHoldingValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Current value'**
  String get ipsPortfolioHoldingValueLabel;

  /// Summary line for a holding entry.
  ///
  /// In en, this message translates to:
  /// **'Qty {quantity} • Value {value}'**
  String ipsPortfolioHoldingValue(Object quantity, Object value);

  /// No description provided for @ipsOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ipsOrdersTitle;

  /// No description provided for @ipsOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'IPS order list and cancellation flow.'**
  String get ipsOrdersSubtitle;

  /// No description provided for @ipsOrdersNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No IPS orders are available.'**
  String get ipsOrdersNoOrders;

  /// No description provided for @ipsOrdersCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get ipsOrdersCancelOrder;

  /// No description provided for @ipsOrdersCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get ipsOrdersCreatedAt;

  /// No description provided for @ipsOrdersOrderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get ipsOrdersOrderId;

  /// No description provided for @ipsOrdersMissingService.
  ///
  /// In en, this message translates to:
  /// **'Orders service is not configured.'**
  String get ipsOrdersMissingService;

  /// No description provided for @ipsOrdersType.
  ///
  /// In en, this message translates to:
  /// **'Order type'**
  String get ipsOrdersType;

  /// No description provided for @ipsOrdersTypeBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get ipsOrdersTypeBuy;

  /// No description provided for @ipsOrdersTypeSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get ipsOrdersTypeSell;

  /// No description provided for @ipsOrdersTypeRecharge.
  ///
  /// In en, this message translates to:
  /// **'Recharge'**
  String get ipsOrdersTypeRecharge;

  /// No description provided for @ipsOrdersLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading order list.'**
  String get ipsOrdersLoading;

  /// Confirmation prompt shown before cancelling an order.
  ///
  /// In en, this message translates to:
  /// **'Cancel order {orderId}?'**
  String ipsOrdersCancelOrderConfirm(Object orderId);

  /// Compact order summary showing type and status.
  ///
  /// In en, this message translates to:
  /// **'{type} • {status}'**
  String ipsOrdersSummary(Object type, Object status);

  /// No description provided for @ipsPaymentRechargeTitle.
  ///
  /// In en, this message translates to:
  /// **'Top up package'**
  String get ipsPaymentRechargeTitle;

  /// No description provided for @ipsPaymentRechargeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Exchange/recharge flow and QR generation.'**
  String get ipsPaymentRechargeSubtitle;

  /// No description provided for @ipsPaymentRechargeQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity to purchase'**
  String get ipsPaymentRechargeQuantityHint;

  /// No description provided for @ipsPaymentRechargeTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total amount'**
  String get ipsPaymentRechargeTotalAmount;

  /// No description provided for @ipsPaymentCreateQr.
  ///
  /// In en, this message translates to:
  /// **'Create QR'**
  String get ipsPaymentCreateQr;

  /// No description provided for @ipsPaymentQrGenerated.
  ///
  /// In en, this message translates to:
  /// **'Payment QR generated'**
  String get ipsPaymentQrGenerated;

  /// No description provided for @ipsPaymentPending.
  ///
  /// In en, this message translates to:
  /// **'Payment is pending.'**
  String get ipsPaymentPending;

  /// No description provided for @ipsPaymentMissingService.
  ///
  /// In en, this message translates to:
  /// **'Recharge/payment service is not configured.'**
  String get ipsPaymentMissingService;

  /// No description provided for @ipsPaymentQrValue.
  ///
  /// In en, this message translates to:
  /// **'QR value'**
  String get ipsPaymentQrValue;

  /// No description provided for @ipsPaymentAcntFlow.
  ///
  /// In en, this message translates to:
  /// **'Acnt flow'**
  String get ipsPaymentAcntFlow;

  /// No description provided for @ipsPaymentCreateInvoiceAndPay.
  ///
  /// In en, this message translates to:
  /// **'Create invoice and pay'**
  String get ipsPaymentCreateInvoiceAndPay;

  /// No description provided for @ipsPaymentInvoiceId.
  ///
  /// In en, this message translates to:
  /// **'Invoice ID'**
  String get ipsPaymentInvoiceId;

  /// No description provided for @ipsPaymentStatusTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Timed out'**
  String get ipsPaymentStatusTimedOut;

  /// No description provided for @ipsPaymentStatusUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported'**
  String get ipsPaymentStatusUnsupported;

  /// No description provided for @ipsPaymentInvoiceCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'The SDK could not create a payment invoice.'**
  String get ipsPaymentInvoiceCreateFailed;

  /// No description provided for @ipsPaymentInvalidInvoice.
  ///
  /// In en, this message translates to:
  /// **'The payment invoice response was missing a usable invoice ID.'**
  String get ipsPaymentInvalidInvoice;

  /// No description provided for @ipsPaymentHostResponseTimedOut.
  ///
  /// In en, this message translates to:
  /// **'The host payment response timed out.'**
  String get ipsPaymentHostResponseTimedOut;

  /// No description provided for @ipsPaymentHostCallbackFailed.
  ///
  /// In en, this message translates to:
  /// **'The host payment callback failed.'**
  String get ipsPaymentHostCallbackFailed;

  /// No description provided for @ipsSellTitle.
  ///
  /// In en, this message translates to:
  /// **'Sell pack'**
  String get ipsSellTitle;

  /// No description provided for @ipsSellCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Close pack'**
  String get ipsSellCloseTitle;

  /// No description provided for @ipsSellSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create an IPS sell order.'**
  String get ipsSellSubtitle;

  /// No description provided for @ipsSellMissingService.
  ///
  /// In en, this message translates to:
  /// **'Sell-order service is not configured.'**
  String get ipsSellMissingService;

  /// No description provided for @ipsSellCreateOrder.
  ///
  /// In en, this message translates to:
  /// **'Create sell order'**
  String get ipsSellCreateOrder;

  /// No description provided for @ipsSellPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'This request will close your package by selling all owned package units.'**
  String get ipsSellPendingMessage;

  /// No description provided for @ipsSellReminderBody.
  ///
  /// In en, this message translates to:
  /// **'The quantity below is loaded from your current package balance. When you submit this request, the app creates a sell order for all owned package units and the final payout is calculated from your latest holdings value, available cash, and fees.'**
  String get ipsSellReminderBody;

  /// No description provided for @ipsSellQuantityClosing.
  ///
  /// In en, this message translates to:
  /// **'Packs to close'**
  String get ipsSellQuantityClosing;

  /// No description provided for @ipsSellTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get ipsSellTotalAmount;

  /// No description provided for @ipsSellProfit.
  ///
  /// In en, this message translates to:
  /// **'PROFIT'**
  String get ipsSellProfit;

  /// No description provided for @ipsSellTotalFee.
  ///
  /// In en, this message translates to:
  /// **'TOTAL FEE'**
  String get ipsSellTotalFee;

  /// No description provided for @ipsSellPayoutAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to receive'**
  String get ipsSellPayoutAmount;

  /// No description provided for @ipsSellSubmitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit request'**
  String get ipsSellSubmitRequest;

  /// No description provided for @ipsSellSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Your request was submitted successfully'**
  String get ipsSellSuccessTitle;

  /// No description provided for @ipsSellSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your close pack request has been received. Trading is executed every Tuesday and Thursday. Your total investment refund will be processed within 10 business days and deposited to your bank account.'**
  String get ipsSellSuccessBody;

  /// No description provided for @ipsSellPackLabel.
  ///
  /// In en, this message translates to:
  /// **'Pack {number}'**
  String ipsSellPackLabel(int number);

  /// No description provided for @ipsSellAllocationLabel.
  ///
  /// In en, this message translates to:
  /// **'{bond}% bond, {stock}% stock'**
  String ipsSellAllocationLabel(int bond, int stock);

  /// No description provided for @ipsStatementTitle.
  ///
  /// In en, this message translates to:
  /// **'Statements'**
  String get ipsStatementTitle;

  /// No description provided for @ipsStatementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Statement and acnt-summary surface.'**
  String get ipsStatementSubtitle;

  /// No description provided for @ipsStatementSummary.
  ///
  /// In en, this message translates to:
  /// **'Statement summary'**
  String get ipsStatementSummary;

  /// No description provided for @ipsStatementBeginBalance.
  ///
  /// In en, this message translates to:
  /// **'Beginning balance'**
  String get ipsStatementBeginBalance;

  /// No description provided for @ipsStatementEndBalance.
  ///
  /// In en, this message translates to:
  /// **'Ending balance'**
  String get ipsStatementEndBalance;

  /// No description provided for @ipsStatementEntriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String ipsStatementEntriesCount(int count);

  /// No description provided for @ipsStatementMissingService.
  ///
  /// In en, this message translates to:
  /// **'Statement service is not configured.'**
  String get ipsStatementMissingService;

  /// No description provided for @ipsStatementsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading statement summary.'**
  String get ipsStatementsLoading;

  /// No description provided for @ipsYieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get ipsYieldTitle;

  /// No description provided for @ipsYieldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Portfolio yield breakdown.'**
  String get ipsYieldSubtitle;

  /// No description provided for @ipsYieldDetails.
  ///
  /// In en, this message translates to:
  /// **'Yield details'**
  String get ipsYieldDetails;

  /// No description provided for @ipsProfitTitle.
  ///
  /// In en, this message translates to:
  /// **'Profit and loss'**
  String get ipsProfitTitle;

  /// No description provided for @ipsProfitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profit and loss summary for IPS holdings.'**
  String get ipsProfitSubtitle;

  /// No description provided for @ipsProfitSummary.
  ///
  /// In en, this message translates to:
  /// **'Profit summary'**
  String get ipsProfitSummary;

  /// No description provided for @ipsSuccessReqCreated.
  ///
  /// In en, this message translates to:
  /// **'Req created successfully.'**
  String get ipsSuccessReqCreated;

  /// No description provided for @ipsSuccessOrderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully.'**
  String get ipsSuccessOrderCancelled;

  /// No description provided for @ipsSuccessContractCreated.
  ///
  /// In en, this message translates to:
  /// **'Contract created successfully.'**
  String get ipsSuccessContractCreated;

  /// No description provided for @ipsSuccessQrCreated.
  ///
  /// In en, this message translates to:
  /// **'QR created successfully.'**
  String get ipsSuccessQrCreated;

  /// No description provided for @ipsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get ipsStatusPending;

  /// No description provided for @ipsStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ipsStatusActive;

  /// No description provided for @ipsStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get ipsStatusCompleted;

  /// No description provided for @ipsStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get ipsStatusCancelled;

  /// No description provided for @ipsStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get ipsStatusFailed;

  /// No description provided for @ipsUnknownRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Route unavailable'**
  String get ipsUnknownRouteTitle;

  /// Shown when a reqed IPS route is not registered in the module.
  ///
  /// In en, this message translates to:
  /// **'The IPS route is not registered: {route}'**
  String ipsUnknownRouteMessage(Object route);

  /// Shown when an internal demo module receives an unknown route.
  ///
  /// In en, this message translates to:
  /// **'The route is not registered for : {route}'**
  String internalUnknownRouteMessage(Object, Object route);

  /// No description provided for @internalProfileCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile screens'**
  String get internalProfileCatalogTitle;

  /// No description provided for @internalProfileModuleName.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get internalProfileModuleName;

  /// No description provided for @internalProfileRouteHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact update home'**
  String get internalProfileRouteHomeTitle;

  /// No description provided for @internalProfileRouteHomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the current email and phone details.'**
  String get internalProfileRouteHomeDescription;

  /// No description provided for @internalProfileRouteUpdateEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Update email'**
  String get internalProfileRouteUpdateEmailTitle;

  /// No description provided for @internalProfileRouteUpdateEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a new email address.'**
  String get internalProfileRouteUpdateEmailDescription;

  /// No description provided for @internalProfileRouteVerifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify email'**
  String get internalProfileRouteVerifyEmailTitle;

  /// No description provided for @internalProfileRouteVerifyEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the email verification code.'**
  String get internalProfileRouteVerifyEmailDescription;

  /// No description provided for @internalProfileRouteEmailVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Email verified'**
  String get internalProfileRouteEmailVerifiedTitle;

  /// No description provided for @internalProfileRouteEmailVerifiedDescription.
  ///
  /// In en, this message translates to:
  /// **'Email verification success state.'**
  String get internalProfileRouteEmailVerifiedDescription;

  /// No description provided for @internalProfileRouteUpdatePhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Update phone'**
  String get internalProfileRouteUpdatePhoneTitle;

  /// No description provided for @internalProfileRouteUpdatePhoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter a new phone number.'**
  String get internalProfileRouteUpdatePhoneDescription;

  /// No description provided for @internalProfileRouteVerifyPhoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify phone'**
  String get internalProfileRouteVerifyPhoneTitle;

  /// No description provided for @internalProfileRouteVerifyPhoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone verification code.'**
  String get internalProfileRouteVerifyPhoneDescription;

  /// No description provided for @internalProfileRoutePhoneVerifiedTitle.
  ///
  /// In en, this message translates to:
  /// **'Phone verified'**
  String get internalProfileRoutePhoneVerifiedTitle;

  /// No description provided for @internalProfileRoutePhoneVerifiedDescription.
  ///
  /// In en, this message translates to:
  /// **'Phone verification success state.'**
  String get internalProfileRoutePhoneVerifiedDescription;

  /// No description provided for @internalProfileRouteReviewUpdatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Review updates'**
  String get internalProfileRouteReviewUpdatesTitle;

  /// No description provided for @internalProfileRouteReviewUpdatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Check the updated contact details.'**
  String get internalProfileRouteReviewUpdatesDescription;

  /// No description provided for @internalProfileRouteConfirmChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm changes'**
  String get internalProfileRouteConfirmChangesTitle;

  /// No description provided for @internalProfileRouteConfirmChangesDescription.
  ///
  /// In en, this message translates to:
  /// **'Confirm the contact updates before saving.'**
  String get internalProfileRouteConfirmChangesDescription;

  /// No description provided for @internalProfileRouteUpdateCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Update complete'**
  String get internalProfileRouteUpdateCompleteTitle;

  /// No description provided for @internalProfileRouteUpdateCompleteDescription.
  ///
  /// In en, this message translates to:
  /// **'Contact update completion state.'**
  String get internalProfileRouteUpdateCompleteDescription;

  /// No description provided for @internalProfileProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get internalProfileProcessing;

  /// No description provided for @internalProfileFlowProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Flow progress'**
  String get internalProfileFlowProgressTitle;

  /// Step indicator for the profile contact update flow.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String internalProfileFlowProgressStep(Object step, Object total);

  /// No description provided for @internalProfileSectionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile details'**
  String get internalProfileSectionDetailsTitle;

  /// No description provided for @internalProfileFieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get internalProfileFieldFullName;

  /// No description provided for @internalProfileFieldCurrentEmail.
  ///
  /// In en, this message translates to:
  /// **'Current email'**
  String get internalProfileFieldCurrentEmail;

  /// No description provided for @internalProfileFieldCurrentPhone.
  ///
  /// In en, this message translates to:
  /// **'Current phone'**
  String get internalProfileFieldCurrentPhone;

  /// No description provided for @internalProfileFieldSdkVersion.
  ///
  /// In en, this message translates to:
  /// **'SDK version'**
  String get internalProfileFieldSdkVersion;

  /// No description provided for @internalProfileFieldNewEmail.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get internalProfileFieldNewEmail;

  /// No description provided for @internalProfileFieldNewPhone.
  ///
  /// In en, this message translates to:
  /// **'New phone number'**
  String get internalProfileFieldNewPhone;

  /// No description provided for @internalProfileFieldUpdatedEmail.
  ///
  /// In en, this message translates to:
  /// **'Updated email'**
  String get internalProfileFieldUpdatedEmail;

  /// No description provided for @internalProfileFieldUpdatedPhone.
  ///
  /// In en, this message translates to:
  /// **'Updated phone'**
  String get internalProfileFieldUpdatedPhone;

  /// No description provided for @internalProfileFieldUpdatedBy.
  ///
  /// In en, this message translates to:
  /// **'Updated by'**
  String get internalProfileFieldUpdatedBy;

  /// No description provided for @internalProfileContactEntryHint.
  ///
  /// In en, this message translates to:
  /// **'Make sure the entered value is correct before reqing verification.'**
  String get internalProfileContactEntryHint;

  /// No description provided for @internalProfileVerificationInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your latest contact channel.'**
  String get internalProfileVerificationInstructions;

  /// No description provided for @internalProfileVerificationCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get internalProfileVerificationCodeLabel;

  /// No description provided for @internalProfileInvalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid.'**
  String get internalProfileInvalidVerificationCode;

  /// No description provided for @internalProfileVerificationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification completed successfully.'**
  String get internalProfileVerificationSuccess;

  /// No description provided for @internalProfileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Contact details were updated successfully.'**
  String get internalProfileUpdateSuccess;

  /// No description provided for @internalAuthCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Auth screens'**
  String get internalAuthCatalogTitle;

  /// No description provided for @internalAuthModuleName.
  ///
  /// In en, this message translates to:
  /// **'Auth'**
  String get internalAuthModuleName;

  /// No description provided for @internalAuthRouteRegistrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Create acnt'**
  String get internalAuthRouteRegistrationTitle;

  /// No description provided for @internalAuthRouteRegistrationDescription.
  ///
  /// In en, this message translates to:
  /// **'Registration flow adapted from the auth design references.'**
  String get internalAuthRouteRegistrationDescription;

  /// No description provided for @internalAuthRouteRegistrationConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm registration'**
  String get internalAuthRouteRegistrationConfirmationTitle;

  /// No description provided for @internalAuthRouteRegistrationConfirmationDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the terms and complete acnt setup.'**
  String get internalAuthRouteRegistrationConfirmationDescription;

  /// No description provided for @internalAuthContinueRegistration.
  ///
  /// In en, this message translates to:
  /// **'Continue registration'**
  String get internalAuthContinueRegistration;

  /// No description provided for @internalAuthSectionPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal information'**
  String get internalAuthSectionPersonalInformation;

  /// No description provided for @internalAuthFieldFullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get internalAuthFieldFullName;

  /// No description provided for @internalAuthFieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get internalAuthFieldEmail;

  /// No description provided for @internalAuthFieldPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get internalAuthFieldPhone;

  /// No description provided for @internalAuthFinishRegistration.
  ///
  /// In en, this message translates to:
  /// **'Finish registration'**
  String get internalAuthFinishRegistration;

  /// No description provided for @internalAuthSectionVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get internalAuthSectionVerification;

  /// No description provided for @internalAuthIdentityCheck.
  ///
  /// In en, this message translates to:
  /// **'Identity check'**
  String get internalAuthIdentityCheck;

  /// No description provided for @internalAuthPendingReview.
  ///
  /// In en, this message translates to:
  /// **'Pending review'**
  String get internalAuthPendingReview;

  /// No description provided for @internalAuthEmailVerification.
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get internalAuthEmailVerification;

  /// No description provided for @internalAuthPhoneVerification.
  ///
  /// In en, this message translates to:
  /// **'Phone verification'**
  String get internalAuthPhoneVerification;

  /// No description provided for @internalAuthVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get internalAuthVerified;

  /// No description provided for @internalAuthSectionConsent.
  ///
  /// In en, this message translates to:
  /// **'Consent'**
  String get internalAuthSectionConsent;

  /// No description provided for @internalAuthConsentBody.
  ///
  /// In en, this message translates to:
  /// **'I agree to the service terms and privacy policy.'**
  String get internalAuthConsentBody;

  /// No description provided for @internalStatesCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'State screens'**
  String get internalStatesCatalogTitle;

  /// No description provided for @internalStatesModuleName.
  ///
  /// In en, this message translates to:
  /// **'States'**
  String get internalStatesModuleName;

  /// No description provided for @internalStatesRouteSplashTitle.
  ///
  /// In en, this message translates to:
  /// **'Splash'**
  String get internalStatesRouteSplashTitle;

  /// No description provided for @internalStatesRouteSplashDescription.
  ///
  /// In en, this message translates to:
  /// **'Initial splash state with brand entry.'**
  String get internalStatesRouteSplashDescription;

  /// No description provided for @internalStatesRouteSplashAlternateTitle.
  ///
  /// In en, this message translates to:
  /// **'Splash alternate'**
  String get internalStatesRouteSplashAlternateTitle;

  /// No description provided for @internalStatesRouteSplashAlternateDescription.
  ///
  /// In en, this message translates to:
  /// **'Secondary splash variant.'**
  String get internalStatesRouteSplashAlternateDescription;

  /// No description provided for @internalStatesRouteLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Loading screen'**
  String get internalStatesRouteLoadingTitle;

  /// No description provided for @internalStatesRouteLoadingDescription.
  ///
  /// In en, this message translates to:
  /// **'Loading indicator with contextual message.'**
  String get internalStatesRouteLoadingDescription;

  /// No description provided for @internalStatesRouteKycOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Signup KYC overlay'**
  String get internalStatesRouteKycOverlayTitle;

  /// No description provided for @internalStatesRouteKycOverlayDescription.
  ///
  /// In en, this message translates to:
  /// **'KYC-required overlay with next-step actions.'**
  String get internalStatesRouteKycOverlayDescription;

  /// No description provided for @internalStatesSplashHeroPrimaryTitle.
  ///
  /// In en, this message translates to:
  /// **''**
  String get internalStatesSplashHeroPrimaryTitle;

  /// No description provided for @internalStatesSplashHeroPrimarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing your workspace...'**
  String get internalStatesSplashHeroPrimarySubtitle;

  /// No description provided for @internalStatesSplashHeroAlternateTitle.
  ///
  /// In en, this message translates to:
  /// **' Finance'**
  String get internalStatesSplashHeroAlternateTitle;

  /// No description provided for @internalStatesSplashHeroAlternateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Loading your personalized dashboard...'**
  String get internalStatesSplashHeroAlternateSubtitle;

  /// No description provided for @internalStatesLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Fetching acnt details...'**
  String get internalStatesLoadingMessage;

  /// No description provided for @internalStatesLoadingHint.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment while the mini app prepares this screen.'**
  String get internalStatesLoadingHint;

  /// No description provided for @internalStatesKycDefaultStatusMessage.
  ///
  /// In en, this message translates to:
  /// **'Complete your verification to continue using all wallet features.'**
  String get internalStatesKycDefaultStatusMessage;

  /// No description provided for @internalStatesKycSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Identity verified'**
  String get internalStatesKycSuccessTitle;

  /// No description provided for @internalStatesKycSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your profile is now verified.You can access all features.'**
  String get internalStatesKycSuccessSubtitle;

  /// No description provided for @internalStatesKycRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'KYC required'**
  String get internalStatesKycRequiredTitle;

  /// No description provided for @internalStatesKycRequiredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Profile verification is required before you continue.'**
  String get internalStatesKycRequiredSubtitle;

  /// No description provided for @internalStatesKycStartVerification.
  ///
  /// In en, this message translates to:
  /// **'Start verification'**
  String get internalStatesKycStartVerification;

  /// No description provided for @internalStatesKycLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get internalStatesKycLater;

  /// No description provided for @internalStatesKycScanningId.
  ///
  /// In en, this message translates to:
  /// **'Scanning ID...'**
  String get internalStatesKycScanningId;

  /// No description provided for @internalStatesKycVerifying.
  ///
  /// In en, this message translates to:
  /// **'Verifying...'**
  String get internalStatesKycVerifying;

  /// No description provided for @internalStatesKycCapturingBiometric.
  ///
  /// In en, this message translates to:
  /// **'Capturing biometric data...'**
  String get internalStatesKycCapturingBiometric;

  /// No description provided for @internalStatesKycFailureFaceMatch.
  ///
  /// In en, this message translates to:
  /// **'Face match failed.Please try again in better lighting.'**
  String get internalStatesKycFailureFaceMatch;

  /// No description provided for @internalLauncherCatalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Launcher screens'**
  String get internalLauncherCatalogTitle;

  /// No description provided for @internalLauncherModuleName.
  ///
  /// In en, this message translates to:
  /// **'Launcher showcase'**
  String get internalLauncherModuleName;

  /// No description provided for @internalLauncherRouteHomeTitle.
  ///
  /// In en, this message translates to:
  /// **' home page'**
  String get internalLauncherRouteHomeTitle;

  /// No description provided for @internalLauncherRouteHomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Primary launcher home composition.'**
  String get internalLauncherRouteHomeDescription;

  /// No description provided for @internalLauncherRouteHomeAlternateTitle.
  ///
  /// In en, this message translates to:
  /// **' home page alt'**
  String get internalLauncherRouteHomeAlternateTitle;

  /// No description provided for @internalLauncherRouteHomeAlternateDescription.
  ///
  /// In en, this message translates to:
  /// **'Alternate hero and feature ordering.'**
  String get internalLauncherRouteHomeAlternateDescription;

  /// No description provided for @internalLauncherRouteFeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Launcher home screen'**
  String get internalLauncherRouteFeedTitle;

  /// No description provided for @internalLauncherRouteFeedDescription.
  ///
  /// In en, this message translates to:
  /// **'Long-form launcher feed and card stack.'**
  String get internalLauncherRouteFeedDescription;

  /// No description provided for @internalLauncherRouteFastActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Hur dan screen'**
  String get internalLauncherRouteFastActionTitle;

  /// No description provided for @internalLauncherRouteFastActionDescription.
  ///
  /// In en, this message translates to:
  /// **'Fast-action launcher variant.'**
  String get internalLauncherRouteFastActionDescription;

  /// No description provided for @internalLauncherRouteMenuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu screen'**
  String get internalLauncherRouteMenuTitle;

  /// No description provided for @internalLauncherRouteMenuDescription.
  ///
  /// In en, this message translates to:
  /// **'Launcher menu and quick links.'**
  String get internalLauncherRouteMenuDescription;

  /// No description provided for @internalLauncherRouteCardVariantOneTitle.
  ///
  /// In en, this message translates to:
  /// **'Card variant 1'**
  String get internalLauncherRouteCardVariantOneTitle;

  /// No description provided for @internalLauncherRouteCardVariantTwoTitle.
  ///
  /// In en, this message translates to:
  /// **'Card variant 2'**
  String get internalLauncherRouteCardVariantTwoTitle;

  /// No description provided for @internalLauncherRouteCardVariantThreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Card variant 3'**
  String get internalLauncherRouteCardVariantThreeTitle;

  /// No description provided for @internalLauncherRouteCardVariantFourTitle.
  ///
  /// In en, this message translates to:
  /// **'Card variant 4'**
  String get internalLauncherRouteCardVariantFourTitle;

  /// No description provided for @internalLauncherRouteCardVariantDescription.
  ///
  /// In en, this message translates to:
  /// **'Card composition extracted from the launcher card variants.'**
  String get internalLauncherRouteCardVariantDescription;

  /// No description provided for @internalLauncherBackToLauncher.
  ///
  /// In en, this message translates to:
  /// **'Back to launcher'**
  String get internalLauncherBackToLauncher;

  /// No description provided for @internalLauncherHeroTitle.
  ///
  /// In en, this message translates to:
  /// **' launcher'**
  String get internalLauncherHeroTitle;

  /// No description provided for @internalLauncherHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Visual hierarchy adapted from the launcher design references.'**
  String get internalLauncherHeroSubtitle;

  /// No description provided for @internalLauncherQuickTagWallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get internalLauncherQuickTagWallet;

  /// No description provided for @internalLauncherQuickTagProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get internalLauncherQuickTagProfile;

  /// No description provided for @internalLauncherQuickTagCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get internalLauncherQuickTagCards;

  /// No description provided for @internalLauncherQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get internalLauncherQuickActionsTitle;

  /// No description provided for @internalLauncherActionOpenWallet.
  ///
  /// In en, this message translates to:
  /// **'Open wallet'**
  String get internalLauncherActionOpenWallet;

  /// No description provided for @internalLauncherActionManageProfile.
  ///
  /// In en, this message translates to:
  /// **'Manage profile'**
  String get internalLauncherActionManageProfile;

  /// No description provided for @internalLauncherActionMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get internalLauncherActionMenu;

  /// No description provided for @internalLauncherRecentActivityTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get internalLauncherRecentActivityTitle;

  /// No description provided for @internalLauncherRecentTopUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Top up complete'**
  String get internalLauncherRecentTopUpLabel;

  /// No description provided for @internalLauncherRecentTopUpTime.
  ///
  /// In en, this message translates to:
  /// **'Today, 08:31'**
  String get internalLauncherRecentTopUpTime;

  /// No description provided for @internalLauncherRecentVerificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile verification pending'**
  String get internalLauncherRecentVerificationLabel;

  /// No description provided for @internalLauncherRecentVerificationTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday, 18:04'**
  String get internalLauncherRecentVerificationTime;

  /// No description provided for @internalLauncherMembershipTitle.
  ///
  /// In en, this message translates to:
  /// **' membership'**
  String get internalLauncherMembershipTitle;

  /// No description provided for @internalLauncherMembershipBody.
  ///
  /// In en, this message translates to:
  /// **'A composable card block for launcher feed previews.'**
  String get internalLauncherMembershipBody;

  /// No description provided for @internalLauncherMembershipTierLabel.
  ///
  /// In en, this message translates to:
  /// **'Tier'**
  String get internalLauncherMembershipTierLabel;

  /// No description provided for @internalLauncherMembershipTierValue.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get internalLauncherMembershipTierValue;

  /// No description provided for @internalLauncherMembershipValidThrough.
  ///
  /// In en, this message translates to:
  /// **'Valid through 2027'**
  String get internalLauncherMembershipValidThrough;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get accept;

  /// No description provided for @tinoConsent.
  ///
  /// In en, this message translates to:
  /// **'Do you consent to the use of the information associated with your Tino app account?'**
  String get tinoConsent;

  /// No description provided for @commonSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get commonSuccess;

  /// No description provided for @commonWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get commonWarning;

  /// No description provided for @commonPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get commonPay;

  /// No description provided for @commonGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get commonGoHome;

  /// No description provided for @commonHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get commonHome;

  /// No description provided for @commonProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get commonProfile;

  /// No description provided for @commonBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get commonBank;

  /// No description provided for @commonIban.
  ///
  /// In en, this message translates to:
  /// **'IBAN number'**
  String get commonIban;

  /// No description provided for @commonPackUnit.
  ///
  /// In en, this message translates to:
  /// **'PACK'**
  String get commonPackUnit;

  /// No description provided for @commonBrandInvestx.
  ///
  /// In en, this message translates to:
  /// **'investX'**
  String get commonBrandInvestx;

  /// No description provided for @commonDrawSignaturePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please draw your signature to confirm'**
  String get commonDrawSignaturePrompt;

  /// No description provided for @commonSignaturePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Draw your signature here'**
  String get commonSignaturePlaceholder;

  /// No description provided for @commonTotalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total payable'**
  String get commonTotalPayable;

  /// Pack quantity label.
  ///
  /// In en, this message translates to:
  /// **'{count} PACK'**
  String commonPackQuantity(Object count);

  /// No description provided for @secAcntPersonalInformationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your personal information.'**
  String get secAcntPersonalInformationSubtitle;

  /// No description provided for @secAcntFieldSecondaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Additional phone number'**
  String get secAcntFieldSecondaryPhone;

  /// No description provided for @secAcntBankSelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Select bank'**
  String get secAcntBankSelectionTitle;

  /// No description provided for @secAcntPaymentSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Tino Pay'**
  String get secAcntPaymentSheetTitle;

  /// No description provided for @secAcntPaymentOptionTinoBalance.
  ///
  /// In en, this message translates to:
  /// **'Tino current balance'**
  String get secAcntPaymentOptionTinoBalance;

  /// No description provided for @secAcntPaymentOptionTinoPayLater.
  ///
  /// In en, this message translates to:
  /// **'Tino Pay Later limit'**
  String get secAcntPaymentOptionTinoPayLater;

  /// No description provided for @secAcntSuccessBankDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bank details'**
  String get secAcntSuccessBankDetailsTitle;

  /// No description provided for @secAcntAgreementConsent.
  ///
  /// In en, this message translates to:
  /// **'I have reviewed and agree to the securities account opening agreement and the service terms.'**
  String get secAcntAgreementConsent;

  /// No description provided for @secAcntServiceFeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get secAcntServiceFeeTitle;

  /// No description provided for @secAcntPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Securities account opening fee'**
  String get secAcntPaymentTitle;

  /// No description provided for @secAcntPaymentTitleWithAmount.
  ///
  /// In en, this message translates to:
  /// **'Securities account opening fee {amount}'**
  String secAcntPaymentTitleWithAmount(Object amount);

  /// No description provided for @secAcntPaymentNoticeMessage.
  ///
  /// In en, this message translates to:
  /// **'Opening this account allows you to invest in both domestic and international markets.'**
  String get secAcntPaymentNoticeMessage;

  /// No description provided for @secAcntPaymentAmountUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The payable amount is currently unavailable. Please refresh your account information and try again.'**
  String get secAcntPaymentAmountUnavailable;

  /// No description provided for @secAcntPaymentFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment failed'**
  String get secAcntPaymentFailedTitle;

  /// No description provided for @secAcntCalculationTitle.
  ///
  /// In en, this message translates to:
  /// **'Your payment was completed successfully'**
  String get secAcntCalculationTitle;

  /// No description provided for @secAcntCalculationMessageTitle.
  ///
  /// In en, this message translates to:
  /// **'Your registration request was created successfully'**
  String get secAcntCalculationMessageTitle;

  /// No description provided for @secAcntCalculationPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your registration request is being reviewed. We will notify you once it is confirmed.'**
  String get secAcntCalculationPendingMessage;

  /// No description provided for @secAcntBankNotSelected.
  ///
  /// In en, this message translates to:
  /// **'No bank selected'**
  String get secAcntBankNotSelected;

  /// No description provided for @secAcntProfileUpdating.
  ///
  /// In en, this message translates to:
  /// **'Saving your personal information.'**
  String get secAcntProfileUpdating;

  /// No description provided for @secAcntInvestxAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'INVESTX service agreement'**
  String get secAcntInvestxAgreementTitle;

  /// No description provided for @secAcntSecuritiesAgreementTitle.
  ///
  /// In en, this message translates to:
  /// **'Securities account opening agreement'**
  String get secAcntSecuritiesAgreementTitle;

  /// No description provided for @secAcntInvestxAgreementText.
  ///
  /// In en, this message translates to:
  /// **'1. This INVESTX service agreement defines the main terms related to starting the investment service, verifying customer information, and account usage.\n\n2. The customer confirms that the submitted information is accurate and agrees to receive service-related notices in the app and through the registered channels.\n\n3. In the next stages of the INVESTX service, the risk questionnaire, pack selection, and purchase actions will be activated in sequence.'**
  String get secAcntInvestxAgreementText;

  /// No description provided for @secAcntSecuritiesAgreementText.
  ///
  /// In en, this message translates to:
  /// **'1. When submitting a request to open a securities account, the customer\'s first name, last name, register number, contact details, and bank information will be verified.\n\n2. The customer acknowledges in advance the fee, verification timeline, and service conditions related to account opening.\n\n3. After verification is completed successfully, the next-stage INVESTX service agreement and risk questionnaire will be opened.'**
  String get secAcntSecuritiesAgreementText;

  /// No description provided for @secAcntTermsText.
  ///
  /// In en, this message translates to:
  /// **'1. These service terms define the general rules related to registration, use, and information security for the customer\'s investment account.\n\n2. Requests, signatures, consents, and payment confirmations submitted in the app are considered valid system actions.\n\n3. While the registration request is under review, some actions may be limited, and the customer will be notified once the review is completed successfully.\n\n4. If updated terms are introduced during the service flow, the customer will receive the notice, review it, and provide consent again when required.'**
  String get secAcntTermsText;

  /// No description provided for @ipsPackBenefitStableYield.
  ///
  /// In en, this message translates to:
  /// **'Targets stable yield'**
  String get ipsPackBenefitStableYield;

  /// No description provided for @ipsPackBenefitLowVolatility.
  ///
  /// In en, this message translates to:
  /// **'Low volatility'**
  String get ipsPackBenefitLowVolatility;

  /// No description provided for @ipsPackBenefitMinRisk.
  ///
  /// In en, this message translates to:
  /// **'Minimal risk'**
  String get ipsPackBenefitMinRisk;

  /// No description provided for @ipsPackBenefitStockGrowth.
  ///
  /// In en, this message translates to:
  /// **'Has growth-oriented stock exposure'**
  String get ipsPackBenefitStockGrowth;

  /// No description provided for @ipsPackBenefitBalancedStructure.
  ///
  /// In en, this message translates to:
  /// **'Balanced pack structure'**
  String get ipsPackBenefitBalancedStructure;

  /// No description provided for @ipsPackBenefitGrowthFocused.
  ///
  /// In en, this message translates to:
  /// **'More growth-focused allocation'**
  String get ipsPackBenefitGrowthFocused;

  /// No description provided for @ipsOverviewPackPrompt.
  ///
  /// In en, this message translates to:
  /// **'Choose a package that suits you'**
  String get ipsOverviewPackPrompt;

  /// No description provided for @ipsPackPerfectFit.
  ///
  /// In en, this message translates to:
  /// **'Perfect fit for you'**
  String get ipsPackPerfectFit;

  /// No description provided for @advice.
  ///
  /// In en, this message translates to:
  /// **'Advice'**
  String get advice;

  /// No description provided for @investmentFund.
  ///
  /// In en, this message translates to:
  /// **'Investment fund'**
  String get investmentFund;

  /// No description provided for @ipsHelpTitle.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get ipsHelpTitle;

  /// No description provided for @ipsHelpContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get ipsHelpContactTitle;

  /// No description provided for @ipsHelpEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get ipsHelpEmail;

  /// No description provided for @ipsHelpPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get ipsHelpPhone;

  /// No description provided for @ipsHelpLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Office location'**
  String get ipsHelpLocationTitle;

  /// No description provided for @ipsHelpLocationWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Mon - Fri 09:00 - 18:00'**
  String get ipsHelpLocationWorkingHours;

  /// No description provided for @ipsFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get ipsFeedbackTitle;

  /// No description provided for @ipsFeedbackEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No feedback yet'**
  String get ipsFeedbackEmptyTitle;

  /// No description provided for @ipsFeedbackEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Press the button below to submit your feedback.'**
  String get ipsFeedbackEmptyBody;

  /// No description provided for @ipsFeedbackCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Submit feedback'**
  String get ipsFeedbackCreateButton;

  /// No description provided for @ipsFeedbackCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get ipsFeedbackCreateTitle;

  /// No description provided for @ipsFeedbackCreateTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get ipsFeedbackCreateTitleHint;

  /// No description provided for @ipsFeedbackCreateBody.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get ipsFeedbackCreateBody;

  /// No description provided for @ipsFeedbackCreateBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a detailed description'**
  String get ipsFeedbackCreateBodyHint;

  /// No description provided for @ipsFeedbackStatusReviewing.
  ///
  /// In en, this message translates to:
  /// **'Reviewing'**
  String get ipsFeedbackStatusReviewing;

  /// No description provided for @ipsFeedbackStatusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get ipsFeedbackStatusResolved;

  /// No description provided for @ipsFeedbackStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get ipsFeedbackStatusClosed;

  /// No description provided for @ipsRewardTitle.
  ///
  /// In en, this message translates to:
  /// **'Your achievements'**
  String get ipsRewardTitle;

  /// No description provided for @ipsRewardGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Target goal'**
  String get ipsRewardGoalTitle;

  /// No description provided for @ipsRewardGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get ipsRewardGoalProgress;

  /// No description provided for @ipsRewardStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Continuous investment'**
  String get ipsRewardStreakTitle;

  /// No description provided for @ipsRewardStreakMonths.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} months'**
  String ipsRewardStreakMonths(int current, int total);

  /// No description provided for @ipsRewardStreakNextReward.
  ///
  /// In en, this message translates to:
  /// **'Next reward: +{reward}'**
  String ipsRewardStreakNextReward(Object reward);

  /// No description provided for @ipsRewardNextGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'Next goal'**
  String get ipsRewardNextGoalTitle;

  /// No description provided for @ipsRewardNextGoalBody.
  ///
  /// In en, this message translates to:
  /// **'After 6 months, your interest rate increases by 2%, plus VIP benefits.'**
  String get ipsRewardNextGoalBody;

  /// No description provided for @ipsRewardMilestoneMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} Months'**
  String ipsRewardMilestoneMonths(int count);

  /// No description provided for @ipsStatementFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter statements'**
  String get ipsStatementFilterTitle;

  /// No description provided for @ipsStatementFilterAmountTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction amount'**
  String get ipsStatementFilterAmountTitle;

  /// No description provided for @ipsStatementFilterDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get ipsStatementFilterDateTitle;

  /// No description provided for @ipsStatementFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get ipsStatementFilterToday;

  /// No description provided for @ipsStatementFilterWeek.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get ipsStatementFilterWeek;

  /// No description provided for @ipsStatementFilterMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get ipsStatementFilterMonth;

  /// No description provided for @ipsStatementFilter3Months.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get ipsStatementFilter3Months;

  /// No description provided for @ipsStatementFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get ipsStatementFilterClear;

  /// No description provided for @ipsStatementFilterSearch.
  ///
  /// In en, this message translates to:
  /// **'Search ({count})'**
  String ipsStatementFilterSearch(int count);

  /// No description provided for @ipsStatementTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get ipsStatementTypeIncome;

  /// No description provided for @ipsStatementTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get ipsStatementTypeExpense;

  /// No description provided for @ipsStatementInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment deposit'**
  String get ipsStatementInvestment;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @ipsPortfolioFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ipsPortfolioFilterAll;

  /// No description provided for @ipsPortfolioFilterBonds.
  ///
  /// In en, this message translates to:
  /// **'Bonds'**
  String get ipsPortfolioFilterBonds;

  /// No description provided for @ipsPortfolioFilterStocks.
  ///
  /// In en, this message translates to:
  /// **'Stocks'**
  String get ipsPortfolioFilterStocks;
}

class _SdkLocalizationsDelegate
    extends LocalizationsDelegate<SdkLocalizations> {
  const _SdkLocalizationsDelegate();

  @override
  Future<SdkLocalizations> load(Locale locale) {
    return SynchronousFuture<SdkLocalizations>(lookupSdkLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_SdkLocalizationsDelegate old) => false;
}

SdkLocalizations lookupSdkLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SdkLocalizationsEn();
    case 'mn':
      return SdkLocalizationsMn();
  }

  throw FlutterError(
    'SdkLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
