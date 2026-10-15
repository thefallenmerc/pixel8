// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_complete_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UploadCompleteRequest extends UploadCompleteRequest {
  @override
  final BuiltList<UploadCompleteRequestPartsInner> parts;

  factory _$UploadCompleteRequest(
          [void Function(UploadCompleteRequestBuilder)? updates]) =>
      (UploadCompleteRequestBuilder()..update(updates))._build();

  _$UploadCompleteRequest._({required this.parts}) : super._();
  @override
  UploadCompleteRequest rebuild(
          void Function(UploadCompleteRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadCompleteRequestBuilder toBuilder() =>
      UploadCompleteRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadCompleteRequest && parts == other.parts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadCompleteRequest')
          ..add('parts', parts))
        .toString();
  }
}

class UploadCompleteRequestBuilder
    implements Builder<UploadCompleteRequest, UploadCompleteRequestBuilder> {
  _$UploadCompleteRequest? _$v;

  ListBuilder<UploadCompleteRequestPartsInner>? _parts;
  ListBuilder<UploadCompleteRequestPartsInner> get parts =>
      _$this._parts ??= ListBuilder<UploadCompleteRequestPartsInner>();
  set parts(ListBuilder<UploadCompleteRequestPartsInner>? parts) =>
      _$this._parts = parts;

  UploadCompleteRequestBuilder() {
    UploadCompleteRequest._defaults(this);
  }

  UploadCompleteRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _parts = $v.parts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadCompleteRequest other) {
    _$v = other as _$UploadCompleteRequest;
  }

  @override
  void update(void Function(UploadCompleteRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadCompleteRequest build() => _build();

  _$UploadCompleteRequest _build() {
    _$UploadCompleteRequest _$result;
    try {
      _$result = _$v ??
          _$UploadCompleteRequest._(
            parts: parts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parts';
        parts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UploadCompleteRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
