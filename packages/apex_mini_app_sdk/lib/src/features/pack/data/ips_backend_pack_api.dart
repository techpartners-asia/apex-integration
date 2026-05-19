import 'package:apex_mini_app_sdk/apex_mini_app_sdk_internal.dart';

extension IpsBackendPackApi on IpsBackendApi {
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
