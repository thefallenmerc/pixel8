// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'capabilities.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Capabilities extends Capabilities {
  @override
  final BuiltList<DisplayMode> displayModes;
  @override
  final DisplayMode selectedMode;
  @override
  final BuiltList<String> decoders;
  @override
  final bool supports1080p;
  @override
  final String softwareVersion;

  factory _$Capabilities([void Function(CapabilitiesBuilder)? updates]) =>
      (CapabilitiesBuilder()..update(updates))._build();

  _$Capabilities._(
      {required this.displayModes,
      required this.selectedMode,
      required this.decoders,
      required this.supports1080p,
      required this.softwareVersion})
      : super._();
  @override
  Capabilities rebuild(void Function(CapabilitiesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CapabilitiesBuilder toBuilder() => CapabilitiesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Capabilities &&
        displayModes == other.displayModes &&
        selectedMode == other.selectedMode &&
        decoders == other.decoders &&
        supports1080p == other.supports1080p &&
        softwareVersion == other.softwareVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, displayModes.hashCode);
    _$hash = $jc(_$hash, selectedMode.hashCode);
    _$hash = $jc(_$hash, decoders.hashCode);
    _$hash = $jc(_$hash, supports1080p.hashCode);
    _$hash = $jc(_$hash, softwareVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Capabilities')
          ..add('displayModes', displayModes)
          ..add('selectedMode', selectedMode)
          ..add('decoders', decoders)
          ..add('supports1080p', supports1080p)
          ..add('softwareVersion', softwareVersion))
        .toString();
  }
}

class CapabilitiesBuilder
    implements Builder<Capabilities, CapabilitiesBuilder> {
  _$Capabilities? _$v;

  ListBuilder<DisplayMode>? _displayModes;
  ListBuilder<DisplayMode> get displayModes =>
      _$this._displayModes ??= ListBuilder<DisplayMode>();
  set displayModes(ListBuilder<DisplayMode>? displayModes) =>
      _$this._displayModes = displayModes;

  DisplayModeBuilder? _selectedMode;
  DisplayModeBuilder get selectedMode =>
      _$this._selectedMode ??= DisplayModeBuilder();
  set selectedMode(DisplayModeBuilder? selectedMode) =>
      _$this._selectedMode = selectedMode;

  ListBuilder<String>? _decoders;
  ListBuilder<String> get decoders =>
      _$this._decoders ??= ListBuilder<String>();
  set decoders(ListBuilder<String>? decoders) => _$this._decoders = decoders;

  bool? _supports1080p;
  bool? get supports1080p => _$this._supports1080p;
  set supports1080p(bool? supports1080p) =>
      _$this._supports1080p = supports1080p;

  String? _softwareVersion;
  String? get softwareVersion => _$this._softwareVersion;
  set softwareVersion(String? softwareVersion) =>
      _$this._softwareVersion = softwareVersion;

  CapabilitiesBuilder() {
    Capabilities._defaults(this);
  }

  CapabilitiesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _displayModes = $v.displayModes.toBuilder();
      _selectedMode = $v.selectedMode.toBuilder();
      _decoders = $v.decoders.toBuilder();
      _supports1080p = $v.supports1080p;
      _softwareVersion = $v.softwareVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Capabilities other) {
    _$v = other as _$Capabilities;
  }

  @override
  void update(void Function(CapabilitiesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Capabilities build() => _build();

  _$Capabilities _build() {
    _$Capabilities _$result;
    try {
      _$result = _$v ??
          _$Capabilities._(
            displayModes: displayModes.build(),
            selectedMode: selectedMode.build(),
            decoders: decoders.build(),
            supports1080p: BuiltValueNullFieldError.checkNotNull(
                supports1080p, r'Capabilities', 'supports1080p'),
            softwareVersion: BuiltValueNullFieldError.checkNotNull(
                softwareVersion, r'Capabilities', 'softwareVersion'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'displayModes';
        displayModes.build();
        _$failedField = 'selectedMode';
        selectedMode.build();
        _$failedField = 'decoders';
        decoders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Capabilities', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
