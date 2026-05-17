import 'dart:ui';

import 'package:mini_app_sdk/apex_mini_app_sdk.dart';

const String exampleUserToken = 'c6f0c7dcec5d787c77cc7aea3558100b';

const ApexMiniAppHostConfig exampleHostConfig = ApexMiniAppHostConfig(
  token: exampleUserToken,
  locale: Locale('mn'),
  entryRoute: MiniAppRoutes.investX,
  user: ApexMiniAppHostUser(
    registerNo: 'AB99112233',
    firstName: 'Apex',
    lastName: 'Host',
    phone: '99112233',
  ),
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
