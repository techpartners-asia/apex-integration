import '../../../../../core/api/api_endpoints.dart';
import '../../../../../core/api/req_context.dart';
import '../dto/ips_response_dtos.dart';
import '../req/cancel_ips_order_api_req.dart';
import '../req/charge_ips_acnt_api_req.dart';
import '../req/create_ips_sell_order_api_req.dart';
import '../req/get_ips_order_list_api_req.dart';
import 'ips_backend_api_base.dart';

extension IpsBackendOrdersApi on IpsBackendApi {
  Future<ActionResDto> createIpsSellOrder(int packQty, {String? srcFiCode}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.createIpsSellOrder,
      body: CreateIpsSellOrderApiReq(
        srcFiCode: resolveSrcFiCode(srcFiCode),
        packQty: packQty,
      ).toJson(),
      context: const ReqContext(operName: 'createIpsSellOrder'),
    );

    return ActionResDto.fromJson(
      json,
      failureMessage: 'Failed to create the IPS sell order.',
    );
  }

  Future<ActionResDto> chargeIpsAcnt(int packQty, {String? srcFiCode}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.chargeIpsAcnt,
      body: ChargeIpsAcntApiReq(
        srcFiCode: resolveSrcFiCode(srcFiCode),
        packQty: packQty,
        wallet: 'APEXTINO',
      ).toJson(),
      context: const ReqContext(operName: 'chargeIpsAcnt'),
    );

    return ActionResDto.fromJson(
      json,
      failureMessage: 'Failed to create the IPS charge request.',
    );
  }

  Future<List<IpsOrderDto>> getIpsOrderList({String? srcFiCode, int packQty = 0}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.getIpsOrderList,
      body: GetIpsOrderListApiReq(
        srcFiCode: resolveSrcFiCode(srcFiCode),
        packQty: packQty,
      ).toJson(),
      context: const ReqContext(operName: 'getIpsOrderList'),
    );

    return IpsOrderDto.listFromResponse(json);
  }

  Future<ActionResDto> cancelIpsOrder({required int orderNo, int packQty = 0, String? srcFiCode}) async {
    final Map<String, Object?> json = await protectedExecutor.postJson(
      ApiEndpoints.cancelIpsOrder,
      body: CancelIpsOrderApiReq(
        srcFiCode: resolveSrcFiCode(srcFiCode),
        packQty: packQty,
        orderNo: orderNo,
      ).toJson(),
      context: const ReqContext(operName: 'cancelIpsOrder'),
    );

    return ActionResDto.fromJson(
      json,
      failureMessage: 'Failed to cancel the IPS order.',
    );
  }
}
