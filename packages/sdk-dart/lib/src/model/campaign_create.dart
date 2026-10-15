//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/campaign_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_create.g.dart';

/// CampaignCreate
///
/// Properties:
/// * [name] 
/// * [description] 
/// * [items] 
@BuiltValue(instantiable: false)
abstract class CampaignCreate  {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'items')
  BuiltList<CampaignItem> get items;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignCreate> get serializer => _$CampaignCreateSerializer();
}

class _$CampaignCreateSerializer implements PrimitiveSerializer<CampaignCreate> {
  @override
  final Iterable<Type> types = const [CampaignCreate];

  @override
  final String wireName = r'CampaignCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignCreate object, {
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
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(CampaignItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  @override
  CampaignCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.deserialize(serialized, specifiedType: FullType($CampaignCreate)) as $CampaignCreate;
  }
}


/// a concrete implementation of [CampaignCreate], since [CampaignCreate] is not instantiable
@BuiltValue(instantiable: true)
abstract class $CampaignCreate implements CampaignCreate, Built<$CampaignCreate, $CampaignCreateBuilder> {
  $CampaignCreate._();

  factory $CampaignCreate([void Function($CampaignCreateBuilder)? updates]) = _$$CampaignCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults($CampaignCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<$CampaignCreate> get serializer => _$$CampaignCreateSerializer();
}

class _$$CampaignCreateSerializer implements PrimitiveSerializer<$CampaignCreate> {
  @override
  final Iterable<Type> types = const [$CampaignCreate, _$$CampaignCreate];

  @override
  final String wireName = r'$CampaignCreate';

  @override
  Object serialize(
    Serializers serializers,
    $CampaignCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return serializers.serialize(object, specifiedType: FullType(CampaignCreate))!;
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignCreateBuilder result,
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
  $CampaignCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = $CampaignCreateBuilder();
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

