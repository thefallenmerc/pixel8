// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_mode.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DisplayMode extends DisplayMode {
  @override
  final int width;
  @override
  final int height;
  @override
  final num refreshHz;

  factory _$DisplayMode([void Function(DisplayModeBuilder)? updates]) =>
      (DisplayModeBuilder()..update(updates))._build();

  _$DisplayMode._(
      {required this.width, required this.height, required this.refreshHz})
      : super._();
  @override
  DisplayMode rebuild(void Function(DisplayModeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DisplayModeBuilder toBuilder() => DisplayModeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DisplayMode &&
        width == other.width &&
        height == other.height &&
        refreshHz == other.refreshHz;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, width.hashCode);
    _$hash = $jc(_$hash, height.hashCode);
    _$hash = $jc(_$hash, refreshHz.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DisplayMode')
          ..add('width', width)
          ..add('height', height)
          ..add('refreshHz', refreshHz))
        .toString();
  }
}

class DisplayModeBuilder implements Builder<DisplayMode, DisplayModeBuilder> {
  _$DisplayMode? _$v;

  int? _width;
  int? get width => _$this._width;
  set width(int? width) => _$this._width = width;

  int? _height;
  int? get height => _$this._height;
  set height(int? height) => _$this._height = height;

  num? _refreshHz;
  num? get refreshHz => _$this._refreshHz;
  set refreshHz(num? refreshHz) => _$this._refreshHz = refreshHz;

  DisplayModeBuilder() {
    DisplayMode._defaults(this);
  }

  DisplayModeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _width = $v.width;
      _height = $v.height;
      _refreshHz = $v.refreshHz;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DisplayMode other) {
    _$v = other as _$DisplayMode;
  }

  @override
  void update(void Function(DisplayModeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DisplayMode build() => _build();

  _$DisplayMode _build() {
    final _$result = _$v ??
        _$DisplayMode._(
          width: BuiltValueNullFieldError.checkNotNull(
              width, r'DisplayMode', 'width'),
          height: BuiltValueNullFieldError.checkNotNull(
              height, r'DisplayMode', 'height'),
          refreshHz: BuiltValueNullFieldError.checkNotNull(
              refreshHz, r'DisplayMode', 'refreshHz'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
