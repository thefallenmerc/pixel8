//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/telemetry_sample.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'telemetry_page.g.dart';

/// TelemetryPage
///
/// Properties:
/// * [items] 
@BuiltValue()
abstract class TelemetryPage implements Built<TelemetryPage, TelemetryPageBuilder> {
  @BuiltValueField(wireName: r'items')
  BuiltList<TelemetrySample> get items;

  TelemetryPage._();

  factory TelemetryPage([void updates(TelemetryPageBuilder b)]) = _$TelemetryPage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TelemetryPageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TelemetryPage> get serializer => _$TelemetryPageSerializer();
}

class _$TelemetryPageSerializer implements PrimitiveSerializer<TelemetryPage> {
  @override
  final Iterable<Type> types = const [TelemetryPage, _$TelemetryPage];

  @override
  final String wireName = r'TelemetryPage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TelemetryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(TelemetrySample)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TelemetryPage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TelemetryPageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TelemetrySample)]),
          ) as BuiltList<TelemetrySample>;
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
  TelemetryPage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TelemetryPageBuilder();
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


