import '../host/apex_mini_app_host_config.dart';

class MiniAppLaunchContext {
  final String? userToken;
  final ApexMiniAppHostUser? hostUser;
  final ApexMiniAppHostSession? hostSession;
  final Object? arguments;

  const MiniAppLaunchContext({
    this.userToken,
    this.hostUser,
    this.hostSession,
    this.arguments,
  });
}
