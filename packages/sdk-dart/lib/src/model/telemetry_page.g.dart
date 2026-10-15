// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TelemetryPage extends TelemetryPage {
  @override
  final BuiltList<TelemetrySample> items;

  factory _$TelemetryPage([void Function(TelemetryPageBuilder)? updates]) =>
      (TelemetryPageBuilder()..update(updates))._build();

  _$TelemetryPage._({required this.items}) : super._();
  @override
  TelemetryPage rebuild(void Function(TelemetryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TelemetryPageBuilder toBuilder() => TelemetryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TelemetryPage && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TelemetryPage')..add('items', items))
        .toString();
  }
}

class TelemetryPageBuilder
    implements Builder<TelemetryPage, TelemetryPageBuilder> {
  _$TelemetryPage? _$v;

  ListBuilder<TelemetrySample>? _items;
  ListBuilder<TelemetrySample> get items =>
      _$this._items ??= ListBuilder<TelemetrySample>();
  set items(ListBuilder<TelemetrySample>? items) => _$this._items = items;

  TelemetryPageBuilder() {
    TelemetryPage._defaults(this);
  }

  TelemetryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TelemetryPage other) {
    _$v = other as _$TelemetryPage;
  }

  @override
  void update(void Function(TelemetryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TelemetryPage build() => _build();

  _$TelemetryPage _build() {
    _$TelemetryPage _$result;
    try {
      _$result = _$v ??
          _$TelemetryPage._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TelemetryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
