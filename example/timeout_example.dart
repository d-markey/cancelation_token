import 'package:cancelation_token/cancelation_token.dart';

import 'long_process.dart';

void main() async {
  final timeout = Duration(seconds: 3);
  final errorOnTimeout = CanceledException.withStackTrace('Too long!');
  final token = TimeoutToken(timeout, errorOnTimeout);
  token.ensureStarted();

  try {
    await longProcess(token);
  } on CanceledException catch (ex, st) {
    print(ex.message);
    print(ex.stackTrace);
    print(st);
  }
}
