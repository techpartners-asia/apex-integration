import '../model/route/mini_app_route_spec.dart';

/// Contract implemented by every mini-app feature module.
///
/// A module declares the routes it owns and provides the metadata needed by the
/// runtime to resolve launch requests. UI-specific modules extend this base
/// contract in the UI package so the core package can stay Flutter-light.
abstract class MiniAppModule {
  /// Creates a mini-app route module contract.
  const MiniAppModule();

  /// Human-readable module name used in logs and diagnostics.
  String get displayName;

  /// Default route opened when the host does not request a specific screen.
  String get initialRoute;

  /// Routes that this module can handle.
  List<MiniAppRouteSpec> get routes;
}
