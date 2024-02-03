/// This package provides an interface for cancelation tokens as well as various
/// implementations:
///
/// * [CancelableToken] which can be canceled programmatically;
/// * [CompositeToken] which is canceled when any or all tokens are canceled;
/// * [TimeoutToken] which is canceled after a timeout period.
///
/// **Example**
///
/// Cancel a long-running execution after a timeout.
///
/// ```dart
/// import 'package:cancelation_token/cancelation_token.dart';
///
/// void main() async {
///   final timeout = Duration(seconds: 5);
///   final errorOnTimeout = CanceledException.withStackTrace('Too long!');
///   final token = TimeoutToken(timeout, errorOnTimeout);
///   token.ensureStarted();
///
///   try {
///     await longProcess(token);
///   } on CanceledException catch (ex, st) {
///     print(ex.message);
///     print(ex.stackTrace);
///     print(st);
///   }
/// }
///
/// Future<void> longProcess(CancelationToken token) async {
///   // very long indeed!
///   while (true) {
///     token.throwIfCanceled();
///     await Future.delayed(const Duration(milliseconds: 100));
///   }
/// }
/// ```
///
library;

import 'src/tokens/cancelable_token.dart';
import 'src/tokens/composite_token.dart';
import 'src/tokens/timeout_token.dart';

export 'src/cancelation_token.dart';
export 'src/exceptions/canceled_exception.dart';
export 'src/exceptions/canceled_exceptions.dart';
export 'src/exceptions/timeout_canceled_exception.dart';
export 'src/tokens/cancelable_token.dart';
export 'src/tokens/composite_token.dart';
export 'src/tokens/timeout_token.dart';
