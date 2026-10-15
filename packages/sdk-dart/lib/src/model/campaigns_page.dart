//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:pixel8_sdk/src/model/campaign.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'campaigns_page.g.dart';

/// CampaignsPage
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class CampaignsPage implements Built<CampaignsPage, CampaignsPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<Campaign> get items;

  CampaignsPage._();

  factory CampaignsPage([void updates(CampaignsPageBuilder b)]) = _$CampaignsPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CampaignsPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CampaignsPage> get serializer => _$CampaignsPageSerializer();
}

class _$CampaignsPageSerializer implements PrimitiveSerializer<CampaignsPage> {
  @override
  final Iterable<Type> types = const [CampaignsPage, _$CampaignsPage];

  @override
  final String wireName = r'CampaignsPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CampaignsPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(Campaign)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CampaignsPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CampaignsPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Campaign)]),
          ) as BuiltList<Campaign>;
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
  CampaignsPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CampaignsPageBuilder();
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


