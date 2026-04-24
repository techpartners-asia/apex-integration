import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/feedback/domain/feedback_entity.dart';

void main() {
  group('FeedbackEntity.fromJson', () {
    test('parses complete JSON correctly', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{
          'id': 42,
          'title': 'Bug report',
          'description': 'Something broke',
          'status': 'pending',
          'created_at': '2026-01-15T10:30:00Z',
          'updated_at': '2026-01-15T12:00:00Z',
          'user_id': 7,
        },
      );

      expect(entity.id, 42);
      expect(entity.title, 'Bug report');
      expect(entity.description, 'Something broke');
      expect(entity.status, FeedbackStatus.pending);
      expect(entity.createdAt, '2026-01-15T10:30:00Z');
      expect(entity.updatedAt, '2026-01-15T12:00:00Z');
      expect(entity.userId, 7);
    });

    test('defaults missing fields safely', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{},
      );

      expect(entity.id, 0);
      expect(entity.title, '');
      expect(entity.description, '');
      expect(entity.status, FeedbackStatus.pending);
      expect(entity.createdAt, '');
      expect(entity.updatedAt, '');
      expect(entity.userId, 0);
    });

    test('parses resolved status', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{'status': 'resolved'},
      );
      expect(entity.status, FeedbackStatus.resolved);
    });

    test('parses closed status', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{'status': 'closed'},
      );
      expect(entity.status, FeedbackStatus.closed);
    });

    test('parses case-insensitive status', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{'status': 'RESOLVED'},
      );
      expect(entity.status, FeedbackStatus.resolved);
    });

    test('treats unknown status as pending', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{'status': 'unknown_value'},
      );
      expect(entity.status, FeedbackStatus.pending);
    });

    test('parses string id as int', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{'id': '99'},
      );
      expect(entity.id, 99);
    });

    test('parses numeric double id as int', () {
      final FeedbackEntity entity = FeedbackEntity.fromJson(
        const <String, Object?>{'id': 5.0},
      );
      expect(entity.id, 5);
    });
  });
}
