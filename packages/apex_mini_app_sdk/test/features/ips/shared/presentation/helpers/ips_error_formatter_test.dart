import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/l10n/sdk_localizations_mn.dart';
import 'package:mini_app_sdk/src/core/exception/api_business_exception.dart';
import 'package:mini_app_sdk/src/core/exception/api_network_exception.dart';
import 'package:mini_app_sdk/src/core/exception/api_unauthorized_exception.dart';
import 'package:mini_app_sdk/src/features/ips/shared/presentation/helpers/ips_error_formatter.dart';

void main() {
  final SdkLocalizationsMn l10n = SdkLocalizationsMn();

  test('returns real business error message', () {
    final String message = formatIpsError(
      const ApiBusinessException(
        responseCode: 400,
        message: 'Дансны нэр хоосон байна.',
      ),
      l10n,
    );

    expect(message, 'Дансны нэр хоосон байна.');
  });

  test('returns real unauthorized message when backend provides one', () {
    final String message = formatIpsError(
      const ApiUnauthorizedException('Хандах эрх хүрэлцэхгүй байна.'),
      l10n,
    );

    expect(message, 'Хандах эрх хүрэлцэхгүй байна.');
  });

  test('keeps generic network copy for technical transport errors', () {
    final String message = formatIpsError(
      const ApiNetworkException('Req timed out for updateProfile.'),
      l10n,
    );

    expect(message, l10n.errorsNetwork);
  });
}
