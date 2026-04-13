import '../exception/api_exception.dart';
import 'api_parser.dart';

class ApiEnvelope<T> {
  final int responseCode;
  final String responseDesc;
  final Object? resValue;
  final T responseData;

  const ApiEnvelope({
    required this.responseCode,
    required this.responseDesc,
    required this.resValue,
    required this.responseData,
  });

  factory ApiEnvelope.fromJson(
    Map<String, Object?> json,
    T Function(Object? raw) mapper,
  ) {
    return ApiEnvelope<T>(
      responseCode: ApiParser.asNullableInt(json['responseCode']) ?? 1,
      responseDesc: ApiParser.asNullableString(json['responseDesc']) ?? '',
      resValue: json['resValue'],
      responseData: mapper(json['responseData']),
    );
  }

  void ensureSuccess() {
    if (responseCode != 0) {
      throw ApiBusinessException(
        responseCode: responseCode,
        message: responseDesc.isEmpty
            ? 'Backend business validation failed.'
            : responseDesc,
      );
    }
  }
}
