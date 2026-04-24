import 'package:mini_app_sdk/mini_app_sdk.dart';

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
