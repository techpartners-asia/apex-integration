/// Canonical route paths exposed by the Apex mini-app SDK.
final class MiniAppRoutes {
  /// Startup/bootstrap route.
  static const String splash = '/splash';

  /// Startup gate shown when signup/bootstrap blocks entry.
  static const String startupBlocked = '/startup-blocked';

  /// Main overview/dashboard route.
  static const String overview = '/overview';

  /// Securities account onboarding route.
  static const String secAcnt = '/sec-acnt';

  /// Risk questionnaire route.
  static const String questionnaire = '/questionnaire';

  /// Investment pack selection route.
  static const String packs = '/packs';

  /// Contract/recharge preparation route.
  static const String contract = '/contract';

  /// Portfolio detail route.
  static const String portfolio = '/portfolio';

  /// Orders route.
  static const String orders = '/orders';

  /// Recharge route.
  static const String recharge = '/recharge';

  /// Sell/close pack route.
  static const String sell = '/sell';

  /// Portfolio statements route.
  static const String statements = '/statements';

  /// Help/support route.
  static const String help = '/help';

  /// Feedback inbox route.
  static const String feedback = '/feedback';

  /// Reward route.
  static const String reward = '/reward';

  /// Profile personal-information route.
  static const String personalInfo = '/personal-info';

  /// Service terms/contract HTML viewer route.
  static const String termsOfService = '/terms-of-service';

  /// Public alias used by hosts that launch the InvestX experience.
  static const String investX = splash;

  /// Routes that can be launched through the host controller.
  static const List<String> publicRoutes = <String>[
    splash,
    startupBlocked,
    overview,
    secAcnt,
    questionnaire,
    packs,
    contract,
    portfolio,
    orders,
    recharge,
    sell,
    statements,
    help,
    feedback,
    reward,
    personalInfo,
    termsOfService,
  ];
}
