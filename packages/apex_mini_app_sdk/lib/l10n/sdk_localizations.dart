import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('mn')];

  /// No description provided for @commonCountryMongolia.
  ///
  /// In mn, this message translates to:
  /// **'Монгол'**
  String get commonCountryMongolia;

  /// No description provided for @ipsSellFailureMessage.
  ///
  /// In mn, this message translates to:
  /// **'Таны хүсэлт амжилтгүй боллоо.'**
  String get ipsSellFailureMessage;

  /// No description provided for @commonLoading.
  ///
  /// In mn, this message translates to:
  /// **'Ачаалж байна'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In mn, this message translates to:
  /// **'Дахин оролдох'**
  String get commonRetry;

  /// No description provided for @commonContinue.
  ///
  /// In mn, this message translates to:
  /// **'Үргэлжлүүлэх'**
  String get commonContinue;

  /// No description provided for @commonSubmit.
  ///
  /// In mn, this message translates to:
  /// **'Илгээх'**
  String get commonSubmit;

  /// No description provided for @commonCancel.
  ///
  /// In mn, this message translates to:
  /// **'Цуцлах'**
  String get commonCancel;

  /// No description provided for @commonDismiss.
  ///
  /// In mn, this message translates to:
  /// **'Болих'**
  String get commonDismiss;

  /// No description provided for @commonClose.
  ///
  /// In mn, this message translates to:
  /// **'Хаах'**
  String get commonClose;

  /// No description provided for @commonBack.
  ///
  /// In mn, this message translates to:
  /// **'Буцах'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In mn, this message translates to:
  /// **'Дараах'**
  String get commonNext;

  /// No description provided for @commonPrevious.
  ///
  /// In mn, this message translates to:
  /// **'Өмнөх'**
  String get commonPrevious;

  /// No description provided for @commonDone.
  ///
  /// In mn, this message translates to:
  /// **'Дуусгах'**
  String get commonDone;

  /// No description provided for @commonRefresh.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчлэх'**
  String get commonRefresh;

  /// No description provided for @commonSelect.
  ///
  /// In mn, this message translates to:
  /// **'Сонгох'**
  String get commonSelect;

  /// No description provided for @commonOpen.
  ///
  /// In mn, this message translates to:
  /// **'Нээх'**
  String get commonOpen;

  /// No description provided for @commonViewDetails.
  ///
  /// In mn, this message translates to:
  /// **'Дэлгэрэнгүй'**
  String get commonViewDetails;

  /// No description provided for @commonAmount.
  ///
  /// In mn, this message translates to:
  /// **'Дүн'**
  String get commonAmount;

  /// No description provided for @commonCurrency.
  ///
  /// In mn, this message translates to:
  /// **'Валют'**
  String get commonCurrency;

  /// No description provided for @commonStatus.
  ///
  /// In mn, this message translates to:
  /// **'Төлөв'**
  String get commonStatus;

  /// No description provided for @commonMessage.
  ///
  /// In mn, this message translates to:
  /// **'Мессеж'**
  String get commonMessage;

  /// No description provided for @commonNoData.
  ///
  /// In mn, this message translates to:
  /// **'Мэдээлэл алга'**
  String get commonNoData;

  /// No description provided for @commonRequired.
  ///
  /// In mn, this message translates to:
  /// **'Шаардлагатай'**
  String get commonRequired;

  /// No description provided for @errorsGenericTitle.
  ///
  /// In mn, this message translates to:
  /// **'Алдаа гарлаа'**
  String get errorsGenericTitle;

  /// No description provided for @errorsServiceUnavailable.
  ///
  /// In mn, this message translates to:
  /// **'Үйлчилгээ одоогоор боломжгүй байна.'**
  String get errorsServiceUnavailable;

  /// No description provided for @errorsUnexpected.
  ///
  /// In mn, this message translates to:
  /// **'Алдаа гарлаа.'**
  String get errorsUnexpected;

  /// No description provided for @errorsNetwork.
  ///
  /// In mn, this message translates to:
  /// **'Сүлжээний холболт амжилтгүй боллоо. Дахин оролдоно уу.'**
  String get errorsNetwork;

  /// No description provided for @errorsSession.
  ///
  /// In mn, this message translates to:
  /// **'Таны session хүчингүй байна. Mini app-аа дахин нээнэ үү.'**
  String get errorsSession;

  /// No description provided for @errorsConfig.
  ///
  /// In mn, this message translates to:
  /// **'mini app integration өгөгдөл алдаатай байна.'**
  String get errorsConfig;

  /// No description provided for @errorsSessionExpired.
  ///
  /// In mn, this message translates to:
  /// **'Session хүчингүй болсон эсвэл дууссан байна.'**
  String get errorsSessionExpired;

  /// No description provided for @errorsUnauthorized.
  ///
  /// In mn, this message translates to:
  /// **'Танд энэ үйлдлийг хийх эрх алга.'**
  String get errorsUnauthorized;

  /// No description provided for @errorsApiLoadFailed.
  ///
  /// In mn, this message translates to:
  /// **'Backend-ээс өгөгдөл татаж чадсангүй.'**
  String get errorsApiLoadFailed;

  /// No description provided for @errorsActionFailed.
  ///
  /// In mn, this message translates to:
  /// **'Үйлдлийг гүйцэтгэж чадсангүй.'**
  String get errorsActionFailed;

  /// No description provided for @errorsMissingIntegration.
  ///
  /// In mn, this message translates to:
  /// **'Шаардлагатай host integration тохируулагдаагүй байна.'**
  String get errorsMissingIntegration;

  /// No description provided for @errorsMissingContract.
  ///
  /// In mn, this message translates to:
  /// **'Backend-ийн нарийн contract хараахан бэлэн болоогүй байна.'**
  String get errorsMissingContract;

  /// No description provided for @errorsUnknownRoute.
  ///
  /// In mn, this message translates to:
  /// **'Route бүртгэгдээгүй байна.'**
  String get errorsUnknownRoute;

  /// No description provided for @validationRequired.
  ///
  /// In mn, this message translates to:
  /// **'Энэ талбарыг заавал бөглөнө.'**
  String get validationRequired;

  /// No description provided for @validationFillRequired.
  ///
  /// In mn, this message translates to:
  /// **'Талбарыг заавал бөглөнө үү.'**
  String get validationFillRequired;

  /// No description provided for @validationSelectionRequired.
  ///
  /// In mn, this message translates to:
  /// **'Утга сонгоно уу.'**
  String get validationSelectionRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In mn, this message translates to:
  /// **'Имэйл хаягаа зөв оруулна уу.'**
  String get validationInvalidEmail;

  /// No description provided for @validationInvalidPhone.
  ///
  /// In mn, this message translates to:
  /// **'Утасны дугаараа зөв оруулна уу.'**
  String get validationInvalidPhone;

  /// No description provided for @validationInvalidRegisterNo.
  ///
  /// In mn, this message translates to:
  /// **'Регистрийн дугаараа зөв оруулна уу.'**
  String get validationInvalidRegisterNo;

  /// No description provided for @validationInvalidIban.
  ///
  /// In mn, this message translates to:
  /// **'Дансны дугаараа зөв оруулна уу.'**
  String get validationInvalidIban;

  /// No description provided for @validationMinLength.
  ///
  /// In mn, this message translates to:
  /// **'Хамгийн багадаа {count} тэмдэгт оруулна уу.'**
  String validationMinLength(int count);

  /// No description provided for @validationMaxLength.
  ///
  /// In mn, this message translates to:
  /// **'Ихдээ {count} тэмдэгт оруулна уу.'**
  String validationMaxLength(int count);

  /// No description provided for @validationMinQuantity.
  ///
  /// In mn, this message translates to:
  /// **'Тоо хэмжээ хамгийн багадаа 1 байна.'**
  String get validationMinQuantity;

  /// No description provided for @validationInvalidAmount.
  ///
  /// In mn, this message translates to:
  /// **'Зөв дүн оруулна уу.'**
  String get validationInvalidAmount;

  /// No description provided for @validationMinAmount.
  ///
  /// In mn, this message translates to:
  /// **'Дүн нь зөвшөөрөгдөх доод хэмжээнээс бага байна.'**
  String get validationMinAmount;

  /// No description provided for @validationQuestionnaireIncomplete.
  ///
  /// In mn, this message translates to:
  /// **'Үргэлжлүүлэхийн өмнө бүх асуултад хариулна уу.'**
  String get validationQuestionnaireIncomplete;

  /// No description provided for @validationMissingPackSelection.
  ///
  /// In mn, this message translates to:
  /// **'Эхлээд санал болгосон багцаас сонгоно уу.'**
  String get validationMissingPackSelection;

  /// No description provided for @validationMissingSrcFiCode.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багцыг авахын өмнө хүчинтэй srcFiCode шаардлагатай.'**
  String get validationMissingSrcFiCode;

  /// No description provided for @validationMissingOrderId.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгын дугаар шаардлагатай.'**
  String get validationMissingOrderId;

  /// No description provided for @validationMissingAcntReference.
  ///
  /// In mn, this message translates to:
  /// **'Дансны лавлагаа шаардлагатай.'**
  String get validationMissingAcntReference;

  /// No description provided for @validationAccountHolderNotFound.
  ///
  /// In mn, this message translates to:
  /// **'Та дансны дугаараа шалгаад шинээр оруулж хадгална уу'**
  String get validationAccountHolderNotFound;

  /// No description provided for @validationIbanNotAllowed.
  ///
  /// In mn, this message translates to:
  /// **'IBAN дугаар биш, зөвхөн дансны дугаараа оруулна уу'**
  String get validationIbanNotAllowed;

  /// No description provided for @ipsHomeTitle.
  ///
  /// In mn, this message translates to:
  /// **'IPS тойм'**
  String get ipsHomeTitle;

  /// No description provided for @ipsHomeSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс баталгаажуулалт'**
  String get ipsHomeSubtitle;

  /// No description provided for @ipsHomeOverviewCardTitle.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн төлөв'**
  String get ipsHomeOverviewCardTitle;

  /// No description provided for @ipsHomeOpenAcntCta.
  ///
  /// In mn, this message translates to:
  /// **'Данс нээх'**
  String get ipsHomeOpenAcntCta;

  /// No description provided for @ipsHomeQuestionnaireCta.
  ///
  /// In mn, this message translates to:
  /// **'Асуумж'**
  String get ipsHomeQuestionnaireCta;

  /// No description provided for @ipsHomeRecommendedPackCta.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багц'**
  String get ipsHomeRecommendedPackCta;

  /// No description provided for @ipsHomePortfolioCta.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын багц'**
  String get ipsHomePortfolioCta;

  /// No description provided for @ipsHomeOrdersCta.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга'**
  String get ipsHomeOrdersCta;

  /// No description provided for @ipsHomeNextStepsTitle.
  ///
  /// In mn, this message translates to:
  /// **'Дараагийн алхам'**
  String get ipsHomeNextStepsTitle;

  /// No description provided for @ipsHomeNextStepsSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн төлөв дээр тулгуурлан IPS-ийн дараагийн алхмыг хийнэ.'**
  String get ipsHomeNextStepsSubtitle;

  /// No description provided for @ipsHomeSecAcntLabel.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс'**
  String get ipsHomeSecAcntLabel;

  /// No description provided for @ipsHomeIpsAcntLabel.
  ///
  /// In mn, this message translates to:
  /// **'IPS данс'**
  String get ipsHomeIpsAcntLabel;

  /// No description provided for @ipsHomeAcntStatusLabel.
  ///
  /// In mn, this message translates to:
  /// **'Дансны төлөв'**
  String get ipsHomeAcntStatusLabel;

  /// No description provided for @ipsHomeIpsBalanceLabel.
  ///
  /// In mn, this message translates to:
  /// **'IPS үлдэгдэл'**
  String get ipsHomeIpsBalanceLabel;

  /// IPS overview
  ///
  /// In mn, this message translates to:
  /// **'Сайн байна уу, {displayName}'**
  String ipsHomeGreeting(Object displayName);

  /// No description provided for @ipsOverviewVerificationTitle.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулалт'**
  String get ipsOverviewVerificationTitle;

  /// No description provided for @ipsOverviewVerificationSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Та доорх алхмуудыг гүйцэтгэснээр багц худалдан авах эрх нээгдэнэ.'**
  String get ipsOverviewVerificationSubtitle;

  /// No description provided for @ipsOverviewFinalStepLabel.
  ///
  /// In mn, this message translates to:
  /// **'Сүүлийн алхам'**
  String get ipsOverviewFinalStepLabel;

  /// No description provided for @ipsOverviewFirstPackTitle.
  ///
  /// In mn, this message translates to:
  /// **'Анхны багцаа худалдан авах'**
  String get ipsOverviewFirstPackTitle;

  /// No description provided for @ipsOverviewActionTitle.
  ///
  /// In mn, this message translates to:
  /// **'Арилжаа'**
  String get ipsOverviewActionTitle;

  /// No description provided for @ipsOverviewActionPendingOrderMessage.
  ///
  /// In mn, this message translates to:
  /// **'Танд идэвхтэй багцын захиалга байгаа тул баталгаажсаны дараа дахин захиалга өгөх боломжтой.'**
  String get ipsOverviewActionPendingOrderMessage;

  /// No description provided for @ipsOverviewProfileVerified.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажсан'**
  String get ipsOverviewProfileVerified;

  /// No description provided for @ipsOverviewProfileGuestName.
  ///
  /// In mn, this message translates to:
  /// **'InvestX хэрэглэгч'**
  String get ipsOverviewProfileGuestName;

  /// No description provided for @ipsOverviewProfileMenuPersonalInfo.
  ///
  /// In mn, this message translates to:
  /// **'Хувийн мэдээлэл'**
  String get ipsOverviewProfileMenuPersonalInfo;

  /// No description provided for @ipsOverviewProfilePersonalInfoMissing.
  ///
  /// In mn, this message translates to:
  /// **'Мэдээлэл дутуу'**
  String get ipsOverviewProfilePersonalInfoMissing;

  /// No description provided for @ipsOverviewProfileMenuLaw.
  ///
  /// In mn, this message translates to:
  /// **'Хууль'**
  String get ipsOverviewProfileMenuLaw;

  /// No description provided for @ipsOverviewProfileMenuPackInfo.
  ///
  /// In mn, this message translates to:
  /// **'Багцын мэдээлэл'**
  String get ipsOverviewProfileMenuPackInfo;

  /// No description provided for @ipsOverviewProfileMenuAchievements.
  ///
  /// In mn, this message translates to:
  /// **'Таны амжилт'**
  String get ipsOverviewProfileMenuAchievements;

  /// No description provided for @ipsOverviewProfileMenuTerms.
  ///
  /// In mn, this message translates to:
  /// **'Үйлчилгээний нөхцөл'**
  String get ipsOverviewProfileMenuTerms;

  /// No description provided for @ipsOverviewProfileMenuFeedback.
  ///
  /// In mn, this message translates to:
  /// **'Гомдол, санал хүсэлт'**
  String get ipsOverviewProfileMenuFeedback;

  /// No description provided for @ipsOverviewProfileMenuContact.
  ///
  /// In mn, this message translates to:
  /// **'Холбоо барих'**
  String get ipsOverviewProfileMenuContact;

  /// No description provided for @ipsOverviewDashboardGreetingLabel.
  ///
  /// In mn, this message translates to:
  /// **'Таньд энэ өдрийн мэнд'**
  String get ipsOverviewDashboardGreetingLabel;

  /// No description provided for @ipsOverviewDashboardProfitMessage.
  ///
  /// In mn, this message translates to:
  /// **'{amount}-н өгөөжтэй'**
  String ipsOverviewDashboardProfitMessage(Object amount);

  /// No description provided for @ipsOverviewDashboardQuickRecharge.
  ///
  /// In mn, this message translates to:
  /// **'Багц цэнэглэх'**
  String get ipsOverviewDashboardQuickRecharge;

  /// No description provided for @ipsOverviewDashboardPendingOrderTitle.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга хүлээгдэж байна.'**
  String get ipsOverviewDashboardPendingOrderTitle;

  /// No description provided for @ipsOverviewDashboardQuickWithdraw.
  ///
  /// In mn, this message translates to:
  /// **'Мөнгө татах'**
  String get ipsOverviewDashboardQuickWithdraw;

  /// No description provided for @ipsOverviewDashboardAllocationStocks.
  ///
  /// In mn, this message translates to:
  /// **'Хувьцаа'**
  String get ipsOverviewDashboardAllocationStocks;

  /// No description provided for @ipsOverviewDashboardAllocationBonds.
  ///
  /// In mn, this message translates to:
  /// **'Бонд'**
  String get ipsOverviewDashboardAllocationBonds;

  /// No description provided for @ipsOverviewDashboardAllocationCash.
  ///
  /// In mn, this message translates to:
  /// **'Бэлэн мөнгө'**
  String get ipsOverviewDashboardAllocationCash;

  /// No description provided for @ipsOverviewDashboardAllocationTotal.
  ///
  /// In mn, this message translates to:
  /// **'Нийт хөрөнгө оруулалт'**
  String get ipsOverviewDashboardAllocationTotal;

  /// No description provided for @ipsOverviewDashboardYieldLabel.
  ///
  /// In mn, this message translates to:
  /// **'Таны өгөөж'**
  String get ipsOverviewDashboardYieldLabel;

  /// No description provided for @ipsOverviewDashboardDetails.
  ///
  /// In mn, this message translates to:
  /// **'Дэлгэрэнгүй харах'**
  String get ipsOverviewDashboardDetails;

  /// No description provided for @ipsOverviewDashboardReminderTitle.
  ///
  /// In mn, this message translates to:
  /// **'Санамж'**
  String get ipsOverviewDashboardReminderTitle;

  /// No description provided for @ipsOverviewDashboardReminderBody.
  ///
  /// In mn, this message translates to:
  /// **'Үнэт цаасны арилжаа долоо хоног бүрийн Даваа, Пүрэв гарагт автоматаар хийгдэнэ. Та дансаа цэнэглэж, захиалгаа өгөхөд хангалттай.'**
  String get ipsOverviewDashboardReminderBody;

  /// No description provided for @ipsOverviewDashboardGoalTitle.
  ///
  /// In mn, this message translates to:
  /// **'Зорилго'**
  String get ipsOverviewDashboardGoalTitle;

  /// No description provided for @ipsOverviewDashboardGoalProgress.
  ///
  /// In mn, this message translates to:
  /// **'Биелүүлэлт'**
  String get ipsOverviewDashboardGoalProgress;

  /// No description provided for @ipsOverviewDashboardRewardTitle.
  ///
  /// In mn, this message translates to:
  /// **'Тасралтгүй {count} дахь сар!'**
  String ipsOverviewDashboardRewardTitle(int count);

  /// No description provided for @ipsOverviewDashboardRewardBody.
  ///
  /// In mn, this message translates to:
  /// **'Та тасралтгүй хөрөнгө оруулалт хийсэнд тань урамшуулан 5000 Tino Coin бэлэглэх болно.'**
  String get ipsOverviewDashboardRewardBody;

  /// No description provided for @ipsOverviewDashboardActionRecharge.
  ///
  /// In mn, this message translates to:
  /// **'Багц цэнэглэх'**
  String get ipsOverviewDashboardActionRecharge;

  /// No description provided for @ipsOverviewDashboardActionSell.
  ///
  /// In mn, this message translates to:
  /// **'Багц хаах'**
  String get ipsOverviewDashboardActionSell;

  /// No description provided for @ipsAcntTitle.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс'**
  String get ipsAcntTitle;

  /// No description provided for @ipsAcntSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Танилцуулга, зөвшөөрөл, данс нээх хүсэлт, QR үүсгэх.'**
  String get ipsAcntSubtitle;

  /// No description provided for @ipsAcntOpenAcnt.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс нээх'**
  String get ipsAcntOpenAcnt;

  /// No description provided for @ipsAcntVerifyAcnt.
  ///
  /// In mn, this message translates to:
  /// **'Данс баталгаажуулах'**
  String get ipsAcntVerifyAcnt;

  /// No description provided for @ipsAcntGenerateQr.
  ///
  /// In mn, this message translates to:
  /// **'QR үүсгэх'**
  String get ipsAcntGenerateQr;

  /// No description provided for @ipsAcntQrValue.
  ///
  /// In mn, this message translates to:
  /// **'QR утга'**
  String get ipsAcntQrValue;

  /// No description provided for @ipsAcntOpeningFee.
  ///
  /// In mn, this message translates to:
  /// **'Нээлтийн шимтгэл'**
  String get ipsAcntOpeningFee;

  /// No description provided for @ipsAcntMissingService.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ дансны integration тохируулагдаагүй байна.'**
  String get ipsAcntMissingService;

  /// No description provided for @ipsAcntHasAcnt.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс бүртгэлтэй'**
  String get ipsAcntHasAcnt;

  /// No description provided for @ipsAcntNoAcnt.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс бүртгэлгүй'**
  String get ipsAcntNoAcnt;

  /// No description provided for @ipsAcntBalance.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ дансны үлдэгдэл'**
  String get ipsAcntBalance;

  /// No description provided for @ipsAcntFlowBody.
  ///
  /// In mn, this message translates to:
  /// **'Данс нээх.'**
  String get ipsAcntFlowBody;

  /// No description provided for @ipsAcntPendingQrMessage.
  ///
  /// In mn, this message translates to:
  /// **'ҮЦ данс нээх алхмыг үргэлжлүүлэхийн тулд QR үүсгэнэ үү.'**
  String get ipsAcntPendingQrMessage;

  /// No description provided for @ipsBootstrapMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Bootstrap service тохируулагдаагүй байна.'**
  String get ipsBootstrapMissingService;

  /// No description provided for @ipsBootstrapLoading.
  ///
  /// In mn, this message translates to:
  /// **'Дансны эхний төлөвийг шалгаж байна.'**
  String get ipsBootstrapLoading;

  /// No description provided for @ipsSplashTitle.
  ///
  /// In mn, this message translates to:
  /// **'InvestX эхлэл'**
  String get ipsSplashTitle;

  /// No description provided for @ipsSplashSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн хэрэглэгч, login session болон IPS төлвийн эхлэлийг ажиллуулна.'**
  String get ipsSplashSubtitle;

  /// No description provided for @ipsStartupBlockedTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны хувийн мэдээлэл дутуу байна'**
  String get ipsStartupBlockedTitle;

  /// No description provided for @ipsStartupBlockedProfileIncompleteMessage.
  ///
  /// In mn, this message translates to:
  /// **'Таны хувийн мэдээлэл бүрэн баталгаажаагүй байна.\nҮргэлжлүүлэхийн тулд ДАН системээр хувийн мэдээллээ баталгаажуулаад дахин нэвтэрнэ үү.'**
  String get ipsStartupBlockedProfileIncompleteMessage;

  /// No description provided for @ipsStartupBlockedAlreadyRegisteredMessage.
  ///
  /// In mn, this message translates to:
  /// **'Та APEX APP-д бүртгэлтэй байна. Та бүртгэлтэй APP-аар нэвтэрнэ үү.'**
  String get ipsStartupBlockedAlreadyRegisteredMessage;

  /// No description provided for @ipsQuestionnaireTitle.
  ///
  /// In mn, this message translates to:
  /// **'Асуумж'**
  String get ipsQuestionnaireTitle;

  /// No description provided for @ipsQuestionnaireSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Асуумжийн жагсаалт авах болон оноо тооцох.'**
  String get ipsQuestionnaireSubtitle;

  /// No description provided for @ipsQuestionnaireCalculateScore.
  ///
  /// In mn, this message translates to:
  /// **'Оноо тооцоолох'**
  String get ipsQuestionnaireCalculateScore;

  /// Дугаартай асуултын угтвар.
  ///
  /// In mn, this message translates to:
  /// **'Асуулт {index}'**
  String ipsQuestionnaireQuestionPrefix(Object index);

  /// Дугаартай асуултын сонголтын орлуулга.
  ///
  /// In mn, this message translates to:
  /// **'Сонголт {index}'**
  String ipsQuestionnaireOptionPrefix(Object index);

  /// No description provided for @ipsQuestionnaireResTitle.
  ///
  /// In mn, this message translates to:
  /// **'Тооцсон үр дүн'**
  String get ipsQuestionnaireResTitle;

  /// No description provided for @ipsQuestionnaireCustomerCode.
  ///
  /// In mn, this message translates to:
  /// **'Харилцагчийн код'**
  String get ipsQuestionnaireCustomerCode;

  /// No description provided for @ipsQuestionnaireViewPacks.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багц харах'**
  String get ipsQuestionnaireViewPacks;

  /// No description provided for @ipsQuestionnaireMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Асуумжийн service тохируулагдаагүй байна.'**
  String get ipsQuestionnaireMissingService;

  /// No description provided for @ipsQuestionnaireScore.
  ///
  /// In mn, this message translates to:
  /// **'Оноо'**
  String get ipsQuestionnaireScore;

  /// No description provided for @ipsQuestionnaireSummary.
  ///
  /// In mn, this message translates to:
  /// **'Тайлбар'**
  String get ipsQuestionnaireSummary;

  /// No description provided for @ipsQuestionnaireLoading.
  ///
  /// In mn, this message translates to:
  /// **'Асуумжийг ачаалж байна.'**
  String get ipsQuestionnaireLoading;

  /// No description provided for @ipsQuestionnaireRecommendationTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны итгэлт зөвлөх'**
  String get ipsQuestionnaireRecommendationTitle;

  /// No description provided for @ipsQuestionnaireRecommendationBody.
  ///
  /// In mn, this message translates to:
  /// **'Хэдхэн асуултад хариулаад танд хамгийн тохирох INVESTX багцын зөвлөмжийг бэлтгэе.'**
  String get ipsQuestionnaireRecommendationBody;

  /// No description provided for @ipsQuestionnaireCalculatingMessage.
  ///
  /// In mn, this message translates to:
  /// **'Танд хамгийн тохирох багцын зөвлөмжийг бэлтгэж байна.'**
  String get ipsQuestionnaireCalculatingMessage;

  /// No description provided for @ipsQuestionnaireStaticQuestionTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын хэмжээ'**
  String get ipsQuestionnaireStaticQuestionTitle;

  /// No description provided for @ipsQuestionnaireStaticOption100k.
  ///
  /// In mn, this message translates to:
  /// **'100,000'**
  String get ipsQuestionnaireStaticOption100k;

  /// No description provided for @ipsQuestionnaireStaticOption200k.
  ///
  /// In mn, this message translates to:
  /// **'200,000'**
  String get ipsQuestionnaireStaticOption200k;

  /// No description provided for @ipsQuestionnaireStaticOption500k.
  ///
  /// In mn, this message translates to:
  /// **'500,000'**
  String get ipsQuestionnaireStaticOption500k;

  /// No description provided for @ipsQuestionnaireStaticOption1000000Plus.
  ///
  /// In mn, this message translates to:
  /// **'1,000,000+'**
  String get ipsQuestionnaireStaticOption1000000Plus;

  /// No description provided for @ipsQuestionnaireTargetGoalMissing.
  ///
  /// In mn, this message translates to:
  /// **'Үргэлжлүүлэхийн өмнө хөрөнгө оруулах дүнгээ сонгоно уу.'**
  String get ipsQuestionnaireTargetGoalMissing;

  /// No description provided for @ipsSignatureUploading.
  ///
  /// In mn, this message translates to:
  /// **'Гарын үсгийг илгээж байна.'**
  String get ipsSignatureUploading;

  /// No description provided for @ipsPackTitle.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багц'**
  String get ipsPackTitle;

  /// No description provided for @ipsPackSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Багцын санал болон сонголт'**
  String get ipsPackSubtitle;

  /// No description provided for @ipsPackRecommendedBadge.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон'**
  String get ipsPackRecommendedBadge;

  /// No description provided for @ipsPackChoosePack.
  ///
  /// In mn, this message translates to:
  /// **'Багц сонгох'**
  String get ipsPackChoosePack;

  /// No description provided for @ipsPackAllocation.
  ///
  /// In mn, this message translates to:
  /// **'Хуваарилалт'**
  String get ipsPackAllocation;

  /// No description provided for @ipsPackBondPercent.
  ///
  /// In mn, this message translates to:
  /// **'Бонд'**
  String get ipsPackBondPercent;

  /// No description provided for @ipsPackStockPercent.
  ///
  /// In mn, this message translates to:
  /// **'Хувьцаа'**
  String get ipsPackStockPercent;

  /// No description provided for @ipsPackAssetPercent.
  ///
  /// In mn, this message translates to:
  /// **'Бусад хөрөнгө'**
  String get ipsPackAssetPercent;

  /// No description provided for @ipsPackNoPacks.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багц ирсэнгүй.'**
  String get ipsPackNoPacks;

  /// No description provided for @ipsPackMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Багцын service тохируулагдаагүй байна.'**
  String get ipsPackMissingService;

  /// No description provided for @ipsPackSrcFiCodeRequired.
  ///
  /// In mn, this message translates to:
  /// **'Official pack API дуудахдаа questionnaire-ийн srcFiCode шаардлагатай.'**
  String get ipsPackSrcFiCodeRequired;

  /// No description provided for @ipsPackCode.
  ///
  /// In mn, this message translates to:
  /// **'Багцын код'**
  String get ipsPackCode;

  /// No description provided for @ipsPackSecondaryName.
  ///
  /// In mn, this message translates to:
  /// **'Нэмэлт нэр'**
  String get ipsPackSecondaryName;

  /// No description provided for @ipsPackLoading.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багцыг ачаалж байна.'**
  String get ipsPackLoading;

  /// Багцын хөрөнгийн хуваарилалт.
  ///
  /// In mn, this message translates to:
  /// **'Бонд {bond}%, Хувьцаа {stock}%'**
  String ipsPackAllocationValue(Object bond, Object stock);

  /// No description provided for @ipsContractTitle.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээ'**
  String get ipsContractTitle;

  /// No description provided for @ipsContractSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээ үүсгэх болон гарын үсгийн баталгаажуулалт.'**
  String get ipsContractSubtitle;

  /// No description provided for @ipsContractCreate.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээ үүсгэх'**
  String get ipsContractCreate;

  /// No description provided for @ipsContractTermsTitle.
  ///
  /// In mn, this message translates to:
  /// **'Үйлчилгээний нөхцөл'**
  String get ipsContractTermsTitle;

  /// No description provided for @ipsContractMissingPack.
  ///
  /// In mn, this message translates to:
  /// **'Багцын сонголтын мэдээлэл алга.'**
  String get ipsContractMissingPack;

  /// No description provided for @ipsContractMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээний service тохируулагдаагүй байна.'**
  String get ipsContractMissingService;

  /// No description provided for @ipsContractCreated.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээ үүслээ'**
  String get ipsContractCreated;

  /// No description provided for @ipsContractOpenPortfolio.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын багц нээх'**
  String get ipsContractOpenPortfolio;

  /// No description provided for @ipsContractId.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээний дугаар'**
  String get ipsContractId;

  /// No description provided for @ipsContractRiskScore.
  ///
  /// In mn, this message translates to:
  /// **'Эрсдэлийн оноо'**
  String get ipsContractRiskScore;

  /// No description provided for @ipsContractTermsBody.
  ///
  /// In mn, this message translates to:
  /// **'Санал болгосон багцыг баталгаажуулж, үйлчилгээний нөхцөлийг зөвшөөрөөд IPS гэрээг үүсгэнэ.'**
  String get ipsContractTermsBody;

  /// No description provided for @ipsContractPreparingAccounts.
  ///
  /// In mn, this message translates to:
  /// **'IPS дансуудыг үүсгэж, багцын мэдээллийг ачаалж байна.'**
  String get ipsContractPreparingAccounts;

  /// No description provided for @ipsContractPackQuantityPrompt.
  ///
  /// In mn, this message translates to:
  /// **'Авах ширхэгийн тоог оруулна уу.'**
  String get ipsContractPackQuantityPrompt;

  /// No description provided for @ipsContractUnitPrice.
  ///
  /// In mn, this message translates to:
  /// **'Нэгж багцын үнэ'**
  String get ipsContractUnitPrice;

  /// No description provided for @ipsContractServiceFee.
  ///
  /// In mn, this message translates to:
  /// **'Үйлчилгээний шимтгэл'**
  String get ipsContractServiceFee;

  /// No description provided for @ipsContractIpsAccountsMissing.
  ///
  /// In mn, this message translates to:
  /// **'Шаардлагатай IPS дансууд хараахан бэлэн болоогүй байна. Дахин оролдоно уу.'**
  String get ipsContractIpsAccountsMissing;

  /// No description provided for @ipsContractPackPricingUnavailable.
  ///
  /// In mn, this message translates to:
  /// **'Сонгосон багцын үнийн мэдээлэл одоогоор байхгүй байна. Дахин оролдоно уу.'**
  String get ipsContractPackPricingUnavailable;

  /// No description provided for @ipsContractPreparingPayment.
  ///
  /// In mn, this message translates to:
  /// **'Гэрээ, төлбөрийн хүсэлт, wallet төлбөрийг бэлтгэж байна.'**
  String get ipsContractPreparingPayment;

  /// No description provided for @ipsPortfolioTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын багц'**
  String get ipsPortfolioTitle;

  /// No description provided for @ipsPortfolioSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'IPS дансны багц, өгөөж, ашиг/алдагдал.'**
  String get ipsPortfolioSubtitle;

  /// No description provided for @ipsPortfolioAvailableBalance.
  ///
  /// In mn, this message translates to:
  /// **'Боломжит үлдэгдэл'**
  String get ipsPortfolioAvailableBalance;

  /// No description provided for @ipsPortfolioInvestedBalance.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулсан үлдэгдэл'**
  String get ipsPortfolioInvestedBalance;

  /// No description provided for @ipsPortfolioProfitLoss.
  ///
  /// In mn, this message translates to:
  /// **'Ашиг/Алдагдал'**
  String get ipsPortfolioProfitLoss;

  /// No description provided for @ipsPortfolioYield.
  ///
  /// In mn, this message translates to:
  /// **'Өгөөж'**
  String get ipsPortfolioYield;

  /// No description provided for @ipsPortfolioHoldings.
  ///
  /// In mn, this message translates to:
  /// **'Миний багц'**
  String get ipsPortfolioHoldings;

  /// No description provided for @ipsPortfolioNoHoldings.
  ///
  /// In mn, this message translates to:
  /// **'Мэдээлэл алга.'**
  String get ipsPortfolioNoHoldings;

  /// No description provided for @ipsPortfolioRecharge.
  ///
  /// In mn, this message translates to:
  /// **'Цэнэглэх'**
  String get ipsPortfolioRecharge;

  /// No description provided for @ipsPortfolioSellOrder.
  ///
  /// In mn, this message translates to:
  /// **'Зарах захиалга'**
  String get ipsPortfolioSellOrder;

  /// No description provided for @ipsPortfolioOrderList.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгын жагсаалт'**
  String get ipsPortfolioOrderList;

  /// No description provided for @ipsPortfolioStatements.
  ///
  /// In mn, this message translates to:
  /// **'Хуулга'**
  String get ipsPortfolioStatements;

  /// No description provided for @ipsPortfolioMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын багцын service тохируулагдаагүй байна.'**
  String get ipsPortfolioMissingService;

  /// No description provided for @ipsPortfolioLoading.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын багцын тоймыг ачаалж байна.'**
  String get ipsPortfolioLoading;

  /// No description provided for @ipsPortfolioHoldingQuantity.
  ///
  /// In mn, this message translates to:
  /// **'Тоо ширхэг'**
  String get ipsPortfolioHoldingQuantity;

  /// No description provided for @ipsPortfolioHoldingValueLabel.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн үнэлгээ'**
  String get ipsPortfolioHoldingValueLabel;

  /// Товч мэдээлэл.
  ///
  /// In mn, this message translates to:
  /// **'Тоо ширхэг {quantity} • Үнэлгээ {value}'**
  String ipsPortfolioHoldingValue(Object quantity, Object value);

  /// No description provided for @ipsOrdersTitle.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга'**
  String get ipsOrdersTitle;

  /// No description provided for @ipsOrdersSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'IPS захиалгын жагсаалт болон цуцлах'**
  String get ipsOrdersSubtitle;

  /// No description provided for @ipsOrdersNoOrders.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга байхгүй байна'**
  String get ipsOrdersNoOrders;

  /// No description provided for @ipsOrdersCancelOrder.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга цуцлах'**
  String get ipsOrdersCancelOrder;

  /// No description provided for @ipsOrdersCreatedAt.
  ///
  /// In mn, this message translates to:
  /// **'Үүсгэсэн огноо'**
  String get ipsOrdersCreatedAt;

  /// No description provided for @ipsOrdersOrderId.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгын дугаар'**
  String get ipsOrdersOrderId;

  /// No description provided for @ipsOrdersMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгын service тохируулагдаагүй байна.'**
  String get ipsOrdersMissingService;

  /// No description provided for @ipsOrdersType.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгын төрөл'**
  String get ipsOrdersType;

  /// No description provided for @ipsOrdersTypeBuy.
  ///
  /// In mn, this message translates to:
  /// **'Авах'**
  String get ipsOrdersTypeBuy;

  /// No description provided for @ipsOrdersTypeSell.
  ///
  /// In mn, this message translates to:
  /// **'Зарах'**
  String get ipsOrdersTypeSell;

  /// No description provided for @ipsOrdersTypeRecharge.
  ///
  /// In mn, this message translates to:
  /// **'Цэнэглэх'**
  String get ipsOrdersTypeRecharge;

  /// No description provided for @ipsOrdersLoading.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгын жагсаалтыг ачаалж байна.'**
  String get ipsOrdersLoading;

  /// Захиалга цуцлахаас өмнө харуулах баталгаажуулах асуулт.
  ///
  /// In mn, this message translates to:
  /// **'{orderId} захиалгыг цуцлах уу?'**
  String ipsOrdersCancelOrderConfirm(Object orderId);

  /// Захиалгын төрөл ба төлөвийг нэг мөрөнд харуулна.
  ///
  /// In mn, this message translates to:
  /// **'{type} • {status}'**
  String ipsOrdersSummary(Object type, Object status);

  /// No description provided for @ipsPaymentRechargeTitle.
  ///
  /// In mn, this message translates to:
  /// **'Багц цэнэглэх'**
  String get ipsPaymentRechargeTitle;

  /// No description provided for @ipsPaymentRechargeSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Солилцоо/цэнэглэлт болон QR үүсгэх.'**
  String get ipsPaymentRechargeSubtitle;

  /// No description provided for @ipsPaymentRechargeQuantityHint.
  ///
  /// In mn, this message translates to:
  /// **'Авах ширхэгийн тоог оруулна уу'**
  String get ipsPaymentRechargeQuantityHint;

  /// No description provided for @ipsPaymentRechargeQuantityUnit.
  ///
  /// In mn, this message translates to:
  /// **'ш'**
  String get ipsPaymentRechargeQuantityUnit;

  /// No description provided for @ipsPaymentRechargeTotalAmount.
  ///
  /// In mn, this message translates to:
  /// **'Нийт дүн'**
  String get ipsPaymentRechargeTotalAmount;

  /// No description provided for @ipsPaymentCreateQr.
  ///
  /// In mn, this message translates to:
  /// **'QR үүсгэх'**
  String get ipsPaymentCreateQr;

  /// No description provided for @ipsPaymentQrGenerated.
  ///
  /// In mn, this message translates to:
  /// **'Төлбөрийн QR үүслээ'**
  String get ipsPaymentQrGenerated;

  /// No description provided for @ipsPaymentPending.
  ///
  /// In mn, this message translates to:
  /// **'Төлбөр хүлээгдэж байна.'**
  String get ipsPaymentPending;

  /// No description provided for @ipsPaymentMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Цэнэглэлт/төлбөрийн service тохируулагдаагүй байна.'**
  String get ipsPaymentMissingService;

  /// No description provided for @ipsPaymentQrValue.
  ///
  /// In mn, this message translates to:
  /// **'QR утга'**
  String get ipsPaymentQrValue;

  /// No description provided for @ipsPaymentAcntFlow.
  ///
  /// In mn, this message translates to:
  /// **'Данс нээх алхамууд'**
  String get ipsPaymentAcntFlow;

  /// No description provided for @ipsPaymentCreateInvoiceAndPay.
  ///
  /// In mn, this message translates to:
  /// **'Нэхэмжлэл үүсгээд төлөх'**
  String get ipsPaymentCreateInvoiceAndPay;

  /// No description provided for @ipsPaymentInvoiceId.
  ///
  /// In mn, this message translates to:
  /// **'Нэхэмжлэлийн дугаар'**
  String get ipsPaymentInvoiceId;

  /// No description provided for @ipsPaymentViewOrders.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга харах'**
  String get ipsPaymentViewOrders;

  /// No description provided for @ipsRechargeSuccessGoHome.
  ///
  /// In mn, this message translates to:
  /// **'Нүүр хуудасруу очих'**
  String get ipsRechargeSuccessGoHome;

  /// No description provided for @ipsRechargeSuccessCardTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны захиалга амжилттай үүслээ'**
  String get ipsRechargeSuccessCardTitle;

  /// No description provided for @ipsRechargeSuccessCardMessage.
  ///
  /// In mn, this message translates to:
  /// **'Үнэт цаасны арилжаа долоо хоног бүрийн Даваа, Пүрэв гарагт автоматаар хийгдэнэ. Таны төлбөр төлөгдсөн тул таны арилжаа дээрх өдрийн дараа багцын үлдэгдэлээ шалгаарай.'**
  String get ipsRechargeSuccessCardMessage;

  /// No description provided for @ipsPaymentStatusTimedOut.
  ///
  /// In mn, this message translates to:
  /// **'Хугацаа хэтэрсэн'**
  String get ipsPaymentStatusTimedOut;

  /// No description provided for @ipsPaymentStatusUnsupported.
  ///
  /// In mn, this message translates to:
  /// **'Дэмжигдээгүй'**
  String get ipsPaymentStatusUnsupported;

  /// No description provided for @ipsPaymentInvoiceCreateFailed.
  ///
  /// In mn, this message translates to:
  /// **'SDK төлбөрийн нэхэмжлэл үүсгэж чадсангүй.'**
  String get ipsPaymentInvoiceCreateFailed;

  /// No description provided for @ipsPaymentInvalidInvoice.
  ///
  /// In mn, this message translates to:
  /// **'Төлбөрийн нэхэмжлэлийн хариунд ашиглах invoice ID байгаагүй.'**
  String get ipsPaymentInvalidInvoice;

  /// No description provided for @ipsPaymentHostResponseTimedOut.
  ///
  /// In mn, this message translates to:
  /// **'Host аппын төлбөрийн хариу хүлээлгийн хугацаа дууслаа.'**
  String get ipsPaymentHostResponseTimedOut;

  /// No description provided for @ipsPaymentHostCallbackFailed.
  ///
  /// In mn, this message translates to:
  /// **'Host аппын төлбөрийн callback амжилтгүй боллоо.'**
  String get ipsPaymentHostCallbackFailed;

  /// No description provided for @ipsSellTitle.
  ///
  /// In mn, this message translates to:
  /// **'Багц зарах'**
  String get ipsSellTitle;

  /// No description provided for @ipsSellCloseTitle.
  ///
  /// In mn, this message translates to:
  /// **'Багц хаах'**
  String get ipsSellCloseTitle;

  /// No description provided for @ipsSellSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Багц зарах захиалга үүсгэх'**
  String get ipsSellSubtitle;

  /// No description provided for @ipsSellMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Зарах захиалгын service тохируулагдаагүй байна.'**
  String get ipsSellMissingService;

  /// No description provided for @ipsSellCreateOrder.
  ///
  /// In mn, this message translates to:
  /// **'Зарах захиалга үүсгэх'**
  String get ipsSellCreateOrder;

  /// No description provided for @ipsSellPendingMessage.
  ///
  /// In mn, this message translates to:
  /// **'Энэ хүсэлт нь таны эзэмшиж буй бүх багцын нэгжийг зарж багцыг хаах үйлдэл юм.'**
  String get ipsSellPendingMessage;

  /// No description provided for @ipsSellReminderBody.
  ///
  /// In mn, this message translates to:
  /// **'Доорх багцын тоо нь таны одоогийн багцын үлдэгдлээс автоматаар авсан болно. Хүсэлт илгээснээр эзэмшиж буй бүх багцын нэгжид зарах захиалга үүсэж, эцсийн дүн нь тухайн үеийн хөрөнгийн үнэлгээ, мөнгөн үлдэгдэл, шимтгэлээр тооцогдоно.'**
  String get ipsSellReminderBody;

  /// No description provided for @ipsSellQuantityClosing.
  ///
  /// In mn, this message translates to:
  /// **'Хааж буй багцын тоо'**
  String get ipsSellQuantityClosing;

  /// No description provided for @ipsSellTotalAmount.
  ///
  /// In mn, this message translates to:
  /// **'НИЙТ ДҮН'**
  String get ipsSellTotalAmount;

  /// No description provided for @ipsSellProfit.
  ///
  /// In mn, this message translates to:
  /// **'АШИГ'**
  String get ipsSellProfit;

  /// No description provided for @ipsSellTotalFee.
  ///
  /// In mn, this message translates to:
  /// **'НИЙТ ШИМТГЭЛ'**
  String get ipsSellTotalFee;

  /// No description provided for @ipsSellPayoutAmount.
  ///
  /// In mn, this message translates to:
  /// **'Танд орох дүн'**
  String get ipsSellPayoutAmount;

  /// No description provided for @ipsSellSubmitRequest.
  ///
  /// In mn, this message translates to:
  /// **'Хүсэлт илгээх'**
  String get ipsSellSubmitRequest;

  /// No description provided for @ipsSellSuccessTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны хүсэлт амжилттай боллоо'**
  String get ipsSellSuccessTitle;

  /// No description provided for @ipsSellSuccessBody.
  ///
  /// In mn, this message translates to:
  /// **'Таны багцаа хаах хүсэлтийг амжилттай хүлээн авлаа. Багцын арилжаа нь долоо хоног бүрийн Мягмар болон Пүрэв гаригт хийгдэнэ. Таны нийт хөрөнгө оруулалтын буцаалтын гүйлгээ ажлын 10 хоногт багтан хийгдэх бөгөөд таны арилжааны банкны данс руу орох болно.'**
  String get ipsSellSuccessBody;

  /// No description provided for @ipsSellPackLabel.
  ///
  /// In mn, this message translates to:
  /// **'Багц {number}'**
  String ipsSellPackLabel(int number);

  /// No description provided for @ipsSellAllocationLabel.
  ///
  /// In mn, this message translates to:
  /// **'{bond}% бонд, {stock}% хувьцаа'**
  String ipsSellAllocationLabel(int bond, int stock);

  /// No description provided for @ipsStatementTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хуулга'**
  String get ipsStatementTitle;

  /// No description provided for @ipsStatementSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Хуулга болон дансны товч дүнгийн дэлгэц.'**
  String get ipsStatementSubtitle;

  /// No description provided for @ipsStatementSummary.
  ///
  /// In mn, this message translates to:
  /// **'Хуулгын товч дүн'**
  String get ipsStatementSummary;

  /// No description provided for @ipsStatementBeginBalance.
  ///
  /// In mn, this message translates to:
  /// **'Эхний үлдэгдэл'**
  String get ipsStatementBeginBalance;

  /// No description provided for @ipsStatementEndBalance.
  ///
  /// In mn, this message translates to:
  /// **'Эцсийн үлдэгдэл'**
  String get ipsStatementEndBalance;

  /// No description provided for @ipsStatementEntriesCount.
  ///
  /// In mn, this message translates to:
  /// **'{count} гүйлгээ'**
  String ipsStatementEntriesCount(int count);

  /// No description provided for @ipsStatementMissingService.
  ///
  /// In mn, this message translates to:
  /// **'Хуулгын service тохируулагдаагүй байна.'**
  String get ipsStatementMissingService;

  /// No description provided for @ipsStatementsLoading.
  ///
  /// In mn, this message translates to:
  /// **'Хуулгын товч мэдээллийг ачаалж байна.'**
  String get ipsStatementsLoading;

  /// No description provided for @ipsYieldTitle.
  ///
  /// In mn, this message translates to:
  /// **'Өгөөж'**
  String get ipsYieldTitle;

  /// No description provided for @ipsYieldSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын багцын өгөөжийн задаргаа.'**
  String get ipsYieldSubtitle;

  /// No description provided for @ipsYieldDetails.
  ///
  /// In mn, this message translates to:
  /// **'Өгөөжийн дэлгэрэнгүй'**
  String get ipsYieldDetails;

  /// No description provided for @ipsProfitTitle.
  ///
  /// In mn, this message translates to:
  /// **'Ашиг алдагдал'**
  String get ipsProfitTitle;

  /// No description provided for @ipsProfitSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Багцын ашиг алдагдлын мэдээлэл.'**
  String get ipsProfitSubtitle;

  /// No description provided for @ipsProfitSummary.
  ///
  /// In mn, this message translates to:
  /// **'Ашиг алдагдлын тойм'**
  String get ipsProfitSummary;

  /// No description provided for @ipsSuccessReqCreated.
  ///
  /// In mn, this message translates to:
  /// **'Хүсэлт амжилттай үүслээ.'**
  String get ipsSuccessReqCreated;

  /// No description provided for @ipsSuccessOrderCancelled.
  ///
  /// In mn, this message translates to:
  /// **'Захиалгыг амжилттай цуцаллаа.'**
  String get ipsSuccessOrderCancelled;

  /// No description provided for @ipsSuccessContractCreated.
  ///
  /// In mn, this message translates to:
  /// **'Данс нээх хүсэлт амжилттай'**
  String get ipsSuccessContractCreated;

  /// No description provided for @ipsSuccessQrCreated.
  ///
  /// In mn, this message translates to:
  /// **'QR амжилттай үүслээ.'**
  String get ipsSuccessQrCreated;

  /// No description provided for @ipsStatusPending.
  ///
  /// In mn, this message translates to:
  /// **'Хүлээгдэж буй'**
  String get ipsStatusPending;

  /// No description provided for @ipsStatusNew.
  ///
  /// In mn, this message translates to:
  /// **'Хүлээгдэж буй'**
  String get ipsStatusNew;

  /// No description provided for @ipsStatusActive.
  ///
  /// In mn, this message translates to:
  /// **'Идэвхтэй'**
  String get ipsStatusActive;

  /// No description provided for @ipsStatusConfirmed.
  ///
  /// In mn, this message translates to:
  /// **'Захиалга баталгаажсан'**
  String get ipsStatusConfirmed;

  /// No description provided for @ipsStatusCompleted.
  ///
  /// In mn, this message translates to:
  /// **'Амжилттай'**
  String get ipsStatusCompleted;

  /// No description provided for @ipsStatusAllocated.
  ///
  /// In mn, this message translates to:
  /// **'Хуваарилагдсан'**
  String get ipsStatusAllocated;

  /// No description provided for @ipsStatusCancelled.
  ///
  /// In mn, this message translates to:
  /// **'Цуцлагдсан'**
  String get ipsStatusCancelled;

  /// No description provided for @ipsStatusFailed.
  ///
  /// In mn, this message translates to:
  /// **'Амжилтгүй'**
  String get ipsStatusFailed;

  /// No description provided for @ipsUnknownRouteTitle.
  ///
  /// In mn, this message translates to:
  /// **'Маршрут олдсонгүй'**
  String get ipsUnknownRouteTitle;

  /// Бүртгэгдээгүй IPS route дуудагдсан үед харуулна.
  ///
  /// In mn, this message translates to:
  /// **'IPS дотор {route} маршрут бүртгэгдээгүй байна.'**
  String ipsUnknownRouteMessage(Object route);

  /// Internal demo module дотор бүртгэгдээгүй маршрут дуудагдсан үед харуулна.
  ///
  /// In mn, this message translates to:
  /// **' модульд {route} маршрут бүртгэгдээгүй байна.'**
  String internalUnknownRouteMessage(Object, Object route);

  /// No description provided for @internalProfileCatalogTitle.
  ///
  /// In mn, this message translates to:
  /// **'Профайл дэлгэцүүд'**
  String get internalProfileCatalogTitle;

  /// No description provided for @internalProfileModuleName.
  ///
  /// In mn, this message translates to:
  /// **'Профайл'**
  String get internalProfileModuleName;

  /// No description provided for @internalProfileRouteHomeTitle.
  ///
  /// In mn, this message translates to:
  /// **'Холбоо барих мэдээлэл шинэчлэх'**
  String get internalProfileRouteHomeTitle;

  /// No description provided for @internalProfileRouteHomeDescription.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн и-мэйл болон утасны мэдээллийг шалгана.'**
  String get internalProfileRouteHomeDescription;

  /// No description provided for @internalProfileRouteUpdateEmailTitle.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйл шинэчлэх'**
  String get internalProfileRouteUpdateEmailTitle;

  /// No description provided for @internalProfileRouteUpdateEmailDescription.
  ///
  /// In mn, this message translates to:
  /// **'Шинэ и-мэйл хаягаа оруулна.'**
  String get internalProfileRouteUpdateEmailDescription;

  /// No description provided for @internalProfileRouteVerifyEmailTitle.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйл баталгаажуулах'**
  String get internalProfileRouteVerifyEmailTitle;

  /// No description provided for @internalProfileRouteVerifyEmailDescription.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйлээр ирсэн баталгаажуулах кодоо оруулна.'**
  String get internalProfileRouteVerifyEmailDescription;

  /// No description provided for @internalProfileRouteEmailVerifiedTitle.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйл баталгаажсан'**
  String get internalProfileRouteEmailVerifiedTitle;

  /// No description provided for @internalProfileRouteEmailVerifiedDescription.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйл баталгаажуулалт амжилттай болсон төлөв.'**
  String get internalProfileRouteEmailVerifiedDescription;

  /// No description provided for @internalProfileRouteUpdatePhoneTitle.
  ///
  /// In mn, this message translates to:
  /// **'Утас шинэчлэх'**
  String get internalProfileRouteUpdatePhoneTitle;

  /// No description provided for @internalProfileRouteUpdatePhoneDescription.
  ///
  /// In mn, this message translates to:
  /// **'Шинэ утасны дугаараа оруулна.'**
  String get internalProfileRouteUpdatePhoneDescription;

  /// No description provided for @internalProfileRouteVerifyPhoneTitle.
  ///
  /// In mn, this message translates to:
  /// **'Утас баталгаажуулах'**
  String get internalProfileRouteVerifyPhoneTitle;

  /// No description provided for @internalProfileRouteVerifyPhoneDescription.
  ///
  /// In mn, this message translates to:
  /// **'Утсаар ирсэн баталгаажуулах кодоо оруулна.'**
  String get internalProfileRouteVerifyPhoneDescription;

  /// No description provided for @internalProfileRoutePhoneVerifiedTitle.
  ///
  /// In mn, this message translates to:
  /// **'Утас баталгаажсан'**
  String get internalProfileRoutePhoneVerifiedTitle;

  /// No description provided for @internalProfileRoutePhoneVerifiedDescription.
  ///
  /// In mn, this message translates to:
  /// **'Утас баталгаажуулалт амжилттай болсон төлөв.'**
  String get internalProfileRoutePhoneVerifiedDescription;

  /// No description provided for @internalProfileRouteReviewUpdatesTitle.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчлэл шалгах'**
  String get internalProfileRouteReviewUpdatesTitle;

  /// No description provided for @internalProfileRouteReviewUpdatesDescription.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчилсэн холбоо барих мэдээллээ шалгана.'**
  String get internalProfileRouteReviewUpdatesDescription;

  /// No description provided for @internalProfileRouteConfirmChangesTitle.
  ///
  /// In mn, this message translates to:
  /// **'Өөрчлөлт батлах'**
  String get internalProfileRouteConfirmChangesTitle;

  /// No description provided for @internalProfileRouteConfirmChangesDescription.
  ///
  /// In mn, this message translates to:
  /// **'Хадгалахаас өмнө холбоо барих мэдээллийн өөрчлөлтөө батална.'**
  String get internalProfileRouteConfirmChangesDescription;

  /// No description provided for @internalProfileRouteUpdateCompleteTitle.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчлэл дууссан'**
  String get internalProfileRouteUpdateCompleteTitle;

  /// No description provided for @internalProfileRouteUpdateCompleteDescription.
  ///
  /// In mn, this message translates to:
  /// **'Холбоо барих мэдээлэл шинэчилж дууссан төлөв.'**
  String get internalProfileRouteUpdateCompleteDescription;

  /// No description provided for @internalProfileProcessing.
  ///
  /// In mn, this message translates to:
  /// **'Боловсруулж байна...'**
  String get internalProfileProcessing;

  /// No description provided for @internalProfileFlowProgressTitle.
  ///
  /// In mn, this message translates to:
  /// **'Progress'**
  String get internalProfileFlowProgressTitle;

  /// Холбоо барих мэдээлэл шинэчлэх алхам
  ///
  /// In mn, this message translates to:
  /// **'{total} алхмын {step}-р алхам'**
  String internalProfileFlowProgressStep(Object step, Object total);

  /// No description provided for @internalProfileSectionDetailsTitle.
  ///
  /// In mn, this message translates to:
  /// **'Профайлын мэдээлэл'**
  String get internalProfileSectionDetailsTitle;

  /// No description provided for @internalProfileFieldFullName.
  ///
  /// In mn, this message translates to:
  /// **'Овог нэр'**
  String get internalProfileFieldFullName;

  /// No description provided for @internalProfileFieldCurrentEmail.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн и-мэйл'**
  String get internalProfileFieldCurrentEmail;

  /// No description provided for @internalProfileFieldCurrentPhone.
  ///
  /// In mn, this message translates to:
  /// **'Одоогийн утас'**
  String get internalProfileFieldCurrentPhone;

  /// No description provided for @internalProfileFieldSdkVersion.
  ///
  /// In mn, this message translates to:
  /// **'SDK хувилбар'**
  String get internalProfileFieldSdkVersion;

  /// No description provided for @internalProfileFieldNewEmail.
  ///
  /// In mn, this message translates to:
  /// **'Шинэ и-мэйл'**
  String get internalProfileFieldNewEmail;

  /// No description provided for @internalProfileFieldNewPhone.
  ///
  /// In mn, this message translates to:
  /// **'Шинэ утасны дугаар'**
  String get internalProfileFieldNewPhone;

  /// No description provided for @internalProfileFieldUpdatedEmail.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчилсэн и-мэйл'**
  String get internalProfileFieldUpdatedEmail;

  /// No description provided for @internalProfileFieldUpdatedPhone.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчилсэн утас'**
  String get internalProfileFieldUpdatedPhone;

  /// No description provided for @internalProfileFieldUpdatedBy.
  ///
  /// In mn, this message translates to:
  /// **'Шинэчилсэн хэрэглэгч'**
  String get internalProfileFieldUpdatedBy;

  /// No description provided for @internalProfileContactEntryHint.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулалт хүсэхээс өмнө оруулсан утга зөв эсэхийг нягтална уу.'**
  String get internalProfileContactEntryHint;

  /// No description provided for @internalProfileVerificationInstructions.
  ///
  /// In mn, this message translates to:
  /// **'Хамгийн сүүлд ашигласан холбоо барих сувгаар ирсэн 6 оронтой кодоо оруулна уу.'**
  String get internalProfileVerificationInstructions;

  /// No description provided for @internalProfileVerificationCodeLabel.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулах код'**
  String get internalProfileVerificationCodeLabel;

  /// No description provided for @internalProfileInvalidVerificationCode.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулах код буруу байна.'**
  String get internalProfileInvalidVerificationCode;

  /// No description provided for @internalProfileVerificationSuccess.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулалт амжилттай дууслаа.'**
  String get internalProfileVerificationSuccess;

  /// No description provided for @internalProfileUpdateSuccess.
  ///
  /// In mn, this message translates to:
  /// **'Холбоо барих мэдээлэл амжилттай шинэчлэгдлээ.'**
  String get internalProfileUpdateSuccess;

  /// No description provided for @internalAuthCatalogTitle.
  ///
  /// In mn, this message translates to:
  /// **'Нэвтрэх дэлгэцүүд'**
  String get internalAuthCatalogTitle;

  /// No description provided for @internalAuthModuleName.
  ///
  /// In mn, this message translates to:
  /// **'Нэвтрэх'**
  String get internalAuthModuleName;

  /// No description provided for @internalAuthRouteRegistrationTitle.
  ///
  /// In mn, this message translates to:
  /// **'Бүртгэл үүсгэх'**
  String get internalAuthRouteRegistrationTitle;

  /// No description provided for @internalAuthRouteRegistrationDescription.
  ///
  /// In mn, this message translates to:
  /// **'Auth дизайны жишээнээс хөрвүүлсэн бүртгэл'**
  String get internalAuthRouteRegistrationDescription;

  /// No description provided for @internalAuthRouteRegistrationConfirmationTitle.
  ///
  /// In mn, this message translates to:
  /// **'Бүртгэл батлах'**
  String get internalAuthRouteRegistrationConfirmationTitle;

  /// No description provided for @internalAuthRouteRegistrationConfirmationDescription.
  ///
  /// In mn, this message translates to:
  /// **'Нөхцөлөө шалгаж, данс нээх тохиргоогоо дуусгана.'**
  String get internalAuthRouteRegistrationConfirmationDescription;

  /// No description provided for @internalAuthContinueRegistration.
  ///
  /// In mn, this message translates to:
  /// **'Бүртгэл үргэлжлүүлэх'**
  String get internalAuthContinueRegistration;

  /// No description provided for @internalAuthSectionPersonalInformation.
  ///
  /// In mn, this message translates to:
  /// **'Хувийн мэдээлэл'**
  String get internalAuthSectionPersonalInformation;

  /// No description provided for @internalAuthFieldFullName.
  ///
  /// In mn, this message translates to:
  /// **'Овог нэр'**
  String get internalAuthFieldFullName;

  /// No description provided for @internalAuthFieldEmail.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйл хаяг'**
  String get internalAuthFieldEmail;

  /// No description provided for @internalAuthFieldPhone.
  ///
  /// In mn, this message translates to:
  /// **'Утасны дугаар'**
  String get internalAuthFieldPhone;

  /// No description provided for @internalAuthFinishRegistration.
  ///
  /// In mn, this message translates to:
  /// **'Бүртгэл дуусгах'**
  String get internalAuthFinishRegistration;

  /// No description provided for @internalAuthSectionVerification.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулалт'**
  String get internalAuthSectionVerification;

  /// No description provided for @internalAuthIdentityCheck.
  ///
  /// In mn, this message translates to:
  /// **'Иргэний баталгаажуулалт'**
  String get internalAuthIdentityCheck;

  /// No description provided for @internalAuthPendingReview.
  ///
  /// In mn, this message translates to:
  /// **'Шалгаж байна'**
  String get internalAuthPendingReview;

  /// No description provided for @internalAuthEmailVerification.
  ///
  /// In mn, this message translates to:
  /// **'И-мэйл баталгаажуулалт'**
  String get internalAuthEmailVerification;

  /// No description provided for @internalAuthPhoneVerification.
  ///
  /// In mn, this message translates to:
  /// **'Утас баталгаажуулалт'**
  String get internalAuthPhoneVerification;

  /// No description provided for @internalAuthVerified.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажсан'**
  String get internalAuthVerified;

  /// No description provided for @internalAuthSectionConsent.
  ///
  /// In mn, this message translates to:
  /// **'Зөвшөөрөл'**
  String get internalAuthSectionConsent;

  /// No description provided for @internalAuthConsentBody.
  ///
  /// In mn, this message translates to:
  /// **'Үйлчилгээний нөхцөл болон нууцлалын бодлогыг зөвшөөрч байна.'**
  String get internalAuthConsentBody;

  /// No description provided for @internalStatesCatalogTitle.
  ///
  /// In mn, this message translates to:
  /// **'Төлвийн дэлгэцүүд'**
  String get internalStatesCatalogTitle;

  /// No description provided for @internalStatesModuleName.
  ///
  /// In mn, this message translates to:
  /// **'Төлвүүд'**
  String get internalStatesModuleName;

  /// No description provided for @internalStatesRouteSplashTitle.
  ///
  /// In mn, this message translates to:
  /// **'Splash'**
  String get internalStatesRouteSplashTitle;

  /// No description provided for @internalStatesRouteSplashDescription.
  ///
  /// In mn, this message translates to:
  /// **'Брэнд нэвтрэх анхны splash төлөв.'**
  String get internalStatesRouteSplashDescription;

  /// No description provided for @internalStatesRouteSplashAlternateTitle.
  ///
  /// In mn, this message translates to:
  /// **'Splash хувилбар'**
  String get internalStatesRouteSplashAlternateTitle;

  /// No description provided for @internalStatesRouteSplashAlternateDescription.
  ///
  /// In mn, this message translates to:
  /// **'Splash дэлгэцийн хоёрдогч хувилбар.'**
  String get internalStatesRouteSplashAlternateDescription;

  /// No description provided for @internalStatesRouteLoadingTitle.
  ///
  /// In mn, this message translates to:
  /// **'Ачаалалтын дэлгэц'**
  String get internalStatesRouteLoadingTitle;

  /// No description provided for @internalStatesRouteLoadingDescription.
  ///
  /// In mn, this message translates to:
  /// **'Нөхцөлт тайлбартай ачаалалтын төлөв.'**
  String get internalStatesRouteLoadingDescription;

  /// No description provided for @internalStatesRouteKycOverlayTitle.
  ///
  /// In mn, this message translates to:
  /// **'KYC overlay'**
  String get internalStatesRouteKycOverlayTitle;

  /// No description provided for @internalStatesRouteKycOverlayDescription.
  ///
  /// In mn, this message translates to:
  /// **'KYC шаардлагатай үед харуулах дараагийн алхмын дэлгэц.'**
  String get internalStatesRouteKycOverlayDescription;

  /// No description provided for @internalStatesSplashHeroPrimaryTitle.
  ///
  /// In mn, this message translates to:
  /// **''**
  String get internalStatesSplashHeroPrimaryTitle;

  /// No description provided for @internalStatesSplashHeroPrimarySubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны ажлын орчныг бэлдэж байна...'**
  String get internalStatesSplashHeroPrimarySubtitle;

  /// No description provided for @internalStatesSplashHeroAlternateTitle.
  ///
  /// In mn, this message translates to:
  /// **' Finance'**
  String get internalStatesSplashHeroAlternateTitle;

  /// No description provided for @internalStatesSplashHeroAlternateSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Танд зориулсан самбарыг ачаалж байна...'**
  String get internalStatesSplashHeroAlternateSubtitle;

  /// No description provided for @internalStatesLoadingMessage.
  ///
  /// In mn, this message translates to:
  /// **'Дансны мэдээллийг татаж байна...'**
  String get internalStatesLoadingMessage;

  /// No description provided for @internalStatesLoadingHint.
  ///
  /// In mn, this message translates to:
  /// **'Энэ дэлгэцийг бэлдэх хүртэл түр хүлээнэ үү.'**
  String get internalStatesLoadingHint;

  /// No description provided for @internalStatesKycDefaultStatusMessage.
  ///
  /// In mn, this message translates to:
  /// **'Бүх wallet боломжийг ашиглахын тулд баталгаажуулалтаа дуусгана уу.'**
  String get internalStatesKycDefaultStatusMessage;

  /// No description provided for @internalStatesKycSuccessTitle.
  ///
  /// In mn, this message translates to:
  /// **'Иргэний баталгаажуулалт амжилттай'**
  String get internalStatesKycSuccessTitle;

  /// No description provided for @internalStatesKycSuccessSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны профайл баталгаажсан тул бүх боломжийг ашиглах боломжтой боллоо.'**
  String get internalStatesKycSuccessSubtitle;

  /// No description provided for @internalStatesKycRequiredTitle.
  ///
  /// In mn, this message translates to:
  /// **'KYC шаардлагатай'**
  String get internalStatesKycRequiredTitle;

  /// No description provided for @internalStatesKycRequiredSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Үргэлжлүүлэхийн өмнө профайлын баталгаажуулалт шаардлагатай.'**
  String get internalStatesKycRequiredSubtitle;

  /// No description provided for @internalStatesKycStartVerification.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулалт эхлүүлэх'**
  String get internalStatesKycStartVerification;

  /// No description provided for @internalStatesKycLater.
  ///
  /// In mn, this message translates to:
  /// **'Дараа'**
  String get internalStatesKycLater;

  /// No description provided for @internalStatesKycScanningId.
  ///
  /// In mn, this message translates to:
  /// **'Бичиг баримт шалгаж байна...'**
  String get internalStatesKycScanningId;

  /// No description provided for @internalStatesKycVerifying.
  ///
  /// In mn, this message translates to:
  /// **'Баталгаажуулж байна...'**
  String get internalStatesKycVerifying;

  /// No description provided for @internalStatesKycCapturingBiometric.
  ///
  /// In mn, this message translates to:
  /// **'Биометрийн мэдээлэл авч байна...'**
  String get internalStatesKycCapturingBiometric;

  /// No description provided for @internalStatesKycFailureFaceMatch.
  ///
  /// In mn, this message translates to:
  /// **'Нүүр тулгалт амжилтгүй боллоо.Гэрэл сайтай орчинд дахин оролдоно уу.'**
  String get internalStatesKycFailureFaceMatch;

  /// No description provided for @reject.
  ///
  /// In mn, this message translates to:
  /// **'Татгалзах'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In mn, this message translates to:
  /// **'Зөвшөөрч байна'**
  String get accept;

  /// No description provided for @tinoConsent.
  ///
  /// In mn, this message translates to:
  /// **'Таны Tino апп дээрх бүртгэлтэй байгаа мэдээллийг ашиглахыг зөвшөөрч байна уу'**
  String get tinoConsent;

  /// No description provided for @commonSuccess.
  ///
  /// In mn, this message translates to:
  /// **'Амжилттай'**
  String get commonSuccess;

  /// No description provided for @commonWarning.
  ///
  /// In mn, this message translates to:
  /// **'Анхаарах'**
  String get commonWarning;

  /// No description provided for @commonPay.
  ///
  /// In mn, this message translates to:
  /// **'Төлбөр төлөх'**
  String get commonPay;

  /// No description provided for @commonGoHome.
  ///
  /// In mn, this message translates to:
  /// **'Нүүр хуудас руу очих'**
  String get commonGoHome;

  /// No description provided for @commonHome.
  ///
  /// In mn, this message translates to:
  /// **'Нүүр'**
  String get commonHome;

  /// No description provided for @commonProfile.
  ///
  /// In mn, this message translates to:
  /// **'Миний'**
  String get commonProfile;

  /// No description provided for @commonBank.
  ///
  /// In mn, this message translates to:
  /// **'Банк'**
  String get commonBank;

  /// No description provided for @commonIban.
  ///
  /// In mn, this message translates to:
  /// **'IBAN дугаар'**
  String get commonIban;

  /// No description provided for @commonAccountNumber.
  ///
  /// In mn, this message translates to:
  /// **'Дансны дугаар'**
  String get commonAccountNumber;

  /// No description provided for @commonPackUnit.
  ///
  /// In mn, this message translates to:
  /// **'PACK'**
  String get commonPackUnit;

  /// No description provided for @commonBrandInvestx.
  ///
  /// In mn, this message translates to:
  /// **'investX'**
  String get commonBrandInvestx;

  /// No description provided for @commonDrawSignaturePrompt.
  ///
  /// In mn, this message translates to:
  /// **'Та гарын үсгээ зурж баталгаажуулна уу'**
  String get commonDrawSignaturePrompt;

  /// No description provided for @commonSignaturePlaceholder.
  ///
  /// In mn, this message translates to:
  /// **'Энд гарын үсгээ зурна уу'**
  String get commonSignaturePlaceholder;

  /// No description provided for @commonTotalPayable.
  ///
  /// In mn, this message translates to:
  /// **'Нийт төлөх дүн'**
  String get commonTotalPayable;

  /// Багцын тоо хэмжээг харуулах шошго.
  ///
  /// In mn, this message translates to:
  /// **'{count} PACK'**
  String commonPackQuantity(Object count);

  /// No description provided for @secAcntPersonalInformationSubtitle.
  ///
  /// In mn, this message translates to:
  /// **'Та өөрийн хувийн мэдээллээ оруулна уу.'**
  String get secAcntPersonalInformationSubtitle;

  /// No description provided for @secAcntFieldSecondaryPhone.
  ///
  /// In mn, this message translates to:
  /// **'Нэмэлт утасны дугаар'**
  String get secAcntFieldSecondaryPhone;

  /// No description provided for @secAcntBankSelectionTitle.
  ///
  /// In mn, this message translates to:
  /// **'Банк сонгох'**
  String get secAcntBankSelectionTitle;

  /// No description provided for @secAcntPaymentSheetTitle.
  ///
  /// In mn, this message translates to:
  /// **'Tino Pay'**
  String get secAcntPaymentSheetTitle;

  /// No description provided for @secAcntPaymentOptionTinoBalance.
  ///
  /// In mn, this message translates to:
  /// **'Tino харилцах үлдэгдэл'**
  String get secAcntPaymentOptionTinoBalance;

  /// No description provided for @secAcntPaymentOptionTinoPayLater.
  ///
  /// In mn, this message translates to:
  /// **'Tino Pay Later эрх'**
  String get secAcntPaymentOptionTinoPayLater;

  /// No description provided for @secAcntSuccessBankDetailsTitle.
  ///
  /// In mn, this message translates to:
  /// **'Банкны мэдээлэл'**
  String get secAcntSuccessBankDetailsTitle;

  /// No description provided for @secAcntAgreementConsent.
  ///
  /// In mn, this message translates to:
  /// **'Би ҮЦ-ын данс нээх гэрээ болон үйлчилгээний нөхцөлтэй танилцаж, зөвшөөрч байна.'**
  String get secAcntAgreementConsent;

  /// No description provided for @secAcntServiceFeeTitle.
  ///
  /// In mn, this message translates to:
  /// **'Үйлчилгээний хураамж'**
  String get secAcntServiceFeeTitle;

  /// No description provided for @secAcntPaymentTitle.
  ///
  /// In mn, this message translates to:
  /// **'Үнэт цаасны данс нээх хураамж'**
  String get secAcntPaymentTitle;

  /// No description provided for @secAcntPaymentTitleWithAmount.
  ///
  /// In mn, this message translates to:
  /// **'Үнэт цаасны данс нээх хураамж {amount}'**
  String secAcntPaymentTitleWithAmount(Object amount);

  /// No description provided for @secAcntPaymentNoticeMessage.
  ///
  /// In mn, this message translates to:
  /// **'Энэхүү данс нээгдсэнээр та дотоод болон гадаад зах зээлийн хөрөнгө оруулалт хийх боломжтой болно.'**
  String get secAcntPaymentNoticeMessage;

  /// No description provided for @secAcntPaymentAmountUnavailable.
  ///
  /// In mn, this message translates to:
  /// **'Төлөх дүнг одоогоор авч чадсангүй. Дансны мэдээллээ шинэчлээд дахин оролдоно уу.'**
  String get secAcntPaymentAmountUnavailable;

  /// No description provided for @secAcntPaymentFailedTitle.
  ///
  /// In mn, this message translates to:
  /// **'Төлбөр амжилтгүй'**
  String get secAcntPaymentFailedTitle;

  /// No description provided for @secAcntCalculationTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны төлбөр амжилттай төлөгдлөө'**
  String get secAcntCalculationTitle;

  /// No description provided for @secAcntCalculationMessageTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны бүртгэлийн хүсэлт амжилттай үүслээ'**
  String get secAcntCalculationMessageTitle;

  /// No description provided for @secAcntCalculationPendingMessage.
  ///
  /// In mn, this message translates to:
  /// **'Таны бүртгэлийн хүсэлт шалгагдаж байна. Баталгаажмагц танд мэдэгдэх болно.'**
  String get secAcntCalculationPendingMessage;

  /// No description provided for @secAcntPendingActivationMessage.
  ///
  /// In mn, this message translates to:
  /// **'Таны үнэт цаасны бүртгэлийн хүсэлтийг хүлээн авлаа.\nХүсэлтийг хянаж баталгаажуулсны дараа танд мэдэгдэх болно.'**
  String get secAcntPendingActivationMessage;

  /// No description provided for @secAcntBankNotSelected.
  ///
  /// In mn, this message translates to:
  /// **'Банк сонгоогүй'**
  String get secAcntBankNotSelected;

  /// No description provided for @secAcntProfileUpdating.
  ///
  /// In mn, this message translates to:
  /// **'Хувийн мэдээллийг хадгалж байна.'**
  String get secAcntProfileUpdating;

  /// No description provided for @secAcntInvestxAgreementTitle.
  ///
  /// In mn, this message translates to:
  /// **'INVESTX үйлчилгээний гэрээ'**
  String get secAcntInvestxAgreementTitle;

  /// No description provided for @secAcntSecuritiesAgreementTitle.
  ///
  /// In mn, this message translates to:
  /// **'Үнэт цаасны данс нээх гэрээ'**
  String get secAcntSecuritiesAgreementTitle;

  /// No description provided for @secAcntInvestxAgreementText.
  ///
  /// In mn, this message translates to:
  /// **'1. Энэхүү INVESTX үйлчилгээний гэрээ нь хөрөнгө оруулалтын үйлчилгээг эхлүүлэх, хэрэглэгчийн мэдээллийг баталгаажуулах, дансны ашиглалттай холбоотой үндсэн нөхцөлийг тодорхойлно.\n\n2. Хэрэглэгч нь оруулсан мэдээлэл үнэн зөв болохыг баталгаажуулж, үйлчилгээтэй холбоотой мэдэгдлийг апп дотор болон бүртгэлтэй сувгаар хүлээн авна.\n\n3. INVESTX үйлчилгээний дараагийн шатуудад эрсдэлийн асуумж, багцын сонголт, худалдан авалтын үйлдэл дарааллаар идэвхжинэ.'**
  String get secAcntInvestxAgreementText;

  /// No description provided for @secAcntSecuritiesAgreementText.
  ///
  /// In mn, this message translates to:
  /// **'1. Үнэт цаасны данс нээх хүсэлт гаргах үед хэрэглэгчийн овог, нэр, регистр, холбоо барих мэдээлэл болон банкны мэдээллийг баталгаажуулна.\n\n2. Данс нээхтэй холбоотой шимтгэл, баталгаажуулалтын хугацаа болон үйлчилгээний нөхцөлийг хэрэглэгч урьдчилан зөвшөөрсөн байна.\n\n3. Баталгаажуулалтын явц амжилттай дууссаны дараа дараагийн шатны INVESTX үйлчилгээний гэрээ болон эрсдэлийн асуумж нээгдэнэ.'**
  String get secAcntSecuritiesAgreementText;

  /// No description provided for @secAcntTermsText.
  ///
  /// In mn, this message translates to:
  /// **'1. Энэхүү үйлчилгээний нөхцөл нь хэрэглэгчийн хөрөнгө оруулалтын дансны бүртгэл, ашиглалт, мэдээллийн аюулгүй байдалтай холбоотой нийтлэг журмыг тодорхойлно.\n\n2. Апп дотор илгээсэн хүсэлт, гарын үсэг, зөвшөөрөл болон төлбөрийн баталгаажуулалтыг системийн хүчинтэй үйлдэл гэж үзнэ.\n\n3. Бүртгэлийн хүсэлт шалгагдаж байх хугацаанд зарим үйлдэл хязгаарлагдаж болох ба шалгалт амжилттай дуусмагц хэрэглэгчид мэдэгдэнэ.\n\n4. Хэрэглэгч үйлчилгээний явцад шинэчилсэн нөхцөл гарсан тохиолдолд мэдэгдлийг хүлээн авч танилцан, шаардлагатай тохиолдолд дахин зөвшөөрөл өгнө.'**
  String get secAcntTermsText;

  /// No description provided for @ipsPackBenefitStableYield.
  ///
  /// In mn, this message translates to:
  /// **'Тогтвортой өгөөжийг зорьдог'**
  String get ipsPackBenefitStableYield;

  /// No description provided for @ipsPackBenefitLowVolatility.
  ///
  /// In mn, this message translates to:
  /// **'Хэлбэлзэл бага'**
  String get ipsPackBenefitLowVolatility;

  /// No description provided for @ipsPackBenefitMinRisk.
  ///
  /// In mn, this message translates to:
  /// **'Эрсдэл хамгийн бага'**
  String get ipsPackBenefitMinRisk;

  /// No description provided for @ipsPackBenefitStockGrowth.
  ///
  /// In mn, this message translates to:
  /// **'Өсөлтийн боломжтой хувьцааны жинтэй'**
  String get ipsPackBenefitStockGrowth;

  /// No description provided for @ipsPackBenefitBalancedStructure.
  ///
  /// In mn, this message translates to:
  /// **'Тэнцвэртэй бүтэцтэй багц'**
  String get ipsPackBenefitBalancedStructure;

  /// No description provided for @ipsPackBenefitGrowthFocused.
  ///
  /// In mn, this message translates to:
  /// **'Илүү өсөлт чиглэсэн бүтэцтэй'**
  String get ipsPackBenefitGrowthFocused;

  /// No description provided for @ipsOverviewPackPrompt.
  ///
  /// In mn, this message translates to:
  /// **'Та өөрт тохирсон багцаа сонгоно уу'**
  String get ipsOverviewPackPrompt;

  /// No description provided for @ipsPackPerfectFit.
  ///
  /// In mn, this message translates to:
  /// **'Танд төгс тохирох'**
  String get ipsPackPerfectFit;

  /// No description provided for @advice.
  ///
  /// In mn, this message translates to:
  /// **'Зөвлөмж'**
  String get advice;

  /// No description provided for @investmentFund.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалтын сан'**
  String get investmentFund;

  /// No description provided for @ipsHelpTitle.
  ///
  /// In mn, this message translates to:
  /// **'Тусламж'**
  String get ipsHelpTitle;

  /// No description provided for @ipsHelpContactTitle.
  ///
  /// In mn, this message translates to:
  /// **'Холбоо барих'**
  String get ipsHelpContactTitle;

  /// No description provided for @ipsHelpEmail.
  ///
  /// In mn, this message translates to:
  /// **'И-Мэйл'**
  String get ipsHelpEmail;

  /// No description provided for @ipsHelpPhone.
  ///
  /// In mn, this message translates to:
  /// **'Дугаар'**
  String get ipsHelpPhone;

  /// No description provided for @ipsHelpLocationTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хаяг байршил'**
  String get ipsHelpLocationTitle;

  /// No description provided for @ipsHelpLocationWorkingHours.
  ///
  /// In mn, this message translates to:
  /// **'Даваа - Баасан 09:00 - 18:00'**
  String get ipsHelpLocationWorkingHours;

  /// No description provided for @ipsFeedbackTitle.
  ///
  /// In mn, this message translates to:
  /// **'Санал хүсэлт'**
  String get ipsFeedbackTitle;

  /// No description provided for @ipsFeedbackEmptyTitle.
  ///
  /// In mn, this message translates to:
  /// **'Одоогоор та санал гомдол өгөөгүй байна'**
  String get ipsFeedbackEmptyTitle;

  /// No description provided for @ipsFeedbackEmptyBody.
  ///
  /// In mn, this message translates to:
  /// **'Та санал гомдол өгөх товч дээр дарж санал гомдлоо өгнө үү'**
  String get ipsFeedbackEmptyBody;

  /// No description provided for @ipsFeedbackCreateButton.
  ///
  /// In mn, this message translates to:
  /// **'Санал гомдол өгөх'**
  String get ipsFeedbackCreateButton;

  /// No description provided for @ipsFeedbackCreateTitle.
  ///
  /// In mn, this message translates to:
  /// **'Гарчиг'**
  String get ipsFeedbackCreateTitle;

  /// No description provided for @ipsFeedbackCreateTitleHint.
  ///
  /// In mn, this message translates to:
  /// **'Утга оруулна уу'**
  String get ipsFeedbackCreateTitleHint;

  /// No description provided for @ipsFeedbackCreateBody.
  ///
  /// In mn, this message translates to:
  /// **'Тайлбар'**
  String get ipsFeedbackCreateBody;

  /// No description provided for @ipsFeedbackCreateBodyHint.
  ///
  /// In mn, this message translates to:
  /// **'Дэлгэрэнгүй тайлбар оруулна уу'**
  String get ipsFeedbackCreateBodyHint;

  /// No description provided for @ipsFeedbackStatusReviewing.
  ///
  /// In mn, this message translates to:
  /// **'Илгээгдсэн'**
  String get ipsFeedbackStatusReviewing;

  /// No description provided for @ipsFeedbackStatusResolved.
  ///
  /// In mn, this message translates to:
  /// **'Шийдвэрлэсэн'**
  String get ipsFeedbackStatusResolved;

  /// No description provided for @ipsFeedbackStatusClosed.
  ///
  /// In mn, this message translates to:
  /// **'Хаагдсан'**
  String get ipsFeedbackStatusClosed;

  /// No description provided for @ipsRewardTitle.
  ///
  /// In mn, this message translates to:
  /// **'Таны амжилт'**
  String get ipsRewardTitle;

  /// No description provided for @ipsRewardGoalTitle.
  ///
  /// In mn, this message translates to:
  /// **'Зорилтот зорилго'**
  String get ipsRewardGoalTitle;

  /// No description provided for @ipsRewardGoalProgress.
  ///
  /// In mn, this message translates to:
  /// **'Биелүүлэлт'**
  String get ipsRewardGoalProgress;

  /// No description provided for @ipsRewardStreakTitle.
  ///
  /// In mn, this message translates to:
  /// **'Тасралтгүй хөрөнгө оруулалт'**
  String get ipsRewardStreakTitle;

  /// No description provided for @ipsRewardStreakMonths.
  ///
  /// In mn, this message translates to:
  /// **'{current} / {total} сар'**
  String ipsRewardStreakMonths(int current, int total);

  /// No description provided for @ipsRewardStreakNextRewardLabel.
  ///
  /// In mn, this message translates to:
  /// **'Дараагийн урамшуулал:'**
  String get ipsRewardStreakNextRewardLabel;

  /// No description provided for @ipsRewardStreakNextReward.
  ///
  /// In mn, this message translates to:
  /// **'Дараагийн урамшуулал: +{reward}'**
  String ipsRewardStreakNextReward(Object reward);

  /// No description provided for @ipsRewardNextGoalTitle.
  ///
  /// In mn, this message translates to:
  /// **'Дараагийн зорилго'**
  String get ipsRewardNextGoalTitle;

  /// No description provided for @ipsRewardNextGoalBody.
  ///
  /// In mn, this message translates to:
  /// **'6 сар хүрэхэд таны хүү 2% нэмэгдэж, VIP боломжууд нээгдэнэ'**
  String get ipsRewardNextGoalBody;

  /// No description provided for @ipsRewardBonusCupon.
  ///
  /// In mn, this message translates to:
  /// **'Купон'**
  String get ipsRewardBonusCupon;

  /// No description provided for @ipsRewardBonusInterest.
  ///
  /// In mn, this message translates to:
  /// **'Хүү'**
  String get ipsRewardBonusInterest;

  /// No description provided for @ipsRewardMilestoneMonths.
  ///
  /// In mn, this message translates to:
  /// **'{count} Сар'**
  String ipsRewardMilestoneMonths(int count);

  /// No description provided for @ipsStatementFilterTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хуулга шүүх'**
  String get ipsStatementFilterTitle;

  /// No description provided for @ipsStatementFilterAmountTitle.
  ///
  /// In mn, this message translates to:
  /// **'Хуулганы унийн дүн'**
  String get ipsStatementFilterAmountTitle;

  /// No description provided for @ipsStatementFilterDateTitle.
  ///
  /// In mn, this message translates to:
  /// **'Огноо'**
  String get ipsStatementFilterDateTitle;

  /// No description provided for @ipsStatementFilterToday.
  ///
  /// In mn, this message translates to:
  /// **'Өчигдөр'**
  String get ipsStatementFilterToday;

  /// No description provided for @ipsStatementFilterWeek.
  ///
  /// In mn, this message translates to:
  /// **'7 хоног'**
  String get ipsStatementFilterWeek;

  /// No description provided for @ipsStatementFilterMonth.
  ///
  /// In mn, this message translates to:
  /// **'1 сар'**
  String get ipsStatementFilterMonth;

  /// No description provided for @ipsStatementFilter3Months.
  ///
  /// In mn, this message translates to:
  /// **'3 сар'**
  String get ipsStatementFilter3Months;

  /// No description provided for @ipsStatementFilterClear.
  ///
  /// In mn, this message translates to:
  /// **'Цэвэрлэх'**
  String get ipsStatementFilterClear;

  /// No description provided for @ipsStatementFilterSearch.
  ///
  /// In mn, this message translates to:
  /// **'Хайх ({count})'**
  String ipsStatementFilterSearch(int count);

  /// No description provided for @ipsStatementTypeIncome.
  ///
  /// In mn, this message translates to:
  /// **'Орлого'**
  String get ipsStatementTypeIncome;

  /// No description provided for @ipsStatementTypeExpense.
  ///
  /// In mn, this message translates to:
  /// **'Зарлага'**
  String get ipsStatementTypeExpense;

  /// No description provided for @ipsStatementInvestment.
  ///
  /// In mn, this message translates to:
  /// **'Хөрөнгө оруулалт'**
  String get ipsStatementInvestment;

  /// No description provided for @commonSave.
  ///
  /// In mn, this message translates to:
  /// **'Хадгалах'**
  String get commonSave;

  /// No description provided for @commonSearch.
  ///
  /// In mn, this message translates to:
  /// **'Хайх'**
  String get commonSearch;

  /// No description provided for @commonAll.
  ///
  /// In mn, this message translates to:
  /// **'Бүгд'**
  String get commonAll;

  /// No description provided for @ipsPortfolioFilterAll.
  ///
  /// In mn, this message translates to:
  /// **'Бүгд'**
  String get ipsPortfolioFilterAll;

  /// No description provided for @ipsPortfolioFilterBonds.
  ///
  /// In mn, this message translates to:
  /// **'Бонд'**
  String get ipsPortfolioFilterBonds;

  /// No description provided for @ipsPortfolioFilterStocks.
  ///
  /// In mn, this message translates to:
  /// **'Хувьцаа'**
  String get ipsPortfolioFilterStocks;

  /// No description provided for @closedPrice.
  ///
  /// In mn, this message translates to:
  /// **'Хаалтын ханш'**
  String get closedPrice;

  /// No description provided for @closedDate.
  ///
  /// In mn, this message translates to:
  /// **'Огноо'**
  String get closedDate;

  /// No description provided for @ipsAcntServiceAgreement.
  ///
  /// In mn, this message translates to:
  /// **'INVESTX үйлчилгээний гэрээ'**
  String get ipsAcntServiceAgreement;

  /// No description provided for @ipsQuestionnaireProfileTitle.
  ///
  /// In mn, this message translates to:
  /// **'Зан төлөв тодорхойлох'**
  String get ipsQuestionnaireProfileTitle;
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
      <String>['mn'].contains(locale.languageCode);

  @override
  bool shouldReload(_SdkLocalizationsDelegate old) => false;
}

SdkLocalizations lookupSdkLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
