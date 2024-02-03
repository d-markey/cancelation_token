import 'dart:math';

import 'package:cancelation_token/cancelation_token.dart';

import 'long_process.dart';

void main() async {
  final rnd = Random();

  final timeout1 = Duration(milliseconds: 2000 + 250 * rnd.nextInt(4));
  final token1 = TimeoutToken(
    timeout1,
    CanceledException.withStackTrace('token 1: $timeout1'),
  );

  final timeout2 = Duration(milliseconds: 1000 + 250 * rnd.nextInt(8));
  final token2 = TimeoutToken(
    timeout2,
    CanceledException.withStackTrace('token 2: $timeout2'),
  );

  print('timeout1 = $timeout1');
  print('timeout2 = $timeout2');

  token1.ensureStarted();
  token2.ensureStarted();

  final token = CompositeToken.any([token1, token2]);

  try {
    await longProcess(token);
  } on CanceledException catch (ex, st) {
    print(ex.message);
    print(ex.stackTrace);
    print(st);
  }
}
