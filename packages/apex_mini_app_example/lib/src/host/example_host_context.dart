import 'dart:ui';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

const String exampleUserToken = '67a0be76dc551a88f24006c177475ebb';

const ApexMiniAppHostConfig exampleHostConfig = ApexMiniAppHostConfig(
  token: exampleUserToken,
  locale: Locale('mn'),
  entryRoute: MiniAppRoutes.investX,
  user: ApexMiniAppHostUser(
    // registerNo: 'AB99112233',
    // firstName: 'Apex',
    // lastName: 'Host',
    // phone: '99112233',
  ),
  devMode: false,
);

MiniAppSdkConfig buildExampleMiniAppSdkConfig({
  required MiniAppWalletPaymentHandler walletPaymentHandler,
  ApexMiniAppHostConfig hostConfig = exampleHostConfig,
  ApexMiniAppHostCallbacks callbacks = ApexMiniAppHostCallbacks.empty,
}) {
  return MiniAppSdkConfig.fromHostConfig(
    hostConfig: hostConfig,
    walletPaymentHandler: walletPaymentHandler,
    callbacks: callbacks,
    userDataSourceMode: MiniAppUserDataSourceMode.realUser,
  );
}
