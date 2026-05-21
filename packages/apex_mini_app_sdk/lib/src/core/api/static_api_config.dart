/// Built-in backend configuration selected by SDK environment mode.
///
/// Host apps normally choose the environment through `ApexMiniAppSdk.devMode`.
/// Explicit host URL/credential overrides still win at runtime; these values
/// are the SDK defaults used when the host leaves a field empty.
class StaticApiConfig {
  StaticApiConfig._();

  /// Legacy development Tech InvestX API base URL.
  static const String devTechInvestXUrl = 'http://192.168.88.120:7001/api/v1';

  /// Legacy development login-session API base URL.
  static const String devLoginSessionBaseUrl = 'http://202.21.105.150:40654';

  /// Legacy development IPS API base URL.
  static const String devIpsApiBaseUrl = 'http://202.21.105.150:40651';

  /// Legacy development app id.
  static const String devAppId = '156';

  /// Legacy development app secret.
  static const String devAppSecret = 'APEXTINO';

  /// Legacy development NE session.
  static const String devNeSession = 'v4omE7WQDotmIpzZvtN2OXgR302rxS';

  /// Legacy development source FI code.
  static const String devDefaultSrcFiCode = '181';

  /// Legacy development FI code.
  static const String devDefaultFiCode = '181';

  /// Legacy development Tech InvestX storage base URL.
  static const String devTechInvestXStorageUrl = 'http://192.168.88.120:9002/';

  /// Production Tech InvestX API base URL.
  static const String productionTechInvestXUrl = 'https://api.admin.investx.mn';

  /// Production login-session API base URL.
  static const String productionLoginSessionBaseUrl = 'https://customer.mostmoney.mn:9094';

  /// Production IPS API base URL.
  static const String productionIpsApiBaseUrl = 'https://customer.mostmoney.mn:9094';

  /// Production app id.
  static const String productionAppId = '114';

  /// Production app secret.
  static const String productionAppSecret = 'APEXTINO';

  /// Production NE session.
  static const String productionNeSession = 'P0JmbkwsVmQX1nbZ63d0lJnY3YJSp0';

  /// Production source FI code.
  static const String productionDefaultSrcFiCode = '78';

  /// Production FI code.
  static const String productionDefaultFiCode = '78';

  /// Production Tech InvestX storage base URL.
  static const String productionTechInvestXStorageUrl = 'https://storage.admin.investx.mn/';

  /// Default backend language code.
  static const String defaultLanguage = 'MN';

  static bool _devMode = true;

  /// Currently configured SDK environment mode.
  static bool get devMode => _devMode;

  /// Configures the SDK's built-in environment defaults.
  static void configure({required bool devMode}) {
    _devMode = devMode;
  }

  /// Resets global environment state for tests.
  static void resetForTesting() {
    _devMode = true;
  }

  /// Tech InvestX API base URL for the current environment.
  static String get techInvestXUrl => techInvestXUrlForDevMode(_devMode);

  /// Login-session API base URL for the current environment.
  static String get loginSessionBaseUrl => loginSessionBaseUrlForDevMode(_devMode);

  /// IPS API base URL for the current environment.
  static String get ipsApiBaseUrl => ipsApiBaseUrlForDevMode(_devMode);

  /// App id for the current environment.
  static String get appId => appIdForDevMode(_devMode);

  /// App secret for the current environment.
  static String get appSecret => appSecretForDevMode(_devMode);

  /// NE session for the current environment.
  static String get neSession => neSessionForDevMode(_devMode);

  /// Default source FI code for the current environment.
  static String get defaultSrcFiCode => defaultSrcFiCodeForDevMode(_devMode);

  /// Default FI code for the current environment.
  static String get defaultFiCode => defaultFiCodeForDevMode(_devMode);

  /// Tech InvestX storage URL for the current environment.
  static String get techInvestXStorageUrl => techInvestXStorageUrlForDevMode(_devMode);

  /// Resolves Tech InvestX API base URL for [devMode].
  static String techInvestXUrlForDevMode(bool devMode) => devMode ? devTechInvestXUrl : productionTechInvestXUrl;

  /// Resolves login-session API base URL for [devMode].
  static String loginSessionBaseUrlForDevMode(bool devMode) => devMode ? devLoginSessionBaseUrl : productionLoginSessionBaseUrl;

  /// Resolves IPS API base URL for [devMode].
  static String ipsApiBaseUrlForDevMode(bool devMode) => devMode ? devIpsApiBaseUrl : productionIpsApiBaseUrl;

  /// Resolves app id for [devMode].
  static String appIdForDevMode(bool devMode) => devMode ? devAppId : productionAppId;

  /// Resolves app secret for [devMode].
  static String appSecretForDevMode(bool devMode) => devMode ? devAppSecret : productionAppSecret;

  /// Resolves NE session for [devMode].
  static String neSessionForDevMode(bool devMode) => devMode ? devNeSession : productionNeSession;

  /// Resolves source FI code for [devMode].
  static String defaultSrcFiCodeForDevMode(bool devMode) => devMode ? devDefaultSrcFiCode : productionDefaultSrcFiCode;

  /// Resolves FI code for [devMode].
  static String defaultFiCodeForDevMode(bool devMode) => devMode ? devDefaultFiCode : productionDefaultFiCode;

  /// Resolves Tech InvestX storage URL for [devMode].
  static String techInvestXStorageUrlForDevMode(bool devMode) => devMode ? devTechInvestXStorageUrl : productionTechInvestXStorageUrl;
}
