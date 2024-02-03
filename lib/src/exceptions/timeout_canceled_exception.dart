import 'dart:async';

import 'canceled_exception.dart';

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
