import 'canceled_exception.dart';

class CanceledExceptions implements CanceledException {
  CanceledExceptions(Iterable<CanceledException?> exceptions)
      : _exceptions = exceptions.whereType<CanceledException>().toList();

  final List<CanceledException> _exceptions;

  Iterable<CanceledException> get innerExceptions => _exceptions.map(_self);

  @override
  String get message => _exceptions.map((e) => e.message).join('\n');

  @override
  StackTrace? get stackTrace => null;
}

X _self<X>(X x) => x;
