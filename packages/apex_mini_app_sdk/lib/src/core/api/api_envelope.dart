import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';

/// Generic backend envelope used by some IPS APIs.
class ApiEnvelope<T> {
  /// Backend response code. `0` means success.
  final int responseCode;

  /// Backend response description.
  final String responseDesc;

  /// Optional raw response value.
  final Object? resValue;

  /// Typed parsed response data.
  final T responseData;

  /// Creates a typed API response envelope.
  const ApiEnvelope({
    required this.responseCode,
    required this.responseDesc,
    required this.resValue,
    required this.responseData,
  });

  /// Parses an envelope and maps `responseData` using [mapper].
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

  /// Throws [ApiBusinessException] when [responseCode] is not zero.
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
