import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = 'bc512a416537dc1385d81ac34fd5941c';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(userToken: userToken, walletPaymentHandler: walletPaymentHandler);
}
