class StaticApiConfig {
  StaticApiConfig._();

  //─── Backend URL-ууд ───────────────────────────────────────────────────────
  ///signup bootstrap endpoint-ийн base URL
  static const String techInvestXUrl = 'https://api.admin.investx.mn';
  // static const String techInvestXUrl = 'http://192.168.88.29:8080';
  // static const String techInvestXUrl = 'https://a267-202-70-40-241.ngrok-free.app';

  ///getLoginSession endpoint-ийн base URL (:40654 port)
  static const String loginSessionBaseUrl = 'http://202.21.105.150:40654';

  ///IPS бүх бусад endpoint-ийн base URL (:40651 port)
  static const String ipsApiBaseUrl = 'http://202.21.105.150:40651';

  //─── App credentials ───────────────────────────────────────────────────────
  static const String appId = '156';
  static const String appSecret = 'APEXTINO';

  //─── Session ───────────────────────────────────────────────────────────────
  static const String neSession = 'v4omE7WQDotmIpzZvtN2OXgR302rxS';

  //─── Defaults ──────────────────────────────────────────────────────────────
  static const String defaultSrcFiCode = '181';
  static const String defaultFiCode = '181';
  static const String defaultLanguage = 'MN';
}
