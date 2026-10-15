// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_start.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UploadStart extends UploadStart {
  @override
  final Asset asset;
  @override
  final String uploadId;
  @override
  final int partSizeBytes;

  factory _$UploadStart([void Function(UploadStartBuilder)? updates]) =>
      (UploadStartBuilder()..update(updates))._build();

  _$UploadStart._(
      {required this.asset,
      required this.uploadId,
      required this.partSizeBytes})
      : super._();
  @override
  UploadStart rebuild(void Function(UploadStartBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadStartBuilder toBuilder() => UploadStartBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadStart &&
        asset == other.asset &&
        uploadId == other.uploadId &&
        partSizeBytes == other.partSizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, asset.hashCode);
    _$hash = $jc(_$hash, uploadId.hashCode);
    _$hash = $jc(_$hash, partSizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadStart')
          ..add('asset', asset)
          ..add('uploadId', uploadId)
          ..add('partSizeBytes', partSizeBytes))
        .toString();
  }
}

class UploadStartBuilder implements Builder<UploadStart, UploadStartBuilder> {
  _$UploadStart? _$v;

  AssetBuilder? _asset;
  AssetBuilder get asset => _$this._asset ??= AssetBuilder();
  set asset(AssetBuilder? asset) => _$this._asset = asset;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  int? _partSizeBytes;
  int? get partSizeBytes => _$this._partSizeBytes;
  set partSizeBytes(int? partSizeBytes) =>
      _$this._partSizeBytes = partSizeBytes;

  UploadStartBuilder() {
    UploadStart._defaults(this);
  }

  UploadStartBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _asset = $v.asset.toBuilder();
      _uploadId = $v.uploadId;
      _partSizeBytes = $v.partSizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadStart other) {
    _$v = other as _$UploadStart;
  }

  @override
  void update(void Function(UploadStartBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadStart build() => _build();

  _$UploadStart _build() {
    _$UploadStart _$result;
    try {
      _$result = _$v ??
          _$UploadStart._(
            asset: asset.build(),
            uploadId: BuiltValueNullFieldError.checkNotNull(
                uploadId, r'UploadStart', 'uploadId'),
            partSizeBytes: BuiltValueNullFieldError.checkNotNull(
                partSizeBytes, r'UploadStart', 'partSizeBytes'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'asset';
        asset.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UploadStart', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
