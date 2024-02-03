import 'package:cancelation_token/cancelation_token.dart';
import 'package:test/test.dart';

import 'test_canceled_exception.dart';

void main() {
  group('$CompositeToken', () {
    test('any', () async {
      final token1 = CancelableToken();
      final token2 = CancelableToken();

      final token = CompositeToken.any([token1, token2]);

      token.throwIfCanceled();

      await token1.cancel(TestCanceledException('token 1'));
      expect(token.isCanceled, isTrue);

      await token2.cancel(TestCanceledException('token 2'));
      expect(token.isCanceled, isTrue);

      try {
        token.throwIfCanceled();
        throw Exception(
            'token is canceled but did not throw a CanceledException');
      } on CanceledException catch (ex) {
        expect(ex, isA<TestCanceledException>());
        expect(ex.message, equals('token 1'));
      }
    });

    test('all', () async {
      final token1 = CancelableToken();
      final token2 = CancelableToken();

      final token = CompositeToken.all([token1, token2]);

      token.throwIfCanceled();

      await token2.cancel(TestCanceledException('token 2'));
      expect(token.isCanceled, isFalse);

      token.throwIfCanceled();

      await token1.cancel(TestCanceledException('token 1'));
      expect(token.isCanceled, isTrue);

      try {
        token.throwIfCanceled();
        throw Exception(
            'token is canceled but did not throw a CanceledException');
      } on CanceledException catch (ex) {
        expect(ex, isA<CanceledExceptions>());
        final actualEx = ex as CanceledExceptions;
        expect(actualEx.innerExceptions.length, equals(2));
        expect(actualEx.innerExceptions.first.message, equals('token 1'));
        expect(actualEx.innerExceptions.last.message, equals('token 2'));
      }
    });
  });
}
