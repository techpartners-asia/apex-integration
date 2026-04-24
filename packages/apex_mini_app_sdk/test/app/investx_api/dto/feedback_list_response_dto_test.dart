import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/mini_app_sdk.dart';

void main() {
  group('FeedbackListResponseDto', () {
    test('parses list payload', () {
      final FeedbackListResponseDto dto = FeedbackListResponseDto.fromJson(
        <String, Object?>{
          'items': <Object?>[
            <String, Object?>{
              'id': 1,
              'title': 'Issue',
              'description': 'Details',
              'status': 'resolved',
              'created_at': '2026-04-01T08:00:00Z',
              'updated_at': '2026-04-02T08:00:00Z',
              'user_id': 9,
            },
          ],
          'total': 5,
          'message': '',
        },
      );

      expect(dto.total, 5);
      expect(dto.items, hasLength(1));
      expect(dto.items.first.status, 'resolved');
    });

    test('supports wrapped body payload', () {
      final FeedbackListResponseDto dto = FeedbackListResponseDto.fromJson(
        <String, Object?>{
          'message': 'ok',
          'body': <String, Object?>{
            'items': <Object?>[],
            'total': 0,
          },
        },
      );

      expect(dto.total, 0);
      expect(dto.items, isEmpty);
      expect(dto.message, 'ok');
    });
  });
}
