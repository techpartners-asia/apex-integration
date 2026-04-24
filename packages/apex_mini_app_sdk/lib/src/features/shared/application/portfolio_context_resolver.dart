import 'package:intl/intl.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

class PortfolioContextResolver {
  final SdkPortfolioContext seed;
  final String? defaultSrcFiCode;
  final DateTime Function() now;

  const PortfolioContextResolver({
    this.seed = const SdkPortfolioContext(),
    this.defaultSrcFiCode,
    this.now = _defaultNow,
  });

  SdkPortfolioContext resolve({
    AcntBootstrapState? bootstrapState,
    UserEntityDto? user,
  }) {
    final SdkPortfolioContext userContext = _fromUser(user);
    final SdkPortfolioContext bootstrapContext = _fromBootstrapState(
      bootstrapState,
    );

    return seed
        .merge(userContext)
        .merge(bootstrapContext)
        .normalized(fallbackSrcFiCode: defaultSrcFiCode);
  }

  SdkPortfolioContext _fromUser(UserEntityDto? user) {
    final AccountDto? account = user?.account;
    return SdkPortfolioContext(
      securityCode: account?.scAcntCode ?? account?.acntCode,
    );
  }

  SdkPortfolioContext _fromBootstrapState(AcntBootstrapState? state) {
    if (state == null) {
      return const SdkPortfolioContext();
    }

    final _StatementRange? statementRange = _resolveStatementRange(
      state.portfolioStatementMaxDays,
    );

    return SdkPortfolioContext(
      brokerId: state.portfolioBrokerId,
      securityCode: state.portfolioSecurityCode,
      casaAcntId: state.portfolioCasaAcntId,
      stmtStartDate: statementRange?.startDate,
      stmtEndDate: statementRange?.endDate,
    );
  }

  _StatementRange? _resolveStatementRange(int? maxDays) {
    if (maxDays == null || maxDays <= 0) {
      return null;
    }

    final DateTime endDate = _dateOnly(now());
    final int offsetDays = maxDays > 1 ? maxDays - 1 : 0;
    final DateTime startDate = endDate.subtract(Duration(days: offsetDays));
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return _StatementRange(
      startDate: formatter.format(startDate),
      endDate: formatter.format(endDate),
    );
  }

  static DateTime _dateOnly(DateTime value) {
    final DateTime local = value.toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  static DateTime _defaultNow() => DateTime.now();
}

class _StatementRange {
  final String startDate;
  final String endDate;

  const _StatementRange({required this.startDate, required this.endDate});
}
