import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

class StaticTokenProvider implements TokenProvider {
  final String? accessToken;

  const StaticTokenProvider(this.accessToken);

  @override
  Future<String?> getAccessToken() async => accessToken;
}
