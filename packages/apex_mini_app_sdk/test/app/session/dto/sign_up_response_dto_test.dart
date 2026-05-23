import 'package:apex_mini_app_sdk/apex_mini_app_sdk.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('signUp parses partial user payload and preserves admin token', () {
    final UserEntityDto response = UserEntityDto.fromJson(<String, Object?>{
      'message': '',
      'body': <String, Object?>{
        'token': 'signup-jwt-token',
        'user': <String, Object?>{
          'id': 2,
          'integration_id': '3a8b553f-c1dd-4997-a10c-1bdb1f7a96a6',
          'rd': '',
          'first_name': '',
          'last_name': null,
          'phone': '88993076',
          'email': '',
          'gender': null,
          'account': <String, Object?>{
            'is_paid_contract': 1,
          },
        },
      },
    });

    final user = response;

    expect(user.admSession, 'signup-jwt-token');
    expect(user.phone, '88993076');
    expect(user.registerNo, '');
    expect(user.firstName, '');
    expect(user.lastName, '');
    expect(user.email, isNull);
    expect(user.gender, isNull);
    expect(user.account?.isPaidContract, isTrue);
  });

  test('signUp defaults missing paid contract flag to false', () {
    final UserEntityDto response = UserEntityDto.fromJson(<String, Object?>{
      'body': <String, Object?>{
        'token': 'signup-jwt-token',
        'user': <String, Object?>{'id': 2},
      },
    });

    expect(response.account?.isPaidContract, isFalse);
  });

  test('signUp parses flat secondary account flow fields', () {
    final UserEntityDto response = UserEntityDto.fromJson(<String, Object?>{
      'body': <String, Object?>{
        'token': 'signup-jwt-token',
        'user': <String, Object?>{
          'id': 2,
          'rd': '',
          'first_name': '',
          'last_name': '',
          'phone': '88993076',
          'phone_addition': '99112233',
          'email': 'investx@example.com',
          'account_number': 'MN991122334455667788',
          'bank_code': '390000',
          'bank_name': 'Хаан банк',
          'is_invest_contract': true,
          'is_paid_contract': true,
          'signature_file': '/uploads/signature.png',
        },
      },
    });

    expect(response.account?.isInvestContract, isTrue);
    expect(response.account?.hasInvestContract, isTrue);
    expect(response.account?.isPaidContract, isTrue);
    expect(response.account?.hasSavedSignature, isTrue);
    expect(response.bank?.accountNumber, 'MN991122334455667788');
    expect(response.bank?.bankCode, '390000');
    expect(response.bank?.bankName, 'Хаан банк');
  });
}
