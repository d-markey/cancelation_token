import 'exceptions/canceled_exception.dart';

/// Base class for cancelation tokens.
abstract class CancelationToken {
  /// `true` if the token was canceled, `false` otherwise.
  bool get isCanceled;

  /// [Future] that completes with a [CanceledException] when the token is
  /// canceled. If the token is never canceled, this future never completes.
  Future<CanceledException> get onCanceled;

  /// If the token was cancelled, throws the [CanceledException] that caused
  /// the cancelation. Otherwise, this method has no effect.
  void throwIfCanceled();

  /// If the token was canceled, this method will trigger any code that has
  /// been attached to [onCanceled] and then throw the [CanceledException].
  Future refreshAndThrowIfCanceled() async {
    await Future.delayed(Duration.zero);
    throwIfCanceled();
  }
}
