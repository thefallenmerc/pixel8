// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DownloadsRequest extends DownloadsRequest {
  @override
  final BuiltList<String> renditionIds;

  factory _$DownloadsRequest(
          [void Function(DownloadsRequestBuilder)? updates]) =>
      (DownloadsRequestBuilder()..update(updates))._build();

  _$DownloadsRequest._({required this.renditionIds}) : super._();
  @override
  DownloadsRequest rebuild(void Function(DownloadsRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DownloadsRequestBuilder toBuilder() =>
      DownloadsRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DownloadsRequest && renditionIds == other.renditionIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, renditionIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DownloadsRequest')
          ..add('renditionIds', renditionIds))
        .toString();
  }
}

class DownloadsRequestBuilder
    implements Builder<DownloadsRequest, DownloadsRequestBuilder> {
  _$DownloadsRequest? _$v;

  ListBuilder<String>? _renditionIds;
  ListBuilder<String> get renditionIds =>
      _$this._renditionIds ??= ListBuilder<String>();
  set renditionIds(ListBuilder<String>? renditionIds) =>
      _$this._renditionIds = renditionIds;

  DownloadsRequestBuilder() {
    DownloadsRequest._defaults(this);
  }

  DownloadsRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _renditionIds = $v.renditionIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DownloadsRequest other) {
    _$v = other as _$DownloadsRequest;
  }

  @override
  void update(void Function(DownloadsRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DownloadsRequest build() => _build();

  _$DownloadsRequest _build() {
    _$DownloadsRequest _$result;
    try {
      _$result = _$v ??
          _$DownloadsRequest._(
            renditionIds: renditionIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'renditionIds';
        renditionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DownloadsRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
