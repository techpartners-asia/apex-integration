# mini_app_example

Reference host app for `mini_app_sdk`.

The example demonstrates the intended host integration shape:

- opens `ApexMiniAppSdk` directly from the host app
- pushes the SDK on the host navigator from `openMiniApp`
- passes a host token, locale, and initial route
- enables `MiniAppUserDataSourceMode.contract`
- implements `MiniAppWalletPaymentHandler`
- receives close, navigation, token-expired, error, and payment result events
- opens the active `investX` mini app entry flow directly
