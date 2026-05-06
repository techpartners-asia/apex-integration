import 'package:mini_app_sdk/mini_app_sdk.dart';

class ApiInvestmentBootstrapService implements InvestmentBootstrapService {
  static const Duration _secAcntListCacheTtl = Duration(minutes: 2);

  final IpsBackendApi api;
  final SdkBackendConfig config;
  final MiniAppSessionController session;
  final FiBomInstRepository fiBomInstRepository;
  final TimedMemoryCache<GetSecuritiesAcntListResDto> _secAcntListCache;

  String? _secAcntListCacheScope;

  ApiInvestmentBootstrapService({
    required this.api,
    required this.config,
    required this.session,
    required this.fiBomInstRepository,
    TimedMemoryCache<GetSecuritiesAcntListResDto>? secAcntListCache,
  }) : _secAcntListCache =
           secAcntListCache ??
           TimedMemoryCache<GetSecuritiesAcntListResDto>(
             ttl: _secAcntListCacheTtl,
           );

  @override
  Future<AcntBootstrapState> getSecAcntListState({
    bool forceRefresh = false,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;
    final SdkBootstrapContext bootstrap = config.bootstrap;
    final UserEntityDto user = await session.ensureCurrentUser();
    final String registerCode = bootstrap.registerCode ?? user.registerNo ?? '';
    final String phone = bootstrap.phone ?? user.phone ?? '';
    final String cacheScope = _cacheScope(
      registerCode: registerCode,
      phone: phone,
    );

    if (_secAcntListCacheScope != cacheScope) {
      _secAcntListCache.invalidate();
      _secAcntListCacheScope = cacheScope;
    }

    final GetSecuritiesAcntListResDto secAcntList = await _secAcntListCache.getOrLoad(
      () async {
        await session.ensureLoginSession();
        return api.getSecuritiesAcntList(
          GetSecuritiesAcntListApiReq(
            registerCode: registerCode.isNotNullOrEmpty ? registerCode : LoginSessionContract.registerNo,
            mobile: phone,
            acnts: bootstrap.secAcntCode == null ? const <String>[] : <String>[bootstrap.secAcntCode!],
            srcFiCode: runtime.defaultSrcFiCode,
          ),
        );
      },
      forceRefresh: forceRefresh,
    );

    return AcntBootstrapState(response: secAcntList);
  }

  @override
  Future<AcntBootstrapState> getSecAcntBalanceState({required AcntBootstrapState currentState}) async {
    final SdkRuntimeConfig runtime = config.runtime;

    await session.ensureLoginSession();
    final GetSecuritiesAcntListResDto balanceState = await api.getSecAcntBalState(
      GetSecAcntBalApiReq(srcFiCode: runtime.defaultSrcFiCode, flag: 3),
    );

    return currentState.copyWithBalanceState(balanceState);
  }

  @override
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;
    final SdkContractDefaults contract = config.contract;
    final String? enteredIban = _normalizedValue(personalInfo?.iban);
    final String? enteredBankCode = _normalizedValue(personalInfo?.bankCode);
    final String? enteredBankLabel = _normalizedValue(personalInfo?.bankLabel);
    await session.ensureLoginSession();
    final FiBomInstDto fiBomInst = await fiBomInstRepository.getDefaultFiBomInst();

    final AddSecuritiesAcntResDto response = await api.addSecuritiesAcntReq(
      AddSecuritiesAcntApiReq(
        srcFiCode: runtime.defaultSrcFiCode,
        bankCode: enteredBankCode ?? fiBomInst.fiCode,
        bankAcntCode: enteredIban ?? contract.bankAcntCode,
        bankAcntName: enteredBankLabel ?? contract.bankAcntName,
      ),
    );
    _secAcntListCache.invalidate();

    return response.toDomain();
  }

  String _cacheScope({
    required String registerCode,
    required String phone,
  }) {
    return <String>[
      session.userToken?.trim() ?? '',
      registerCode.trim(),
      phone.trim(),
    ].join('|');
  }

  String? _normalizedValue(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
