# mini_app_sdk

Partner-facing Flutter SDK for the sec/IPS mini app.

## Public API intent

The public integration surface is intentionally small:

 `MiniAppSdk`
 `MiniAppSdkConfig`
 `MiniAppPaymentHandler`
 `MiniAppPaymentRes`
 `MiniAppRoutes`

The host app should not provide:

 DAN/KYC/session/region state
 launch guards
 deep-link/session-refresh callbacks
 invoice provider logic
 broad host service bundles

## Minimal integration

```dart
final sdk = MiniAppSdk(
 config: MiniAppSdkConfig(
 paymentHandler: (String invoiceId, {double? amount}) async {
 return hostWalletPay(invoiceId, amount: amount);
 },
 ),
);

await sdk.launchRoute(
 context,
 route: MiniAppRoutes.investX,
);
```

`MiniAppRoutes` is the stable public launch contract.
`launchRoute()` defaults to `MiniAppRoutes.investX`.
`launchInvestX()` is the convenience helper for the active mini app.

## Launch model

Launch is permissive by default.
The SDK does not block launch based on DAN/KYC/session/region checks.

## Payment model

1.SDK reaches a payment step.
2.SDK prepares its own invoice/payment reference internally.
3.SDK calls `paymentHandler(invoiceId, amount: amount)`.
4.Host wallet executes payment.
5.Host returns `MiniAppPaymentRes`.
6.SDK continues its internal flow based on the returned res.

## Remote API usage

Backend URL, `APPID`, `APPSECRET`, `NESSESSION`, and IPS defaults are read
from the SDK-owned static config in
`lib/src/core/api/api_config.dart`.

The SDK fetches the current user internally, then bootstraps
`getLoginSession()`, and then reuses the returned `accessToken` for protected
IPS APIs.The embedded backend path is enabled directly from those static
config values.If the current-user bootstrap is unavailable, the SDK still
launches and falls back only through the temporary mock current-user path.

The SDK runtime now only includes the active `investX` flow.
Host-side presentation behavior is SDK-owned and fixed; there is no
