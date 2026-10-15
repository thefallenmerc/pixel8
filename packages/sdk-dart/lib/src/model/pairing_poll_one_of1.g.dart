// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_poll_one_of1.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PairingPollOneOf1 extends PairingPollOneOf1 {
  @override
  final JsonObject? status;
  @override
  final String deviceToken;
  @override
  final String screenId;

  factory _$PairingPollOneOf1(
          [void Function(PairingPollOneOf1Builder)? updates]) =>
      (PairingPollOneOf1Builder()..update(updates))._build();

  _$PairingPollOneOf1._(
      {this.status, required this.deviceToken, required this.screenId})
      : super._();
  @override
  PairingPollOneOf1 rebuild(void Function(PairingPollOneOf1Builder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PairingPollOneOf1Builder toBuilder() =>
      PairingPollOneOf1Builder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PairingPollOneOf1 &&
        status == other.status &&
        deviceToken == other.deviceToken &&
        screenId == other.screenId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, deviceToken.hashCode);
    _$hash = $jc(_$hash, screenId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PairingPollOneOf1')
          ..add('status', status)
          ..add('deviceToken', deviceToken)
          ..add('screenId', screenId))
        .toString();
  }
}

class PairingPollOneOf1Builder
    implements Builder<PairingPollOneOf1, PairingPollOneOf1Builder> {
  _$PairingPollOneOf1? _$v;

  JsonObject? _status;
  JsonObject? get status => _$this._status;
  set status(JsonObject? status) => _$this._status = status;

  String? _deviceToken;
  String? get deviceToken => _$this._deviceToken;
  set deviceToken(String? deviceToken) => _$this._deviceToken = deviceToken;

  String? _screenId;
  String? get screenId => _$this._screenId;
  set screenId(String? screenId) => _$this._screenId = screenId;

  PairingPollOneOf1Builder() {
    PairingPollOneOf1._defaults(this);
  }

  PairingPollOneOf1Builder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _deviceToken = $v.deviceToken;
      _screenId = $v.screenId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PairingPollOneOf1 other) {
    _$v = other as _$PairingPollOneOf1;
  }

  @override
  void update(void Function(PairingPollOneOf1Builder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PairingPollOneOf1 build() => _build();

  _$PairingPollOneOf1 _build() {
    final _$result = _$v ??
        _$PairingPollOneOf1._(
          status: status,
          deviceToken: BuiltValueNullFieldError.checkNotNull(
              deviceToken, r'PairingPollOneOf1', 'deviceToken'),
          screenId: BuiltValueNullFieldError.checkNotNull(
              screenId, r'PairingPollOneOf1', 'screenId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
