import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  test('profile dto parses full nested profile response safely', () {
    final UserEntityDto user = UserEntityDto.fromJson(<String, Object?>{
      'message': '',
      'body': <String, Object?>{
        'id': 9,
        'rd': 'УБ90010101',
        'first_name': 'Бат',
        'last_name': 'Дорж',
        'email': 'investx@example.com',
        'phone': '88112233',
        'phone_addition': '99112233',
        'gender': 'male',
        'integration_id': 'integration-1',
        'platform': 'tino',
        'current_department': 'Technology',
        'current_position': 'Engineer',
        'residence_address': 'Ulaanbaatar',
        'residence_country': 'Mongolia',
        'image_id': 14,
        'region_id': 7,
        'created_at': '2026-04-03T00:00:00Z',
        'updated_at': '2026-04-03T01:00:00Z',
        'image': <String, Object?>{
          'id': 14,
          'file_name': 'profile.png',
          'original_name': 'profile-original.png',
          'physical_path': '/uploads/profile.png',
          'extention': 'png',
          'file_size': 128.5,
          'created_at': '2026-04-03T00:00:00Z',
          'updated_at': '2026-04-03T01:00:00Z',
        },
        'region': <String, Object?>{
          'id': 7,
          'name': 'Монгол',
          'alpha2': 'MN',
          'created_at': '2026-04-01T00:00:00Z',
          'updated_at': '2026-04-02T00:00:00Z',
        },
        'account': <String, Object?>{
          'id': 17,
          'acnt_code': 'AC001',
          'sc_acnt_code': 'SC001',
          'package_code': 'PACK1',
          'target_goal': 500000,
          'invest_amount': 250000,
          'profit_amount': 12000,
          'profit_percent': 4.8,
          'total_amount': 262000,
          'streak': '90',
          'is_invest': true,
          'is_invest_contract': true,
          'kyc_status': 'verified',
          'signature_id': 31,
          'signature_file': <String, Object?>{
            'id': 31,
            'file_name': 'signature.png',
            'original_name': 'signature-original.png',
            'physical_path': '/uploads/signature.png',
            'extention': 'png',
            'file_size': 64,
            'created_at': '2026-04-03T00:00:00Z',
            'updated_at': '2026-04-03T01:00:00Z',
          },
        },
        'bank': <String, Object?>{
          'id': 20,
          'user_id': 9,
          'account_number': '1234567890',
          'account_name': 'Investor Name',
          'bank_code': '390000',
          'bank_name': 'Хаан банк',
          'created_at': '2026-04-03T00:00:00Z',
          'updated_at': '2026-04-03T01:00:00Z',
        },
      },
    });

    expect(user.userId, 9);
    expect(user.platform, PlatformType.tino);
    expect(user.currentDepartment, 'Technology');
    expect(user.currentPosition, 'Engineer');
    expect(user.residenceAddress, 'Ulaanbaatar');
    expect(user.residenceCountry, 'Mongolia');
    expect(user.imageId, 14);
    expect(user.image?.fileName, 'profile.png');
    expect(user.regionId, 7);
    expect(user.region?.name, 'Монгол');
    expect(user.account?.targetGoal, 500000);
    expect(user.account?.signatureId, 31);
    expect(user.account?.signatureFile?.fileName, 'signature.png');
    expect(user.account?.kycStatus, KycStatusType.verified);
    expect(user.bank?.id, 20);
    expect(user.bank?.userId, 9);
    expect(user.bank?.bankCode, '390000');
    expect(user.bank?.bankName, 'Хаан банк');
    expect(user.bank?.accountName, 'Investor Name');
  });

  test('profile dto falls back safely for unknown enum values', () {
    final UserEntityDto user = UserEntityDto.fromJson(<String, Object?>{
      'body': <String, Object?>{
        'platform': 'unknown-platform',
        'account': <String, Object?>{'kyc_status': 'virtual_only'},
      },
    });

    expect(user.platform, PlatformType.unknown);
    expect(user.account?.kycStatus, KycStatusType.unknown);
  });
}
