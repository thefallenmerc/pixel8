// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_parts_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UploadPartsRequest extends UploadPartsRequest {
  @override
  final BuiltList<int> partNumbers;

  factory _$UploadPartsRequest(
          [void Function(UploadPartsRequestBuilder)? updates]) =>
      (UploadPartsRequestBuilder()..update(updates))._build();

  _$UploadPartsRequest._({required this.partNumbers}) : super._();
  @override
  UploadPartsRequest rebuild(
          void Function(UploadPartsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadPartsRequestBuilder toBuilder() =>
      UploadPartsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadPartsRequest && partNumbers == other.partNumbers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, partNumbers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadPartsRequest')
          ..add('partNumbers', partNumbers))
        .toString();
  }
}

class UploadPartsRequestBuilder
    implements Builder<UploadPartsRequest, UploadPartsRequestBuilder> {
  _$UploadPartsRequest? _$v;

  ListBuilder<int>? _partNumbers;
  ListBuilder<int> get partNumbers =>
      _$this._partNumbers ??= ListBuilder<int>();
  set partNumbers(ListBuilder<int>? partNumbers) =>
      _$this._partNumbers = partNumbers;

  UploadPartsRequestBuilder() {
    UploadPartsRequest._defaults(this);
  }

  UploadPartsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _partNumbers = $v.partNumbers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadPartsRequest other) {
    _$v = other as _$UploadPartsRequest;
  }

  @override
  void update(void Function(UploadPartsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadPartsRequest build() => _build();

  _$UploadPartsRequest _build() {
    _$UploadPartsRequest _$result;
    try {
      _$result = _$v ??
          _$UploadPartsRequest._(
            partNumbers: partNumbers.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'partNumbers';
        partNumbers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UploadPartsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
