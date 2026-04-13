# mini_app_example

Reference host app for `_mini_app_sdk`.

This package is not the product SDK.It demonstrates the intended partner integration shape:

 create `MiniAppSdkConfig`
 pass a single `paymentHandler`
 let the SDK fetch the current user internally before `getLoginSession()`
 open the single `investX` mini app entry flow directly

The example does not provide DAN/KYC/session/region gating and does not provide invoice creation logic from the host side.
