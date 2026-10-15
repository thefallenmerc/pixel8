// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CampaignUpdate extends CampaignUpdate {
  @override
  final int expectedRevision;
  @override
  final String name;
  @override
  final String? description;
  @override
  final BuiltList<CampaignItem> items;

  factory _$CampaignUpdate([void Function(CampaignUpdateBuilder)? updates]) =>
      (CampaignUpdateBuilder()..update(updates))._build();

  _$CampaignUpdate._(
      {required this.expectedRevision,
      required this.name,
      this.description,
      required this.items})
      : super._();
  @override
  CampaignUpdate rebuild(void Function(CampaignUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignUpdateBuilder toBuilder() => CampaignUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignUpdate &&
        expectedRevision == other.expectedRevision &&
        name == other.name &&
        description == other.description &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, expectedRevision.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignUpdate')
          ..add('expectedRevision', expectedRevision)
          ..add('name', name)
          ..add('description', description)
          ..add('items', items))
        .toString();
  }
}

class CampaignUpdateBuilder
    implements
        Builder<CampaignUpdate, CampaignUpdateBuilder>,
        CampaignCreateBuilder {
  _$CampaignUpdate? _$v;

  int? _expectedRevision;
  int? get expectedRevision => _$this._expectedRevision;
  set expectedRevision(covariant int? expectedRevision) =>
      _$this._expectedRevision = expectedRevision;

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

  CampaignUpdateBuilder() {
    CampaignUpdate._defaults(this);
  }

  CampaignUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _expectedRevision = $v.expectedRevision;
      _name = $v.name;
      _description = $v.description;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CampaignUpdate other) {
    _$v = other as _$CampaignUpdate;
  }

  @override
  void update(void Function(CampaignUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignUpdate build() => _build();

  _$CampaignUpdate _build() {
    _$CampaignUpdate _$result;
    try {
      _$result = _$v ??
          _$CampaignUpdate._(
            expectedRevision: BuiltValueNullFieldError.checkNotNull(
                expectedRevision, r'CampaignUpdate', 'expectedRevision'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'CampaignUpdate', 'name'),
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
            r'CampaignUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
