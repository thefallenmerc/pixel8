// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_pair_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScreenPairRequest extends ScreenPairRequest {
  @override
  final String code;
  @override
  final String name;

  factory _$ScreenPairRequest(
          [void Function(ScreenPairRequestBuilder)? updates]) =>
      (ScreenPairRequestBuilder()..update(updates))._build();

  _$ScreenPairRequest._({required this.code, required this.name}) : super._();
  @override
  ScreenPairRequest rebuild(void Function(ScreenPairRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreenPairRequestBuilder toBuilder() =>
      ScreenPairRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScreenPairRequest &&
        code == other.code &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScreenPairRequest')
          ..add('code', code)
          ..add('name', name))
        .toString();
  }
}

class ScreenPairRequestBuilder
    implements Builder<ScreenPairRequest, ScreenPairRequestBuilder> {
  _$ScreenPairRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ScreenPairRequestBuilder() {
    ScreenPairRequest._defaults(this);
  }

  ScreenPairRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScreenPairRequest other) {
    _$v = other as _$ScreenPairRequest;
  }

  @override
  void update(void Function(ScreenPairRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScreenPairRequest build() => _build();

  _$ScreenPairRequest _build() {
    final _$result = _$v ??
        _$ScreenPairRequest._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'ScreenPairRequest', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ScreenPairRequest', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
