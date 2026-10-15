// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_telemetry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScreenTelemetry extends ScreenTelemetry {
  @override
  final int hours;

  factory _$ScreenTelemetry([void Function(ScreenTelemetryBuilder)? updates]) =>
      (ScreenTelemetryBuilder()..update(updates))._build();

  _$ScreenTelemetry._({required this.hours}) : super._();
  @override
  ScreenTelemetry rebuild(void Function(ScreenTelemetryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreenTelemetryBuilder toBuilder() => ScreenTelemetryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScreenTelemetry && hours == other.hours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScreenTelemetry')
          ..add('hours', hours))
        .toString();
  }
}

class ScreenTelemetryBuilder
    implements Builder<ScreenTelemetry, ScreenTelemetryBuilder> {
  _$ScreenTelemetry? _$v;

  int? _hours;
  int? get hours => _$this._hours;
  set hours(int? hours) => _$this._hours = hours;

  ScreenTelemetryBuilder() {
    ScreenTelemetry._defaults(this);
  }

  ScreenTelemetryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hours = $v.hours;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScreenTelemetry other) {
    _$v = other as _$ScreenTelemetry;
  }

  @override
  void update(void Function(ScreenTelemetryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScreenTelemetry build() => _build();

  _$ScreenTelemetry _build() {
    final _$result = _$v ??
        _$ScreenTelemetry._(
          hours: BuiltValueNullFieldError.checkNotNull(
              hours, r'ScreenTelemetry', 'hours'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
