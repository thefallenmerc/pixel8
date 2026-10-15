//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaign_item.g.dart';

/// CampaignItem
///
/// Properties:
/// * [assetId] 
/// * [durationSeconds] 
/// * [fit] 
@BuiltValue()
abstract class CampaignItem implements Built<CampaignItem, CampaignItemBuilder> {
  @BuiltValueField(wireName: r'assetId')
  String get assetId;

  @BuiltValueField(wireName: r'durationSeconds')
  int get durationSeconds;

  @BuiltValueField(wireName: r'fit')
  CampaignItemFitEnum get fit;
  // enum fitEnum {  contain,  cover,  };

  CampaignItem._();

  factory CampaignItem([void updates(CampaignItemBuilder b)]) = _$CampaignItem;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignItemBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignItem> get serializer => _$CampaignItemSerializer();
}

class _$CampaignItemSerializer implements PrimitiveSerializer<CampaignItem> {
  @override
  final Iterable<Type> types = const [CampaignItem, _$CampaignItem];

  @override
  final String wireName = r'CampaignItem';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignItem object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'assetId';
    yield serializers.serialize(
      object.assetId,
      specifiedType: const FullType(String),
    );
    yield r'durationSeconds';
    yield serializers.serialize(
      object.durationSeconds,
      specifiedType: const FullType(int),
    );
    yield r'fit';
    yield serializers.serialize(
      object.fit,
      specifiedType: const FullType(CampaignItemFitEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignItem object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignItemBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'assetId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.assetId = valueDes;
          break;
        case r'durationSeconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.durationSeconds = valueDes;
          break;
        case r'fit':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CampaignItemFitEnum),
          ) as CampaignItemFitEnum;
          result.fit = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CampaignItem deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignItemBuilder();
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


class CampaignItemFitEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'contain')
  static const CampaignItemFitEnum contain = _$campaignItemFitEnum_contain;
  @BuiltValueEnumConst(wireName: r'cover')
  static const CampaignItemFitEnum cover = _$campaignItemFitEnum_cover;

  static Serializer<CampaignItemFitEnum> get serializer => _$campaignItemFitEnumSerializer;

  const CampaignItemFitEnum._(String name): super(name);

  static BuiltSet<CampaignItemFitEnum> get values => _$campaignItemFitEnumValues;
  static CampaignItemFitEnum valueOf(String name) => _$campaignItemFitEnumValueOf(name);
}

