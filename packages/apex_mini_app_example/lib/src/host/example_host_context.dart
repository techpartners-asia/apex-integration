import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = '1b18aa6ee9e657a9cda7de8d73edb66c';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(
    userToken: userToken,
    walletPaymentHandler: walletPaymentHandler,
  );
}
