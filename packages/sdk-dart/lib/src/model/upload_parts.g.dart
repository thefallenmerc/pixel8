// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_parts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UploadParts extends UploadParts {
  @override
  final BuiltList<UploadPart> parts;
  @override
  final DateTime expiresAt;

  factory _$UploadParts([void Function(UploadPartsBuilder)? updates]) =>
      (UploadPartsBuilder()..update(updates))._build();

  _$UploadParts._({required this.parts, required this.expiresAt}) : super._();
  @override
  UploadParts rebuild(void Function(UploadPartsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UploadPartsBuilder toBuilder() => UploadPartsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UploadParts &&
        parts == other.parts &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, parts.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UploadParts')
          ..add('parts', parts)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class UploadPartsBuilder implements Builder<UploadParts, UploadPartsBuilder> {
  _$UploadParts? _$v;

  ListBuilder<UploadPart>? _parts;
  ListBuilder<UploadPart> get parts =>
      _$this._parts ??= ListBuilder<UploadPart>();
  set parts(ListBuilder<UploadPart>? parts) => _$this._parts = parts;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  UploadPartsBuilder() {
    UploadParts._defaults(this);
  }

  UploadPartsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _parts = $v.parts.toBuilder();
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UploadParts other) {
    _$v = other as _$UploadParts;
  }

  @override
  void update(void Function(UploadPartsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UploadParts build() => _build();

  _$UploadParts _build() {
    _$UploadParts _$result;
    try {
      _$result = _$v ??
          _$UploadParts._(
            parts: parts.build(),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
                expiresAt, r'UploadParts', 'expiresAt'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'parts';
        parts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UploadParts', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
