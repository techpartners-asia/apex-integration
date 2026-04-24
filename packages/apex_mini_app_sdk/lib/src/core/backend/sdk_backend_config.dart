import 'package:mini_app_sdk/mini_app_sdk.dart';

class SdkBackendConfig {
  final SdkRuntimeConfig runtime;
  final SdkBootstrapContext bootstrap;
  final SdkPortfolioContext portfolio;
  final SdkContractDefaults contract;

  const SdkBackendConfig({
    required this.runtime,
    this.bootstrap = const SdkBootstrapContext(),
    this.portfolio = const SdkPortfolioContext(),
    this.contract = const SdkContractDefaults(),
  });

  factory SdkBackendConfig.fromConfig() {
    return SdkBackendConfig(
      runtime: SdkRuntimeConfig.fromConfig(),
      bootstrap: const SdkBootstrapContext(),
      portfolio: const SdkPortfolioContext(),
      contract: const SdkContractDefaults(),
    );
  }
}
