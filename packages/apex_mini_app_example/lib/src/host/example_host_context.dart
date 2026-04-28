import 'package:mini_app_sdk/mini_app_sdk.dart';

const String exampleUserToken = 'ac966ed400b0f93bcc66e4628c9044cb';

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  String userToken = exampleUserToken,
}) {
  return MiniAppSdkConfig(
    userToken: userToken,
    walletPaymentHandler: walletPaymentHandler,
  );
}
