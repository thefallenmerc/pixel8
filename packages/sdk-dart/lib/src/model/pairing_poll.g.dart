// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_poll.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PairingPoll extends PairingPoll {
  @override
  final OneOf oneOf;

  factory _$PairingPoll([void Function(PairingPollBuilder)? updates]) =>
      (PairingPollBuilder()..update(updates))._build();

  _$PairingPoll._({required this.oneOf}) : super._();
  @override
  PairingPoll rebuild(void Function(PairingPollBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PairingPollBuilder toBuilder() => PairingPollBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PairingPoll && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PairingPoll')..add('oneOf', oneOf))
        .toString();
  }
}

class PairingPollBuilder implements Builder<PairingPoll, PairingPollBuilder> {
  _$PairingPoll? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  PairingPollBuilder() {
    PairingPoll._defaults(this);
  }

  PairingPollBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PairingPoll other) {
    _$v = other as _$PairingPoll;
  }

  @override
  void update(void Function(PairingPollBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PairingPoll build() => _build();

  _$PairingPoll _build() {
    final _$result = _$v ??
        _$PairingPoll._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
              oneOf, r'PairingPoll', 'oneOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
