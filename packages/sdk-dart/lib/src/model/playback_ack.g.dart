// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_ack.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PlaybackAckStatusEnum _$playbackAckStatusEnum_downloading =
    const PlaybackAckStatusEnum._('downloading');
const PlaybackAckStatusEnum _$playbackAckStatusEnum_playing =
    const PlaybackAckStatusEnum._('playing');
const PlaybackAckStatusEnum _$playbackAckStatusEnum_idle =
    const PlaybackAckStatusEnum._('idle');
const PlaybackAckStatusEnum _$playbackAckStatusEnum_error =
    const PlaybackAckStatusEnum._('error');

PlaybackAckStatusEnum _$playbackAckStatusEnumValueOf(String name) {
  switch (name) {
    case 'downloading':
      return _$playbackAckStatusEnum_downloading;
    case 'playing':
      return _$playbackAckStatusEnum_playing;
    case 'idle':
      return _$playbackAckStatusEnum_idle;
    case 'error':
      return _$playbackAckStatusEnum_error;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PlaybackAckStatusEnum> _$playbackAckStatusEnumValues =
    BuiltSet<PlaybackAckStatusEnum>(const <PlaybackAckStatusEnum>[
  _$playbackAckStatusEnum_downloading,
  _$playbackAckStatusEnum_playing,
  _$playbackAckStatusEnum_idle,
  _$playbackAckStatusEnum_error,
]);

Serializer<PlaybackAckStatusEnum> _$playbackAckStatusEnumSerializer =
    _$PlaybackAckStatusEnumSerializer();

class _$PlaybackAckStatusEnumSerializer
    implements PrimitiveSerializer<PlaybackAckStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'downloading': 'downloading',
    'playing': 'playing',
    'idle': 'idle',
    'error': 'error',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'downloading': 'downloading',
    'playing': 'playing',
    'idle': 'idle',
    'error': 'error',
  };

  @override
  final Iterable<Type> types = const <Type>[PlaybackAckStatusEnum];
  @override
  final String wireName = 'PlaybackAckStatusEnum';

  @override
  Object serialize(Serializers serializers, PlaybackAckStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PlaybackAckStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PlaybackAckStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PlaybackAck extends PlaybackAck {
  @override
  final int version;
  @override
  final PlaybackAckStatusEnum status;
  @override
  final String? currentItemId;
  @override
  final Optional<int?> playingVersion;
  @override
  final String? error;

  factory _$PlaybackAck([void Function(PlaybackAckBuilder)? updates]) =>
      (PlaybackAckBuilder()..update(updates))._build();

  _$PlaybackAck._(
      {required this.version,
      required this.status,
      this.currentItemId,
      required this.playingVersion,
      this.error})
      : super._();
  @override
  PlaybackAck rebuild(void Function(PlaybackAckBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PlaybackAckBuilder toBuilder() => PlaybackAckBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PlaybackAck &&
        version == other.version &&
        status == other.status &&
        currentItemId == other.currentItemId &&
        playingVersion == other.playingVersion &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, currentItemId.hashCode);
    _$hash = $jc(_$hash, playingVersion.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PlaybackAck')
          ..add('version', version)
          ..add('status', status)
          ..add('currentItemId', currentItemId)
          ..add('playingVersion', playingVersion)
          ..add('error', error))
        .toString();
  }
}

class PlaybackAckBuilder implements Builder<PlaybackAck, PlaybackAckBuilder> {
  _$PlaybackAck? _$v;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  PlaybackAckStatusEnum? _status;
  PlaybackAckStatusEnum? get status => _$this._status;
  set status(PlaybackAckStatusEnum? status) => _$this._status = status;

  String? _currentItemId;
  String? get currentItemId => _$this._currentItemId;
  set currentItemId(String? currentItemId) =>
      _$this._currentItemId = currentItemId;

  Optional<int?>? _playingVersion;
  Optional<int?>? get playingVersion => _$this._playingVersion;
  set playingVersion(Optional<int?>? playingVersion) =>
      _$this._playingVersion = playingVersion;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  PlaybackAckBuilder() {
    PlaybackAck._defaults(this);
  }

  PlaybackAckBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _version = $v.version;
      _status = $v.status;
      _currentItemId = $v.currentItemId;
      _playingVersion = $v.playingVersion;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PlaybackAck other) {
    _$v = other as _$PlaybackAck;
  }

  @override
  void update(void Function(PlaybackAckBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PlaybackAck build() => _build();

  _$PlaybackAck _build() {
    final _$result = _$v ??
        _$PlaybackAck._(
          version: BuiltValueNullFieldError.checkNotNull(
              version, r'PlaybackAck', 'version'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'PlaybackAck', 'status'),
          currentItemId: currentItemId,
          playingVersion: BuiltValueNullFieldError.checkNotNull(
              playingVersion, r'PlaybackAck', 'playingVersion'),
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
