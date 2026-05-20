import 'dart:ui';

import '../routes/mini_app_routes.dart';

/// Host-provided configuration required to start the Apex mini app.
///
/// This object is the stable boundary between the host app and the SDK. Keep
/// host-only values here, then map them into `MiniAppSdkConfig` before building
/// the internal runtime.
class ApexMiniAppHostConfig {
  /// Creates host configuration for `ApexMiniAppSdk`.
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

  /// Required host authentication token.
  final String token;

  /// Default backend base URL used when more specific service URLs are absent.
  final String? baseUrl;

  /// Base URL for Tech InvestX APIs.
  final String? techInvestXBaseUrl;

  /// Base URL used to resolve login-session data.
  final String? loginSessionBaseUrl;

  /// Base URL for IPS/securities APIs.
  final String? ipsApiBaseUrl;

  /// Locale requested by the host app.
  final Locale? locale;

  /// Initial mini-app route.
  ///
  /// `entryRoute` and `initialRoute` are aliases for host compatibility; the
  /// constructor normalizes both into this single field.
  final String initialRoute;

  /// Optional payload passed to the first mini-app screen.
  final Object? initialArguments;

  /// Optional host user profile snapshot.
  final ApexMiniAppHostUser? user;

  /// Optional host session values such as access token and NE session.
  final ApexMiniAppHostSession? session;

  /// Host application id used by APIs that require app credentials.
  final String? appId;

  /// Host application secret used by APIs that require app credentials.
  final String? appSecret;

  /// Default source FI code used by securities account/recharge flows.
  final String? defaultSrcFiCode;

  /// Default FI code used when the backend does not provide a specific value.
  final String? defaultFiCode;

  /// Explicit language code. When omitted, it is derived from [locale].
  final String? language;

  /// Optional debug logging switch passed through from the host app.
  final bool? enableDebugLogs;

  /// Trimmed token used by validation and SDK runtime creation.
  String get normalizedToken => token.trim();

  /// Trimmed route with a safe default when the host passes an empty string.
  String get normalizedInitialRoute {
    final String route = initialRoute.trim();
    return route.isEmpty ? MiniAppRoutes.investX : route;
  }

  /// Validates host parameters before the SDK runtime is constructed.
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

  /// Adds an error only when a non-empty URL is present but malformed.
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

  /// Creates a modified host config while preserving unspecified fields.
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

/// Deep equality helper for host values that may be maps/lists.
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

/// Deep hash helper matching [_hostValueEquals].
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

/// User profile values optionally supplied by the host app.
class ApexMiniAppHostUser {
  /// Creates an optional host user snapshot.
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

  /// Host user id.
  final int? id;

  /// National/register number when available.
  final String? registerNo;

  /// User first name.
  final String? firstName;

  /// User last name.
  final String? lastName;

  /// Primary phone number.
  final String? phone;

  /// Email address.
  final String? email;

  /// Gender value supplied by the host.
  final String? gender;

  /// Host admin/session token if available.
  final String? adminSession;

  /// Host user access token if supplied separately from host session.
  final String? accessToken;

  /// Host bank account data used to prefill onboarding forms.
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

/// Bank/account values optionally supplied by the host app.
class ApexMiniAppHostBank {
  /// Creates optional host bank/account values for onboarding prefill.
  const ApexMiniAppHostBank({
    this.accountNumber,
    this.accountName,
    this.bankId,
    this.bankCode,
    this.bankName,
  });

  /// Bank account number or IBAN.
  final String? accountNumber;

  /// Account holder name.
  final String? accountName;

  /// Host/backend bank id.
  final String? bankId;

  /// Bank code used by Apex/IPS APIs.
  final String? bankCode;

  /// Display name of the bank.
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

/// Host session values used by login/session bootstrap.
class ApexMiniAppHostSession {
  /// Creates optional host session values.
  const ApexMiniAppHostSession({
    this.accessToken,
    this.customerToken,
    this.neSession,
  });

  /// Access token for APIs that need a bearer/session token.
  final String? accessToken;

  /// Customer token when the host exposes it separately.
  final String? customerToken;

  /// NE session value required by some InvestX APIs.
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

/// Result of validating [ApexMiniAppHostConfig].
class ApexMiniAppHostValidationResult {
  /// Creates a validation result from field-level errors.
  const ApexMiniAppHostValidationResult(this.errors);

  /// Individual validation errors. Empty means the config is usable.
  final List<ApexMiniAppHostParameterError> errors;

  /// Whether the host config can be used to construct the SDK runtime.
  bool get isValid => errors.isEmpty;

  /// Convenience flag for showing the dedicated missing-token fallback screen.
  bool get isMissingToken => errors.any((ApexMiniAppHostParameterError error) {
    return error.code == ApexMiniAppHostParameterErrorCode.missingToken;
  });

  /// Human-readable combined error message.
  String get message {
    return errors
        .map((ApexMiniAppHostParameterError error) => error.message)
        .join('\n');
  }
}

/// One host parameter validation failure.
class ApexMiniAppHostParameterError {
  /// Creates a host parameter validation error.
  const ApexMiniAppHostParameterError({
    required this.code,
    required this.field,
    required this.message,
  });

  /// Machine-readable error code.
  final ApexMiniAppHostParameterErrorCode code;

  /// Host config field that failed validation.
  final String field;

  /// Human-readable validation message.
  final String message;

  @override
  String toString() => '$field: $message';
}

/// Validation error codes for host-provided parameters.
enum ApexMiniAppHostParameterErrorCode {
  /// Required token is missing or blank.
  missingToken,

  /// A URL field is present but is not an absolute HTTP(S) URL.
  invalidBaseUrl,

  /// The requested initial route is not registered as a public mini-app route.
  invalidInitialRoute,
}

/// Exception wrapper used to report invalid host configuration through the
/// normal host error callback.
class ApexMiniAppHostParameterException implements Exception {
  /// Creates an exception that wraps host config validation details.
  const ApexMiniAppHostParameterException(this.validation);

  /// Validation result that contains the detailed field errors.
  final ApexMiniAppHostValidationResult validation;

  @override
  String toString() => validation.message;
}
