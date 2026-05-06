import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = 'f4887549b92ba54480fc9b39a6d5ba7e';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(userToken: userToken, walletPaymentHandler: walletPaymentHandler);
}
