import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = '9274155afdb70e50822d0303823c4e24';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(userToken: userToken, walletPaymentHandler: walletPaymentHandler);
}
