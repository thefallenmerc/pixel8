// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class CampaignCreateBuilder {
  void replace(CampaignCreate other);
  void update(void Function(CampaignCreateBuilder) updates);
  String? get name;
  set name(String? name);

  String? get description;
  set description(String? description);

  ListBuilder<CampaignItem> get items;
  set items(ListBuilder<CampaignItem>? items);
}

class _$$CampaignCreate extends $CampaignCreate {
  @override
  final String name;
  @override
  final String? description;
  @override
  final BuiltList<CampaignItem> items;

  factory _$$CampaignCreate([void Function($CampaignCreateBuilder)? updates]) =>
      ($CampaignCreateBuilder()..update(updates))._build();

  _$$CampaignCreate._(
      {required this.name, this.description, required this.items})
      : super._();
  @override
  $CampaignCreate rebuild(void Function($CampaignCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $CampaignCreateBuilder toBuilder() => $CampaignCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $CampaignCreate &&
        name == other.name &&
        description == other.description &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'$CampaignCreate')
          ..add('name', name)
          ..add('description', description)
          ..add('items', items))
        .toString();
  }
}

class $CampaignCreateBuilder
    implements
        Builder<$CampaignCreate, $CampaignCreateBuilder>,
        CampaignCreateBuilder {
  _$$CampaignCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(covariant String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(covariant String? description) =>
      _$this._description = description;

  ListBuilder<CampaignItem>? _items;
  ListBuilder<CampaignItem> get items =>
      _$this._items ??= ListBuilder<CampaignItem>();
  set items(covariant ListBuilder<CampaignItem>? items) =>
      _$this._items = items;

  $CampaignCreateBuilder() {
    $CampaignCreate._defaults(this);
  }

  $CampaignCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant $CampaignCreate other) {
    _$v = other as _$$CampaignCreate;
  }

  @override
  void update(void Function($CampaignCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $CampaignCreate build() => _build();

  _$$CampaignCreate _build() {
    _$$CampaignCreate _$result;
    try {
      _$result = _$v ??
          _$$CampaignCreate._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'$CampaignCreate', 'name'),
            description: description,
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'$CampaignCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
