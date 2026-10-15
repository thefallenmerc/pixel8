// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apps_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppsPage extends AppsPage {
  @override
  final BuiltList<App> items;

  factory _$AppsPage([void Function(AppsPageBuilder)? updates]) =>
      (AppsPageBuilder()..update(updates))._build();

  _$AppsPage._({required this.items}) : super._();
  @override
  AppsPage rebuild(void Function(AppsPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppsPageBuilder toBuilder() => AppsPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppsPage && items == other.items;
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
    return (newBuiltValueToStringHelper(r'AppsPage')..add('items', items))
        .toString();
  }
}

class AppsPageBuilder implements Builder<AppsPage, AppsPageBuilder> {
  _$AppsPage? _$v;

  ListBuilder<App>? _items;
  ListBuilder<App> get items => _$this._items ??= ListBuilder<App>();
  set items(ListBuilder<App>? items) => _$this._items = items;

  AppsPageBuilder() {
    AppsPage._defaults(this);
  }

  AppsPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppsPage other) {
    _$v = other as _$AppsPage;
  }

  @override
  void update(void Function(AppsPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppsPage build() => _build();

  _$AppsPage _build() {
    _$AppsPage _$result;
    try {
      _$result = _$v ??
          _$AppsPage._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AppsPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
