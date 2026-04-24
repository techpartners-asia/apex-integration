import 'package:mini_app_sdk/mini_app_sdk.dart';

typedef MiniAppWalletPaymentHandler =
    Future<MiniAppPaymentRes> Function(MiniAppWalletPaymentRequest request);

typedef MiniAppPaymentHandler = MiniAppWalletPaymentHandler;
