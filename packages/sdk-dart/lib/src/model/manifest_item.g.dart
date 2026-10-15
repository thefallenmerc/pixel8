// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manifest_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ManifestItem extends ManifestItem {
  @override
  final String id;
  @override
  final String assetId;
  @override
  final String renditionId;
  @override
  final String sha256;
  @override
  final int sizeBytes;
  @override
  final int durationMs;

  factory _$ManifestItem([void Function(ManifestItemBuilder)? updates]) =>
      (ManifestItemBuilder()..update(updates))._build();

  _$ManifestItem._(
      {required this.id,
      required this.assetId,
      required this.renditionId,
      required this.sha256,
      required this.sizeBytes,
      required this.durationMs})
      : super._();
  @override
  ManifestItem rebuild(void Function(ManifestItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ManifestItemBuilder toBuilder() => ManifestItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ManifestItem &&
        id == other.id &&
        assetId == other.assetId &&
        renditionId == other.renditionId &&
        sha256 == other.sha256 &&
        sizeBytes == other.sizeBytes &&
        durationMs == other.durationMs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, renditionId.hashCode);
    _$hash = $jc(_$hash, sha256.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, durationMs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ManifestItem')
          ..add('id', id)
          ..add('assetId', assetId)
          ..add('renditionId', renditionId)
          ..add('sha256', sha256)
          ..add('sizeBytes', sizeBytes)
          ..add('durationMs', durationMs))
        .toString();
  }
}

class ManifestItemBuilder
    implements Builder<ManifestItem, ManifestItemBuilder> {
  _$ManifestItem? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  String? _renditionId;
  String? get renditionId => _$this._renditionId;
  set renditionId(String? renditionId) => _$this._renditionId = renditionId;

  String? _sha256;
  String? get sha256 => _$this._sha256;
  set sha256(String? sha256) => _$this._sha256 = sha256;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  int? _durationMs;
  int? get durationMs => _$this._durationMs;
  set durationMs(int? durationMs) => _$this._durationMs = durationMs;

  ManifestItemBuilder() {
    ManifestItem._defaults(this);
  }

  ManifestItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _assetId = $v.assetId;
      _renditionId = $v.renditionId;
      _sha256 = $v.sha256;
      _sizeBytes = $v.sizeBytes;
      _durationMs = $v.durationMs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ManifestItem other) {
    _$v = other as _$ManifestItem;
  }

  @override
  void update(void Function(ManifestItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ManifestItem build() => _build();

  _$ManifestItem _build() {
    final _$result = _$v ??
        _$ManifestItem._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ManifestItem', 'id'),
          assetId: BuiltValueNullFieldError.checkNotNull(
              assetId, r'ManifestItem', 'assetId'),
          renditionId: BuiltValueNullFieldError.checkNotNull(
              renditionId, r'ManifestItem', 'renditionId'),
          sha256: BuiltValueNullFieldError.checkNotNull(
              sha256, r'ManifestItem', 'sha256'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'ManifestItem', 'sizeBytes'),
          durationMs: BuiltValueNullFieldError.checkNotNull(
              durationMs, r'ManifestItem', 'durationMs'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
