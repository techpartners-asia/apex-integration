import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Aggregated backend/runtime configuration for the mini app.
class SdkBackendConfig {
  /// Runtime API URLs, credentials, token, and logging options.
  final SdkRuntimeConfig runtime;

  /// Optional user/bootstrap values.
  final SdkBootstrapContext bootstrap;

  /// Optional portfolio/account context.
  final SdkPortfolioContext portfolio;

  /// Optional contract/payment defaults.
  final SdkContractDefaults contract;

  /// Creates the aggregate backend config object used by repositories.
  const SdkBackendConfig({
    required this.runtime,
    this.bootstrap = const SdkBootstrapContext(),
    this.portfolio = const SdkPortfolioContext(),
    this.contract = const SdkContractDefaults(),
  });

  /// Creates backend config from current static/host runtime values.
  factory SdkBackendConfig.fromConfig({
    SdkRuntimeConfig? runtime,
  }) {
    return SdkBackendConfig(
      runtime: runtime ?? SdkRuntimeConfig.fromConfig(),
      bootstrap: const SdkBootstrapContext(),
      portfolio: const SdkPortfolioContext(),
      contract: const SdkContractDefaults(),
    );
  }
}
