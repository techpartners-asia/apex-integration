enum MiniAppLaunchErrorCode {
  routeNotFound,
  invalidReq,
  runtimeError,
  unsupportedPresentation
  ;

  String get title => switch (this) {
    routeNotFound => 'Route Not Found',
    invalidReq => 'Invalid Req',
    runtimeError => 'Runtime Error',
    unsupportedPresentation => 'Unsupported Presentation',
  };
}
