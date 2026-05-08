// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'sdk_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SdkLocalizationsEn extends SdkLocalizations {
  SdkLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonPrevious => 'Previous';

  @override
  String get commonDone => 'Done';

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonSelect => 'Select';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonViewDetails => 'View details';

  @override
  String get commonAmount => 'Amount';

  @override
  String get commonCurrency => 'Currency';

  @override
  String get commonStatus => 'Status';

  @override
  String get commonMessage => 'Message';

  @override
  String get commonNoData => 'No data available';

  @override
  String get commonRequired => 'Required';

  @override
  String get errorsGenericTitle => 'Something went wrong';

  @override
  String get errorsServiceUnavailable => 'Service is currently unavailable.';

  @override
  String get errorsUnexpected => 'An unexpected error occurred.';

  @override
  String get errorsNetwork => 'Network connection failed. Please try again.';

  @override
  String get errorsSession =>
      'Your session is invalid. Please reopen the mini app.';

  @override
  String get errorsConfig =>
      'This mini app integration is not configured correctly.';

  @override
  String get errorsSessionExpired => 'Session is invalid or has expired.';

  @override
  String get errorsUnauthorized =>
      'You are not authorized to perform this action.';

  @override
  String get errorsApiLoadFailed => 'Failed to load data from the backend.';

  @override
  String get errorsActionFailed => 'The action could not be completed.';

  @override
  String get errorsMissingIntegration =>
      'Required host integration is missing.';

  @override
  String get errorsMissingContract =>
      'Exact backend contract is not available yet.';

  @override
  String get errorsUnknownRoute => 'The reqed flow route is not registered.';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationSelectionRequired => 'Please select a value.';

  @override
  String get validationInvalidEmail => 'Enter a valid email address.';

  @override
  String get validationInvalidPhone => 'Enter a valid phone number.';

  @override
  String get validationInvalidRegisterNo => 'Enter a valid register number.';

  @override
  String get validationInvalidIban => 'Enter a valid IBAN/account number.';

  @override
  String validationMinLength(int count) {
    return 'Enter at least $count characters.';
  }

  @override
  String validationMaxLength(int count) {
    return 'Enter no more than $count characters.';
  }

  @override
  String get validationMinQuantity => 'Quantity must be at least 1.';

  @override
  String get validationInvalidAmount => 'Enter a valid amount.';

  @override
  String get validationMinAmount =>
      'Amount is below the minimum allowed value.';

  @override
  String get validationQuestionnaireIncomplete =>
      'Please answer all questions before continuing.';

  @override
  String get validationMissingPackSelection =>
      'Please choose a recommended pack first.';

  @override
  String get validationMissingSrcFiCode =>
      'A valid srcFiCode is required before retrieving recommended packs.';

  @override
  String get validationMissingOrderId => 'Order identifier is required.';

  @override
  String get validationMissingAcntReference => 'Acnt reference is required.';

  @override
  String get ipsHomeTitle => 'IPS Overview';

  @override
  String get ipsHomeSubtitle => 'Sec acnt bootstrap and IPS eligibility flow.';

  @override
  String get ipsHomeOverviewCardTitle => 'Current state';

  @override
  String get ipsHomeOpenAcntCta => 'Acnt flow';

  @override
  String get ipsHomeQuestionnaireCta => 'Questionnaire';

  @override
  String get ipsHomeRecommendedPackCta => 'Recommended packs';

  @override
  String get ipsHomePortfolioCta => 'Portfolio';

  @override
  String get ipsHomeOrdersCta => 'Orders';

  @override
  String get ipsHomeNextStepsTitle => 'Next steps';

  @override
  String get ipsHomeNextStepsSubtitle =>
      'Open the next IPS flow based on the current customer state.';

  @override
  String get ipsHomeSecAcntLabel => 'Sec acnt';

  @override
  String get ipsHomeIpsAcntLabel => 'IPS acnt';

  @override
  String get ipsHomeAcntStatusLabel => 'Acnt status';

  @override
  String get ipsHomeIpsBalanceLabel => 'IPS balance';

  @override
  String ipsHomeGreeting(Object displayName) {
    return 'Hello, $displayName';
  }

  @override
  String get ipsOverviewVerificationTitle => 'Verification';

  @override
  String get ipsOverviewVerificationSubtitle =>
      'Complete the steps below to unlock your first pack purchase.';

  @override
  String get ipsOverviewFinalStepLabel => 'Final step';

  @override
  String get ipsOverviewFirstPackTitle => 'Buy your first pack';

  @override
  String get ipsOverviewActionTitle => 'Trading';

  @override
  String get ipsOverviewProfileVerified => 'Verified';

  @override
  String get ipsOverviewProfileGuestName => 'InvestX user';

  @override
  String get ipsOverviewProfileMenuPersonalInfo => 'Personal information';

  @override
  String get ipsOverviewProfilePersonalInfoMissing => 'Information missing';

  @override
  String get ipsOverviewProfileMenuLaw => 'Legal';

  @override
  String get ipsOverviewProfileMenuPackInfo => 'Pack details';

  @override
  String get ipsOverviewProfileMenuAchievements => 'Your achievements';

  @override
  String get ipsOverviewProfileMenuTerms => 'Terms of service';

  @override
  String get ipsOverviewProfileMenuFeedback => 'Complaints and feedback';

  @override
  String get ipsOverviewProfileMenuContact => 'Contact us';

  @override
  String get ipsOverviewDashboardGreetingLabel => 'Greetings of the day';

  @override
  String ipsOverviewDashboardProfitMessage(Object amount) {
    return '$amount in return';
  }

  @override
  String get ipsOverviewDashboardQuickRecharge => 'Recharge pack';

  @override
  String get ipsOverviewDashboardQuickWithdraw => 'Withdraw money';

  @override
  String get ipsOverviewDashboardAllocationStocks => 'Stocks';

  @override
  String get ipsOverviewDashboardAllocationBonds => 'Bonds';

  @override
  String get ipsOverviewDashboardAllocationTotal => 'Total investment';

  @override
  String get ipsOverviewDashboardYieldLabel => 'Your return';

  @override
  String get ipsOverviewDashboardDetails => 'View details';

  @override
  String get ipsOverviewDashboardReminderTitle => 'Reminder';

  @override
  String get ipsOverviewDashboardReminderBody =>
      'If you keep recharging your account every month, your selected pack will continue funding automatically. Securities-account transfers may take 2 to 4 business days before trading is executed.';

  @override
  String get ipsOverviewDashboardGoalTitle => 'Target goal';

  @override
  String get ipsOverviewDashboardGoalProgress => 'Progress';

  @override
  String ipsOverviewDashboardRewardTitle(int count) {
    return 'Month $count in a row!';
  }

  @override
  String get ipsOverviewDashboardRewardBody =>
      'You have invested consistently, so you qualify for a 5000 Tino Coin reward.';

  @override
  String get ipsOverviewDashboardActionRecharge => 'Recharge pack';

  @override
  String get ipsOverviewDashboardActionSell => 'Close pack';

  @override
  String get ipsAcntTitle => 'Sec acnt';

  @override
  String get ipsAcntSubtitle => 'Intro, agreement, acnt req, and QR creation.';

  @override
  String get ipsAcntOpenAcnt => 'Open sec acnt';

  @override
  String get ipsAcntVerifyAcnt => 'Verify acnt';

  @override
  String get ipsAcntGenerateQr => 'Generate QR';

  @override
  String get ipsAcntQrValue => 'QR value';

  @override
  String get ipsAcntOpeningFee => 'Opening fee';

  @override
  String get ipsAcntMissingService => 'Sec acnt integration is not configured.';

  @override
  String get ipsAcntHasAcnt => 'Sec acnt available';

  @override
  String get ipsAcntNoAcnt => 'Sec acnt missing';

  @override
  String get ipsAcntBalance => 'Sec balance';

  @override
  String get ipsAcntFlowBody => 'Account opening flow';

  @override
  String get ipsAcntPendingQrMessage =>
      'Generate the QR to continue the sec-acnt opening flow.';

  @override
  String get ipsBootstrapMissingService =>
      'Bootstrap service is not configured.';

  @override
  String get ipsBootstrapLoading => 'Checking acnt bootstrap state.';

  @override
  String get ipsSplashTitle => 'InvestX Splash';

  @override
  String get ipsSplashSubtitle =>
      'Launch startup flow for the current user, login session, and IPS state.';

  @override
  String get ipsQuestionnaireTitle => 'Questionnaire';

  @override
  String get ipsQuestionnaireSubtitle =>
      'Question list retrieval and score calculation.';

  @override
  String get ipsQuestionnaireCalculateScore => 'Calculate score';

  @override
  String ipsQuestionnaireQuestionPrefix(Object index) {
    return 'Question $index';
  }

  @override
  String ipsQuestionnaireOptionPrefix(Object index) {
    return 'Option $index';
  }

  @override
  String get ipsQuestionnaireResTitle => 'Calculated res';

  @override
  String get ipsQuestionnaireCustomerCode => 'Customer code';

  @override
  String get ipsQuestionnaireViewPacks => 'View recommended packs';

  @override
  String get ipsQuestionnaireMissingService =>
      'Questionnaire service is not configured.';

  @override
  String get ipsQuestionnaireScore => 'Score';

  @override
  String get ipsQuestionnaireSummary => 'Summary';

  @override
  String get ipsQuestionnaireLoading => 'Loading questionnaire.';

  @override
  String get ipsQuestionnaireRecommendationTitle =>
      'Your trusted investment guide';

  @override
  String get ipsQuestionnaireRecommendationBody =>
      'Answer a few short questions and we will match you with the most suitable INVESTX pack.';

  @override
  String get ipsQuestionnaireCalculatingMessage =>
      'Preparing the most suitable pack recommendation for you.';

  @override
  String get ipsQuestionnaireStaticQuestionTitle => 'Investment amount';

  @override
  String get ipsQuestionnaireStaticOption100k => '100,000';

  @override
  String get ipsQuestionnaireStaticOption200k => '200,000';

  @override
  String get ipsQuestionnaireStaticOption500k => '500,000';

  @override
  String get ipsQuestionnaireStaticOption1000000Plus => '1,000,000+';

  @override
  String get ipsQuestionnaireTargetGoalMissing =>
      'Select your investment amount before continuing.';

  @override
  String get ipsSignatureUploading => 'Uploading your signature.';

  @override
  String get ipsPackTitle => 'Recommended packs';

  @override
  String get ipsPackSubtitle => 'Recommended IPS pack retrieval and selection.';

  @override
  String get ipsPackRecommendedBadge => 'Recommended';

  @override
  String get ipsPackChoosePack => 'Choose pack';

  @override
  String get ipsPackAllocation => 'Allocation';

  @override
  String get ipsPackBondPercent => 'Bond';

  @override
  String get ipsPackStockPercent => 'Stock';

  @override
  String get ipsPackAssetPercent => 'Asset';

  @override
  String get ipsPackNoPacks => 'No recommended packs were returned.';

  @override
  String get ipsPackMissingService => 'Pack service is not configured.';

  @override
  String get ipsPackSrcFiCodeRequired =>
      'Questionnaire res with srcFiCode is required for the official pack API.';

  @override
  String get ipsPackCode => 'Pack code';

  @override
  String get ipsPackSecondaryName => 'Secondary name';

  @override
  String get ipsPackLoading => 'Loading recommended packs.';

  @override
  String ipsPackAllocationValue(Object bond, Object stock) {
    return 'Bond $bond%, Stock $stock%';
  }

  @override
  String get ipsContractTitle => 'Contract';

  @override
  String get ipsContractSubtitle =>
      'Contract creation and signing acknowledgement.';

  @override
  String get ipsContractCreate => 'Create contract';

  @override
  String get ipsContractTermsTitle => 'Terms and conditions';

  @override
  String get ipsContractMissingPack => 'Pack selection data is missing.';

  @override
  String get ipsContractMissingService => 'Contract service is not configured.';

  @override
  String get ipsContractCreated => 'Contract created';

  @override
  String get ipsContractOpenPortfolio => 'Open portfolio';

  @override
  String get ipsContractId => 'Contract ID';

  @override
  String get ipsContractRiskScore => 'Risk score';

  @override
  String get ipsContractTermsBody =>
      'Confirm the recommended pack, acknowledge the service terms, and create the IPS contract.';

  @override
  String get ipsContractPreparingAccounts =>
      'Creating your IPS accounts and loading package details.';

  @override
  String get ipsContractPackQuantityPrompt =>
      'Enter the pack quantity you would like to purchase.';

  @override
  String get ipsContractUnitPrice => 'Price per pack';

  @override
  String get ipsContractServiceFee => 'Service fee';

  @override
  String get ipsContractIpsAccountsMissing =>
      'The required IPS accounts are not ready yet. Please try again.';

  @override
  String get ipsContractPackPricingUnavailable =>
      'The selected package pricing is currently unavailable. Please try again.';

  @override
  String get ipsContractPreparingPayment =>
      'Preparing your contract, payment request, and wallet checkout.';

  @override
  String get ipsPortfolioTitle => 'Portfolio';

  @override
  String get ipsPortfolioSubtitle =>
      'IPS acnt overview, holdings, yield, and profit.';

  @override
  String get ipsPortfolioAvailableBalance => 'Available balance';

  @override
  String get ipsPortfolioInvestedBalance => 'Invested balance';

  @override
  String get ipsPortfolioProfitLoss => 'Profit/Loss';

  @override
  String get ipsPortfolioYield => 'Yield';

  @override
  String get ipsPortfolioHoldings => 'Holdings';

  @override
  String get ipsPortfolioNoHoldings => 'No holdings data is available.';

  @override
  String get ipsPortfolioRecharge => 'Recharge';

  @override
  String get ipsPortfolioSellOrder => 'Sell order';

  @override
  String get ipsPortfolioOrderList => 'Order list';

  @override
  String get ipsPortfolioStatements => 'Statements';

  @override
  String get ipsPortfolioMissingService =>
      'Portfolio service is not configured.';

  @override
  String get ipsPortfolioLoading => 'Loading portfolio overview.';

  @override
  String get ipsPortfolioHoldingQuantity => 'Quantity';

  @override
  String get ipsPortfolioHoldingValueLabel => 'Current value';

  @override
  String ipsPortfolioHoldingValue(Object quantity, Object value) {
    return 'Qty $quantity • Value $value';
  }

  @override
  String get ipsOrdersTitle => 'Orders';

  @override
  String get ipsOrdersSubtitle => 'IPS order list and cancellation flow.';

  @override
  String get ipsOrdersNoOrders => 'No IPS orders are available.';

  @override
  String get ipsOrdersCancelOrder => 'Cancel order';

  @override
  String get ipsOrdersCreatedAt => 'Created';

  @override
  String get ipsOrdersOrderId => 'Order ID';

  @override
  String get ipsOrdersMissingService => 'Orders service is not configured.';

  @override
  String get ipsOrdersType => 'Order type';

  @override
  String get ipsOrdersTypeBuy => 'Buy';

  @override
  String get ipsOrdersTypeSell => 'Sell';

  @override
  String get ipsOrdersTypeRecharge => 'Recharge';

  @override
  String get ipsOrdersLoading => 'Loading order list.';

  @override
  String ipsOrdersCancelOrderConfirm(Object orderId) {
    return 'Cancel order $orderId?';
  }

  @override
  String ipsOrdersSummary(Object type, Object status) {
    return '$type • $status';
  }

  @override
  String get ipsPaymentRechargeTitle => 'Top up package';

  @override
  String get ipsPaymentRechargeSubtitle =>
      'Exchange/recharge flow and QR generation.';

  @override
  String get ipsPaymentRechargeQuantityHint => 'Enter the quantity to purchase';

  @override
  String get ipsPaymentRechargeTotalAmount => 'Total amount';

  @override
  String get ipsPaymentCreateQr => 'Create QR';

  @override
  String get ipsPaymentQrGenerated => 'Payment QR generated';

  @override
  String get ipsPaymentPending => 'Payment is pending.';

  @override
  String get ipsPaymentMissingService =>
      'Recharge/payment service is not configured.';

  @override
  String get ipsPaymentQrValue => 'QR value';

  @override
  String get ipsPaymentAcntFlow => 'Acnt flow';

  @override
  String get ipsPaymentCreateInvoiceAndPay => 'Create invoice and pay';

  @override
  String get ipsPaymentInvoiceId => 'Invoice ID';

  @override
  String get ipsPaymentStatusTimedOut => 'Timed out';

  @override
  String get ipsPaymentStatusUnsupported => 'Unsupported';

  @override
  String get ipsPaymentInvoiceCreateFailed =>
      'The SDK could not create a payment invoice.';

  @override
  String get ipsPaymentInvalidInvoice =>
      'The payment invoice response was missing a usable invoice ID.';

  @override
  String get ipsPaymentHostResponseTimedOut =>
      'The host payment response timed out.';

  @override
  String get ipsPaymentHostCallbackFailed =>
      'The host payment callback failed.';

  @override
  String get ipsSellTitle => 'Sell pack';

  @override
  String get ipsSellCloseTitle => 'Close pack';

  @override
  String get ipsSellSubtitle => 'Create an IPS sell order.';

  @override
  String get ipsSellMissingService => 'Sell-order service is not configured.';

  @override
  String get ipsSellCreateOrder => 'Create sell order';

  @override
  String get ipsSellPendingMessage =>
      'This request will close your package by selling all owned package units.';

  @override
  String get ipsSellReminderBody =>
      'The quantity below is loaded from your current package balance. When you submit this request, the app creates a sell order for all owned package units and the final payout is calculated from your latest holdings value, available cash, and fees.';

  @override
  String get ipsSellQuantityClosing => 'Packs to close';

  @override
  String get ipsSellTotalAmount => 'TOTAL';

  @override
  String get ipsSellProfit => 'PROFIT';

  @override
  String get ipsSellTotalFee => 'TOTAL FEE';

  @override
  String get ipsSellPayoutAmount => 'Amount to receive';

  @override
  String get ipsSellSubmitRequest => 'Submit request';

  @override
  String get ipsSellSuccessTitle => 'Your request was submitted successfully';

  @override
  String get ipsSellSuccessBody =>
      'Your close pack request has been received. Trading is executed every Tuesday and Thursday. Your total investment refund will be processed within 10 business days and deposited to your bank account.';

  @override
  String ipsSellPackLabel(int number) {
    return 'Pack $number';
  }

  @override
  String ipsSellAllocationLabel(int bond, int stock) {
    return '$bond% bond, $stock% stock';
  }

  @override
  String get ipsStatementTitle => 'Statements';

  @override
  String get ipsStatementSubtitle => 'Statement and acnt-summary surface.';

  @override
  String get ipsStatementSummary => 'Statement summary';

  @override
  String get ipsStatementBeginBalance => 'Beginning balance';

  @override
  String get ipsStatementEndBalance => 'Ending balance';

  @override
  String ipsStatementEntriesCount(int count) {
    return '$count entries';
  }

  @override
  String get ipsStatementMissingService =>
      'Statement service is not configured.';

  @override
  String get ipsStatementsLoading => 'Loading statement summary.';

  @override
  String get ipsYieldTitle => 'Yield';

  @override
  String get ipsYieldSubtitle => 'Portfolio yield breakdown.';

  @override
  String get ipsYieldDetails => 'Yield details';

  @override
  String get ipsProfitTitle => 'Profit and loss';

  @override
  String get ipsProfitSubtitle => 'Profit and loss summary for IPS holdings.';

  @override
  String get ipsProfitSummary => 'Profit summary';

  @override
  String get ipsSuccessReqCreated => 'Req created successfully.';

  @override
  String get ipsSuccessOrderCancelled => 'Order cancelled successfully.';

  @override
  String get ipsSuccessContractCreated => 'Contract created successfully.';

  @override
  String get ipsSuccessQrCreated => 'QR created successfully.';

  @override
  String get ipsStatusPending => 'Pending';

  @override
  String get ipsStatusActive => 'Active';

  @override
  String get ipsStatusCompleted => 'Completed';

  @override
  String get ipsStatusCancelled => 'Cancelled';

  @override
  String get ipsStatusFailed => 'Failed';

  @override
  String get ipsUnknownRouteTitle => 'Route unavailable';

  @override
  String ipsUnknownRouteMessage(Object route) {
    return 'The IPS route is not registered: $route';
  }

  @override
  String internalUnknownRouteMessage(Object, Object route) {
    return 'The route is not registered for : $route';
  }

  @override
  String get internalProfileCatalogTitle => 'Profile screens';

  @override
  String get internalProfileModuleName => 'Profile';

  @override
  String get internalProfileRouteHomeTitle => 'Contact update home';

  @override
  String get internalProfileRouteHomeDescription =>
      'Review the current email and phone details.';

  @override
  String get internalProfileRouteUpdateEmailTitle => 'Update email';

  @override
  String get internalProfileRouteUpdateEmailDescription =>
      'Enter a new email address.';

  @override
  String get internalProfileRouteVerifyEmailTitle => 'Verify email';

  @override
  String get internalProfileRouteVerifyEmailDescription =>
      'Enter the email verification code.';

  @override
  String get internalProfileRouteEmailVerifiedTitle => 'Email verified';

  @override
  String get internalProfileRouteEmailVerifiedDescription =>
      'Email verification success state.';

  @override
  String get internalProfileRouteUpdatePhoneTitle => 'Update phone';

  @override
  String get internalProfileRouteUpdatePhoneDescription =>
      'Enter a new phone number.';

  @override
  String get internalProfileRouteVerifyPhoneTitle => 'Verify phone';

  @override
  String get internalProfileRouteVerifyPhoneDescription =>
      'Enter the phone verification code.';

  @override
  String get internalProfileRoutePhoneVerifiedTitle => 'Phone verified';

  @override
  String get internalProfileRoutePhoneVerifiedDescription =>
      'Phone verification success state.';

  @override
  String get internalProfileRouteReviewUpdatesTitle => 'Review updates';

  @override
  String get internalProfileRouteReviewUpdatesDescription =>
      'Check the updated contact details.';

  @override
  String get internalProfileRouteConfirmChangesTitle => 'Confirm changes';

  @override
  String get internalProfileRouteConfirmChangesDescription =>
      'Confirm the contact updates before saving.';

  @override
  String get internalProfileRouteUpdateCompleteTitle => 'Update complete';

  @override
  String get internalProfileRouteUpdateCompleteDescription =>
      'Contact update completion state.';

  @override
  String get internalProfileProcessing => 'Processing...';

  @override
  String get internalProfileFlowProgressTitle => 'Flow progress';

  @override
  String internalProfileFlowProgressStep(Object step, Object total) {
    return 'Step $step of $total';
  }

  @override
  String get internalProfileSectionDetailsTitle => 'Profile details';

  @override
  String get internalProfileFieldFullName => 'Full name';

  @override
  String get internalProfileFieldCurrentEmail => 'Current email';

  @override
  String get internalProfileFieldCurrentPhone => 'Current phone';

  @override
  String get internalProfileFieldSdkVersion => 'SDK version';

  @override
  String get internalProfileFieldNewEmail => 'New email';

  @override
  String get internalProfileFieldNewPhone => 'New phone number';

  @override
  String get internalProfileFieldUpdatedEmail => 'Updated email';

  @override
  String get internalProfileFieldUpdatedPhone => 'Updated phone';

  @override
  String get internalProfileFieldUpdatedBy => 'Updated by';

  @override
  String get internalProfileContactEntryHint =>
      'Make sure the entered value is correct before reqing verification.';

  @override
  String get internalProfileVerificationInstructions =>
      'Enter the 6-digit code sent to your latest contact channel.';

  @override
  String get internalProfileVerificationCodeLabel => 'Verification code';

  @override
  String get internalProfileInvalidVerificationCode =>
      'The verification code is invalid.';

  @override
  String get internalProfileVerificationSuccess =>
      'Verification completed successfully.';

  @override
  String get internalProfileUpdateSuccess =>
      'Contact details were updated successfully.';

  @override
  String get internalAuthCatalogTitle => 'Auth screens';

  @override
  String get internalAuthModuleName => 'Auth';

  @override
  String get internalAuthRouteRegistrationTitle => 'Create acnt';

  @override
  String get internalAuthRouteRegistrationDescription =>
      'Registration flow adapted from the auth design references.';

  @override
  String get internalAuthRouteRegistrationConfirmationTitle =>
      'Confirm registration';

  @override
  String get internalAuthRouteRegistrationConfirmationDescription =>
      'Review the terms and complete acnt setup.';

  @override
  String get internalAuthContinueRegistration => 'Continue registration';

  @override
  String get internalAuthSectionPersonalInformation => 'Personal information';

  @override
  String get internalAuthFieldFullName => 'Full name';

  @override
  String get internalAuthFieldEmail => 'Email address';

  @override
  String get internalAuthFieldPhone => 'Phone number';

  @override
  String get internalAuthFinishRegistration => 'Finish registration';

  @override
  String get internalAuthSectionVerification => 'Verification';

  @override
  String get internalAuthIdentityCheck => 'Identity check';

  @override
  String get internalAuthPendingReview => 'Pending review';

  @override
  String get internalAuthEmailVerification => 'Email verification';

  @override
  String get internalAuthPhoneVerification => 'Phone verification';

  @override
  String get internalAuthVerified => 'Verified';

  @override
  String get internalAuthSectionConsent => 'Consent';

  @override
  String get internalAuthConsentBody =>
      'I agree to the service terms and privacy policy.';

  @override
  String get internalStatesCatalogTitle => 'State screens';

  @override
  String get internalStatesModuleName => 'States';

  @override
  String get internalStatesRouteSplashTitle => 'Splash';

  @override
  String get internalStatesRouteSplashDescription =>
      'Initial splash state with brand entry.';

  @override
  String get internalStatesRouteSplashAlternateTitle => 'Splash alternate';

  @override
  String get internalStatesRouteSplashAlternateDescription =>
      'Secondary splash variant.';

  @override
  String get internalStatesRouteLoadingTitle => 'Loading screen';

  @override
  String get internalStatesRouteLoadingDescription =>
      'Loading indicator with contextual message.';

  @override
  String get internalStatesRouteKycOverlayTitle => 'Signup KYC overlay';

  @override
  String get internalStatesRouteKycOverlayDescription =>
      'KYC-required overlay with next-step actions.';

  @override
  String get internalStatesSplashHeroPrimaryTitle => '';

  @override
  String get internalStatesSplashHeroPrimarySubtitle =>
      'Preparing your workspace...';

  @override
  String get internalStatesSplashHeroAlternateTitle => ' Finance';

  @override
  String get internalStatesSplashHeroAlternateSubtitle =>
      'Loading your personalized dashboard...';

  @override
  String get internalStatesLoadingMessage => 'Fetching acnt details...';

  @override
  String get internalStatesLoadingHint =>
      'Please wait a moment while the mini app prepares this screen.';

  @override
  String get internalStatesKycDefaultStatusMessage =>
      'Complete your verification to continue using all wallet features.';

  @override
  String get internalStatesKycSuccessTitle => 'Identity verified';

  @override
  String get internalStatesKycSuccessSubtitle =>
      'Your profile is now verified.You can access all features.';

  @override
  String get internalStatesKycRequiredTitle => 'KYC required';

  @override
  String get internalStatesKycRequiredSubtitle =>
      'Profile verification is required before you continue.';

  @override
  String get internalStatesKycStartVerification => 'Start verification';

  @override
  String get internalStatesKycLater => 'Later';

  @override
  String get internalStatesKycScanningId => 'Scanning ID...';

  @override
  String get internalStatesKycVerifying => 'Verifying...';

  @override
  String get internalStatesKycCapturingBiometric =>
      'Capturing biometric data...';

  @override
  String get internalStatesKycFailureFaceMatch =>
      'Face match failed.Please try again in better lighting.';

  @override
  String get reject => 'Reject';

  @override
  String get accept => 'Continue';

  @override
  String get tinoConsent =>
      'Do you consent to the use of the information associated with your Tino app account?';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonWarning => 'Warning';

  @override
  String get commonPay => 'Pay';

  @override
  String get commonGoHome => 'Go to home';

  @override
  String get commonHome => 'Home';

  @override
  String get commonProfile => 'Profile';

  @override
  String get commonBank => 'Bank';

  @override
  String get commonIban => 'IBAN number';

  @override
  String get commonPackUnit => 'PACK';

  @override
  String get commonBrandInvestx => 'investX';

  @override
  String get commonDrawSignaturePrompt =>
      'Please draw your signature to confirm';

  @override
  String get commonSignaturePlaceholder => 'Draw your signature here';

  @override
  String get commonTotalPayable => 'Total payable';

  @override
  String commonPackQuantity(Object count) {
    return '$count PACK';
  }

  @override
  String get secAcntPersonalInformationSubtitle =>
      'Please enter your personal information.';

  @override
  String get secAcntFieldSecondaryPhone => 'Additional phone number';

  @override
  String get secAcntBankSelectionTitle => 'Select bank';

  @override
  String get secAcntPaymentSheetTitle => 'Tino Pay';

  @override
  String get secAcntPaymentOptionTinoBalance => 'Tino current balance';

  @override
  String get secAcntPaymentOptionTinoPayLater => 'Tino Pay Later limit';

  @override
  String get secAcntSuccessBankDetailsTitle => 'Bank details';

  @override
  String get secAcntAgreementConsent =>
      'I have reviewed and agree to the securities account opening agreement and the service terms.';

  @override
  String get secAcntServiceFeeTitle => 'Service fee';

  @override
  String get secAcntPaymentTitle => 'Securities account opening fee';

  @override
  String secAcntPaymentTitleWithAmount(Object amount) {
    return 'Securities account opening fee $amount';
  }

  @override
  String get secAcntPaymentNoticeMessage =>
      'Opening this account allows you to invest in both domestic and international markets.';

  @override
  String get secAcntPaymentAmountUnavailable =>
      'The payable amount is currently unavailable. Please refresh your account information and try again.';

  @override
  String get secAcntPaymentFailedTitle => 'Payment failed';

  @override
  String get secAcntCalculationTitle =>
      'Your payment was completed successfully';

  @override
  String get secAcntCalculationMessageTitle =>
      'Your registration request was created successfully';

  @override
  String get secAcntCalculationPendingMessage =>
      'Your registration request is being reviewed. We will notify you once it is confirmed.';

  @override
  String get secAcntBankNotSelected => 'No bank selected';

  @override
  String get secAcntProfileUpdating => 'Saving your personal information.';

  @override
  String get secAcntInvestxAgreementTitle => 'INVESTX service agreement';

  @override
  String get secAcntSecuritiesAgreementTitle =>
      'Securities account opening agreement';

  @override
  String get secAcntInvestxAgreementText =>
      '1. This INVESTX service agreement defines the main terms related to starting the investment service, verifying customer information, and account usage.\n\n2. The customer confirms that the submitted information is accurate and agrees to receive service-related notices in the app and through the registered channels.\n\n3. In the next stages of the INVESTX service, the risk questionnaire, pack selection, and purchase actions will be activated in sequence.';

  @override
  String get secAcntSecuritiesAgreementText =>
      '1. When submitting a request to open a securities account, the customer\'s first name, last name, register number, contact details, and bank information will be verified.\n\n2. The customer acknowledges in advance the fee, verification timeline, and service conditions related to account opening.\n\n3. After verification is completed successfully, the next-stage INVESTX service agreement and risk questionnaire will be opened.';

  @override
  String get secAcntTermsText =>
      '1. These service terms define the general rules related to registration, use, and information security for the customer\'s investment account.\n\n2. Requests, signatures, consents, and payment confirmations submitted in the app are considered valid system actions.\n\n3. While the registration request is under review, some actions may be limited, and the customer will be notified once the review is completed successfully.\n\n4. If updated terms are introduced during the service flow, the customer will receive the notice, review it, and provide consent again when required.';

  @override
  String get ipsPackBenefitStableYield => 'Targets stable yield';

  @override
  String get ipsPackBenefitLowVolatility => 'Low volatility';

  @override
  String get ipsPackBenefitMinRisk => 'Minimal risk';

  @override
  String get ipsPackBenefitStockGrowth => 'Has growth-oriented stock exposure';

  @override
  String get ipsPackBenefitBalancedStructure => 'Balanced pack structure';

  @override
  String get ipsPackBenefitGrowthFocused => 'More growth-focused allocation';

  @override
  String get ipsOverviewPackPrompt => 'Choose a package that suits you';

  @override
  String get ipsPackPerfectFit => 'Perfect fit for you';

  @override
  String get advice => 'Advice';

  @override
  String get investmentFund => 'Investment fund';

  @override
  String get ipsHelpTitle => 'Support';

  @override
  String get ipsHelpContactTitle => 'Contact us';

  @override
  String get ipsHelpEmail => 'Email';

  @override
  String get ipsHelpPhone => 'Phone';

  @override
  String get ipsHelpLocationTitle => 'Office location';

  @override
  String get ipsHelpLocationWorkingHours => 'Mon - Fri 09:00 - 18:00';

  @override
  String get ipsFeedbackTitle => 'Feedback';

  @override
  String get ipsFeedbackEmptyTitle => 'No feedback yet';

  @override
  String get ipsFeedbackEmptyBody =>
      'Press the button below to submit your feedback.';

  @override
  String get ipsFeedbackCreateButton => 'Submit feedback';

  @override
  String get ipsFeedbackCreateTitle => 'Title';

  @override
  String get ipsFeedbackCreateTitleHint => 'Enter a title';

  @override
  String get ipsFeedbackCreateBody => 'Description';

  @override
  String get ipsFeedbackCreateBodyHint => 'Enter a detailed description';

  @override
  String get ipsFeedbackStatusReviewing => 'Reviewing';

  @override
  String get ipsFeedbackStatusResolved => 'Resolved';

  @override
  String get ipsFeedbackStatusClosed => 'Closed';

  @override
  String get ipsRewardTitle => 'Your achievements';

  @override
  String get ipsRewardGoalTitle => 'Target goal';

  @override
  String get ipsRewardGoalProgress => 'Progress';

  @override
  String get ipsRewardStreakTitle => 'Continuous investment';

  @override
  String ipsRewardStreakMonths(int current, int total) {
    return '$current / $total months';
  }

  @override
  String ipsRewardStreakNextReward(Object reward) {
    return 'Next reward: +$reward';
  }

  @override
  String get ipsRewardNextGoalTitle => 'Next goal';

  @override
  String get ipsRewardNextGoalBody =>
      'After 6 months, your interest rate increases by 2%, plus VIP benefits.';

  @override
  String ipsRewardMilestoneMonths(int count) {
    return '$count Months';
  }

  @override
  String get ipsStatementFilterTitle => 'Filter statements';

  @override
  String get ipsStatementFilterAmountTitle => 'Transaction amount';

  @override
  String get ipsStatementFilterDateTitle => 'Date';

  @override
  String get ipsStatementFilterToday => 'Today';

  @override
  String get ipsStatementFilterWeek => '7 days';

  @override
  String get ipsStatementFilterMonth => '1 month';

  @override
  String get ipsStatementFilter3Months => '3 months';

  @override
  String get ipsStatementFilterClear => 'Clear';

  @override
  String ipsStatementFilterSearch(int count) {
    return 'Search ($count)';
  }

  @override
  String get ipsStatementTypeIncome => 'Income';

  @override
  String get ipsStatementTypeExpense => 'Expense';

  @override
  String get ipsStatementInvestment => 'Investment deposit';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonAll => 'All';

  @override
  String get ipsPortfolioFilterAll => 'All';

  @override
  String get ipsPortfolioFilterBonds => 'Bonds';

  @override
  String get ipsPortfolioFilterStocks => 'Stocks';

  @override
  String get closedPrice => 'Closing price';

  @override
  String get closedDate => 'Date';
}
