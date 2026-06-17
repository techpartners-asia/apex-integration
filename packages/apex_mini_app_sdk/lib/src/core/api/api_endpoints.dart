/// Centralized backend endpoint constants used by the SDK.
class ApiEndpoints {
  const ApiEndpoints._();

  /// Host-token bootstrap/sign-up endpoint.
  static const String signUp = '/api/v1/user/signup';

  /// Current user profile endpoint.
  static const String profileInfo = '/api/v1/user/profile/info';

  /// Investor questionnaire/goal list endpoint.
  static const String getAllGoals = '/api/v1/user/question/get-all';

  /// Grape questionnaire completion check endpoint.
  static const String checkGrapeQuestionnaireCompleted =
      '/api/v1/user/question/grape/check-completed';

  /// Grape questionnaire bulk save endpoint.
  static const String completeGrapeQuestionnaire =
      '/api/v1/user/question/grape/complete';

  /// Grape questionnaire score persistence endpoint.
  static const String setGrapeQuestionnaireScore =
      '/api/v1/user/question/grape/set-score';

  /// User profile update endpoint.
  static const String updateProfile = '/api/v1/user/profile/update';

  /// Target goal update endpoint.
  static const String updateTargetGoal = '/api/v1/user/profile/update-target-goal';

  /// Signature upload/update endpoint.
  static const String updateSignature = '/api/v1/user/profile/update-signature';

  /// Feedback creation endpoint.
  static const String createFeedback = '/api/v1/user/feedback/create';

  /// Feedback history endpoint.
  static const String feedbackList = '/api/v1/user/feedback/list';

  /// Company information endpoint.
  static const String companyInfo = '/api/v1/user/company/get-info';

  /// Invoice creation endpoint used before host wallet handoff.
  static const String createInvoice = '/api/v1/user/invoice/create';

  /// Securities account opening fee amount added to the payment total.
  static const String accountFeesAmount =
      '/api/v1/user/payment/account-fees-amount';

  /// Backend payment callback endpoint called after wallet success.
  static const String paymentCallback = '/api/v1/webhooks/payment/callback';

  /// Protected login-session bootstrap endpoint.
  static const String getLoginSession = '/api/v1.0/getLoginSession';

  /// Financial institution/bank list endpoint.
  static const String getFiBomInst = '/api/v1.0/getFiBomInst';

  /// Securities account list endpoint.
  static const String getSecuritiesAcntList = '/api/v1.0/getSecuritiesAcntList';

  /// Securities account opening request endpoint.
  static const String addSecuritiesAcntReq = '/api/v1.0/addSecuritiesAcntReq';

  /// Securities account balance endpoint.
  static const String getSecAcntBalance = '/api/v1.0/getSecAcntBalance';

  /// Risk questionnaire list endpoint.
  static const String getQuestionList = '/api/v1.0/getQuestionList';

  /// Risk questionnaire score calculation endpoint.
  static const String calculateScore = '/api/v1.0/calculateScore';

  /// Investment package list endpoint.
  static const String getPack = '/api/v1.0/getPack';

  /// Broker customer contract creation endpoint.
  static const String addBkrCustContract = '/api/v1.0/addBkrCustContract';

  /// IPS account balance endpoint.
  static const String getIpsBalance = '/api/v1.0/getIpsBalance';

  /// Public CASA account statement endpoint.
  static const String getBkrPublicCasaAcntStmt = '/api/v1.0/getBkrPublicCasaAcntStmt';

  /// IPS sell order creation endpoint.
  static const String createIpsSellOrder = '/api/v1.0/createIpsSellOrder';

  /// IPS account recharge endpoint.
  static const String chargeIpsAcnt = '/api/v1.0/chargeIpsAcnt';

  /// IPS order list endpoint.
  static const String getIpsOrderList = '/api/v1.0/getIpsOrderList';

  /// IPS order cancellation endpoint.
  static const String cancelIpsOrder = '/api/v1.0/cancelIpsOrder';

  /// Stock account yield detail endpoint.
  static const String getStockAcntYieldDtl = '/api/v1.0/getStockAcntYieldDtl';

  /// Account yield/profit summary endpoint.
  static const String getAcntYieldProfit = '/api/v1.0/getAcntYieldProfit';

  /// Account-name lookup endpoint for account codes.
  static const String getAcntNameByAcntCode = '/api/v1.0/getAcntNameByAcntCode';

  /// User loyalty/milestone list endpoint.
  static const String loyalty = '/api/v1/user/profile/loyalty';

  /// User loyalty info endpoint (streak + active loyalty).
  static const String loyaltyInfo = '/api/v1/user/profile/loyalty-info';

  /// Remote client API diagnostic logger endpoint.
  static const String loggerCreate = '/api/v1/logger/create';
}
