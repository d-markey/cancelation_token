import 'exceptions/canceled_exception.dart';

/// Base class for cancelation tokens.
abstract class CancelationToken {
  /// Return `true` if the token was canceled, `false` otherwise.
  bool get isCanceled => (exception != null);

  /// Return the [exception] that canceled the token, if it was canceled.
  /// Otherwise return `null`.
  CanceledException? get exception;

  /// [Future] that completes with the [exception] after the token is canceled.
  /// If the token is never canceled, this future never completes.
  Future<CanceledException> get onCanceled;

  /// If the token is a timeout token, or if it contains one, this method makes
  /// sure the timeout countdown has started.
  void ensureStarted();

  /// If the token was cancelled, throws the [CanceledException] that caused
  /// the cancelation (see [exception]). Otherwise, this method has no effect.
  void throwIfCanceled() {
    if (exception != null) {
      throw exception!;
    }
  }

  /// This method will throw the [exception] asynchronously.
  Future<void> refreshAndThrowIfCanceled() => Future(throwIfCanceled);
}
