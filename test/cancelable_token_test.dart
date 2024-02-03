import 'package:cancelation_token/cancelation_token.dart';
import 'package:test/test.dart';

import 'test_canceled_exception.dart';

void main() {
  group('$CancelableToken', () {
    test('cancel()', () async {
      final token = CancelableToken();
      expect(token.isCanceled, isFalse);

      var res = 0;
      token.onCanceled.then((canceled) {
        expect(canceled, isA<CanceledException>());
        res += 1;
      });

      expect(token.isCanceled, isFalse);
      expect(res, isZero);

      token.throwIfCanceled();

      final cancelFuture = token.cancel(TestCanceledException());

      expect(token.isCanceled, isTrue);
      expect(res, isZero);

      await cancelFuture;

      expect(token.isCanceled, isTrue);
      expect(res, equals(1));

      await token.cancel(CanceledException());

      expect(token.isCanceled, isTrue);
      expect(res, equals(1));

      await expectLater(
          () => token.throwIfCanceled(), throwsA(isA<TestCanceledException>()));
    });
  });
}
