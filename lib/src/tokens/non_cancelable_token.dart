import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';
import 'cancelable_token.dart';

/// A non-cancelable token.
class NonCancelableToken extends CancelationToken implements CancelableToken {
  const NonCancelableToken();

  @override
  CanceledException? get exception => null;

  @override
  bool get isCanceled => false;

  /// Returns a future that will never complete.
  @override
  Future<CanceledException> get onCanceled => _never.future;
  static final _never = Completer<CanceledException>();

  /// This method has no effect in [NonCancelableToken] instances.
  @override
  void ensureStarted() {}

  /// This method has no effect in [NonCancelableToken] instances.
  @override
  Future<void> cancel([CanceledException? exception]) => _completedFuture;

  /// [NonCancelableToken] never throws.
  @override
  void throwIfCanceled() {}

  /// [NonCancelableToken] never throws.
  @override
  Future<void> refreshAndThrowIfCanceled() => _completedFuture;
  static final _completedFuture = Future.value();
}
