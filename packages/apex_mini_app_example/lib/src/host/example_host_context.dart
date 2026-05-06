import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = '4802654c0655c4d21ad90c698d2c4226';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(userToken: userToken, walletPaymentHandler: walletPaymentHandler);
}
