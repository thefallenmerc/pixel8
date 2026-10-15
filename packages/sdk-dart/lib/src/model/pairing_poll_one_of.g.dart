// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_poll_one_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PairingPollOneOf extends PairingPollOneOf {
  @override
  final JsonObject? status;

  factory _$PairingPollOneOf(
          [void Function(PairingPollOneOfBuilder)? updates]) =>
      (PairingPollOneOfBuilder()..update(updates))._build();

  _$PairingPollOneOf._({this.status}) : super._();
  @override
  PairingPollOneOf rebuild(void Function(PairingPollOneOfBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PairingPollOneOfBuilder toBuilder() =>
      PairingPollOneOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PairingPollOneOf && status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PairingPollOneOf')
          ..add('status', status))
        .toString();
  }
}

class PairingPollOneOfBuilder
    implements Builder<PairingPollOneOf, PairingPollOneOfBuilder> {
  _$PairingPollOneOf? _$v;

  JsonObject? _status;
  JsonObject? get status => _$this._status;
  set status(JsonObject? status) => _$this._status = status;

  PairingPollOneOfBuilder() {
    PairingPollOneOf._defaults(this);
  }

  PairingPollOneOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PairingPollOneOf other) {
    _$v = other as _$PairingPollOneOf;
  }

  @override
  void update(void Function(PairingPollOneOfBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PairingPollOneOf build() => _build();

  _$PairingPollOneOf _build() {
    final _$result = _$v ??
        _$PairingPollOneOf._(
          status: status,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
