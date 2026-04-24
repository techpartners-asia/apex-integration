import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = '0377bb5b9ec88f133358d87fcfb6857e';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(
    userToken: userToken,
    walletPaymentHandler: walletPaymentHandler,
  );
}
