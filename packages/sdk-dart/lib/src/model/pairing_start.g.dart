// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_start.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PairingStart extends PairingStart {
  @override
  final String pairingId;
  @override
  final String code;
  @override
  final String pollToken;
  @override
  final DateTime expiresAt;

  factory _$PairingStart([void Function(PairingStartBuilder)? updates]) =>
      (PairingStartBuilder()..update(updates))._build();

  _$PairingStart._(
      {required this.pairingId,
      required this.code,
      required this.pollToken,
      required this.expiresAt})
      : super._();
  @override
  PairingStart rebuild(void Function(PairingStartBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PairingStartBuilder toBuilder() => PairingStartBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PairingStart &&
        pairingId == other.pairingId &&
        code == other.code &&
        pollToken == other.pollToken &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pairingId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, pollToken.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PairingStart')
          ..add('pairingId', pairingId)
          ..add('code', code)
          ..add('pollToken', pollToken)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class PairingStartBuilder
    implements Builder<PairingStart, PairingStartBuilder> {
  _$PairingStart? _$v;

  String? _pairingId;
  String? get pairingId => _$this._pairingId;
  set pairingId(String? pairingId) => _$this._pairingId = pairingId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _pollToken;
  String? get pollToken => _$this._pollToken;
  set pollToken(String? pollToken) => _$this._pollToken = pollToken;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  PairingStartBuilder() {
    PairingStart._defaults(this);
  }

  PairingStartBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pairingId = $v.pairingId;
      _code = $v.code;
      _pollToken = $v.pollToken;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PairingStart other) {
    _$v = other as _$PairingStart;
  }

  @override
  void update(void Function(PairingStartBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PairingStart build() => _build();

  _$PairingStart _build() {
    final _$result = _$v ??
        _$PairingStart._(
          pairingId: BuiltValueNullFieldError.checkNotNull(
              pairingId, r'PairingStart', 'pairingId'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PairingStart', 'code'),
          pollToken: BuiltValueNullFieldError.checkNotNull(
              pollToken, r'PairingStart', 'pollToken'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'PairingStart', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
