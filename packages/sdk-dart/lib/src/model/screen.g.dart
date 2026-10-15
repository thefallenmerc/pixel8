// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ScreenOrientationEnum _$screenOrientationEnum_number0 =
    const ScreenOrientationEnum._('number0');
const ScreenOrientationEnum _$screenOrientationEnum_number90 =
    const ScreenOrientationEnum._('number90');
const ScreenOrientationEnum _$screenOrientationEnum_number180 =
    const ScreenOrientationEnum._('number180');
const ScreenOrientationEnum _$screenOrientationEnum_number270 =
    const ScreenOrientationEnum._('number270');

ScreenOrientationEnum _$screenOrientationEnumValueOf(String name) {
  switch (name) {
    case 'number0':
      return _$screenOrientationEnum_number0;
    case 'number90':
      return _$screenOrientationEnum_number90;
    case 'number180':
      return _$screenOrientationEnum_number180;
    case 'number270':
      return _$screenOrientationEnum_number270;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScreenOrientationEnum> _$screenOrientationEnumValues =
    BuiltSet<ScreenOrientationEnum>(const <ScreenOrientationEnum>[
  _$screenOrientationEnum_number0,
  _$screenOrientationEnum_number90,
  _$screenOrientationEnum_number180,
  _$screenOrientationEnum_number270,
]);

const ScreenStatusEnum _$screenStatusEnum_offline =
    const ScreenStatusEnum._('offline');
const ScreenStatusEnum _$screenStatusEnum_preparing =
    const ScreenStatusEnum._('preparing');
const ScreenStatusEnum _$screenStatusEnum_ready =
    const ScreenStatusEnum._('ready');
const ScreenStatusEnum _$screenStatusEnum_downloading =
    const ScreenStatusEnum._('downloading');
const ScreenStatusEnum _$screenStatusEnum_playing =
    const ScreenStatusEnum._('playing');
const ScreenStatusEnum _$screenStatusEnum_error =
    const ScreenStatusEnum._('error');

ScreenStatusEnum _$screenStatusEnumValueOf(String name) {
  switch (name) {
    case 'offline':
      return _$screenStatusEnum_offline;
    case 'preparing':
      return _$screenStatusEnum_preparing;
    case 'ready':
      return _$screenStatusEnum_ready;
    case 'downloading':
      return _$screenStatusEnum_downloading;
    case 'playing':
      return _$screenStatusEnum_playing;
    case 'error':
      return _$screenStatusEnum_error;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ScreenStatusEnum> _$screenStatusEnumValues =
    BuiltSet<ScreenStatusEnum>(const <ScreenStatusEnum>[
  _$screenStatusEnum_offline,
  _$screenStatusEnum_preparing,
  _$screenStatusEnum_ready,
  _$screenStatusEnum_downloading,
  _$screenStatusEnum_playing,
  _$screenStatusEnum_error,
]);

Serializer<ScreenOrientationEnum> _$screenOrientationEnumSerializer =
    _$ScreenOrientationEnumSerializer();
Serializer<ScreenStatusEnum> _$screenStatusEnumSerializer =
    _$ScreenStatusEnumSerializer();

class _$ScreenOrientationEnumSerializer
    implements PrimitiveSerializer<ScreenOrientationEnum> {
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
  final Iterable<Type> types = const <Type>[ScreenOrientationEnum];
  @override
  final String wireName = 'ScreenOrientationEnum';

  @override
  Object serialize(Serializers serializers, ScreenOrientationEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScreenOrientationEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScreenOrientationEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ScreenStatusEnumSerializer
    implements PrimitiveSerializer<ScreenStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'offline': 'offline',
    'preparing': 'preparing',
    'ready': 'ready',
    'downloading': 'downloading',
    'playing': 'playing',
    'error': 'error',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'offline': 'offline',
    'preparing': 'preparing',
    'ready': 'ready',
    'downloading': 'downloading',
    'playing': 'playing',
    'error': 'error',
  };

  @override
  final Iterable<Type> types = const <Type>[ScreenStatusEnum];
  @override
  final String wireName = 'ScreenStatusEnum';

  @override
  Object serialize(Serializers serializers, ScreenStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ScreenStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ScreenStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Screen extends Screen {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? campaignId;
  @override
  final ScreenOrientationEnum orientation;
  @override
  final bool muted;
  @override
  final int volume;
  @override
  final int desiredVersion;
  @override
  final int? playingVersion;
  @override
  final ScreenStatusEnum status;
  @override
  final DateTime? lastSeenAt;
  @override
  final String? error;
  @override
  final Capabilities? capabilities;

  factory _$Screen([void Function(ScreenBuilder)? updates]) =>
      (ScreenBuilder()..update(updates))._build();

  _$Screen._(
      {required this.id,
      required this.name,
      this.campaignId,
      required this.orientation,
      required this.muted,
      required this.volume,
      required this.desiredVersion,
      this.playingVersion,
      required this.status,
      this.lastSeenAt,
      this.error,
      this.capabilities})
      : super._();
  @override
  Screen rebuild(void Function(ScreenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreenBuilder toBuilder() => ScreenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Screen &&
        id == other.id &&
        name == other.name &&
        campaignId == other.campaignId &&
        orientation == other.orientation &&
        muted == other.muted &&
        volume == other.volume &&
        desiredVersion == other.desiredVersion &&
        playingVersion == other.playingVersion &&
        status == other.status &&
        lastSeenAt == other.lastSeenAt &&
        error == other.error &&
        capabilities == other.capabilities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, campaignId.hashCode);
    _$hash = $jc(_$hash, orientation.hashCode);
    _$hash = $jc(_$hash, muted.hashCode);
    _$hash = $jc(_$hash, volume.hashCode);
    _$hash = $jc(_$hash, desiredVersion.hashCode);
    _$hash = $jc(_$hash, playingVersion.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lastSeenAt.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, capabilities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Screen')
          ..add('id', id)
          ..add('name', name)
          ..add('campaignId', campaignId)
          ..add('orientation', orientation)
          ..add('muted', muted)
          ..add('volume', volume)
          ..add('desiredVersion', desiredVersion)
          ..add('playingVersion', playingVersion)
          ..add('status', status)
          ..add('lastSeenAt', lastSeenAt)
          ..add('error', error)
          ..add('capabilities', capabilities))
        .toString();
  }
}

class ScreenBuilder implements Builder<Screen, ScreenBuilder> {
  _$Screen? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _campaignId;
  String? get campaignId => _$this._campaignId;
  set campaignId(String? campaignId) => _$this._campaignId = campaignId;

  ScreenOrientationEnum? _orientation;
  ScreenOrientationEnum? get orientation => _$this._orientation;
  set orientation(ScreenOrientationEnum? orientation) =>
      _$this._orientation = orientation;

  bool? _muted;
  bool? get muted => _$this._muted;
  set muted(bool? muted) => _$this._muted = muted;

  int? _volume;
  int? get volume => _$this._volume;
  set volume(int? volume) => _$this._volume = volume;

  int? _desiredVersion;
  int? get desiredVersion => _$this._desiredVersion;
  set desiredVersion(int? desiredVersion) =>
      _$this._desiredVersion = desiredVersion;

  int? _playingVersion;
  int? get playingVersion => _$this._playingVersion;
  set playingVersion(int? playingVersion) =>
      _$this._playingVersion = playingVersion;

  ScreenStatusEnum? _status;
  ScreenStatusEnum? get status => _$this._status;
  set status(ScreenStatusEnum? status) => _$this._status = status;

  DateTime? _lastSeenAt;
  DateTime? get lastSeenAt => _$this._lastSeenAt;
  set lastSeenAt(DateTime? lastSeenAt) => _$this._lastSeenAt = lastSeenAt;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  CapabilitiesBuilder? _capabilities;
  CapabilitiesBuilder get capabilities =>
      _$this._capabilities ??= CapabilitiesBuilder();
  set capabilities(CapabilitiesBuilder? capabilities) =>
      _$this._capabilities = capabilities;

  ScreenBuilder() {
    Screen._defaults(this);
  }

  ScreenBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _campaignId = $v.campaignId;
      _orientation = $v.orientation;
      _muted = $v.muted;
      _volume = $v.volume;
      _desiredVersion = $v.desiredVersion;
      _playingVersion = $v.playingVersion;
      _status = $v.status;
      _lastSeenAt = $v.lastSeenAt;
      _error = $v.error;
      _capabilities = $v.capabilities?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Screen other) {
    _$v = other as _$Screen;
  }

  @override
  void update(void Function(ScreenBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Screen build() => _build();

  _$Screen _build() {
    _$Screen _$result;
    try {
      _$result = _$v ??
          _$Screen._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Screen', 'id'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, r'Screen', 'name'),
            campaignId: campaignId,
            orientation: BuiltValueNullFieldError.checkNotNull(
                orientation, r'Screen', 'orientation'),
            muted: BuiltValueNullFieldError.checkNotNull(
                muted, r'Screen', 'muted'),
            volume: BuiltValueNullFieldError.checkNotNull(
                volume, r'Screen', 'volume'),
            desiredVersion: BuiltValueNullFieldError.checkNotNull(
                desiredVersion, r'Screen', 'desiredVersion'),
            playingVersion: playingVersion,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Screen', 'status'),
            lastSeenAt: lastSeenAt,
            error: error,
            capabilities: _capabilities?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'capabilities';
        _capabilities?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Screen', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
