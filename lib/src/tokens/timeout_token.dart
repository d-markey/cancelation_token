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

  CanceledException? _exception;

  /// The [timeout] duration for canceling the token.
  final Duration timeout;
  Timer? _timer;

  final _canceler = Completer<CanceledException>();

  @override
  bool get isCanceled => _canceler.isCompleted;

  @override
  Future<CanceledException> get onCanceled => _canceler.future;

  /// Start the [timeout] countdown.
  void ensureStarted() {
    if (timeout == Duration.zero) {
      _cancel();
    } else {
      _timer ??= Timer.periodic(timeout, (t) {
        t.cancel();
        _cancel();
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

  @override
  void throwIfCanceled() {
    if (_canceler.isCompleted && _exception != null) {
      throw _exception!;
    }
  }

  void _cancel() {
    if (!_canceler.isCompleted) {
      _exception ??= TimeoutCanceledException();
      _canceler.complete(_exception);
    }
  }
}
