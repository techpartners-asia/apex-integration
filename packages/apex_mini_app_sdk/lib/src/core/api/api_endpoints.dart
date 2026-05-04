class ApiEndpoints {
  const ApiEndpoints._();

  static const String signUp = '/api/v1/user/signup';
  static const String profileInfo = '/api/v1/user/profile/info';
  static const String updateProfile = '/api/v1/user/profile/update';
  static const String updateTargetGoal = '/api/v1/user/profile/update-target-goal';
  static const String updateSignature = '/api/v1/user/profile/update-signature';
  static const String createFeedback = '/api/v1/user/feedback/create';
  static const String feedbackList = '/api/v1/user/feedback/list';
  static const String companyInfo = '/api/v1/user/company/get-info';
  static const String createInvoice = '/api/v1/user/invoice/create';
  static const String paymentCallback = '/api/v1/webhooks/payment/callback';

  static const String getLoginSession = '/api/v1.0/getLoginSession';
  static const String getFiBomInst = '/api/v1.0/getFiBomInst';
  static const String getSecuritiesAcntList = '/api/v1.0/getSecuritiesAcntList';
  static const String addSecuritiesAcntReq = '/api/v1.0/addSecuritiesAcntReq';
  static const String getSecAcntBalance = '/api/v1.0/getSecAcntBalance';
  static const String getQuestionList = '/api/v1.0/getQuestionList';
  static const String calculateScore = '/api/v1.0/calculateScore';
  static const String getPack = '/api/v1.0/getPack';
  static const String addBkrCustContract = '/api/v1.0/addBkrCustContract';
  static const String getIpsBalance = '/api/v1.0/getIpsBalance';
  static const String getBkrPublicCasaAcntStmt = '/api/v1.0/getBkrPublicCasaAcntStmt';
  static const String createIpsSellOrder = '/api/v1.0/createIpsSellOrder';
  static const String chargeIpsAcnt = '/api/v1.0/chargeIpsAcnt';
  static const String getIpsOrderList = '/api/v1.0/getIpsOrderList';
  static const String cancelIpsOrder = '/api/v1.0/cancelIpsOrder';
  static const String getStockAcntYieldDtl = '/api/v1.0/getStockAcntYieldDtl';
  static const String getAcntYieldProfit = '/api/v1.0/getAcntYieldProfit';
  static const String getAcntNameByAcntCode = '/api/v1.0/getAcntNameByAcntCode';
}
