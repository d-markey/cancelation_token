import 'dart:async';

import 'package:cancelation_token/cancelation_token.dart';

Future<void> longProcess(CancelationToken token) async {
  // very long indeed!
  while (true) {
    await token.refreshAndThrowIfCanceled();
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
