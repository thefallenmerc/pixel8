// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screens_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScreensPage extends ScreensPage {
  @override
  final BuiltList<Screen> items;

  factory _$ScreensPage([void Function(ScreensPageBuilder)? updates]) =>
      (ScreensPageBuilder()..update(updates))._build();

  _$ScreensPage._({required this.items}) : super._();
  @override
  ScreensPage rebuild(void Function(ScreensPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScreensPageBuilder toBuilder() => ScreensPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScreensPage && items == other.items;
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
    return (newBuiltValueToStringHelper(r'ScreensPage')..add('items', items))
        .toString();
  }
}

class ScreensPageBuilder implements Builder<ScreensPage, ScreensPageBuilder> {
  _$ScreensPage? _$v;

  ListBuilder<Screen>? _items;
  ListBuilder<Screen> get items => _$this._items ??= ListBuilder<Screen>();
  set items(ListBuilder<Screen>? items) => _$this._items = items;

  ScreensPageBuilder() {
    ScreensPage._defaults(this);
  }

  ScreensPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScreensPage other) {
    _$v = other as _$ScreensPage;
  }

  @override
  void update(void Function(ScreensPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScreensPage build() => _build();

  _$ScreensPage _build() {
    _$ScreensPage _$result;
    try {
      _$result = _$v ??
          _$ScreensPage._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ScreensPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
