//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'delete_campaign.g.dart';

/// DeleteCampaign
///
/// Properties:
/// * [unassignScreens] 
@BuiltValue()
abstract class DeleteCampaign implements Built<DeleteCampaign, DeleteCampaignBuilder> {
  @BuiltValueField(wireName: r'unassignScreens')
  DeleteCampaignUnassignScreensEnum? get unassignScreens;
  // enum unassignScreensEnum {  true,  };

  DeleteCampaign._();

  factory DeleteCampaign([void updates(DeleteCampaignBuilder b)]) = _$DeleteCampaign;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DeleteCampaignBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DeleteCampaign> get serializer => _$DeleteCampaignSerializer();
}

class _$DeleteCampaignSerializer implements PrimitiveSerializer<DeleteCampaign> {
  @override
  final Iterable<Type> types = const [DeleteCampaign, _$DeleteCampaign];

  @override
  final String wireName = r'DeleteCampaign';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DeleteCampaign object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.unassignScreens != null) {
      yield r'unassignScreens';
      yield serializers.serialize(
        object.unassignScreens,
        specifiedType: const FullType(DeleteCampaignUnassignScreensEnum),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    DeleteCampaign object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DeleteCampaignBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'unassignScreens':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DeleteCampaignUnassignScreensEnum),
          ) as DeleteCampaignUnassignScreensEnum?;
          if (valueDes == null) continue;
          result.unassignScreens = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DeleteCampaign deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DeleteCampaignBuilder();
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


class DeleteCampaignUnassignScreensEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const DeleteCampaignUnassignScreensEnum true_ = _$deleteCampaignUnassignScreensEnum_true_;

  static Serializer<DeleteCampaignUnassignScreensEnum> get serializer => _$deleteCampaignUnassignScreensEnumSerializer;

  const DeleteCampaignUnassignScreensEnum._(String name): super(name);

  static BuiltSet<DeleteCampaignUnassignScreensEnum> get values => _$deleteCampaignUnassignScreensEnumValues;
  static DeleteCampaignUnassignScreensEnum valueOf(String name) => _$deleteCampaignUnassignScreensEnumValueOf(name);
}

