import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Backend-backed implementation of the IPS orders service.
class ApiOrdersService implements OrdersService {
  /// IPS backend facade.
  final IpsBackendApi api;

  /// Runtime backend config used for source FI code defaults.
  final SdkBackendConfig config;

  /// Session controller used to ensure login-session auth before calls.
  final MiniAppSessionController session;

  /// Creates the orders service.
  const ApiOrdersService({
    required this.api,
    required this.config,
    required this.session,
  });

  @override
  Future<ActionRes> cancelOrder(IpsOrder order) async {
    if (order.orderNo <= 0) {
      throw ApiIntegrationException(
        'Invalid IPS order number for order id: ${order.id}',
      );
    }

    await session.ensureLoginSession();
    final ActionResDto res = await api.cancelIpsOrder(
      orderNo: order.orderNo,
      packQty: order.packQty ?? 0,
      srcFiCode: config.runtime.defaultSrcFiCode,
    );

    return res.toDomain();
  }

  @override
  Future<ActionRes> createSellOrder(SellOrderReq req) async {
    await session.ensureLoginSession();
    final ActionResDto res = await api.createIpsSellOrder(
      req.packQty,
      srcFiCode: config.runtime.defaultSrcFiCode,
    );
    return res.toDomain();
  }

  @override
  Future<ActionRes> chargeIpsAcnt(RechargeReq req) async {
    await session.ensureLoginSession();
    final ActionResDto res = await api.chargeIpsAcnt(
      req.packQty,
      srcFiCode: config.runtime.defaultSrcFiCode,
    );
    return res.toDomain();
  }

  @override
  Future<List<IpsOrder>> getOrders() async {
    await session.ensureLoginSession();
    final List<IpsOrderDto> orders = await api.getIpsOrderList(
      srcFiCode: config.runtime.defaultSrcFiCode,
    );

    return orders
        .map((IpsOrderDto dto) => dto.toDomain())
        .toList(growable: false);
  }
}
