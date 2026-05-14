import 'dart:ui';

import 'package:mini_app_sdk/apex_mini_app_sdk.dart';

const String exampleUserToken = '6ff8c996c4bd61366ff858a537ea7640';

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
