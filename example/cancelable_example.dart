import 'dart:async';

import 'package:cancelation_token/cancelation_token.dart';

import 'long_process.dart';

void main() async {
  final token = CancelableToken();

  int counter = 0;
  Timer.periodic(Duration(seconds: 1), (timer) {
    counter++;
    print('[$counter] still running...');
    if (counter > 3) {
      token.cancel(CanceledException.withStackTrace('Too long!'));
      timer.cancel();
    }
  });

  try {
    await longProcess(token);
  } on CanceledException catch (ex, st) {
    print(ex.message);
    print(ex.stackTrace);
    print(st);
  }
}
