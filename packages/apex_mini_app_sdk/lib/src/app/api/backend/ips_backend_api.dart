import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

class IpsBackendApi {
  final SdkBackendConfig backendConfig;
  final ApiExecutor protectedExecutor;

  IpsBackendApi({required this.backendConfig, required this.protectedExecutor});

  String resolveSrcFiCode(String? candidate) {
    final String resolved =
        candidate?.trim() ?? backendConfig.runtime.defaultSrcFiCode;
    if (resolved.isEmpty) {
      throw const ApiIntegrationException('A non-empty srcFiCode is required.');
    }

    return resolved;
  }
}
