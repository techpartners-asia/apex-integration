class ReqContext {
  final String? operName;
  final Map<String, String> extraHeaders;
  final String? accessTokenOverride;

  const ReqContext({
    this.operName,
    this.extraHeaders = const <String, String>{},
    this.accessTokenOverride,
  });
}
