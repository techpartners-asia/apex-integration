import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hasRequiredUserProfileFields', () {
    test('returns true when all required fields are present', () {
      final user = UserEntityDto(
        registerNo: 'AA12345678',
        firstName: 'Bold',
        lastName: 'Test',
        phone: '99112233',
        email: 'bold@example.com',
      );

      expect(hasRequiredUserProfileFields(user), isTrue);
    });

    test('returns false when any required field is missing', () {
      final complete = UserEntityDto(
        registerNo: 'AA12345678',
        firstName: 'Bold',
        lastName: 'Test',
        phone: '99112233',
        email: 'bold@example.com',
      );

      expect(
        hasRequiredUserProfileFields(
          complete.copyWith(registerNo: ' '),
        ),
        isFalse,
      );
      expect(
        hasRequiredUserProfileFields(
          complete.copyWith(firstName: ''),
        ),
        isFalse,
      );
      expect(
        hasRequiredUserProfileFields(
          complete.copyWith(lastName: ''),
        ),
        isFalse,
      );
      expect(
        hasRequiredUserProfileFields(
          complete.copyWith(phone: ''),
        ),
        isFalse,
      );
      expect(
        hasRequiredUserProfileFields(
          complete.copyWith(email: ' '),
        ),
        isFalse,
      );
      expect(hasRequiredUserProfileFields(null), isFalse);
    });
  });
}
