import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';

/// A programmatically cancelable token.
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

  /// Cancel the token. Multiple calls are allowed but only the first one will
  /// be taken into account.
  Future<void> cancel([CanceledException? exception]) {
    if (!_canceler.isCompleted) {
      _exception = exception ?? CanceledException();
      _canceler.complete(_exception);
    }
    return _canceledFuture;
  }

  static final _canceledFuture = Future.value();
}
