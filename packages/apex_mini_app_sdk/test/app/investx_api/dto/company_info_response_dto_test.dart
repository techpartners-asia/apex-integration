import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  group('CompanyInfoResponseDto', () {
    test('parses company info with nested location and social links', () {
      final CompanyInfoResponseDto dto = CompanyInfoResponseDto.fromJson(
        <String, Object?>{
          'email': 'info@investx.mn',
          'phone': '75107500',
          'locations': <String, Object?>{
            'title': 'Head Office',
            'description': 'Olympic street',
            'openTime': '09:00',
            'closeTime': '18:00',
            'startDay': 'monday',
            'endDay': 'friday',
            'latitude': 47.91,
            'longitude': 106.91,
            'images': <Object?>[
              <String, Object?>{
                'physical_path': 'https://example.com/location.png',
              },
            ],
            'company': <String, Object?>{
              'socialLinks': <Object?>[
                <String, Object?>{
                  'name': 'InvestX',
                  'link': 'https://facebook.com/investx',
                  'type': 'facebook',
                },
              ],
            },
          },
        },
      );

      expect(dto.entity.email, 'info@investx.mn');
      expect(dto.entity.location?.title, 'Head Office');
      expect(dto.entity.location?.startDay, DayOfWeekType.monday);
      expect(dto.entity.socialLinks.single.type, SocialMediaType.facebook);
    });
  });
}
