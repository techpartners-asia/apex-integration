import 'dart:ui';

import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

const String exampleUserToken = '65781c9fbbfdf7d6d8cc9c965326e37a';

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
