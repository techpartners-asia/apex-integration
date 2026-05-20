import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Domain wrapper around securities-account list/balance bootstrap responses.
class AcntBootstrapState {
  final GetSecuritiesAcntListResDto _response;

  /// Creates bootstrap state from the securities-account list response.
  const AcntBootstrapState({required GetSecuritiesAcntListResDto response})
    : _response = response;

  GetSecuritiesAcntListDetailDto get _detail => _response.detail;

  GetSecAcntListAccountDto? get _securitiesAccount =>
      _response.securitiesAccount;

  GetSecAcntListAccountDto? get _ipsMasterAccount => _response.ipsMasterAccount;

  GetSecAcntListAccountDto? get _ipsCasaAccount => _response.ipsCasaAccount;

  /// Whether both IPS master and CASA accounts are present.
  bool get hasRequiredIpsAccounts =>
      _ipsMasterAccount != null && _ipsCasaAccount != null;

  /// Whether the backend says the user has a securities-account request/account.
  bool get hasAcnt => _detail.hasAcnt;

  /// Whether IPS account data is present.
  bool get hasIpsAcnt =>
      _detail.hasIpsAcnt ||
      _ipsMasterAccount != null ||
      _ipsCasaAccount != null;

  /// Simplified account status used by UI/onboarding decisions.
  AcntStatus get acntStatus => !hasAcnt
      ? AcntStatus.none
      : (hasIpsAcnt ? AcntStatus.active : AcntStatus.pending);

  /// Raw status code for the securities account, when present.
  int? get secAcntStatusCode => _securitiesAccount?.status;

  /// Securities account code used by account-required securities flows.
  String? get secAcntCode =>
      _securitiesAccount?.scAcntCode ?? _securitiesAccount?.acntCode;

  /// IPS master account code used by portfolio and pack flows.
  String? get ipsAcntCode =>
      _ipsMasterAccount?.scAcntCode ?? _ipsMasterAccount?.acntCode;

  /// Broker id resolved for portfolio and statement API requests.
  String? get portfolioBrokerId {
    return _trimToNull(_securitiesAccount?.brokerId) ??
        _trimToNull(_detail.brokerCode);
  }

  // String? get portfolioSecurityCode {
  //   return _trimToNull(_securitiesAccount?.instrumentCode) ?? _trimToNull(_securitiesAccount?.scAcntCode) ?? _trimToNull(_securitiesAccount?.acntCode);
  // }

  /// CASA account id used by portfolio statement API requests.
  int? get portfolioCasaAcntId => _ipsCasaAccount?.acntId;

  /// Maximum statement range accepted by the backend for this account.
  int? get portfolioStatementMaxDays {
    return _parsePositiveInt(_ipsCasaAccount?.statementMaxDay) ??
        _parsePositiveInt(_securitiesAccount?.statementMaxDay);
  }

  /// Securities-account available balance, falling back to total balance.
  double? get secBalance =>
      _securitiesAccount?.availableBalance ?? _securitiesAccount?.balance;

  /// IPS CASA available balance, falling back to total balance.
  double? get ipsBalance =>
      _ipsCasaAccount?.availableBalance ?? _ipsCasaAccount?.balance;

  /// Commission value from the bootstrap detail payload.
  double? get commission => _detail.commission;

  /// Display currency resolved from primary or IPS CASA account data.
  String get currency =>
      _response.primaryAccount?.symbol ??
      _ipsCasaAccount?.symbol ??
      IpsDefaults.defaultCurrency;

  /// User-facing status message shown on onboarding/dashboard surfaces.
  String? get statusMessage =>
      _detail.introIps ?? _detail.intro ?? _detail.info;

  /// General introduction text returned by the bootstrap endpoint.
  String? get intro => _detail.intro;

  /// IPS-specific introduction text returned by the bootstrap endpoint.
  String? get introIps => _detail.introIps;

  /// Bank code used to prefill securities-account personal information.
  String? get bootstrapBankCode {
    final String? detailBankCode = _trimToNull(
      _detail.bankCode ?? _securitiesAccount?.bankCode,
    );
    if (detailBankCode != null) {
      return detailBankCode;
    }

    for (final GetSecAcntSettlementAccountDto account in _response.stlAcnts) {
      if (account.isDefault) {
        return _trimToNull(account.bkrFiCode);
      }
    }

    return null;
  }

  /// Bank name used to prefill securities-account personal information.
  String? get bootstrapBankName {
    final String? detailBankName = _trimToNull(
      _detail.bankName ?? _securitiesAccount?.bankName,
    );
    if (detailBankName != null) {
      return detailBankName;
    }

    for (final GetSecAcntSettlementAccountDto account in _response.stlAcnts) {
      if (account.isDefault) {
        return _trimToNull(account.bkrFiName);
      }
    }

    return null;
  }

  /// Account holder name used to prefill securities-account personal info.
  String? get bootstrapAcntName {
    final String? detailAcntName = _trimToNull(_detail.toAcntName);
    if (detailAcntName != null) {
      return detailAcntName;
    }

    for (final GetSecAcntSettlementAccountDto account in _response.stlAcnts) {
      if (account.isDefault) {
        return _trimToNull(account.bkrAcntName);
      }
    }

    return null;
  }

  /// IBAN/account number used to prefill securities-account personal info.
  String? get bootstrapIban {
    final String? detailIban = _trimToNull(_detail.toAcntCode);
    if (detailIban != null) {
      return detailIban;
    }

    for (final GetSecAcntSettlementAccountDto account in _response.stlAcnts) {
      if (account.isDefault) {
        return _trimToNull(account.bkrAcntCode);
      }
    }

    return null;
  }

  /// Whether a securities account exists and is open/active.
  bool get hasOpenSecAcnt => hasAcnt && secAcntStatusCode == 1;

  /// Whether the flow should continue through pending account/payment state.
  bool get requiresSecAcntPayment => hasAcnt && !hasOpenSecAcnt;

  /// Returns a copy with fee/balance fields merged from [balanceState].
  AcntBootstrapState copyWithBalanceState(
    GetSecuritiesAcntListResDto balanceState,
  ) {
    final GetSecAcntListAccountDto? updatedBalanceAccount =
        balanceState.acnts.isEmpty ? null : balanceState.acnts.first;
    if (updatedBalanceAccount == null) {
      return this;
    }

    final List<GetSecAcntListAccountDto> updatedAccounts = _response.acnts
        .map(
          (GetSecAcntListAccountDto account) => account.copyWith(
            scFee: updatedBalanceAccount.scFee,
            buyXocFee: updatedBalanceAccount.buyXocFee,
            sellXocFee: updatedBalanceAccount.sellXocFee,
            balance: updatedBalanceAccount.balance,
            availableBalance: updatedBalanceAccount.availableBalance,
            balances: updatedBalanceAccount.balances,
            custId: updatedBalanceAccount.custId,
            instrumentCode: updatedBalanceAccount.instrumentCode,
            marketCode: updatedBalanceAccount.marketCode,
            canTxn: updatedBalanceAccount.canTxn,
            nominalAcntCode: updatedBalanceAccount.nominalAcntCode,
            secType: updatedBalanceAccount.secType,
            secTypeName: updatedBalanceAccount.secTypeName,
          ),
        )
        .toList(growable: false);

    return AcntBootstrapState(
      response: _response.copyWith(acnts: updatedAccounts),
    );
  }

  String? _trimToNull(String? value) {
    final String trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  int? _parsePositiveInt(String? value) {
    final String? trimmed = _trimToNull(value);
    if (trimmed == null) {
      return null;
    }

    final int? parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return null;
    }

    return parsed;
  }
}
