// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloads.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Downloads extends Downloads {
  @override
  final BuiltList<Download> downloads;

  factory _$Downloads([void Function(DownloadsBuilder)? updates]) =>
      (DownloadsBuilder()..update(updates))._build();

  _$Downloads._({required this.downloads}) : super._();
  @override
  Downloads rebuild(void Function(DownloadsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DownloadsBuilder toBuilder() => DownloadsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Downloads && downloads == other.downloads;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, downloads.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Downloads')
          ..add('downloads', downloads))
        .toString();
  }
}

class DownloadsBuilder implements Builder<Downloads, DownloadsBuilder> {
  _$Downloads? _$v;

  ListBuilder<Download>? _downloads;
  ListBuilder<Download> get downloads =>
      _$this._downloads ??= ListBuilder<Download>();
  set downloads(ListBuilder<Download>? downloads) =>
      _$this._downloads = downloads;

  DownloadsBuilder() {
    Downloads._defaults(this);
  }

  DownloadsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _downloads = $v.downloads.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Downloads other) {
    _$v = other as _$Downloads;
  }

  @override
  void update(void Function(DownloadsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Downloads build() => _build();

  _$Downloads _build() {
    _$Downloads _$result;
    try {
      _$result = _$v ??
          _$Downloads._(
            downloads: downloads.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'downloads';
        downloads.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Downloads', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
