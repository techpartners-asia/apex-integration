# Apex Mini App SDK холбох заавар

Зөвхөн public SDK import-ыг ашиглана:

```dart
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
```

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
  mini_app_sdk:
    git:
      url: https://github.com/techpartners-asia/apex-integration.git
      path: packages/apex_mini_app_sdk
      ref: v0.0.1
```

Дараа нь:

```sh
flutter pub get
```

### `callbacks`

Callback-уудыг `ApexMiniAppSdk` руу шууд дамжуулна:

- `onClose`
- `onCloseWithResult`
- `onNavigate`
- `onError`
- `onTokenExpired`

### `walletPaymentHandler`

Заавал шаардлагатай. Mini app төлбөр эсвэл гүйлгээ хийх шаардлагатай үед энэ handler-ийг дуудна.

Handler нь `MiniAppPaymentRes` буцаах ёстой.

## 3. Үндсэн integration жишээ

## Example `pubspec.yaml`

```yaml
dependencies:
  flutter:
    sdk: flutter

  mini_app_sdk:
    git:
      url: https://github.com/techpartners-asia/apex-integration.git
      path: packages/apex_mini_app_sdk
      ref: v0.0.1
```

```dart
import 'package:flutter/material.dart';
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';

void openApexMiniApp(BuildContext context) {
  final NavigatorState navigator = Navigator.of(context);
  var isMiniAppOpen = true;

  navigator
      .push<void>(
        MaterialPageRoute<void>(
          settings: const RouteSettings(name: 'apex-mini-app'),
          builder: (_) {
            return ApexMiniAppSdk(
              token: hostToken,
              baseUrl: 'https://your-api.example.com',
              locale: const Locale('mn'),
              entryRoute: MiniAppRoutes.investX,
              userDataSourceMode: MiniAppUserDataSourceMode.realUser,
              user: ApexMiniAppHostUser(
                id: hostUser.id,
                registerNo: hostUser.registerNo,
                firstName: hostUser.firstName,
                lastName: hostUser.lastName,
                phone: hostUser.phone,
                email: hostUser.email,
              ),
              session: ApexMiniAppHostSession(
                accessToken: hostSession.accessToken,
                customerToken: hostSession.customerToken,
                neSession: hostSession.neSession,
              ),
              walletPaymentHandler: (MiniAppWalletPaymentRequest request) async {
                final bool paid = await hostWallet.pay(
                  invoiceId: request.invoiceId,
                  amount: request.amount,
                  description: request.note,
                );

                if (paid) {
                  return MiniAppPaymentRes.success(
                    isTransaction: request.isTransaction,
                    paymentReference: request.invoiceId,
                  );
                }

                return MiniAppPaymentRes.failed(
                  isTransaction: request.isTransaction,
                  message: 'Payment failed.',
                );
              },
              onClose: () {
                if (!isMiniAppOpen || !navigator.canPop()) {
                  return;
                }
                isMiniAppOpen = false;
                navigator.pop();
              },
              onCloseWithResult: (Object? result) {
                debugPrint('Apex mini app closed with result: $result');
              },
              onNavigate: (String? route, Object? arguments) {
                debugPrint('Apex mini app route: $route');
              },
              onTokenExpired: () {
                // Host auth state цэвэрлэх эсвэл token refresh хийх.
                // Шинэ token авсны дараа шаардлагатай бол mini app-ийг дахин нээнэ.
              },
              onError: (Object error, StackTrace? stackTrace) {
                debugPrint('Apex mini app error: $error');
              },
            );
          },
        ),
      )
      .whenComplete(() {
        isMiniAppOpen = false;
      });
}
```

## 4. Payment Flow

Mini app дараах үед payment хүснэ:

- IPS recharge.
- Securities account opening payment.

Host app `MiniAppWalletPaymentRequest` object хүлээн авна. Үүнд:

- `flow`
- `invoiceId`
- `amount`
- `note`
- `refId`
- `paymentRecordId`
- `externalInvoiceId`
- `uuid`
- `isTransaction`