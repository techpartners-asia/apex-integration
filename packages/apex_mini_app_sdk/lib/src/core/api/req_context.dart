/// Per-request metadata used by [ApiExecutor].
class ReqContext {
  /// Optional operation name for diagnostics/error messages.
  final String? operName;

  /// Extra headers merged into standard app/token headers.
  final Map<String, String> extraHeaders;

  /// Token override for this request only.
  final String? accessTokenOverride;

  /// Creates per-request API metadata.
  const ReqContext({
    this.operName,
    this.extraHeaders = const <String, String>{},
    this.accessTokenOverride,
  });
}
