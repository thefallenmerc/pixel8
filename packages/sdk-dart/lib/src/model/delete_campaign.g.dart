// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_campaign.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const DeleteCampaignUnassignScreensEnum
    _$deleteCampaignUnassignScreensEnum_true_ =
    const DeleteCampaignUnassignScreensEnum._('true_');

DeleteCampaignUnassignScreensEnum _$deleteCampaignUnassignScreensEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$deleteCampaignUnassignScreensEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<DeleteCampaignUnassignScreensEnum>
    _$deleteCampaignUnassignScreensEnumValues = BuiltSet<
        DeleteCampaignUnassignScreensEnum>(const <DeleteCampaignUnassignScreensEnum>[
  _$deleteCampaignUnassignScreensEnum_true_,
]);

Serializer<DeleteCampaignUnassignScreensEnum>
    _$deleteCampaignUnassignScreensEnumSerializer =
    _$DeleteCampaignUnassignScreensEnumSerializer();

class _$DeleteCampaignUnassignScreensEnumSerializer
    implements PrimitiveSerializer<DeleteCampaignUnassignScreensEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[DeleteCampaignUnassignScreensEnum];
  @override
  final String wireName = 'DeleteCampaignUnassignScreensEnum';

  @override
  Object serialize(
          Serializers serializers, DeleteCampaignUnassignScreensEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  DeleteCampaignUnassignScreensEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      DeleteCampaignUnassignScreensEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$DeleteCampaign extends DeleteCampaign {
  @override
  final DeleteCampaignUnassignScreensEnum? unassignScreens;

  factory _$DeleteCampaign([void Function(DeleteCampaignBuilder)? updates]) =>
      (DeleteCampaignBuilder()..update(updates))._build();

  _$DeleteCampaign._({this.unassignScreens}) : super._();
  @override
  DeleteCampaign rebuild(void Function(DeleteCampaignBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DeleteCampaignBuilder toBuilder() => DeleteCampaignBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DeleteCampaign && unassignScreens == other.unassignScreens;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, unassignScreens.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DeleteCampaign')
          ..add('unassignScreens', unassignScreens))
        .toString();
  }
}

class DeleteCampaignBuilder
    implements Builder<DeleteCampaign, DeleteCampaignBuilder> {
  _$DeleteCampaign? _$v;

  DeleteCampaignUnassignScreensEnum? _unassignScreens;
  DeleteCampaignUnassignScreensEnum? get unassignScreens =>
      _$this._unassignScreens;
  set unassignScreens(DeleteCampaignUnassignScreensEnum? unassignScreens) =>
      _$this._unassignScreens = unassignScreens;

  DeleteCampaignBuilder() {
    DeleteCampaign._defaults(this);
  }

  DeleteCampaignBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _unassignScreens = $v.unassignScreens;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DeleteCampaign other) {
    _$v = other as _$DeleteCampaign;
  }

  @override
  void update(void Function(DeleteCampaignBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DeleteCampaign build() => _build();

  _$DeleteCampaign _build() {
    final _$result = _$v ??
        _$DeleteCampaign._(
          unassignScreens: unassignScreens,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
