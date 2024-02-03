class CanceledException implements Exception {
  CanceledException([this.message = 'Operation was canceled.'])
      : stackTrace = null;

  CanceledException.withStackTrace([this.message = 'Operation was canceled.'])
      : stackTrace = StackTrace.current;

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() =>
      message.trim().isEmpty ? '$runtimeType' : '$runtimeType: $message';
}
