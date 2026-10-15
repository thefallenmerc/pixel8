// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaigns_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignsPage extends CampaignsPage {
  @override
  final BuiltList<Campaign> items;

  factory _$CampaignsPage([void Function(CampaignsPageBuilder)? updates]) =>
      (CampaignsPageBuilder()..update(updates))._build();

  _$CampaignsPage._({required this.items}) : super._();
  @override
  CampaignsPage rebuild(void Function(CampaignsPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignsPageBuilder toBuilder() => CampaignsPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignsPage && items == other.items;
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
    return (newBuiltValueToStringHelper(r'CampaignsPage')..add('items', items))
        .toString();
  }
}

class CampaignsPageBuilder
    implements Builder<CampaignsPage, CampaignsPageBuilder> {
  _$CampaignsPage? _$v;

  ListBuilder<Campaign>? _items;
  ListBuilder<Campaign> get items => _$this._items ??= ListBuilder<Campaign>();
  set items(ListBuilder<Campaign>? items) => _$this._items = items;

  CampaignsPageBuilder() {
    CampaignsPage._defaults(this);
  }

  CampaignsPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignsPage other) {
    _$v = other as _$CampaignsPage;
  }

  @override
  void update(void Function(CampaignsPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignsPage build() => _build();

  _$CampaignsPage _build() {
    _$CampaignsPage _$result;
    try {
      _$result = _$v ??
          _$CampaignsPage._(
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CampaignsPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
