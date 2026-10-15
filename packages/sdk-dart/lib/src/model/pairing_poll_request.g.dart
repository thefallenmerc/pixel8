// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pairing_poll_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PairingPollRequest extends PairingPollRequest {
  @override
  final String pollToken;

  factory _$PairingPollRequest(
          [void Function(PairingPollRequestBuilder)? updates]) =>
      (PairingPollRequestBuilder()..update(updates))._build();

  _$PairingPollRequest._({required this.pollToken}) : super._();
  @override
  PairingPollRequest rebuild(
          void Function(PairingPollRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PairingPollRequestBuilder toBuilder() =>
      PairingPollRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PairingPollRequest && pollToken == other.pollToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pollToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PairingPollRequest')
          ..add('pollToken', pollToken))
        .toString();
  }
}

class PairingPollRequestBuilder
    implements Builder<PairingPollRequest, PairingPollRequestBuilder> {
  _$PairingPollRequest? _$v;

  String? _pollToken;
  String? get pollToken => _$this._pollToken;
  set pollToken(String? pollToken) => _$this._pollToken = pollToken;

  PairingPollRequestBuilder() {
    PairingPollRequest._defaults(this);
  }

  PairingPollRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pollToken = $v.pollToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PairingPollRequest other) {
    _$v = other as _$PairingPollRequest;
  }

  @override
  void update(void Function(PairingPollRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PairingPollRequest build() => _build();

  _$PairingPollRequest _build() {
    final _$result = _$v ??
        _$PairingPollRequest._(
          pollToken: BuiltValueNullFieldError.checkNotNull(
              pollToken, r'PairingPollRequest', 'pollToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
