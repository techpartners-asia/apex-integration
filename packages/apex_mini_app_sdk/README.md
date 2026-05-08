# Apex mini app SDK

Partner-facing Flutter SDK for the Apex investX mini app.

Host apps should import the curated SDK surface:

```dart
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
```

## Public entry points

- `ApexMiniAppSdk`: direct widget entry point, similar to `ZahiiMiniAppSdk`.
- `ApexMiniAppHostConfig`: host parameters such as token, URLs, locale, initial route, user data, and session data.
- `MiniAppSdk`: programmatic launcher for hosts that already own a Flutter app shell.
- `MiniAppWalletPaymentHandler`: callback the host implements for wallet/payment handoff.

## Direct widget integration

```dart
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';

void openMiniApp(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context);
  var miniAppOpen = true;

  navigator.push<void>(
    MaterialPageRoute<void>(
      builder: (_) => ApexMiniAppSdk(
        token: hostToken,
        baseUrl: 'https://api.admin.investx.mn',
        locale: const Locale('mn'),
        entryRoute: MiniAppRoutes.investX,
        userDataSourceMode: MiniAppUserDataSourceMode.contract,
        user: ApexMiniAppHostUser(
          registerNo: hostUser.registerNo,
          firstName: hostUser.firstName,
          lastName: hostUser.lastName,
          phone: hostUser.phone,
        ),
        walletPaymentHandler: (MiniAppWalletPaymentRequest request) async {
          return hostWallet.pay(request.invoiceId, amount: request.amount);
        },
        onClose: () {
          if (!miniAppOpen || !navigator.canPop()) return;
          miniAppOpen = false;
          navigator.pop();
        },
        onCloseWithResult: (result) => hostLogger.info('Apex closed: $result'),
        onTokenExpired: () => hostAuth.refreshAndReopen(),
        onNavigate: (route, arguments) => hostAnalytics.trackMiniAppRoute(route),
        onError: (error, stackTrace) => hostLogger.capture(error, stackTrace),
      ),
    ),
  ).whenComplete(() => miniAppOpen = false);
}
```

## Programmatic launcher

```dart
final sdk = MiniAppSdk(
  config: MiniAppSdkConfig.fromHostConfig(
    hostConfig: ApexMiniAppHostConfig(
      token: hostToken,
      locale: const Locale('mn'),
      initialRoute: MiniAppRoutes.investX,
    ),
    walletPaymentHandler: hostWalletPaymentHandler,
    callbacks: ApexMiniAppHostCallbacks(
      onClose: (result) => handleMiniAppClosed(result),
      onTokenExpired: refreshHostToken,
      onNavigate: trackMiniAppNavigation,
      onError: reportMiniAppError,
    ),
  ),
);

final MiniAppLaunchRes result = await sdk.launchRoute(context);
```

The SDK validates required host parameters before launch. Missing token,
invalid URLs, invalid initial route, expired session, bootstrap failures, and
network/auth failures are surfaced through fallback screens and host callbacks
where appropriate.
