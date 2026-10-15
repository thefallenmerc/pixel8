// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Preview extends Preview {
  @override
  final String url;
  @override
  final DateTime expiresAt;
  @override
  final String mimeType;

  factory _$Preview([void Function(PreviewBuilder)? updates]) =>
      (PreviewBuilder()..update(updates))._build();

  _$Preview._(
      {required this.url, required this.expiresAt, required this.mimeType})
      : super._();
  @override
  Preview rebuild(void Function(PreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PreviewBuilder toBuilder() => PreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Preview &&
        url == other.url &&
        expiresAt == other.expiresAt &&
        mimeType == other.mimeType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Preview')
          ..add('url', url)
          ..add('expiresAt', expiresAt)
          ..add('mimeType', mimeType))
        .toString();
  }
}

class PreviewBuilder implements Builder<Preview, PreviewBuilder> {
  _$Preview? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  PreviewBuilder() {
    Preview._defaults(this);
  }

  PreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _mimeType = $v.mimeType;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Preview other) {
    _$v = other as _$Preview;
  }

  @override
  void update(void Function(PreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Preview build() => _build();

  _$Preview _build() {
    final _$result = _$v ??
        _$Preview._(
          url: BuiltValueNullFieldError.checkNotNull(url, r'Preview', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'Preview', 'expiresAt'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'Preview', 'mimeType'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
