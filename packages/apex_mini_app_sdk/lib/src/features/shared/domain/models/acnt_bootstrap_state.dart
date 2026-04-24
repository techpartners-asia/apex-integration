import 'package:mini_app_sdk/mini_app_sdk.dart';

class AcntBootstrapState {
  final GetSecuritiesAccountListResDto _response;

  const AcntBootstrapState({required GetSecuritiesAccountListResDto response}) : _response = response;

  GetSecAcntListDetailDto get _detail => _response.detail;

  GetSecAcntListAccountDto? get _securitiesAccount => _response.securitiesAccount;

  GetSecAcntListAccountDto? get _ipsMasterAccount => _response.ipsMasterAccount;

  GetSecAcntListAccountDto? get _ipsCasaAccount => _response.ipsCasaAccount;

  bool get hasRequiredIpsAccounts => _ipsMasterAccount != null && _ipsCasaAccount != null;

  bool get hasAcnt => _detail.hasAcnt;

  bool get hasIpsAcnt => _detail.hasIpsAcnt || _ipsMasterAccount != null || _ipsCasaAccount != null;

  AcntStatus get acntStatus => !hasAcnt ? AcntStatus.none : (hasIpsAcnt ? AcntStatus.active : AcntStatus.pending);

  int? get secAcntStatusCode => _securitiesAccount?.status;

  String? get secAcntCode => _securitiesAccount?.scAcntCode ?? _securitiesAccount?.acntCode;

  String? get portfolioBrokerId {
    return _trimToNull(_securitiesAccount?.brokerId) ?? _trimToNull(_detail.brokerCode);
  }

  String? get portfolioSecurityCode {
    return _trimToNull(_securitiesAccount?.instrumentCode) ?? _trimToNull(_securitiesAccount?.scAcntCode) ?? _trimToNull(_securitiesAccount?.acntCode);
  }

  int? get portfolioCasaAcntId => _ipsCasaAccount?.acntId;

  int? get portfolioStatementMaxDays {
    return _parsePositiveInt(_ipsCasaAccount?.statementMaxDay) ?? _parsePositiveInt(_securitiesAccount?.statementMaxDay);
  }

  double? get secBalance => _securitiesAccount?.availableBalance ?? _securitiesAccount?.balance;

  double? get ipsBalance => _ipsCasaAccount?.availableBalance ?? _ipsCasaAccount?.balance;

  double? get commission => _detail.commission;

  String get currency => _response.primaryAccount?.symbol ?? _ipsCasaAccount?.symbol ?? IpsDefaults.defaultCurrency;

  String? get statusMessage => _detail.introIps ?? _detail.intro ?? _detail.info;

  String? get intro => _detail.intro;

  String? get introIps => _detail.introIps;

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

  String? get bootstrapBankName {
    final String? detailBankName = _trimToNull(_detail.bankName ?? _securitiesAccount?.bankName);
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

  bool get hasOpenSecAcnt => hasAcnt && secAcntStatusCode == 1;

  bool get requiresSecAcntPayment => hasAcnt && !hasOpenSecAcnt;

  AcntBootstrapState copyWithBalanceState(
    GetSecuritiesAccountListResDto balanceState,
  ) {
    final GetSecAcntListAccountDto? updatedBalanceAccount = balanceState.acnts.isEmpty ? null : balanceState.acnts.first;
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
