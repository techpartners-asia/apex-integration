import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test('loadPricing uses the focused IPS balance path', () async {
    final _FakePortfolioService portfolioService = _FakePortfolioService(
      overview: const PortfolioOverview(
        currency: 'MNT',
        packAmount: 120000,
        packFee: 1500,
      ),
    );
    final IpsRechargeCubit cubit = IpsRechargeCubit(
      service: _FakeOrdersService(),
      portfolioService: portfolioService,
      paymentExecutor: _FakePaymentExecutor(
        result: MiniAppPaymentRes.success(
          req: MiniAppPaymentReq(
            flow: MiniAppPaymentFlow.ipsRecharge,
            invoiceId: '',
            amount: 0,
            note: '',
            paymentRecordId: 0,
            isTransaction: true,
          ),
        ),
      ),
      l10n: lookupSdkLocalizations(const Locale('en')),
    );

    await cubit.loadPricing();

    expect(portfolioService.getIpsBalanceCallCount, 1);
    expect(portfolioService.getOverviewCallCount, 0);
    expect(cubit.state.unitPrice, 120000);
    expect(cubit.state.serviceFee, 1500);
  });

  test(
    'loadPricing resolves bootstrap-backed portfolio context when available',
    () async {
      final _FakePortfolioService portfolioService = _FakePortfolioService(
        overview: const PortfolioOverview(
          currency: 'MNT',
          packAmount: 90000,
          packFee: 1000,
        ),
      );
      final IpsRechargeCubit cubit = IpsRechargeCubit(
        service: _FakeOrdersService(),
        portfolioService: portfolioService,
        bootstrapService: _FakeBootstrapService(
          state: const AcntBootstrapState(
            response: GetSecuritiesAcntListResDto(
              detail: GetSecuritiesAcntListDetailDto(
                hasAcnt: true,
                hasIpsAcnt: true,
                brokerCode: 'DETAIL-BROKER',
              ),
              acnts: <GetSecAcntListAccountDto>[
                GetSecAcntListAccountDto(
                  flag: 3,
                  brokerId: 'BROKER-1',
                ),
                GetSecAcntListAccountDto(
                  flag: 12,
                  acntId: 77,
                  statementMaxDay: '7',
                ),
              ],
              stlAcnts: <GetSecAcntSettlementAccountDto>[],
              responseCode: 0,
            ),
          ),
        ),
        paymentExecutor: _FakePaymentExecutor(
          result: MiniAppPaymentRes.success(
            req: MiniAppPaymentReq(
              flow: MiniAppPaymentFlow.ipsRecharge,
              invoiceId: '',
              amount: 0,
              note: '',
              paymentRecordId: 0,
              isTransaction: true,
            ),
          ),
        ),
        l10n: lookupSdkLocalizations(const Locale('en')),
      );

      await cubit.loadPricing();

      expect(portfolioService.lastContext?.normalizedBrokerId, 'BROKER-1');
      expect(portfolioService.lastContext?.normalizedCasaAcntId, 77);
      expect(cubit.state.unitPrice, 90000);
      expect(cubit.state.serviceFee, 1000);
      expect(cubit.state.canSubmit, isFalse);
    },
  );

  test('submit refreshes IPS balance after charge success', () async {
    final _FakeOrdersService ordersService = _FakeOrdersService();
    final _FakePortfolioService portfolioService = _FakePortfolioService(
      overview: const PortfolioOverview(
        currency: 'MNT',
        availableBalance: 1500,
        investedBalance: 3000,
      ),
    );
    final IpsRechargeCubit cubit = IpsRechargeCubit(
      service: ordersService,
      portfolioService: portfolioService,
      paymentExecutor: _FakePaymentExecutor(
        result: MiniAppPaymentRes.success(
          req: MiniAppPaymentReq(
            flow: MiniAppPaymentFlow.ipsRecharge,
            invoiceId: '',
            amount: 0,
            note: '',
            paymentRecordId: 0,
            isTransaction: true,
          ),
        ),
      ),
      l10n: lookupSdkLocalizations(const Locale('en')),
      unitPrice: 150000,
      serviceFee: 2500,
    );

    cubit.updatePackQty('3');
    await cubit.submit();

    final IpsRechargeState state = cubit.state;
    expect(ordersService.chargeCallCount, 1);
    expect(portfolioService.getIpsBalanceCallCount, 1);
    expect(state.paymentRes?.status, MiniAppPaymentStatus.success);
    expect(state.refreshedOverview?.availableBalance, 1500);
    expect(state.refreshedOverview?.investedBalance, 3000);
    expect(state.errorMessage, isNull);
  });
}

class _FakeOrdersService implements OrdersService {
  int chargeCallCount = 0;

  @override
  Future<ActionRes> chargeIpsAcnt(RechargeReq req) async {
    chargeCallCount += 1;
    return const ActionRes(message: 'ok');
  }

  @override
  Future<ActionRes> cancelOrder(IpsOrder order) {
    throw UnimplementedError();
  }

  @override
  Future<ActionRes> createSellOrder(SellOrderReq req) {
    throw UnimplementedError();
  }

  @override
  Future<List<IpsOrder>> getOrders() {
    throw UnimplementedError();
  }
}

class _FakePortfolioService implements PortfolioService {
  _FakePortfolioService({required this.overview});

  final PortfolioOverview overview;
  int getIpsBalanceCallCount = 0;
  int getOverviewCallCount = 0;
  SdkPortfolioContext? lastContext;

  @override
  Future<PortfolioOverview> getIpsBalance({
    SdkPortfolioContext? context,
  }) async {
    getIpsBalanceCallCount += 1;
    lastContext = context;
    return overview;
  }

  @override
  Future<PortfolioDashboardData> getDashboardData({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<List<PortfolioHolding>> getHoldings({SdkPortfolioContext? context}) {
    throw UnimplementedError();
  }

  @override
  Future<PortfolioOverview> getOverview({SdkPortfolioContext? context}) async {
    getOverviewCallCount += 1;
    return overview;
  }

  @override
  Future<PortfolioStatementsData> getStatements({
    SdkPortfolioContext? context,
  }) {
    throw UnimplementedError();
  }
}

class _FakeBootstrapService implements InvestmentBootstrapService {
  _FakeBootstrapService({required this.state});

  final AcntBootstrapState state;

  @override
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) async {
    return state;
  }

  @override
  Future<AcntBootstrapState> getSecAcntListState({
    bool forceRefresh = false,
  }) async {
    return state;
  }
}

class _FakeMiniAppApiRepository implements MiniAppApiRepository {
  const _FakeMiniAppApiRepository();

  @override
  Future<FeedbackEntity> createFeedback(CreateFeedbackApiReq req) {
    // TODO: implement createFeedback
    throw UnimplementedError();
  }

  @override
  Future<MiniAppPayment> createInvoice(CreateInvoiceApiReq req) {
    // TODO: implement createInvoice
    throw UnimplementedError();
  }

  @override
  Future<BranchInfoEntity> getCompanyInfo({bool forceRefresh = false}) {
    // TODO: implement getCompanyInfo
    throw UnimplementedError();
  }

  @override
  Future<FeedbackListResponse> getFeedbackList({
    required int limit,
    required int page,
    bool forceRefresh = false,
  }) {
    // TODO: implement getFeedbackList
    throw UnimplementedError();
  }

  @override
  Future<String> getPaymentCallback({required String uuid}) {
    // TODO: implement getPaymentCallback
    throw UnimplementedError();
  }

  @override
  Future<List<QuestionnaireQuestion>> getAllGoals() {
    // TODO: implement getAllGoals
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> getProfileInfo() {
    // TODO: implement getProfileInfo
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateProfile(UpdateProfileApiReq req) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateSignature({
    required Uint8List bytes,
    String fileName = 'signature.png',
  }) {
    // TODO: implement updateSignature
    throw UnimplementedError();
  }

  @override
  Future<UserEntityDto> updateTargetGoal(UpdateTargetGoalApiReq req) {
    // TODO: implement updateTargetGoal
    throw UnimplementedError();
  }

  // implement required methods
}

class _FakePaymentExecutor extends MiniAppPaymentExecutor {
  _FakePaymentExecutor({required this.result})
    : super(
        appApi: const _FakeMiniAppApiRepository(),
        walletPaymentHandler: _unusedWalletHandler,
      );

  final MiniAppPaymentRes result;

  @override
  Future<MiniAppPaymentRes> execute({
    required MiniAppPaymentFlow flow,
    required CreateInvoiceApiReq invoiceRequest,
  }) async {
    return result;
  }

  static Future<MiniAppPaymentRes> _unusedWalletHandler(
    MiniAppPaymentReq request,
  ) async {
    return MiniAppPaymentRes.unknown(
      req: MiniAppPaymentReq(
        flow: MiniAppPaymentFlow.ipsRecharge,
        invoiceId: '',
        amount: 0,
        note: '',
        paymentRecordId: 0,
        isTransaction: true,
      ),
    );
  }
}
