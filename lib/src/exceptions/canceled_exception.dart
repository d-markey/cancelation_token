/// Base exception for cancelation tokens.
class CanceledException implements Exception {
  CanceledException([this.message = 'Operation was canceled.'])
      : stackTrace = null;

  /// This constructor keeps track of the stacktrace where it was created.
  CanceledException.withStackTrace([this.message = 'Operation was canceled.'])
      : stackTrace = StackTrace.current;

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      message.trim().isEmpty ? '$runtimeType' : '$runtimeType: $message';
}
