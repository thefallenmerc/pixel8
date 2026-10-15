//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:pixel8_sdk/src/model/asset.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'assets_page.g.dart';

/// AssetsPage
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AssetsPage implements Built<AssetsPage, AssetsPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<Asset> get items;

  AssetsPage._();

  factory AssetsPage([void updates(AssetsPageBuilder b)]) = _$AssetsPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetsPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AssetsPage> get serializer => _$AssetsPageSerializer();
}

class _$AssetsPageSerializer implements PrimitiveSerializer<AssetsPage> {
  @override
  final Iterable<Type> types = const [AssetsPage, _$AssetsPage];

  @override
  final String wireName = r'AssetsPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AssetsPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(Asset)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AssetsPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetsPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Asset)]),
          ) as BuiltList<Asset>;
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
  AssetsPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetsPageBuilder();
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


