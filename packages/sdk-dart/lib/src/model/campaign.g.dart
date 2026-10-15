// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CampaignStatusEnum _$campaignStatusEnum_preparing =
    const CampaignStatusEnum._('preparing');
const CampaignStatusEnum _$campaignStatusEnum_ready =
    const CampaignStatusEnum._('ready');
const CampaignStatusEnum _$campaignStatusEnum_failed =
    const CampaignStatusEnum._('failed');

CampaignStatusEnum _$campaignStatusEnumValueOf(String name) {
  switch (name) {
    case 'preparing':
      return _$campaignStatusEnum_preparing;
    case 'ready':
      return _$campaignStatusEnum_ready;
    case 'failed':
      return _$campaignStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CampaignStatusEnum> _$campaignStatusEnumValues =
    BuiltSet<CampaignStatusEnum>(const <CampaignStatusEnum>[
  _$campaignStatusEnum_preparing,
  _$campaignStatusEnum_ready,
  _$campaignStatusEnum_failed,
]);

Serializer<CampaignStatusEnum> _$campaignStatusEnumSerializer =
    _$CampaignStatusEnumSerializer();

class _$CampaignStatusEnumSerializer
    implements PrimitiveSerializer<CampaignStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'preparing': 'preparing',
    'ready': 'ready',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'preparing': 'preparing',
    'ready': 'ready',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[CampaignStatusEnum];
  @override
  final String wireName = 'CampaignStatusEnum';

  @override
  Object serialize(Serializers serializers, CampaignStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  CampaignStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      CampaignStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Campaign extends Campaign {
  @override
  final String id;
  @override
  final String appId;
  @override
  final String name;
  @override
  final String? description;
  @override
  final int revision;
  @override
  final int? currentRevision;
  @override
  final CampaignStatusEnum status;
  @override
  final BuiltList<CampaignItem> items;
  @override
  final String? error;

  factory _$Campaign([void Function(CampaignBuilder)? updates]) =>
      (CampaignBuilder()..update(updates))._build();

  _$Campaign._(
      {required this.id,
      required this.appId,
      required this.name,
      this.description,
      required this.revision,
      this.currentRevision,
      required this.status,
      required this.items,
      this.error})
      : super._();
  @override
  Campaign rebuild(void Function(CampaignBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CampaignBuilder toBuilder() => CampaignBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Campaign &&
        id == other.id &&
        appId == other.appId &&
        name == other.name &&
        description == other.description &&
        revision == other.revision &&
        currentRevision == other.currentRevision &&
        status == other.status &&
        items == other.items &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, appId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, revision.hashCode);
    _$hash = $jc(_$hash, currentRevision.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Campaign')
          ..add('id', id)
          ..add('appId', appId)
          ..add('name', name)
          ..add('description', description)
          ..add('revision', revision)
          ..add('currentRevision', currentRevision)
          ..add('status', status)
          ..add('items', items)
          ..add('error', error))
        .toString();
  }
}

class CampaignBuilder implements Builder<Campaign, CampaignBuilder> {
  _$Campaign? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _appId;
  String? get appId => _$this._appId;
  set appId(String? appId) => _$this._appId = appId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _revision;
  int? get revision => _$this._revision;
  set revision(int? revision) => _$this._revision = revision;

  int? _currentRevision;
  int? get currentRevision => _$this._currentRevision;
  set currentRevision(int? currentRevision) =>
      _$this._currentRevision = currentRevision;

  CampaignStatusEnum? _status;
  CampaignStatusEnum? get status => _$this._status;
  set status(CampaignStatusEnum? status) => _$this._status = status;

  ListBuilder<CampaignItem>? _items;
  ListBuilder<CampaignItem> get items =>
      _$this._items ??= ListBuilder<CampaignItem>();
  set items(ListBuilder<CampaignItem>? items) => _$this._items = items;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  CampaignBuilder() {
    Campaign._defaults(this);
  }

  CampaignBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _appId = $v.appId;
      _name = $v.name;
      _description = $v.description;
      _revision = $v.revision;
      _currentRevision = $v.currentRevision;
      _status = $v.status;
      _items = $v.items.toBuilder();
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Campaign other) {
    _$v = other as _$Campaign;
  }

  @override
  void update(void Function(CampaignBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Campaign build() => _build();

  _$Campaign _build() {
    _$Campaign _$result;
    try {
      _$result = _$v ??
          _$Campaign._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Campaign', 'id'),
            appId: BuiltValueNullFieldError.checkNotNull(
                appId, r'Campaign', 'appId'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'Campaign', 'name'),
            description: description,
            revision: BuiltValueNullFieldError.checkNotNull(
                revision, r'Campaign', 'revision'),
            currentRevision: currentRevision,
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Campaign', 'status'),
            items: items.build(),
            error: error,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Campaign', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
