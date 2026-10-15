// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_patch.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScreenPatchOrientationEnum _$screenPatchOrientationEnum_number0 =
    const ScreenPatchOrientationEnum._('number0');
const ScreenPatchOrientationEnum _$screenPatchOrientationEnum_number90 =
    const ScreenPatchOrientationEnum._('number90');
const ScreenPatchOrientationEnum _$screenPatchOrientationEnum_number180 =
    const ScreenPatchOrientationEnum._('number180');
const ScreenPatchOrientationEnum _$screenPatchOrientationEnum_number270 =
    const ScreenPatchOrientationEnum._('number270');

ScreenPatchOrientationEnum _$screenPatchOrientationEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$screenPatchOrientationEnum_number0;
    case 'number90':
      return _$screenPatchOrientationEnum_number90;
    case 'number180':
      return _$screenPatchOrientationEnum_number180;
    case 'number270':
      return _$screenPatchOrientationEnum_number270;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScreenPatchOrientationEnum> _$screenPatchOrientationEnumValues =
    BuiltSet<ScreenPatchOrientationEnum>(const <ScreenPatchOrientationEnum>[
  _$screenPatchOrientationEnum_number0,
  _$screenPatchOrientationEnum_number90,
  _$screenPatchOrientationEnum_number180,
  _$screenPatchOrientationEnum_number270,
]);

Serializer<ScreenPatchOrientationEnum> _$screenPatchOrientationEnumSerializer =
    _$ScreenPatchOrientationEnumSerializer();

class _$ScreenPatchOrientationEnumSerializer
    implements PrimitiveSerializer<ScreenPatchOrientationEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number0': 0,
    'number90': 90,
    'number180': 180,
    'number270': 270,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    0: 'number0',
    90: 'number90',
    180: 'number180',
    270: 'number270',
  };

  @override
  final Iterable<Type> types = const <Type>[ScreenPatchOrientationEnum];
  @override
  final String wireName = 'ScreenPatchOrientationEnum';

  @override
  Object serialize(Serializers serializers, ScreenPatchOrientationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScreenPatchOrientationEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScreenPatchOrientationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScreenPatch extends ScreenPatch {
  @override
  final int expectedDesiredVersion;
  @override
  final Optional<String?> name;
  @override
  final Optional<String?> campaignId;
  @override
  final Optional<ScreenPatchOrientationEnum?> orientation;
  @override
  final Optional<bool?> muted;
  @override
  final Optional<int?> volume;

  factory _$ScreenPatch([void Function(ScreenPatchBuilder)? updates]) =>
      (ScreenPatchBuilder()..update(updates))._build();

  _$ScreenPatch._(
      {required this.expectedDesiredVersion,
      required this.name,
      required this.campaignId,
      required this.orientation,
      required this.muted,
      required this.volume})
      : super._();
  @override
  ScreenPatch rebuild(void Function(ScreenPatchBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreenPatchBuilder toBuilder() => ScreenPatchBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScreenPatch &&
        expectedDesiredVersion == other.expectedDesiredVersion &&
        name == other.name &&
        campaignId == other.campaignId &&
        orientation == other.orientation &&
        muted == other.muted &&
        volume == other.volume;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedDesiredVersion.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, campaignId.hashCode);
    _$hash = $jc(_$hash, orientation.hashCode);
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, volume.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScreenPatch')
          ..add('expectedDesiredVersion', expectedDesiredVersion)
          ..add('name', name)
          ..add('campaignId', campaignId)
          ..add('orientation', orientation)
          ..add('muted', muted)
          ..add('volume', volume))
        .toString();
  }
}

class ScreenPatchBuilder implements Builder<ScreenPatch, ScreenPatchBuilder> {
  _$ScreenPatch? _$v;

  int? _expectedDesiredVersion;
  int? get expectedDesiredVersion => _$this._expectedDesiredVersion;
  set expectedDesiredVersion(int? expectedDesiredVersion) =>
      _$this._expectedDesiredVersion = expectedDesiredVersion;

  Optional<String?>? _name;
  Optional<String?>? get name => _$this._name;
  set name(Optional<String?>? name) => _$this._name = name;

  Optional<String?>? _campaignId;
  Optional<String?>? get campaignId => _$this._campaignId;
  set campaignId(Optional<String?>? campaignId) =>
      _$this._campaignId = campaignId;

  Optional<ScreenPatchOrientationEnum?>? _orientation;
  Optional<ScreenPatchOrientationEnum?>? get orientation => _$this._orientation;
  set orientation(Optional<ScreenPatchOrientationEnum?>? orientation) =>
      _$this._orientation = orientation;

  Optional<bool?>? _muted;
  Optional<bool?>? get muted => _$this._muted;
  set muted(Optional<bool?>? muted) => _$this._muted = muted;

  Optional<int?>? _volume;
  Optional<int?>? get volume => _$this._volume;
  set volume(Optional<int?>? volume) => _$this._volume = volume;

  ScreenPatchBuilder() {
    ScreenPatch._defaults(this);
  }

  ScreenPatchBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedDesiredVersion = $v.expectedDesiredVersion;
      _name = $v.name;
      _campaignId = $v.campaignId;
      _orientation = $v.orientation;
      _muted = $v.muted;
      _volume = $v.volume;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScreenPatch other) {
    _$v = other as _$ScreenPatch;
  }

  @override
  void update(void Function(ScreenPatchBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScreenPatch build() => _build();

  _$ScreenPatch _build() {
    final _$result = _$v ??
        _$ScreenPatch._(
          expectedDesiredVersion: BuiltValueNullFieldError.checkNotNull(
              expectedDesiredVersion, r'ScreenPatch', 'expectedDesiredVersion'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ScreenPatch', 'name'),
          campaignId: BuiltValueNullFieldError.checkNotNull(
              campaignId, r'ScreenPatch', 'campaignId'),
          orientation: BuiltValueNullFieldError.checkNotNull(
              orientation, r'ScreenPatch', 'orientation'),
          muted: BuiltValueNullFieldError.checkNotNull(
              muted, r'ScreenPatch', 'muted'),
          volume: BuiltValueNullFieldError.checkNotNull(
              volume, r'ScreenPatch', 'volume'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
