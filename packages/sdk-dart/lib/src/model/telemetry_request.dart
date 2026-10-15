//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/telemetry_sample.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'telemetry_request.g.dart';

/// TelemetryRequest
///
/// Properties:
/// * [samples] 
@BuiltValue()
abstract class TelemetryRequest implements Built<TelemetryRequest, TelemetryRequestBuilder> {
  @BuiltValueField(wireName: r'samples')
  BuiltList<TelemetrySample> get samples;

  TelemetryRequest._();

  factory TelemetryRequest([void updates(TelemetryRequestBuilder b)]) = _$TelemetryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TelemetryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TelemetryRequest> get serializer => _$TelemetryRequestSerializer();
}

class _$TelemetryRequestSerializer implements PrimitiveSerializer<TelemetryRequest> {
  @override
  final Iterable<Type> types = const [TelemetryRequest, _$TelemetryRequest];

  @override
  final String wireName = r'TelemetryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TelemetryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'samples';
    yield serializers.serialize(
      object.samples,
      specifiedType: const FullType(BuiltList, [FullType(TelemetrySample)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TelemetryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TelemetryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'samples':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(TelemetrySample)]),
          ) as BuiltList<TelemetrySample>;
          result.samples.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TelemetryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TelemetryRequestBuilder();
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


