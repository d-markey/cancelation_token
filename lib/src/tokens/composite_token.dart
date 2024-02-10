import 'dart:async';

import '../cancelation_token.dart';
import '../exceptions/canceled_exception.dart';
import '../exceptions/canceled_exceptions.dart';

enum _Mode {
  any,
  every,
}

/// Cancelation token that get canceled when one or all tracked cancelation
/// tokens are canceled.
class CompositeToken extends CancelationToken {
  CompositeToken._(Iterable<CancelationToken> tokens, this._mode)
      : _tokens = tokens.toList() {
    _checkTokens();
    for (var idx = 0; idx < _tokens.length; idx++) {
      _tokens[idx].onCanceled.then((_) => _checkTokens(idx));
    }
  }

  /// This constructor builds a cancelation token that will be canceled when
  /// one of the provided tokens is canceled.
  CompositeToken.any(Iterable<CancelationToken> tokens)
      : this._(tokens, _Mode.any);

  /// This constructor builds a cancelation token that will be canceled when
  /// all of the provided tokens are canceled.
  CompositeToken.all(Iterable<CancelationToken> tokens)
      : this._(tokens, _Mode.every);

  final _Mode _mode;
  final List<CancelationToken> _tokens;

  @override
  Future<CanceledException> get onCanceled => _canceler.future;
  final _canceler = Completer<CanceledException>();

  @override
  CanceledException? get exception => _exception;
  CanceledException? _exception;

  @override
  bool get isCanceled {
    _checkTokens();
    return super.isCanceled;
  }

  @override
  void ensureStarted() {
    for (var t in _tokens) {
      t.ensureStarted();
    }
  }

  @override
  void throwIfCanceled() {
    _checkTokens();
    super.throwIfCanceled();
  }

  void _checkTokens([int? idx]) {
    if (_exception == null) {
      CanceledException? first;
      var pending = _tokens.length;
      // check monitored tokens
      for (var i = 0; i < _tokens.length; i++) {
        final ex = _tokens[i].exception;
        if (ex != null) {
          pending -= 1;
          first ??= ex;
        }
      }
      // update token state
      switch (_mode) {
        case _Mode.any:
          _exception ??= (idx != null) ? _tokens[idx].exception : first;
          break;
        case _Mode.every:
          _exception ??= (pending == 0)
              ? CanceledExceptions(_tokens.map((e) => e.exception))
              : null;
      }
      // complete future
      if (!_canceler.isCompleted && _exception != null) {
        _canceler.complete(_exception);
      }
    }
  }
}
