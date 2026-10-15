// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CampaignItemFitEnum _$campaignItemFitEnum_contain =
    const CampaignItemFitEnum._('contain');
const CampaignItemFitEnum _$campaignItemFitEnum_cover =
    const CampaignItemFitEnum._('cover');

CampaignItemFitEnum _$campaignItemFitEnumValueOf(String name) {
  switch (name) {
    case 'contain':
      return _$campaignItemFitEnum_contain;
    case 'cover':
      return _$campaignItemFitEnum_cover;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignItemFitEnum> _$campaignItemFitEnumValues =
    BuiltSet<CampaignItemFitEnum>(const <CampaignItemFitEnum>[
  _$campaignItemFitEnum_contain,
  _$campaignItemFitEnum_cover,
]);

Serializer<CampaignItemFitEnum> _$campaignItemFitEnumSerializer =
    _$CampaignItemFitEnumSerializer();

class _$CampaignItemFitEnumSerializer
    implements PrimitiveSerializer<CampaignItemFitEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'contain': 'contain',
    'cover': 'cover',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'contain': 'contain',
    'cover': 'cover',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignItemFitEnum];
  @override
  final String wireName = 'CampaignItemFitEnum';

  @override
  Object serialize(Serializers serializers, CampaignItemFitEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignItemFitEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignItemFitEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$CampaignItem extends CampaignItem {
  @override
  final String assetId;
  @override
  final int durationSeconds;
  @override
  final CampaignItemFitEnum fit;

  factory _$CampaignItem([void Function(CampaignItemBuilder)? updates]) =>
      (CampaignItemBuilder()..update(updates))._build();

  _$CampaignItem._(
      {required this.assetId, required this.durationSeconds, required this.fit})
      : super._();
  @override
  CampaignItem rebuild(void Function(CampaignItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignItemBuilder toBuilder() => CampaignItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CampaignItem &&
        assetId == other.assetId &&
        durationSeconds == other.durationSeconds &&
        fit == other.fit;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, assetId.hashCode);
    _$hash = $jc(_$hash, durationSeconds.hashCode);
    _$hash = $jc(_$hash, fit.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CampaignItem')
          ..add('assetId', assetId)
          ..add('durationSeconds', durationSeconds)
          ..add('fit', fit))
        .toString();
  }
}

class CampaignItemBuilder
    implements Builder<CampaignItem, CampaignItemBuilder> {
  _$CampaignItem? _$v;

  String? _assetId;
  String? get assetId => _$this._assetId;
  set assetId(String? assetId) => _$this._assetId = assetId;

  int? _durationSeconds;
  int? get durationSeconds => _$this._durationSeconds;
  set durationSeconds(int? durationSeconds) =>
      _$this._durationSeconds = durationSeconds;

  CampaignItemFitEnum? _fit;
  CampaignItemFitEnum? get fit => _$this._fit;
  set fit(CampaignItemFitEnum? fit) => _$this._fit = fit;

  CampaignItemBuilder() {
    CampaignItem._defaults(this);
  }

  CampaignItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _assetId = $v.assetId;
      _durationSeconds = $v.durationSeconds;
      _fit = $v.fit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CampaignItem other) {
    _$v = other as _$CampaignItem;
  }

  @override
  void update(void Function(CampaignItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CampaignItem build() => _build();

  _$CampaignItem _build() {
    final _$result = _$v ??
        _$CampaignItem._(
          assetId: BuiltValueNullFieldError.checkNotNull(
              assetId, r'CampaignItem', 'assetId'),
          durationSeconds: BuiltValueNullFieldError.checkNotNull(
              durationSeconds, r'CampaignItem', 'durationSeconds'),
          fit: BuiltValueNullFieldError.checkNotNull(
              fit, r'CampaignItem', 'fit'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
