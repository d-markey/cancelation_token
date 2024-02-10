import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';
import '../exceptions/timeout_canceled_exception.dart';

/// Cancelation token that get canceled after a [timeout] duration. Countdown
/// starts after a call to [ensureStarted].
class TimeoutToken extends CancelationToken {
  TimeoutToken(this.timeout, [CanceledException? exception])
      : _exception = exception {
    if (timeout.isNegative) {
      throw ArgumentError.value(timeout, 'timeout');
    }
  }

  /// The [timeout] duration for canceling the token.
  final Duration timeout;
  Timer? _timer;

  @override
  CanceledException? get exception => _canceler.isCompleted ? _exception : null;
  CanceledException? _exception;

  @override
  Future<CanceledException> get onCanceled => _canceler.future;
  final _canceler = Completer<CanceledException>();

  /// Start the [timeout] countdown.
  @override
  void ensureStarted() {
    if (timeout == Duration.zero) {
      _cancel();
    } else {
      _timer ??= Timer.periodic(timeout, (t) {
        _cancel();
        t.cancel();
      });
    }
  }

  /// Stop the countdown. The countdown can be restarted by calling
  /// [ensureStarted], but it will restart from the initial [timeout]
  /// duration.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _cancel() {
    _exception ??= TimeoutCanceledException();
    if (!_canceler.isCompleted) {
      _canceler.complete(_exception);
    }
  }
}
