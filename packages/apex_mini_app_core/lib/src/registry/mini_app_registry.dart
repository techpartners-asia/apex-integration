import '../contract/mini_app_module.dart';

class MiniAppRegistry {
  final Map<String, MiniAppModule> modulesByRoute = <String, MiniAppModule>{};

  void register(MiniAppModule module) {
    final String displayName = module.displayName.trim();
    if (displayName.isEmpty) {
      throw StateError('Mini app module displayName must not be empty.');
    }

    final String initialRoute = module.initialRoute.trim();
    if (initialRoute.isEmpty) {
      throw StateError('Mini app module "$displayName" initialRoute must not be empty.');
    }

    final List<String> routePaths = module.routes.map((route) => route.path).toList(growable: false);
    if (routePaths.isEmpty) {
      throw StateError('Mini app module must declare at least one route.');
    }

    final Set<String> uniqueRoutePaths = routePaths.toSet();
    if (uniqueRoutePaths.length != routePaths.length) {
      throw StateError('Mini app module "$displayName" declares duplicate routes.');
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
      throw StateError('Route "$conflictingRoute" is already registered by another module.');
    }

    for (final String route in routePaths) {
      modulesByRoute[route] = module;
    }
  }

  void unregister(MiniAppModule module) {
    for (final route in module.routes) {
      if (modulesByRoute[route.path] == module) {
        modulesByRoute.remove(route.path);
      }
    }
  }

  void clear() {
    modulesByRoute.clear();
  }

  MiniAppModule? findByRoute(String? route) {
    if (route == null) return null;
    final String normalized = route.trim();
    if (normalized.isEmpty) return null;
    return modulesByRoute[normalized];
  }

  void registerAll(Iterable<MiniAppModule> modules) {
    for (final module in modules) {
      register(module);
    }
  }
}
