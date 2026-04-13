import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_ui/mini_app_ui.dart';

void main() {
  group('SilentMiniAppLogger', () {
    test('onError does not throw', () {
      const SilentMiniAppLogger logger = SilentMiniAppLogger();
      expect(
        () => logger.onError('test', error: 'some error'),
        returnsNormally,
      );
    });

    test('onInfo does not throw', () {
      const SilentMiniAppLogger logger = SilentMiniAppLogger();
      expect(
        () => logger.onInfo('test', data: <String, Object?>{'key': 'value'}),
        returnsNormally,
      );
    });
  });

  group('DebugMiniAppLogger', () {
    test('onError does not throw', () {
      const DebugMiniAppLogger logger = DebugMiniAppLogger();
      expect(
        () => logger.onError(
          'test_event',
          error: StateError('boom'),
          stackTrace: StackTrace.current,
          data: <String, Object?>{'context': 'unit_test'},
        ),
        returnsNormally,
      );
    });

    test('onInfo does not throw', () {
      const DebugMiniAppLogger logger = DebugMiniAppLogger();
      expect(
        () => logger.onInfo(
          'info_event',
          data: <String, Object?>{'key': 42},
        ),
        returnsNormally,
      );
    });

    test('implements MiniAppLogger', () {
      const DebugMiniAppLogger logger = DebugMiniAppLogger();
      expect(logger, isA<MiniAppLogger>());
    });
  });
}
