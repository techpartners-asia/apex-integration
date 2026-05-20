import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Order-specific backend calls on top of [IpsBackendApi].
extension IpsBackendOrdersApi on IpsBackendApi {
  /// Creates a sell order for the selected pack quantity.
  Future<ActionResDto> createIpsSellOrder(
    int packQty, {
    String? srcFiCode,
  }) async {
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

  /// Creates a recharge/charge request for the selected pack quantity.
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

  /// Loads IPS order history.
  Future<List<IpsOrderDto>> getIpsOrderList({
    String? srcFiCode,
    int packQty = 0,
  }) async {
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

  /// Cancels a pending IPS order.
  Future<ActionResDto> cancelIpsOrder({
    required int orderNo,
    int packQty = 0,
    String? srcFiCode,
  }) async {
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
