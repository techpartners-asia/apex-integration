import 'package:mini_app_core/mini_app_core.dart';

import 'mini_app_wallet_payment_request.dart';

typedef MiniAppWalletPaymentHandler =
    Future<MiniAppPaymentRes> Function(MiniAppWalletPaymentRequest request);

typedef MiniAppPaymentHandler = MiniAppWalletPaymentHandler;
