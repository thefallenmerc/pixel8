// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accepted.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Accepted extends Accepted {
  @override
  final int accepted;

  factory _$Accepted([void Function(AcceptedBuilder)? updates]) =>
      (AcceptedBuilder()..update(updates))._build();

  _$Accepted._({required this.accepted}) : super._();
  @override
  Accepted rebuild(void Function(AcceptedBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AcceptedBuilder toBuilder() => AcceptedBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Accepted && accepted == other.accepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Accepted')..add('accepted', accepted))
        .toString();
  }
}

class AcceptedBuilder implements Builder<Accepted, AcceptedBuilder> {
  _$Accepted? _$v;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  AcceptedBuilder() {
    Accepted._defaults(this);
  }

  AcceptedBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Accepted other) {
    _$v = other as _$Accepted;
  }

  @override
  void update(void Function(AcceptedBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Accepted build() => _build();

  _$Accepted _build() {
    final _$result = _$v ??
        _$Accepted._(
          accepted: BuiltValueNullFieldError.checkNotNull(
              accepted, r'Accepted', 'accepted'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
