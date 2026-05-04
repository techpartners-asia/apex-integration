import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = 'ffb5e46734dcf33b09e12c57cedf3e33';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(userToken: userToken, walletPaymentHandler: walletPaymentHandler);
}
