import 'package:mini_app_ui/mini_app_ui.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

enum MiniAppUserDataSourceMode {
  contract,
  realUser,
}

class MiniAppSdkConfig {
  static const Duration defaultPaymentTimeout = Duration(seconds: 45);

  final String? userToken;
  final MiniAppWalletPaymentHandler walletPaymentHandler;
  final Duration paymentTimeout;
  final MiniAppLogger logger;
  final MiniAppUserDataSourceMode userDataSourceMode;

  const MiniAppSdkConfig({
    this.userToken,
    required this.walletPaymentHandler,
    this.paymentTimeout = defaultPaymentTimeout,
    this.logger = const DebugMiniAppLogger(),
    this.userDataSourceMode = MiniAppUserDataSourceMode.contract,
  }) : assert(
         paymentTimeout > Duration.zero,
         'paymentTimeout must be greater than zero.',
       );

  MiniAppSdkConfig copyWith({
    String? userToken,
    MiniAppWalletPaymentHandler? walletPaymentHandler,
    Duration? paymentTimeout,
    MiniAppLogger? logger,
    MiniAppUserDataSourceMode? userDataSourceMode,
  }) {
    return MiniAppSdkConfig(
      userToken: userToken ?? this.userToken,
      walletPaymentHandler: walletPaymentHandler ?? this.walletPaymentHandler,
      paymentTimeout: paymentTimeout ?? this.paymentTimeout,
      logger: logger ?? this.logger,
      userDataSourceMode: userDataSourceMode ?? this.userDataSourceMode,
    );
  }
}
