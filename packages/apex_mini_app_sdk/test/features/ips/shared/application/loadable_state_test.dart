import 'package:flutter_test/flutter_test.dart';
import 'package:mini_app_sdk/src/features/shared/application/loadable_state.dart';

void main() {
  group('LoadableState', () {
    test('initial state has correct defaults', () {
      const LoadableState<String> state = LoadableState<String>();
      expect(state.isInitial, isTrue);
      expect(state.isLoading, isFalse);
      expect(state.isSuccess, isFalse);
      expect(state.isFailure, isFalse);
      expect(state.data, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith preserves unchanged fields', () {
      const LoadableState<String> state = LoadableState<String>(
        status: LoadableStatus.success,
        data: 'hello',
        errorMessage: null,
      );
      final LoadableState<String> updated = state.copyWith(
        status: LoadableStatus.loading,
      );
      expect(updated.isLoading, isTrue);
      expect(updated.data, 'hello');
      expect(updated.errorMessage, isNull);
    });

    test('copyWith can set errorMessage to null explicitly', () {
      const LoadableState<String> state = LoadableState<String>(
        status: LoadableStatus.failure,
        errorMessage: 'Something failed',
      );
      final LoadableState<String> updated = state.copyWith(
        status: LoadableStatus.loading,
        errorMessage: null,
      );
      expect(updated.isLoading, isTrue);
      expect(updated.errorMessage, isNull);
    });

    test('equality: identical states are equal', () {
      const LoadableState<String> a = LoadableState<String>(
        status: LoadableStatus.success,
        data: 'data',
      );
      const LoadableState<String> b = LoadableState<String>(
        status: LoadableStatus.success,
        data: 'data',
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('equality: different status makes states unequal', () {
      const LoadableState<String> a = LoadableState<String>(
        status: LoadableStatus.loading,
        data: 'data',
      );
      const LoadableState<String> b = LoadableState<String>(
        status: LoadableStatus.success,
        data: 'data',
      );
      expect(a, isNot(equals(b)));
    });

    test('equality: different data makes states unequal', () {
      const LoadableState<String> a = LoadableState<String>(
        status: LoadableStatus.success,
        data: 'hello',
      );
      const LoadableState<String> b = LoadableState<String>(
        status: LoadableStatus.success,
        data: 'world',
      );
      expect(a, isNot(equals(b)));
    });

    test('equality: different errorMessage makes states unequal', () {
      const LoadableState<String> a = LoadableState<String>(
        status: LoadableStatus.failure,
        errorMessage: 'error A',
      );
      const LoadableState<String> b = LoadableState<String>(
        status: LoadableStatus.failure,
        errorMessage: 'error B',
      );
      expect(a, isNot(equals(b)));
    });

    test('equality: null data states are equal', () {
      const LoadableState<String> a = LoadableState<String>();
      const LoadableState<String> b = LoadableState<String>();
      expect(a, equals(b));
    });
  });
}
