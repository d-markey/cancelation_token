import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';
import '../exceptions/canceled_exceptions.dart';

class CompositeToken extends CancelationToken {
  CompositeToken.any(Iterable<CancelationToken> tokens) {
    for (var t in tokens) {
      t.onCanceled.then(_cancel);
    }
  }

  CompositeToken.all(Iterable<CancelationToken> tokens) {
    final list = tokens.toList();
    final count = list.length;
    final exceptions = List<CanceledException?>.generate(count, (i) => null);
    for (var i = 0; i < count; i++) {
      list[i].onCanceled.then((ex) {
        exceptions[i] = ex;
        if (exceptions.whereType<CanceledException>().length == count) {
          _cancel(CanceledExceptions(exceptions));
        }
      });
    }
  }

  final _canceler = Completer<CanceledException>();

  @override
  bool get isCanceled => _canceler.isCompleted;

  @override
  Future<CanceledException> get onCanceled => _canceler.future;

  CanceledException? _exception;

  @override
  void throwIfCanceled() {
    if (_exception != null) {
      throw _exception!;
    }
  }

  void _cancel(CanceledException exception) {
    if (!_canceler.isCompleted) {
      _exception = exception;
      _canceler.complete(_exception);
    }
  }
}
