import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Shared backend helper for IPS protected API extension methods.
class IpsBackendApi {
  /// Backend/runtime config used by endpoint helpers.
  final SdkBackendConfig backendConfig;

  /// Executor for protected IPS API calls.
  final ApiExecutor protectedExecutor;

  IpsBackendApi({required this.backendConfig, required this.protectedExecutor});

  /// Resolves a non-empty source FI code from [candidate] or runtime defaults.
  String resolveSrcFiCode(String? candidate) {
    final String resolved = candidate?.trim() ?? backendConfig.runtime.defaultSrcFiCode;
    if (resolved.isEmpty) {
      throw const ApiIntegrationException('A non-empty srcFiCode is required.');
    }

    return resolved;
  }
}
