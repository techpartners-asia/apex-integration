# Apex Mini App SDK холбох заавар

Зөвхөн public SDK import-ыг ашиглана:

```dart
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
```

> **Upgrading from v0.0.3?** Package нэрс өөрчлөгдсөн (бусад mini app SDK-уудтай нэр давхцахаас сэргийлэх зорилгоор):
>
> - `mini_app_sdk` → `apex_mini_app_sdk`
> - `mini_app_core` → `apex_mini_app_core`
> - `mini_app_ui` → `apex_mini_app_ui`
>
> `pubspec.yaml` болон бүх Dart import-уудаа шинэ нэрэнд шилжүүлнэ үү.

## 1. Overview

Host app дараах мэдээллийг өгнө:

- Хүчинтэй хэрэглэгчийн token.
- Environment/base URL тохиргоо.
- Locale буюу хэлний тохиргоо.
- Боломжтой бол хэрэглэгч болон session мэдээлэл.
- Close, navigation, token expiration, error, payment callback-ууд.
- Mini app төлбөр/гүйлгээ хийх шаардлагатай үед wallet/payment handler.

## 2. Installation / Setup

Host app-ийн `pubspec.yaml` файлд SDK package-ийг нэмнэ.

```yaml
dependencies:
  apex_mini_app_sdk:
    git:
      url: https://github.com/techpartners-asia/apex-integration.git
      path: packages/apex_mini_app_sdk
      ref: v0.1.0
```

Дараа нь:

```sh
flutter pub get
```

### `callbacks`

Callback-уудыг `ApexMiniAppSdk` руу шууд дамжуулна:

- `onNavigate`
- `onError`
- `onTokenExpired`

### `walletPaymentHandler`

Заавал шаардлагатай. Mini app төлбөр эсвэл гүйлгээ хийх шаардлагатай үед энэ handler-ийг дуудна.

Handler нь `MiniAppPaymentRes` буцаах ёстой.

## 3. Үндсэн integration жишээ

Host app can open the mini app from any screen, for example when the user taps a button.

### Example: Open Mini App from a Button

```dart
import 'package:flutter/material.dart';
import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

class HostHomePage extends StatefulWidget {
  const HostHomePage({super.key});

  @override
  State<HostHomePage> createState() => _HostHomePageState();
}

class _HostHomePageState extends State<HostHomePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> miniAppNavigatorKey =
  GlobalKey<NavigatorState>();

  bool _miniAppRouteOpen = false;

  late final ApexMiniAppHostConfig hostConfig;

  @override
  void initState() {
    super.initState();

    hostConfig = ApexMiniAppHostConfig(
        token: '<USER_TOKEN>'
    );
  }

  void openMiniApp() {
    if (_miniAppRouteOpen) {
      return;
    }

    final NavigatorState? navigator = navigatorKey.currentState;

    if (navigator == null) {
      debugPrint('Mini app open failed: host navigator unavailable');
      return;
    }

    _miniAppRouteOpen = true;

    navigator
        .push<void>(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: 'apex-mini-app'),
        builder: (BuildContext context) {
          return ApexMiniAppSdk.config(
            hostConfig: hostConfig,
            navigatorKey: miniAppNavigatorKey,
            onTokenExpired: () {
              debugPrint('Mini app token expired');
            },
            onNavigate: (String? route, Object? arguments) {
              debugPrint('Mini app navigate: $route');
            },
            onError: (Object error, StackTrace? stackTrace) {
              debugPrint('Mini app error: $error');
            },
            walletPaymentHandler: (MiniAppPaymentReq request) async {
              final bool paid = await hostWallet.pay(
                invoiceId: request.invoiceId,
                amount: request.amount,
                description: request.note,
              );

              if (paid) {
                return MiniAppPaymentRes.success(
                  message: 'Payment success.',
                  req: request,
                );
              }

              return MiniAppPaymentRes.failed(
                message: 'Payment failed.',
                req: request,
              );
            },
          );
        },
      ),
    )
        .whenComplete(() {
      _miniAppRouteOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Host App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: openMiniApp,
            child: const Text('Open Mini App'),
          ),
        ),
      ),
    );
  }
}
```

## 4. Payment Flow

Mini app дараах үед payment хүснэ:

- IPS recharge.
- Securities account opening payment.

Host app `MiniAppPaymentReq` object хүлээн авна. Үүнд:

- `flow` — `MiniAppPaymentFlow.ipsRecharge` эсвэл `MiniAppPaymentFlow.secAcntOpening`
- `invoiceId`
- `amount`
- `note`
- `paymentRecordId`
- `externalInvoiceId` (optional)
- `uuid` (optional)
- `isTransaction`
