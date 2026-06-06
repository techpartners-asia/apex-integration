import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// API-backed implementation of securities-account startup/onboarding checks.
class ApiInvestmentBootstrapService implements InvestmentBootstrapService {
  /// Cache lifetime for securities-account list bootstrap responses.
  static const Duration _secAcntListCacheTtl = Duration(minutes: 2);

  /// Protected IPS backend API.
  final IpsBackendApi api;

  /// SDK backend/runtime configuration.
  final SdkBackendConfig config;

  /// Session controller used to load users and protected login sessions.
  final MiniAppSessionController session;

  /// Repository used to resolve default source FI data.
  final FiBomInstRepository fiBomInstRepository;

  /// User data source mode used when building account-list requests.
  final MiniAppUserDataSourceMode userDataSourceMode;

  /// Cached account-list response keyed by current launch identity.
  final TimedMemoryCache<GetSecuritiesAcntListResDto> _secAcntListCache;

  /// Scope key for the current cached account-list response.
  String? _secAcntListCacheScope;

  /// Creates the API-backed bootstrap service.
  ApiInvestmentBootstrapService({
    required this.api,
    required this.config,
    required this.session,
    required this.fiBomInstRepository,
    this.userDataSourceMode = MiniAppUserDataSourceMode.realUser,
    TimedMemoryCache<GetSecuritiesAcntListResDto>? secAcntListCache,
  }) : _secAcntListCache =
           secAcntListCache ??
           TimedMemoryCache<GetSecuritiesAcntListResDto>(
             ttl: _secAcntListCacheTtl,
           );

  @override
  /// Loads securities account list state, caching by user/register/phone scope.
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

    final GetSecuritiesAcntListResDto secAcntList = await _secAcntListCache
        .getOrLoad(
          () async {
            await session.ensureLoginSession();
            return api.getSecuritiesAcntList(
              GetSecuritiesAcntListApiReq(
                registerCode: registerCode.isNotNullOrEmpty
                    ? registerCode
                    : ResolvedUserIdentity.resolveRegisterNo(
                        mode: userDataSourceMode,
                        user: user,
                      ),
                mobile: phone,
                acnts: bootstrap.secAcntCode == null
                    ? const <String>[]
                    : <String>[bootstrap.secAcntCode!],
                srcFiCode: runtime.defaultSrcFiCode,
              ),
            );
          },
          forceRefresh: forceRefresh,
        );

    return AcntBootstrapState(response: secAcntList);
  }

  @override
  /// Loads account balance/fee state and merges it into [currentState].
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;

    await session.ensureLoginSession();
    final GetSecuritiesAcntListResDto balanceState = await api
        .getSecAcntBalState(
          GetSecAcntBalApiReq(srcFiCode: runtime.defaultSrcFiCode, flag: 3),
        );

    return currentState.copyWithBalanceState(balanceState);
  }

  @override
  /// Sends the securities account opening request and invalidates list cache.
  Future<SecAcntRequestResult> addSecuritiesAcntReq({
    SecAcntPersonalInfoData? personalInfo,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;
    final SdkContractDefaults contract = config.contract;
    final String? enteredIban = _normalizedValue(personalInfo?.iban);
    final String? enteredBankCode = _normalizedValue(personalInfo?.bankCode);
    final String? enteredBankLabel = _normalizedValue(personalInfo?.bankLabel);
    await session.ensureLoginSession();
    final FiBomInstDto fiBomInst = await fiBomInstRepository
        .getDefaultFiBomInst();

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

  /// Builds the cache key for user-scoped securities account state.
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

  /// Trims blank strings to null.
  String? _normalizedValue(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
