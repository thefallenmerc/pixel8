// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PairingRequest extends PairingRequest {
  @override
  final String deviceId;
  @override
  final Capabilities capabilities;

  factory _$PairingRequest([void Function(PairingRequestBuilder)? updates]) =>
      (PairingRequestBuilder()..update(updates))._build();

  _$PairingRequest._({required this.deviceId, required this.capabilities})
      : super._();
  @override
  PairingRequest rebuild(void Function(PairingRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PairingRequestBuilder toBuilder() => PairingRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PairingRequest &&
        deviceId == other.deviceId &&
        capabilities == other.capabilities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, capabilities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PairingRequest')
          ..add('deviceId', deviceId)
          ..add('capabilities', capabilities))
        .toString();
  }
}

class PairingRequestBuilder
    implements Builder<PairingRequest, PairingRequestBuilder> {
  _$PairingRequest? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  CapabilitiesBuilder? _capabilities;
  CapabilitiesBuilder get capabilities =>
      _$this._capabilities ??= CapabilitiesBuilder();
  set capabilities(CapabilitiesBuilder? capabilities) =>
      _$this._capabilities = capabilities;

  PairingRequestBuilder() {
    PairingRequest._defaults(this);
  }

  PairingRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _capabilities = $v.capabilities.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PairingRequest other) {
    _$v = other as _$PairingRequest;
  }

  @override
  void update(void Function(PairingRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PairingRequest build() => _build();

  _$PairingRequest _build() {
    _$PairingRequest _$result;
    try {
      _$result = _$v ??
          _$PairingRequest._(
            deviceId: BuiltValueNullFieldError.checkNotNull(
                deviceId, r'PairingRequest', 'deviceId'),
            capabilities: capabilities.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'capabilities';
        capabilities.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PairingRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
