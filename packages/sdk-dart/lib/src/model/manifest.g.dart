// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ManifestSchemaVersionEnum _$manifestSchemaVersionEnum_number1 =
    const ManifestSchemaVersionEnum._('number1');

ManifestSchemaVersionEnum _$manifestSchemaVersionEnumValueOf(String name) {
  switch (name) {
    case 'number1':
      return _$manifestSchemaVersionEnum_number1;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManifestSchemaVersionEnum> _$manifestSchemaVersionEnumValues =
    BuiltSet<ManifestSchemaVersionEnum>(const <ManifestSchemaVersionEnum>[
  _$manifestSchemaVersionEnum_number1,
]);

const ManifestProfileEnum _$manifestProfileEnum_n720p30V1 =
    const ManifestProfileEnum._('n720p30V1');
const ManifestProfileEnum _$manifestProfileEnum_n1080p30V1 =
    const ManifestProfileEnum._('n1080p30V1');

ManifestProfileEnum _$manifestProfileEnumValueOf(String name) {
  switch (name) {
    case 'n720p30V1':
      return _$manifestProfileEnum_n720p30V1;
    case 'n1080p30V1':
      return _$manifestProfileEnum_n1080p30V1;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ManifestProfileEnum> _$manifestProfileEnumValues =
    BuiltSet<ManifestProfileEnum>(const <ManifestProfileEnum>[
  _$manifestProfileEnum_n720p30V1,
  _$manifestProfileEnum_n1080p30V1,
]);

Serializer<ManifestSchemaVersionEnum> _$manifestSchemaVersionEnumSerializer =
    _$ManifestSchemaVersionEnumSerializer();
Serializer<ManifestProfileEnum> _$manifestProfileEnumSerializer =
    _$ManifestProfileEnumSerializer();

class _$ManifestSchemaVersionEnumSerializer
    implements PrimitiveSerializer<ManifestSchemaVersionEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number1': 1,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    1: 'number1',
  };

  @override
  final Iterable<Type> types = const <Type>[ManifestSchemaVersionEnum];
  @override
  final String wireName = 'ManifestSchemaVersionEnum';

  @override
  Object serialize(Serializers serializers, ManifestSchemaVersionEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManifestSchemaVersionEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManifestSchemaVersionEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ManifestProfileEnumSerializer
    implements PrimitiveSerializer<ManifestProfileEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'n720p30V1': '720p30-v1',
    'n1080p30V1': '1080p30-v1',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    '720p30-v1': 'n720p30V1',
    '1080p30-v1': 'n1080p30V1',
  };

  @override
  final Iterable<Type> types = const <Type>[ManifestProfileEnum];
  @override
  final String wireName = 'ManifestProfileEnum';

  @override
  Object serialize(Serializers serializers, ManifestProfileEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ManifestProfileEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ManifestProfileEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Manifest extends Manifest {
  @override
  final ManifestSchemaVersionEnum schemaVersion;
  @override
  final String screenId;
  @override
  final int version;
  @override
  final ManifestProfileEnum profile;
  @override
  final int orientation;
  @override
  final bool muted;
  @override
  final int volume;
  @override
  final BuiltList<ManifestItem> items;

  factory _$Manifest([void Function(ManifestBuilder)? updates]) =>
      (ManifestBuilder()..update(updates))._build();

  _$Manifest._(
      {required this.schemaVersion,
      required this.screenId,
      required this.version,
      required this.profile,
      required this.orientation,
      required this.muted,
      required this.volume,
      required this.items})
      : super._();
  @override
  Manifest rebuild(void Function(ManifestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManifestBuilder toBuilder() => ManifestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Manifest &&
        schemaVersion == other.schemaVersion &&
        screenId == other.screenId &&
        version == other.version &&
        profile == other.profile &&
        orientation == other.orientation &&
        muted == other.muted &&
        volume == other.volume &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, schemaVersion.hashCode);
    _$hash = $jc(_$hash, screenId.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, profile.hashCode);
    _$hash = $jc(_$hash, orientation.hashCode);
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, volume.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Manifest')
          ..add('schemaVersion', schemaVersion)
          ..add('screenId', screenId)
          ..add('version', version)
          ..add('profile', profile)
          ..add('orientation', orientation)
          ..add('muted', muted)
          ..add('volume', volume)
          ..add('items', items))
        .toString();
  }
}

class ManifestBuilder implements Builder<Manifest, ManifestBuilder> {
  _$Manifest? _$v;

  ManifestSchemaVersionEnum? _schemaVersion;
  ManifestSchemaVersionEnum? get schemaVersion => _$this._schemaVersion;
  set schemaVersion(ManifestSchemaVersionEnum? schemaVersion) =>
      _$this._schemaVersion = schemaVersion;

  String? _screenId;
  String? get screenId => _$this._screenId;
  set screenId(String? screenId) => _$this._screenId = screenId;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  ManifestProfileEnum? _profile;
  ManifestProfileEnum? get profile => _$this._profile;
  set profile(ManifestProfileEnum? profile) => _$this._profile = profile;

  int? _orientation;
  int? get orientation => _$this._orientation;
  set orientation(int? orientation) => _$this._orientation = orientation;

  bool? _muted;
  bool? get muted => _$this._muted;
  set muted(bool? muted) => _$this._muted = muted;

  int? _volume;
  int? get volume => _$this._volume;
  set volume(int? volume) => _$this._volume = volume;

  ListBuilder<ManifestItem>? _items;
  ListBuilder<ManifestItem> get items =>
      _$this._items ??= ListBuilder<ManifestItem>();
  set items(ListBuilder<ManifestItem>? items) => _$this._items = items;

  ManifestBuilder() {
    Manifest._defaults(this);
  }

  ManifestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _schemaVersion = $v.schemaVersion;
      _screenId = $v.screenId;
      _version = $v.version;
      _profile = $v.profile;
      _orientation = $v.orientation;
      _muted = $v.muted;
      _volume = $v.volume;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Manifest other) {
    _$v = other as _$Manifest;
  }

  @override
  void update(void Function(ManifestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Manifest build() => _build();

  _$Manifest _build() {
    _$Manifest _$result;
    try {
      _$result = _$v ??
          _$Manifest._(
            schemaVersion: BuiltValueNullFieldError.checkNotNull(
                schemaVersion, r'Manifest', 'schemaVersion'),
            screenId: BuiltValueNullFieldError.checkNotNull(
                screenId, r'Manifest', 'screenId'),
            version: BuiltValueNullFieldError.checkNotNull(
                version, r'Manifest', 'version'),
            profile: BuiltValueNullFieldError.checkNotNull(
                profile, r'Manifest', 'profile'),
            orientation: BuiltValueNullFieldError.checkNotNull(
                orientation, r'Manifest', 'orientation'),
            muted: BuiltValueNullFieldError.checkNotNull(
                muted, r'Manifest', 'muted'),
            volume: BuiltValueNullFieldError.checkNotNull(
                volume, r'Manifest', 'volume'),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Manifest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
