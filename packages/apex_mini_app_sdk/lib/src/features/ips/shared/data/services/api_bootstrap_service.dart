import '../../../../../app/investx_api/dto/user_entity_dto.dart';
import '../../../../../app/session/constants/login_session_contract.dart';
import '../../../../../core/backend/sdk_runtime_config.dart';
import '../../../../../utils/extension/extension.dart';

import '../../../../../app/session/mini_app_session_controller.dart';
import '../../../../../core/backend/sdk_backend_config.dart';
import '../../../../../utils/timed_memory_cache.dart';
import '../../domain/services/investment_services.dart';
import '../api/ips_backend_api.dart';
import '../dto/ips_response_dtos.dart';
import '../req/add_sec_acnt_api_req.dart';
import '../req/get_sec_acnt_bal_api_req.dart';
import '../req/get_sec_acnt_list_api_req.dart';
import 'fi_bom_inst_repository.dart';

class ApiInvestmentBootstrapService implements InvestmentBootstrapService {
  static const Duration _secAcntListCacheTtl = Duration(minutes: 2);

  final IpsBackendApi api;
  final SdkBackendConfig config;
  final MiniAppSessionController session;
  final FiBomInstRepository fiBomInstRepository;
  final TimedMemoryCache<GetSecuritiesAccountListResDto> _secAcntListCache;

  String? _secAcntListCacheScope;

  ApiInvestmentBootstrapService({
    required this.api,
    required this.config,
    required this.session,
    required this.fiBomInstRepository,
    TimedMemoryCache<GetSecuritiesAccountListResDto>? secAcntListCache,
  }) : _secAcntListCache =
           secAcntListCache ??
           TimedMemoryCache<GetSecuritiesAccountListResDto>(
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

    final GetSecuritiesAccountListResDto secAcntList = await _secAcntListCache
        .getOrLoad(
          () async {
            await session.ensureLoginSession();
            return api.getSecuritiesAcntList(
              GetSecuritiesAcntListApiReq(
                registerCode: registerCode.isNotNullOrEmpty
                    ? registerCode
                    : LoginSessionContract.registerNo,
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
  Future<AcntBootstrapState> getSecAcntBalanceState({
    required AcntBootstrapState currentState,
  }) async {
    final SdkRuntimeConfig runtime = config.runtime;

    await session.ensureLoginSession();
    final GetSecuritiesAccountListResDto balanceState = await api
        .getSecAcntBalState(
          GetSecAcntBalApiReq(
            // sessionId: bootstrap.sessionId,
            srcFiCode: runtime.defaultSrcFiCode,
            flag: 3,
          ),
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
