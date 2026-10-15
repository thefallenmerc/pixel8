// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_sample.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TelemetrySample extends TelemetrySample {
  @override
  final DateTime sampledAt;
  @override
  final num cpuPercent;
  @override
  final int memoryUsedBytes;
  @override
  final int memoryTotalBytes;
  @override
  final num? temperatureC;
  @override
  final bool throttled;
  @override
  final int diskFreeBytes;
  @override
  final int cacheBytes;
  @override
  final String? currentItemId;
  @override
  final int desiredVersion;
  @override
  final int? playingVersion;
  @override
  final int droppedFrames;
  @override
  final String softwareVersion;
  @override
  final DisplayMode displayMode;
  @override
  final String decoder;
  @override
  final String? error;

  factory _$TelemetrySample([void Function(TelemetrySampleBuilder)? updates]) =>
      (TelemetrySampleBuilder()..update(updates))._build();

  _$TelemetrySample._(
      {required this.sampledAt,
      required this.cpuPercent,
      required this.memoryUsedBytes,
      required this.memoryTotalBytes,
      this.temperatureC,
      required this.throttled,
      required this.diskFreeBytes,
      required this.cacheBytes,
      this.currentItemId,
      required this.desiredVersion,
      this.playingVersion,
      required this.droppedFrames,
      required this.softwareVersion,
      required this.displayMode,
      required this.decoder,
      this.error})
      : super._();
  @override
  TelemetrySample rebuild(void Function(TelemetrySampleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TelemetrySampleBuilder toBuilder() => TelemetrySampleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TelemetrySample &&
        sampledAt == other.sampledAt &&
        cpuPercent == other.cpuPercent &&
        memoryUsedBytes == other.memoryUsedBytes &&
        memoryTotalBytes == other.memoryTotalBytes &&
        temperatureC == other.temperatureC &&
        throttled == other.throttled &&
        diskFreeBytes == other.diskFreeBytes &&
        cacheBytes == other.cacheBytes &&
        currentItemId == other.currentItemId &&
        desiredVersion == other.desiredVersion &&
        playingVersion == other.playingVersion &&
        droppedFrames == other.droppedFrames &&
        softwareVersion == other.softwareVersion &&
        displayMode == other.displayMode &&
        decoder == other.decoder &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sampledAt.hashCode);
    _$hash = $jc(_$hash, cpuPercent.hashCode);
    _$hash = $jc(_$hash, memoryUsedBytes.hashCode);
    _$hash = $jc(_$hash, memoryTotalBytes.hashCode);
    _$hash = $jc(_$hash, temperatureC.hashCode);
    _$hash = $jc(_$hash, throttled.hashCode);
    _$hash = $jc(_$hash, diskFreeBytes.hashCode);
    _$hash = $jc(_$hash, cacheBytes.hashCode);
    _$hash = $jc(_$hash, currentItemId.hashCode);
    _$hash = $jc(_$hash, desiredVersion.hashCode);
    _$hash = $jc(_$hash, playingVersion.hashCode);
    _$hash = $jc(_$hash, droppedFrames.hashCode);
    _$hash = $jc(_$hash, softwareVersion.hashCode);
    _$hash = $jc(_$hash, displayMode.hashCode);
    _$hash = $jc(_$hash, decoder.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TelemetrySample')
          ..add('sampledAt', sampledAt)
          ..add('cpuPercent', cpuPercent)
          ..add('memoryUsedBytes', memoryUsedBytes)
          ..add('memoryTotalBytes', memoryTotalBytes)
          ..add('temperatureC', temperatureC)
          ..add('throttled', throttled)
          ..add('diskFreeBytes', diskFreeBytes)
          ..add('cacheBytes', cacheBytes)
          ..add('currentItemId', currentItemId)
          ..add('desiredVersion', desiredVersion)
          ..add('playingVersion', playingVersion)
          ..add('droppedFrames', droppedFrames)
          ..add('softwareVersion', softwareVersion)
          ..add('displayMode', displayMode)
          ..add('decoder', decoder)
          ..add('error', error))
        .toString();
  }
}

class TelemetrySampleBuilder
    implements Builder<TelemetrySample, TelemetrySampleBuilder> {
  _$TelemetrySample? _$v;

  DateTime? _sampledAt;
  DateTime? get sampledAt => _$this._sampledAt;
  set sampledAt(DateTime? sampledAt) => _$this._sampledAt = sampledAt;

  num? _cpuPercent;
  num? get cpuPercent => _$this._cpuPercent;
  set cpuPercent(num? cpuPercent) => _$this._cpuPercent = cpuPercent;

  int? _memoryUsedBytes;
  int? get memoryUsedBytes => _$this._memoryUsedBytes;
  set memoryUsedBytes(int? memoryUsedBytes) =>
      _$this._memoryUsedBytes = memoryUsedBytes;

  int? _memoryTotalBytes;
  int? get memoryTotalBytes => _$this._memoryTotalBytes;
  set memoryTotalBytes(int? memoryTotalBytes) =>
      _$this._memoryTotalBytes = memoryTotalBytes;

  num? _temperatureC;
  num? get temperatureC => _$this._temperatureC;
  set temperatureC(num? temperatureC) => _$this._temperatureC = temperatureC;

  bool? _throttled;
  bool? get throttled => _$this._throttled;
  set throttled(bool? throttled) => _$this._throttled = throttled;

  int? _diskFreeBytes;
  int? get diskFreeBytes => _$this._diskFreeBytes;
  set diskFreeBytes(int? diskFreeBytes) =>
      _$this._diskFreeBytes = diskFreeBytes;

  int? _cacheBytes;
  int? get cacheBytes => _$this._cacheBytes;
  set cacheBytes(int? cacheBytes) => _$this._cacheBytes = cacheBytes;

  String? _currentItemId;
  String? get currentItemId => _$this._currentItemId;
  set currentItemId(String? currentItemId) =>
      _$this._currentItemId = currentItemId;

  int? _desiredVersion;
  int? get desiredVersion => _$this._desiredVersion;
  set desiredVersion(int? desiredVersion) =>
      _$this._desiredVersion = desiredVersion;

  int? _playingVersion;
  int? get playingVersion => _$this._playingVersion;
  set playingVersion(int? playingVersion) =>
      _$this._playingVersion = playingVersion;

  int? _droppedFrames;
  int? get droppedFrames => _$this._droppedFrames;
  set droppedFrames(int? droppedFrames) =>
      _$this._droppedFrames = droppedFrames;

  String? _softwareVersion;
  String? get softwareVersion => _$this._softwareVersion;
  set softwareVersion(String? softwareVersion) =>
      _$this._softwareVersion = softwareVersion;

  DisplayModeBuilder? _displayMode;
  DisplayModeBuilder get displayMode =>
      _$this._displayMode ??= DisplayModeBuilder();
  set displayMode(DisplayModeBuilder? displayMode) =>
      _$this._displayMode = displayMode;

  String? _decoder;
  String? get decoder => _$this._decoder;
  set decoder(String? decoder) => _$this._decoder = decoder;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  TelemetrySampleBuilder() {
    TelemetrySample._defaults(this);
  }

  TelemetrySampleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sampledAt = $v.sampledAt;
      _cpuPercent = $v.cpuPercent;
      _memoryUsedBytes = $v.memoryUsedBytes;
      _memoryTotalBytes = $v.memoryTotalBytes;
      _temperatureC = $v.temperatureC;
      _throttled = $v.throttled;
      _diskFreeBytes = $v.diskFreeBytes;
      _cacheBytes = $v.cacheBytes;
      _currentItemId = $v.currentItemId;
      _desiredVersion = $v.desiredVersion;
      _playingVersion = $v.playingVersion;
      _droppedFrames = $v.droppedFrames;
      _softwareVersion = $v.softwareVersion;
      _displayMode = $v.displayMode.toBuilder();
      _decoder = $v.decoder;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TelemetrySample other) {
    _$v = other as _$TelemetrySample;
  }

  @override
  void update(void Function(TelemetrySampleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TelemetrySample build() => _build();

  _$TelemetrySample _build() {
    _$TelemetrySample _$result;
    try {
      _$result = _$v ??
          _$TelemetrySample._(
            sampledAt: BuiltValueNullFieldError.checkNotNull(
                sampledAt, r'TelemetrySample', 'sampledAt'),
            cpuPercent: BuiltValueNullFieldError.checkNotNull(
                cpuPercent, r'TelemetrySample', 'cpuPercent'),
            memoryUsedBytes: BuiltValueNullFieldError.checkNotNull(
                memoryUsedBytes, r'TelemetrySample', 'memoryUsedBytes'),
            memoryTotalBytes: BuiltValueNullFieldError.checkNotNull(
                memoryTotalBytes, r'TelemetrySample', 'memoryTotalBytes'),
            temperatureC: temperatureC,
            throttled: BuiltValueNullFieldError.checkNotNull(
                throttled, r'TelemetrySample', 'throttled'),
            diskFreeBytes: BuiltValueNullFieldError.checkNotNull(
                diskFreeBytes, r'TelemetrySample', 'diskFreeBytes'),
            cacheBytes: BuiltValueNullFieldError.checkNotNull(
                cacheBytes, r'TelemetrySample', 'cacheBytes'),
            currentItemId: currentItemId,
            desiredVersion: BuiltValueNullFieldError.checkNotNull(
                desiredVersion, r'TelemetrySample', 'desiredVersion'),
            playingVersion: playingVersion,
            droppedFrames: BuiltValueNullFieldError.checkNotNull(
                droppedFrames, r'TelemetrySample', 'droppedFrames'),
            softwareVersion: BuiltValueNullFieldError.checkNotNull(
                softwareVersion, r'TelemetrySample', 'softwareVersion'),
            displayMode: displayMode.build(),
            decoder: BuiltValueNullFieldError.checkNotNull(
                decoder, r'TelemetrySample', 'decoder'),
            error: error,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'displayMode';
        displayMode.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TelemetrySample', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
