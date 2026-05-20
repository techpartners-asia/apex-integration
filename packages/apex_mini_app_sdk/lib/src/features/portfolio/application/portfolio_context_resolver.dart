import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:intl/intl.dart';

/// Resolves portfolio API context from host config, bootstrap state, and user.
class PortfolioContextResolver {
  /// Starting context supplied by host/runtime.
  final SdkPortfolioContext seed;

  /// Source FI fallback when no context value is supplied.
  final String? defaultSrcFiCode;

  /// Clock used to calculate statement ranges.
  final DateTime Function() now;

  /// Creates a context resolver.
  const PortfolioContextResolver({
    this.seed = const SdkPortfolioContext(),
    this.defaultSrcFiCode,
    this.now = _defaultNow,
  });

  /// Merges all available sources into a normalized portfolio context.
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
    return SdkPortfolioContext();
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
      ipsAcntCode: state.ipsAcntCode,
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

/// Date range used when querying portfolio statements.
class _StatementRange {
  /// Start date in backend `yyyy-MM-dd` format.
  final String startDate;

  /// End date in backend `yyyy-MM-dd` format.
  final String endDate;

  /// Creates a statement date range.
  const _StatementRange({required this.startDate, required this.endDate});
}
