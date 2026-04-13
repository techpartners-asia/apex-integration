import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/ips/shared/data/dto/acnt_name_lookup_dto.dart';

void main() {
  test('parses direct acnt lookup payload', () {
    final dto = AcntNameLookupDto.fromJson(<String, Object?>{
      'responseCode': 0,
      'responseDesc': '',
      'acntName': 'John Doe',
      'maskedAcntName': 'J*** D**',
    });

    expect(dto.responseCode, 0);
    expect(dto.responseDesc, isNull);
    expect(dto.acntName, 'John Doe');
    expect(dto.maskedAcntName, 'J*** D**');
  });

  test('parses nested responseData acnt lookup payload', () {
    final dto = AcntNameLookupDto.fromJson(<String, Object?>{
      'responseCode': 0,
      'responseDesc': '',
      'responseData': <String, Object?>{
        'acntName': 'Jane Doe',
        'maskedAcntName': 'J*** D**',
      },
    });

    expect(dto.responseCode, 0);
    expect(dto.acntName, 'Jane Doe');
    expect(dto.maskedAcntName, 'J*** D**');
  });
}
