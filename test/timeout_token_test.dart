import 'package:cancelation_token/cancelation_token.dart';
import 'package:test/test.dart';

import 'test_canceled_exception.dart';

void main() {
  group('$TimeoutToken', () {
    final smallDelay = Duration(milliseconds: 10);
    final timeout = smallDelay * 10;

    test('is canceled after timeout', () async {
      final token = TimeoutToken(timeout, TestCanceledException());
      expect(token.isCanceled, isFalse);

      var res = 0;
      token.onCanceled.then((canceled) {
        expect(canceled, isA<CanceledException>());
        res += 1;
      });

      expect(token.isCanceled, isFalse);
      expect(res, isZero);

      token.throwIfCanceled();

      token.ensureStarted();

      await Future.delayed(timeout + smallDelay);

      expect(token.isCanceled, isTrue);
      expect(res, equals(1));

      await Future.delayed(timeout + smallDelay);

      expect(token.isCanceled, isTrue);
      expect(res, equals(1));

      await expectLater(
          () => token.throwIfCanceled(), throwsA(isA<TestCanceledException>()));
    });

    test('is not canceled until ensureStarted() is called', () async {
      final token = TimeoutToken(timeout, TestCanceledException());
      expect(token.isCanceled, isFalse);

      var res = 0;
      token.onCanceled.then((canceled) {
        expect(canceled, isA<CanceledException>());
        res += 1;
      });

      expect(token.isCanceled, isFalse);
      expect(res, isZero);

      token.throwIfCanceled();

      await Future.delayed(timeout * 2);

      expect(token.isCanceled, isFalse);
      expect(res, isZero);

      token.throwIfCanceled();

      token.ensureStarted();

      await Future.delayed(smallDelay);

      expect(token.isCanceled, isFalse);
      expect(res, isZero);

      token.throwIfCanceled();

      await Future.delayed(timeout);

      expect(token.isCanceled, isTrue);
      expect(res, equals(1));

      await expectLater(
          () => token.throwIfCanceled(), throwsA(isA<TestCanceledException>()));
    });

    test('is canceled immediately after ensureStarted() if timeout is zero',
        () async {
      final token = TimeoutToken(Duration.zero, TestCanceledException());
      expect(token.isCanceled, isFalse);

      var res = 0;
      token.onCanceled.then((canceled) {
        expect(canceled, isA<CanceledException>());
        res += 1;
      });

      expect(token.isCanceled, isFalse);
      expect(res, isZero);

      token.throwIfCanceled();

      token.ensureStarted();

      expect(token.isCanceled, isTrue);
      expect(res, isZero);

      await expectLater(
          () => token.throwIfCanceled(), throwsA(isA<TestCanceledException>()));

      expect(token.isCanceled, isTrue);
      expect(res, equals(1));
    });
  });
}
