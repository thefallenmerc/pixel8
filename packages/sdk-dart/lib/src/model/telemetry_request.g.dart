// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TelemetryRequest extends TelemetryRequest {
  @override
  final BuiltList<TelemetrySample> samples;

  factory _$TelemetryRequest(
          [void Function(TelemetryRequestBuilder)? updates]) =>
      (TelemetryRequestBuilder()..update(updates))._build();

  _$TelemetryRequest._({required this.samples}) : super._();
  @override
  TelemetryRequest rebuild(void Function(TelemetryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TelemetryRequestBuilder toBuilder() =>
      TelemetryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TelemetryRequest && samples == other.samples;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, samples.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TelemetryRequest')
          ..add('samples', samples))
        .toString();
  }
}

class TelemetryRequestBuilder
    implements Builder<TelemetryRequest, TelemetryRequestBuilder> {
  _$TelemetryRequest? _$v;

  ListBuilder<TelemetrySample>? _samples;
  ListBuilder<TelemetrySample> get samples =>
      _$this._samples ??= ListBuilder<TelemetrySample>();
  set samples(ListBuilder<TelemetrySample>? samples) =>
      _$this._samples = samples;

  TelemetryRequestBuilder() {
    TelemetryRequest._defaults(this);
  }

  TelemetryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _samples = $v.samples.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TelemetryRequest other) {
    _$v = other as _$TelemetryRequest;
  }

  @override
  void update(void Function(TelemetryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TelemetryRequest build() => _build();

  _$TelemetryRequest _build() {
    _$TelemetryRequest _$result;
    try {
      _$result = _$v ??
          _$TelemetryRequest._(
            samples: samples.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'samples';
        samples.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TelemetryRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
