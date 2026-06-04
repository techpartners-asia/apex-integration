import 'package:dio/dio.dart';

import 'api_endpoints.dart';
import 'backend_api_logger.dart';
import 'backend_logger_context.dart';
import 'backend_logger_request_extra.dart';
import 'backend_logger_payload.dart';

/// Dio interceptor that mirrors API traffic to the admin `/logger/create` endpoint.
class BackendLoggerInterceptor extends Interceptor {
  /// Creates the interceptor.
  BackendLoggerInterceptor({required BackendApiLogger logger}) : _logger = logger;

  final BackendApiLogger _logger;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final RequestOptions options = response.requestOptions;
    if (_shouldSkip(options)) {
      handler.next(response);
      return;
    }

    final int? statusCode = response.statusCode;
    final String level = _levelForStatusCode(statusCode);
    _logger.log(
      level: level,
      path: options.uri.toString(),
      msg: _buildMessage(
        operName: _operName(options),
        detail: _responseDetail(level, statusCode),
      ),
      info: BackendLoggerPayload.infoForRoundTrip(
        options: options,
        responseData: response.data,
        statusCode: statusCode,
      ),
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final RequestOptions options = err.requestOptions;
    if (_shouldSkip(options)) {
      handler.next(err);
      return;
    }

    final int? statusCode = err.response?.statusCode;
    final String level = statusCode == null
        ? 'error'
        : _levelForStatusCode(statusCode);
    _logger.log(
      level: level,
      path: options.uri.toString(),
      msg: _buildMessage(
        operName: _operName(options),
        detail: _errorDetail(err, statusCode),
      ),
      info: BackendLoggerPayload.infoForRoundTrip(
        options: options,
        responseData: err.response?.data,
        statusCode: statusCode,
        errorType: err.type.name,
        errorMessage: err.message,
      ),
    );
    handler.next(err);
  }

  bool _shouldSkip(RequestOptions options) {
    if (options.extra[BackendLoggerRequestExtra.skip] == true) {
      return true;
    }
    final String path = options.uri.path;
    return path.endsWith(ApiEndpoints.loggerCreate) ||
        path.contains('/logger/create');
  }

  String? _operName(RequestOptions options) {
    final Object? operName = options.extra[BackendLoggerRequestExtra.operName];
    if (operName is String && operName.trim().isNotEmpty) {
      return operName.trim();
    }
    return null;
  }

  String _buildMessage({String? operName, required String detail}) {
    final String suffix = BackendLoggerContext.messageSuffix()?.trim() ?? '';
    final String operation = operName ?? 'api';
    if (suffix.isEmpty) {
      return '$detail $operation';
    }
    return '$detail $operation $suffix';
  }

  String _responseDetail(String level, int? statusCode) {
    if (level == 'warn') {
      return 'warn response ${statusCode ?? '-'}';
    }
    return 'response ${statusCode ?? '-'}';
  }

  String _errorDetail(DioException err, int? statusCode) {
    if (statusCode != null) {
      return 'error response $statusCode';
    }
    return 'error ${err.type.name}';
  }

  String _levelForStatusCode(int? statusCode) {
    if (statusCode == null) {
      return 'info';
    }
    if (statusCode >= 500) {
      return 'error';
    }
    if (statusCode >= 400) {
      if (statusCode == 401 || statusCode == 403) {
        return 'error';
      }
      return 'warn';
    }
    return 'info';
  }
}
