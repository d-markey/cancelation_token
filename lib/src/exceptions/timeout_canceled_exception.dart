import 'dart:async';

import 'canceled_exception.dart';

/// Cancelation exception for timeout tokens. It also implements
/// [TimeoutException].
class TimeoutCanceledException extends CanceledException
    implements TimeoutException {
  TimeoutCanceledException(
      {this.duration, String message = 'Operation timed out.'})
      : super(message);

  TimeoutCanceledException.withStackTrace(
      {this.duration, String message = 'Operation timed out.'})
      : super.withStackTrace(message);

  @override
  final Duration? duration;
}
