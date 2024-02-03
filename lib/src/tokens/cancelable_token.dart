import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';

class CancelableToken extends CancelationToken {
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

  Future<void> cancel([CanceledException? exception]) {
    if (!_canceler.isCompleted) {
      _exception = exception ?? CanceledException();
      _canceler.complete(_exception);
    }
    return _canceledFuture;
  }

  static final _canceledFuture = Future.value();
}
