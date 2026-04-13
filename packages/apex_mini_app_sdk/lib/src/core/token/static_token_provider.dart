import 'token_provider_contract.dart';

class StaticTokenProvider implements TokenProvider {
  final String? accessToken;

  const StaticTokenProvider(this.accessToken);

  @override
  Future<String?> getAccessToken() async => accessToken;
}
