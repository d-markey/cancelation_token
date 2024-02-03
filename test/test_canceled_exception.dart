import 'package:cancelation_token/cancelation_token.dart';

class TestCanceledException extends CanceledException {
  TestCanceledException([super.message = 'Ccancelation test']);
}
