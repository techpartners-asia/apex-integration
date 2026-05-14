import 'dart:ui';

import 'package:mini_app_sdk/apex_mini_app_sdk.dart';

const String exampleUserToken = 'c486815d1ec2c1f522574d648a2f9d1b';

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
