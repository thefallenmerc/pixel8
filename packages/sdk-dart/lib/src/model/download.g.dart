// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Download extends Download {
  @override
  final String renditionId;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$Download([void Function(DownloadBuilder)? updates]) =>
      (DownloadBuilder()..update(updates))._build();

  _$Download._(
      {required this.renditionId, required this.url, required this.expiresAt})
      : super._();
  @override
  Download rebuild(void Function(DownloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DownloadBuilder toBuilder() => DownloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Download &&
        renditionId == other.renditionId &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, renditionId.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Download')
          ..add('renditionId', renditionId)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class DownloadBuilder implements Builder<Download, DownloadBuilder> {
  _$Download? _$v;

  String? _renditionId;
  String? get renditionId => _$this._renditionId;
  set renditionId(String? renditionId) => _$this._renditionId = renditionId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  DownloadBuilder() {
    Download._defaults(this);
  }

  DownloadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _renditionId = $v.renditionId;
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Download other) {
    _$v = other as _$Download;
  }

  @override
  void update(void Function(DownloadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Download build() => _build();

  _$Download _build() {
    final _$result = _$v ??
        _$Download._(
          renditionId: BuiltValueNullFieldError.checkNotNull(
              renditionId, r'Download', 'renditionId'),
          url: BuiltValueNullFieldError.checkNotNull(url, r'Download', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'Download', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
