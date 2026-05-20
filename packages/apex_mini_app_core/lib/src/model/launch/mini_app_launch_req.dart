/// Request object used by the host controller to open or replace a mini-app
/// route.
class MiniAppLaunchReq {
  /// Target route path, for example `/invest-x` or `/recharge`.
  final String? route;

  /// Optional payload passed to the destination route.
  ///
  /// SDK-hosted launches usually wrap this in a higher-level launch context so
  /// host token/session data can travel with the first route.
  final Object? arguments;

  /// Creates a request to launch or replace a mini-app route.
  MiniAppLaunchReq({this.route, this.arguments});
}
