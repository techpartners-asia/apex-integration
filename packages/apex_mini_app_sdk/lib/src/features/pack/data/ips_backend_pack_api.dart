import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Pack-specific backend calls on top of [IpsBackendApi].
extension IpsBackendPackApi on IpsBackendApi {
  /// Loads investment packs for the resolved source FI code.
  Future<List<PackDto>> getPacks({String? srcFiCode}) async {
    final ApiEnvelope<List<PackDto>> envelope = await protectedExecutor
        .postEnvelope<List<PackDto>>(
          ApiEndpoints.getPack,
          body: <String, Object?>{'srcFiCode': resolveSrcFiCode(srcFiCode)},
          mapper: PackDto.listFromRaw,
          context: const ReqContext(operName: 'getPack'),
        );

    return envelope.responseData;
  }
}
