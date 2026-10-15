// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ok.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Ok extends Ok {
  @override
  final bool ok;

  factory _$Ok([void Function(OkBuilder)? updates]) =>
      (OkBuilder()..update(updates))._build();

  _$Ok._({required this.ok}) : super._();
  @override
  Ok rebuild(void Function(OkBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OkBuilder toBuilder() => OkBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ok && ok == other.ok;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ok.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Ok')..add('ok', ok)).toString();
  }
}

class OkBuilder implements Builder<Ok, OkBuilder> {
  _$Ok? _$v;

  bool? _ok;
  bool? get ok => _$this._ok;
  set ok(bool? ok) => _$this._ok = ok;

  OkBuilder() {
    Ok._defaults(this);
  }

  OkBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ok = $v.ok;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Ok other) {
    _$v = other as _$Ok;
  }

  @override
  void update(void Function(OkBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Ok build() => _build();

  _$Ok _build() {
    final _$result = _$v ??
        _$Ok._(
          ok: BuiltValueNullFieldError.checkNotNull(ok, r'Ok', 'ok'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
