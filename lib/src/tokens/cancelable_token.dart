import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';

/// A programmatically cancelable token.
class CancelableToken extends CancelationToken {
  @override
  CanceledException? get exception => _exception;
  CanceledException? _exception;

  @override
  Future<CanceledException> get onCanceled => _canceler.future;
  final _canceler = Completer<CanceledException>();

  /// This method has no effect in [CancelableToken] instances.
  @override
  void ensureStarted() {}

  /// Cancel the token and return a completed future. Multiple calls are
  /// allowed but only the first one will be taken into account. Returns a
  /// completed future.
  Future<void> cancel([CanceledException? exception]) {
    _exception ??= exception ?? CanceledException();
    if (!_canceler.isCompleted) {
      _canceler.complete(_exception);
    }
    return _canceledFuture;
  }

  static final _canceledFuture = Future.value();
}
