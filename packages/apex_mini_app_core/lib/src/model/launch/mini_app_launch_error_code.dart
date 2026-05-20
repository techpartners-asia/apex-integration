/// Machine-readable reasons why a route launch can fail.
enum MiniAppLaunchErrorCode {
  /// No registered module owns the requested route.
  routeNotFound,

  /// Launch request is missing required data or is otherwise invalid.
  invalidReq,

  /// Runtime error occurred while building or opening the route.
  runtimeError,

  /// Requested presentation mode is not supported by this runtime.
  unsupportedPresentation
  ;

  /// Short display title for diagnostics.
  String get title => switch (this) {
    routeNotFound => 'Route Not Found',
    invalidReq => 'Invalid Req',
    runtimeError => 'Runtime Error',
    unsupportedPresentation => 'Unsupported Presentation',
  };
}
