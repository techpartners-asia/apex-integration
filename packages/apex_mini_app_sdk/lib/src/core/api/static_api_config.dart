/// Built-in fallback backend configuration.
///
/// Host apps should normally pass environment-specific URLs through
/// `ApexMiniAppSdk`; these values are retained as SDK defaults.
class StaticApiConfig {
  StaticApiConfig._();

  //─── Backend URL-ууд ───────────────────────────────────────────────────────
  ///signup bootstrap endpoint-ийн base URL
  static const String techInvestXUrl = 'https://api.admin.investx.mn';

  ///getLoginSession endpoint-ийн base URL (:40654 port)
  static const String loginSessionBaseUrl = 'http://202.21.105.150:40654';

  ///IPS бүх бусад endpoint-ийн base URL (:40651 port)
  static const String ipsApiBaseUrl = 'http://202.21.105.150:40651';

  //─── App credentials ───────────────────────────────────────────────────────
  /// Default app id used when the host does not override credentials.
  static const String appId = '156';

  /// Default app secret used when the host does not override credentials.
  static const String appSecret = 'APEXTINO';

  //─── Session ───────────────────────────────────────────────────────────────
  /// Default NE session used for login-session bootstrap.
  static const String neSession = 'v4omE7WQDotmIpzZvtN2OXgR302rxS';

  //─── Defaults ──────────────────────────────────────────────────────────────
  /// Default source FI code used by securities APIs.
  static const String defaultSrcFiCode = '181';

  /// Default FI code used by securities APIs.
  static const String defaultFiCode = '181';

  /// Default backend language code.
  static const String defaultLanguage = 'MN';

  /// Storage base URL used for Tech InvestX media assets.
  static const String techInvestXStorageUrl = 'https://storage.admin.investx.mn/';
}
