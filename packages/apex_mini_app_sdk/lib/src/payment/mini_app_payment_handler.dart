import 'package:mini_app_sdk/apex_mini_app_sdk.dart';

typedef MiniAppWalletPaymentHandler = Future<MiniAppPaymentRes> Function(MiniAppPaymentReq request);

typedef MiniAppPaymentHandler = MiniAppWalletPaymentHandler;
