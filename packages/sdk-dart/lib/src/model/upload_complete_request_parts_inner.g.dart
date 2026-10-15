// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_complete_request_parts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UploadCompleteRequestPartsInner
    extends UploadCompleteRequestPartsInner {
  @override
  final int partNumber;
  @override
  final String etag;

  factory _$UploadCompleteRequestPartsInner(
          [void Function(UploadCompleteRequestPartsInnerBuilder)? updates]) =>
      (UploadCompleteRequestPartsInnerBuilder()..update(updates))._build();

  _$UploadCompleteRequestPartsInner._(
      {required this.partNumber, required this.etag})
      : super._();
  @override
  UploadCompleteRequestPartsInner rebuild(
          void Function(UploadCompleteRequestPartsInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadCompleteRequestPartsInnerBuilder toBuilder() =>
      UploadCompleteRequestPartsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadCompleteRequestPartsInner &&
        partNumber == other.partNumber &&
        etag == other.etag;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, partNumber.hashCode);
    _$hash = $jc(_$hash, etag.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadCompleteRequestPartsInner')
          ..add('partNumber', partNumber)
          ..add('etag', etag))
        .toString();
  }
}

class UploadCompleteRequestPartsInnerBuilder
    implements
        Builder<UploadCompleteRequestPartsInner,
            UploadCompleteRequestPartsInnerBuilder> {
  _$UploadCompleteRequestPartsInner? _$v;

  int? _partNumber;
  int? get partNumber => _$this._partNumber;
  set partNumber(int? partNumber) => _$this._partNumber = partNumber;

  String? _etag;
  String? get etag => _$this._etag;
  set etag(String? etag) => _$this._etag = etag;

  UploadCompleteRequestPartsInnerBuilder() {
    UploadCompleteRequestPartsInner._defaults(this);
  }

  UploadCompleteRequestPartsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _partNumber = $v.partNumber;
      _etag = $v.etag;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadCompleteRequestPartsInner other) {
    _$v = other as _$UploadCompleteRequestPartsInner;
  }

  @override
  void update(void Function(UploadCompleteRequestPartsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadCompleteRequestPartsInner build() => _build();

  _$UploadCompleteRequestPartsInner _build() {
    final _$result = _$v ??
        _$UploadCompleteRequestPartsInner._(
          partNumber: BuiltValueNullFieldError.checkNotNull(
              partNumber, r'UploadCompleteRequestPartsInner', 'partNumber'),
          etag: BuiltValueNullFieldError.checkNotNull(
              etag, r'UploadCompleteRequestPartsInner', 'etag'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
