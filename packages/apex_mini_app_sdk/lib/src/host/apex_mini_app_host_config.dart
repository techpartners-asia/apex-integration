import 'dart:ui';

import '../routes/mini_app_routes.dart';

class ApexMiniAppHostConfig {
  const ApexMiniAppHostConfig({
    required this.token,
    this.baseUrl,
    this.techInvestXBaseUrl,
    this.loginSessionBaseUrl,
    this.ipsApiBaseUrl,
    this.locale,
    String? entryRoute,
    String? initialRoute,
    this.initialArguments,
    this.user,
    this.session,
    this.appId,
    this.appSecret,
    this.defaultSrcFiCode,
    this.defaultFiCode,
    this.language,
    this.enableDebugLogs,
  }) : initialRoute = entryRoute ?? initialRoute ?? MiniAppRoutes.investX;

  final String token;
  final String? baseUrl;
  final String? techInvestXBaseUrl;
  final String? loginSessionBaseUrl;
  final String? ipsApiBaseUrl;
  final Locale? locale;
  final String initialRoute;
  final Object? initialArguments;
  final ApexMiniAppHostUser? user;
  final ApexMiniAppHostSession? session;
  final String? appId;
  final String? appSecret;
  final String? defaultSrcFiCode;
  final String? defaultFiCode;
  final String? language;
  final bool? enableDebugLogs;

  String get normalizedToken => token.trim();

  String get normalizedInitialRoute {
    final String route = initialRoute.trim();
    return route.isEmpty ? MiniAppRoutes.investX : route;
  }

  ApexMiniAppHostValidationResult validate() {
    final List<ApexMiniAppHostParameterError> errors =
        <ApexMiniAppHostParameterError>[];

    if (normalizedToken.isEmpty) {
      errors.add(
        const ApexMiniAppHostParameterError(
          code: ApexMiniAppHostParameterErrorCode.missingToken,
          field: 'token',
          message: 'Apex mini app requires a non-empty host token.',
        ),
      );
    }

    _validateUrl(errors, field: 'baseUrl', value: baseUrl);
    _validateUrl(
      errors,
      field: 'techInvestXBaseUrl',
      value: techInvestXBaseUrl,
    );
    _validateUrl(
      errors,
      field: 'loginSessionBaseUrl',
      value: loginSessionBaseUrl,
    );
    _validateUrl(errors, field: 'ipsApiBaseUrl', value: ipsApiBaseUrl);

    final String route = normalizedInitialRoute;
    if (!MiniAppRoutes.publicRoutes.contains(route)) {
      errors.add(
        ApexMiniAppHostParameterError(
          code: ApexMiniAppHostParameterErrorCode.invalidInitialRoute,
          field: 'initialRoute',
          message: 'Unknown Apex mini app initial route "$route".',
        ),
      );
    }

    return ApexMiniAppHostValidationResult(errors);
  }

  void _validateUrl(
    List<ApexMiniAppHostParameterError> errors, {
    required String field,
    required String? value,
  }) {
    final String normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return;
    }

    final Uri? uri = Uri.tryParse(normalized);
    final bool hasHttpScheme = uri?.scheme == 'http' || uri?.scheme == 'https';
    if (uri == null || !hasHttpScheme || uri.host.trim().isEmpty) {
      errors.add(
        ApexMiniAppHostParameterError(
          code: ApexMiniAppHostParameterErrorCode.invalidBaseUrl,
          field: field,
          message: '$field must be an absolute URL.',
        ),
      );
    }
  }

  ApexMiniAppHostConfig copyWith({
    String? token,
    String? baseUrl,
    String? techInvestXBaseUrl,
    String? loginSessionBaseUrl,
    String? ipsApiBaseUrl,
    Locale? locale,
    String? entryRoute,
    String? initialRoute,
    Object? initialArguments,
    ApexMiniAppHostUser? user,
    ApexMiniAppHostSession? session,
    String? appId,
    String? appSecret,
    String? defaultSrcFiCode,
    String? defaultFiCode,
    String? language,
    bool? enableDebugLogs,
  }) {
    return ApexMiniAppHostConfig(
      token: token ?? this.token,
      baseUrl: baseUrl ?? this.baseUrl,
      techInvestXBaseUrl: techInvestXBaseUrl ?? this.techInvestXBaseUrl,
      loginSessionBaseUrl: loginSessionBaseUrl ?? this.loginSessionBaseUrl,
      ipsApiBaseUrl: ipsApiBaseUrl ?? this.ipsApiBaseUrl,
      locale: locale ?? this.locale,
      entryRoute: entryRoute,
      initialRoute: initialRoute ?? this.initialRoute,
      initialArguments: initialArguments ?? this.initialArguments,
      user: user ?? this.user,
      session: session ?? this.session,
      appId: appId ?? this.appId,
      appSecret: appSecret ?? this.appSecret,
      defaultSrcFiCode: defaultSrcFiCode ?? this.defaultSrcFiCode,
      defaultFiCode: defaultFiCode ?? this.defaultFiCode,
      language: language ?? this.language,
      enableDebugLogs: enableDebugLogs ?? this.enableDebugLogs,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApexMiniAppHostConfig &&
            token == other.token &&
            baseUrl == other.baseUrl &&
            techInvestXBaseUrl == other.techInvestXBaseUrl &&
            loginSessionBaseUrl == other.loginSessionBaseUrl &&
            ipsApiBaseUrl == other.ipsApiBaseUrl &&
            locale == other.locale &&
            initialRoute == other.initialRoute &&
            _hostValueEquals(initialArguments, other.initialArguments) &&
            user == other.user &&
            session == other.session &&
            appId == other.appId &&
            appSecret == other.appSecret &&
            defaultSrcFiCode == other.defaultSrcFiCode &&
            defaultFiCode == other.defaultFiCode &&
            language == other.language &&
            enableDebugLogs == other.enableDebugLogs;
  }

  @override
  int get hashCode {
    return Object.hash(
      token,
      baseUrl,
      techInvestXBaseUrl,
      loginSessionBaseUrl,
      ipsApiBaseUrl,
      locale,
      initialRoute,
      _hostValueHash(initialArguments),
      user,
      session,
      appId,
      appSecret,
      defaultSrcFiCode,
      defaultFiCode,
      language,
      enableDebugLogs,
    );
  }
}

bool _hostValueEquals(Object? first, Object? second) {
  if (identical(first, second)) {
    return true;
  }

  if (first is Map && second is Map) {
    if (first.length != second.length) {
      return false;
    }
    for (final Object? key in first.keys) {
      if (!second.containsKey(key)) {
        return false;
      }
      if (!_hostValueEquals(first[key], second[key])) {
        return false;
      }
    }
    return true;
  }

  if (first is List && second is List) {
    if (first.length != second.length) {
      return false;
    }
    for (int i = 0; i < first.length; i += 1) {
      if (!_hostValueEquals(first[i], second[i])) {
        return false;
      }
    }
    return true;
  }

  return first == second;
}

int _hostValueHash(Object? value) {
  if (value is Map) {
    return Object.hashAllUnordered(
      value.entries.map((MapEntry<dynamic, dynamic> entry) {
        return Object.hash(
          _hostValueHash(entry.key),
          _hostValueHash(entry.value),
        );
      }),
    );
  }

  if (value is List) {
    return Object.hashAll(value.map(_hostValueHash));
  }

  return value.hashCode;
}

class ApexMiniAppHostUser {
  const ApexMiniAppHostUser({
    this.id,
    this.registerNo,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.gender,
    this.adminSession,
    this.accessToken,
    this.bank,
  });

  final int? id;
  final String? registerNo;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String? gender;
  final String? adminSession;
  final String? accessToken;
  final ApexMiniAppHostBank? bank;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApexMiniAppHostUser &&
            id == other.id &&
            registerNo == other.registerNo &&
            firstName == other.firstName &&
            lastName == other.lastName &&
            phone == other.phone &&
            email == other.email &&
            gender == other.gender &&
            adminSession == other.adminSession &&
            accessToken == other.accessToken &&
            bank == other.bank;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      registerNo,
      firstName,
      lastName,
      phone,
      email,
      gender,
      adminSession,
      accessToken,
      bank,
    );
  }
}

class ApexMiniAppHostBank {
  const ApexMiniAppHostBank({
    this.accountNumber,
    this.accountName,
    this.bankId,
    this.bankCode,
    this.bankName,
  });

  final String? accountNumber;
  final String? accountName;
  final String? bankId;
  final String? bankCode;
  final String? bankName;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApexMiniAppHostBank &&
            accountNumber == other.accountNumber &&
            accountName == other.accountName &&
            bankId == other.bankId &&
            bankCode == other.bankCode &&
            bankName == other.bankName;
  }

  @override
  int get hashCode {
    return Object.hash(
      accountNumber,
      accountName,
      bankId,
      bankCode,
      bankName,
    );
  }
}

class ApexMiniAppHostSession {
  const ApexMiniAppHostSession({
    this.accessToken,
    this.customerToken,
    this.neSession,
  });

  final String? accessToken;
  final String? customerToken;
  final String? neSession;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ApexMiniAppHostSession &&
            accessToken == other.accessToken &&
            customerToken == other.customerToken &&
            neSession == other.neSession;
  }

  @override
  int get hashCode => Object.hash(accessToken, customerToken, neSession);
}

class ApexMiniAppHostValidationResult {
  const ApexMiniAppHostValidationResult(this.errors);

  final List<ApexMiniAppHostParameterError> errors;

  bool get isValid => errors.isEmpty;

  bool get isMissingToken => errors.any((ApexMiniAppHostParameterError error) {
    return error.code == ApexMiniAppHostParameterErrorCode.missingToken;
  });

  String get message {
    return errors
        .map((ApexMiniAppHostParameterError error) => error.message)
        .join('\n');
  }
}

class ApexMiniAppHostParameterError {
  const ApexMiniAppHostParameterError({
    required this.code,
    required this.field,
    required this.message,
  });

  final ApexMiniAppHostParameterErrorCode code;
  final String field;
  final String message;

  @override
  String toString() => '$field: $message';
}

enum ApexMiniAppHostParameterErrorCode {
  missingToken,
  invalidBaseUrl,
  invalidInitialRoute,
}

class ApexMiniAppHostParameterException implements Exception {
  const ApexMiniAppHostParameterException(this.validation);

  final ApexMiniAppHostValidationResult validation;

  @override
  String toString() => validation.message;
}
