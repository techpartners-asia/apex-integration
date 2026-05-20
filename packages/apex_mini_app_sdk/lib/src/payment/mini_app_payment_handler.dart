import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Host callback that performs wallet/payment work for a mini-app request.
typedef MiniAppWalletPaymentHandler =
    Future<MiniAppPaymentRes> Function(MiniAppPaymentReq request);

/// Backward-compatible alias for [MiniAppWalletPaymentHandler].
typedef MiniAppPaymentHandler = MiniAppWalletPaymentHandler;
