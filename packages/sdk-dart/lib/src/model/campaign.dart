//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/campaign_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign.g.dart';

/// Campaign
///
/// Properties:
/// * [id] 
/// * [appId] 
/// * [name] 
/// * [description] 
/// * [revision] 
/// * [currentRevision] 
/// * [status] 
/// * [items] 
/// * [error] 
@BuiltValue()
abstract class Campaign implements Built<Campaign, CampaignBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'appId')
  String get appId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'revision')
  int get revision;

  @BuiltValueField(wireName: r'currentRevision')
  int? get currentRevision;

  @BuiltValueField(wireName: r'status')
  CampaignStatusEnum get status;
  // enum statusEnum {  preparing,  ready,  failed,  };

  @BuiltValueField(wireName: r'items')
  BuiltList<CampaignItem> get items;

  @BuiltValueField(wireName: r'error')
  String? get error;

  Campaign._();

  factory Campaign([void updates(CampaignBuilder b)]) = _$Campaign;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Campaign> get serializer => _$CampaignSerializer();
}

class _$CampaignSerializer implements PrimitiveSerializer<Campaign> {
  @override
  final Iterable<Type> types = const [Campaign, _$Campaign];

  @override
  final String wireName = r'Campaign';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Campaign object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'appId';
    yield serializers.serialize(
      object.appId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'revision';
    yield serializers.serialize(
      object.revision,
      specifiedType: const FullType(int),
    );
    yield r'currentRevision';
    yield object.currentRevision == null ? null : serializers.serialize(
      object.currentRevision,
      specifiedType: const FullType.nullable(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CampaignStatusEnum),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CampaignItem)]),
    );
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Campaign object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'appId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'revision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.revision = valueDes;
          break;
        case r'currentRevision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.currentRevision = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CampaignStatusEnum),
          ) as CampaignStatusEnum;
          result.status = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignItem)]),
          ) as BuiltList<CampaignItem>;
          result.items.replace(valueDes);
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Campaign deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class CampaignStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'preparing')
  static const CampaignStatusEnum preparing = _$campaignStatusEnum_preparing;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CampaignStatusEnum ready = _$campaignStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CampaignStatusEnum failed = _$campaignStatusEnum_failed;

  static Serializer<CampaignStatusEnum> get serializer => _$campaignStatusEnumSerializer;

  const CampaignStatusEnum._(String name): super(name);

  static BuiltSet<CampaignStatusEnum> get values => _$campaignStatusEnumValues;
  static CampaignStatusEnum valueOf(String name) => _$campaignStatusEnumValueOf(name);
}

