// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UploadCreate extends UploadCreate {
  @override
  final String name;
  @override
  final String mimeType;
  @override
  final int sizeBytes;

  factory _$UploadCreate([void Function(UploadCreateBuilder)? updates]) =>
      (UploadCreateBuilder()..update(updates))._build();

  _$UploadCreate._(
      {required this.name, required this.mimeType, required this.sizeBytes})
      : super._();
  @override
  UploadCreate rebuild(void Function(UploadCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadCreateBuilder toBuilder() => UploadCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadCreate &&
        name == other.name &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadCreate')
          ..add('name', name)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes))
        .toString();
  }
}

class UploadCreateBuilder
    implements Builder<UploadCreate, UploadCreateBuilder> {
  _$UploadCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  UploadCreateBuilder() {
    UploadCreate._defaults(this);
  }

  UploadCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadCreate other) {
    _$v = other as _$UploadCreate;
  }

  @override
  void update(void Function(UploadCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadCreate build() => _build();

  _$UploadCreate _build() {
    final _$result = _$v ??
        _$UploadCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'UploadCreate', 'name'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'UploadCreate', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'UploadCreate', 'sizeBytes'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
