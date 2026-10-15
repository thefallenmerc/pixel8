// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_error.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorError extends ErrorError {
  @override
  final String code;
  @override
  final String message;
  @override
  final JsonObject? details;

  factory _$ErrorError([void Function(ErrorErrorBuilder)? updates]) =>
      (ErrorErrorBuilder()..update(updates))._build();

  _$ErrorError._({required this.code, required this.message, this.details})
      : super._();
  @override
  ErrorError rebuild(void Function(ErrorErrorBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorErrorBuilder toBuilder() => ErrorErrorBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorError &&
        code == other.code &&
        message == other.message &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ErrorError')
          ..add('code', code)
          ..add('message', message)
          ..add('details', details))
        .toString();
  }
}

class ErrorErrorBuilder implements Builder<ErrorError, ErrorErrorBuilder> {
  _$ErrorError? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  JsonObject? _details;
  JsonObject? get details => _$this._details;
  set details(JsonObject? details) => _$this._details = details;

  ErrorErrorBuilder() {
    ErrorError._defaults(this);
  }

  ErrorErrorBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _message = $v.message;
      _details = $v.details;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorError other) {
    _$v = other as _$ErrorError;
  }

  @override
  void update(void Function(ErrorErrorBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorError build() => _build();

  _$ErrorError _build() {
    final _$result = _$v ??
        _$ErrorError._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ErrorError', 'code'),
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'ErrorError', 'message'),
          details: details,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
