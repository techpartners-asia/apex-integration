import '../contract/mini_app_module.dart';

/// In-memory registry mapping mini-app routes to their owning module.
///
/// The host controller uses this registry to validate launch requests and to
/// find the module that should build a requested route.
class MiniAppRegistry {
  /// Route path to module lookup table.
  final Map<String, MiniAppModule> modulesByRoute = <String, MiniAppModule>{};

  /// Registers [module] after validating its display name and route table.
  void register(MiniAppModule module) {
    final String displayName = module.displayName.trim();
    if (displayName.isEmpty) {
      throw StateError('Mini app module displayName must not be empty.');
    }

    final String initialRoute = module.initialRoute.trim();
    if (initialRoute.isEmpty) {
      throw StateError(
        'Mini app module "$displayName" initialRoute must not be empty.',
      );
    }

    final List<String> routePaths = module.routes
        .map((route) => route.path)
        .toList(growable: false);
    if (routePaths.isEmpty) {
      throw StateError('Mini app module must declare at least one route.');
    }

    final Set<String> uniqueRoutePaths = routePaths.toSet();
    if (uniqueRoutePaths.length != routePaths.length) {
      throw StateError(
        'Mini app module "$displayName" declares duplicate routes.',
      );
    }

    if (!uniqueRoutePaths.contains(initialRoute)) {
      throw StateError(
        'Mini app module "$displayName" initialRoute '
        '"$initialRoute" is not declared in routes.',
      );
    }

    final String? conflictingRoute = routePaths.cast<String?>().firstWhere(
      (String? route) => modulesByRoute.containsKey(route),
      orElse: () => null,
    );
    if (conflictingRoute != null) {
      throw StateError(
        'Route "$conflictingRoute" is already registered by another module.',
      );
    }

    for (final String route in routePaths) {
      modulesByRoute[route] = module;
    }
  }

  /// Removes routes owned by [module].
  void unregister(MiniAppModule module) {
    for (final route in module.routes) {
      if (modulesByRoute[route.path] == module) {
        modulesByRoute.remove(route.path);
      }
    }
  }

  /// Removes every registered module route.
  void clear() {
    modulesByRoute.clear();
  }

  /// Finds the module that owns [route], after trimming empty input.
  MiniAppModule? findByRoute(String? route) {
    if (route == null) return null;
    final String normalized = route.trim();
    if (normalized.isEmpty) return null;
    return modulesByRoute[normalized];
  }

  /// Registers each module in [modules].
  void registerAll(Iterable<MiniAppModule> modules) {
    for (final module in modules) {
      register(module);
    }
  }
}
