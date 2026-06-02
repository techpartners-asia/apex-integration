/// [RequestOptions.extra] keys used by [BackendLoggerInterceptor].
abstract final class BackendLoggerRequestExtra {
  /// Operation name from [ReqContext.operName].
  static const String operName = 'backendLoggerOperName';

  /// When true, the backend logger interceptor skips this request.
  static const String skip = 'backendLoggerSkip';

  const BackendLoggerRequestExtra._();
}
