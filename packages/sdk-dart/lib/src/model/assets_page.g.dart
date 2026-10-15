// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AssetsPage extends AssetsPage {
  @override
  final BuiltList<Asset> items;

  factory _$AssetsPage([void Function(AssetsPageBuilder)? updates]) =>
      (AssetsPageBuilder()..update(updates))._build();

  _$AssetsPage._({required this.items}) : super._();
  @override
  AssetsPage rebuild(void Function(AssetsPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetsPageBuilder toBuilder() => AssetsPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AssetsPage && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AssetsPage')..add('items', items))
        .toString();
  }
}

class AssetsPageBuilder implements Builder<AssetsPage, AssetsPageBuilder> {
  _$AssetsPage? _$v;

  ListBuilder<Asset>? _items;
  ListBuilder<Asset> get items => _$this._items ??= ListBuilder<Asset>();
  set items(ListBuilder<Asset>? items) => _$this._items = items;

  AssetsPageBuilder() {
    AssetsPage._defaults(this);
  }

  AssetsPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AssetsPage other) {
    _$v = other as _$AssetsPage;
  }

  @override
  void update(void Function(AssetsPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AssetsPage build() => _build();

  _$AssetsPage _build() {
    _$AssetsPage _$result;
    try {
      _$result = _$v ??
          _$AssetsPage._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AssetsPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
