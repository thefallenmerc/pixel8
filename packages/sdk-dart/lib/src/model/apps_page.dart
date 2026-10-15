//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/app.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'apps_page.g.dart';

/// AppsPage
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class AppsPage implements Built<AppsPage, AppsPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<App> get items;

  AppsPage._();

  factory AppsPage([void updates(AppsPageBuilder b)]) = _$AppsPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppsPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AppsPage> get serializer => _$AppsPageSerializer();
}

class _$AppsPageSerializer implements PrimitiveSerializer<AppsPage> {
  @override
  final Iterable<Type> types = const [AppsPage, _$AppsPage];

  @override
  final String wireName = r'AppsPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppsPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(App)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AppsPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AppsPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(App)]),
          ) as BuiltList<App>;
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
  AppsPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppsPageBuilder();
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


