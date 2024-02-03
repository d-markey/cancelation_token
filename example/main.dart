import 'cancelable_example.dart' as cancelable;
import 'composite_example.dart' as composite;
import 'timeout_example.dart' as timeout;

void main() async {
  print('CANCELABLE EXAMPLE');
  await cancelable.main();

  print('');
  print('TIMEOUT EXAMPLE');
  await timeout.main();

  print('');
  print('COMPOSITE EXAMPLE');
  await composite.main();
}
