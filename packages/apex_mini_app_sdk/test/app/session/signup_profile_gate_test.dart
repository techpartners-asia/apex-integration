import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('hasCompleteSignupProfile', () {
    test('returns false when any required field is missing', () {
      expect(
        hasCompleteSignupProfile(
          UserEntityDto(
            registerNo: 'AB12345678',
            firstName: 'Bold',
            lastName: 'Baatar',
          ),
        ),
        isFalse,
      );
      expect(
        hasCompleteSignupProfile(
          UserEntityDto(
            registerNo: 'AB12345678',
            firstName: 'Bold',
            phone: '88993076',
          ),
        ),
        isFalse,
      );
      expect(
        hasCompleteSignupProfile(
          UserEntityDto(
            registerNo: 'AB12345678',
            lastName: 'Baatar',
            phone: '88993076',
          ),
        ),
        isFalse,
      );
      expect(
        hasCompleteSignupProfile(
          UserEntityDto(
            firstName: 'Bold',
            lastName: 'Baatar',
            phone: '88993076',
          ),
        ),
        isFalse,
      );
    });

    test('returns false when required fields are blank', () {
      expect(
        hasCompleteSignupProfile(
          UserEntityDto(
            registerNo: ' ',
            firstName: 'Bold',
            lastName: 'Baatar',
            phone: '88993076',
          ),
        ),
        isFalse,
      );
    });

    test('returns true when all required fields are present', () {
      expect(
        hasCompleteSignupProfile(
          UserEntityDto(
            registerNo: 'AB12345678',
            firstName: 'Bold',
            lastName: 'Baatar',
            phone: '88993076',
          ),
        ),
        isTrue,
      );
    });
  });
}
