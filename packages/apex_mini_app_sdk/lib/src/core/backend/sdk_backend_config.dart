export 'sdk_bootstrap_context.dart';
export 'sdk_contract_defaults.dart';
export 'sdk_portfolio_context.dart';

import 'sdk_bootstrap_context.dart';
import 'sdk_contract_defaults.dart';
import 'sdk_portfolio_context.dart';
import 'sdk_runtime_config.dart';

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
