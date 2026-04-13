import '../../../../../core/exception/api_exception.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations.dart';

String formatIpsError(Object? error, SdkLocalizations l10n) {
  if (error is ApiNetworkException) {
    return _resolveApiMessage(error.message, fallback: l10n.errorsNetwork);
  }
  if (error is ApiUnauthorizedException) {
    return _resolveApiMessage(error.message, fallback: l10n.errorsSession);
  }
  if (error is ApiBusinessException) {
    return _resolveApiMessage(error.message, fallback: l10n.errorsActionFailed);
  }
  if (error is ApiIntegrationException) {
    return l10n.errorsConfig;
  }
  if (error is ApiException) {
    return _resolveApiMessage(error.message, fallback: l10n.errorsUnexpected);
  }

  return l10n.errorsUnexpected;
}

String _resolveApiMessage(String? message, {required String fallback}) {
  final String normalized = message?.trim() ?? '';
  if (normalized.isEmpty || _looksTechnicalApiMessage(normalized)) {
    return fallback;
  }
  return normalized;
}

bool _looksTechnicalApiMessage(String message) {
  final String lowerCased = message.trim().toLowerCase();
  return lowerCased.startsWith('http ') ||
      lowerCased.startsWith('req timed out') ||
      lowerCased.startsWith('network req failed') ||
      lowerCased.startsWith('authentication failed') ||
      lowerCased.startsWith('unexpected error during');
}
