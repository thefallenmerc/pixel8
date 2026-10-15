//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/campaign_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:pixel8_sdk/src/model/campaign_create.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_update.g.dart';

/// CampaignUpdate
///
/// Properties:
/// * [name] 
/// * [description] 
/// * [items] 
/// * [expectedRevision] 
@BuiltValue()
abstract class CampaignUpdate implements CampaignCreate, Built<CampaignUpdate, CampaignUpdateBuilder> {
  @BuiltValueField(wireName: r'expectedRevision')
  int get expectedRevision;

  CampaignUpdate._();

  factory CampaignUpdate([void updates(CampaignUpdateBuilder b)]) = _$CampaignUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignUpdate> get serializer => _$CampaignUpdateSerializer();
}

class _$CampaignUpdateSerializer implements PrimitiveSerializer<CampaignUpdate> {
  @override
  final Iterable<Type> types = const [CampaignUpdate, _$CampaignUpdate];

  @override
  final String wireName = r'CampaignUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'expectedRevision';
    yield serializers.serialize(
      object.expectedRevision,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CampaignItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'expectedRevision':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedRevision = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(CampaignItem)]),
          ) as BuiltList<CampaignItem>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignUpdateBuilder();
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


