//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pairing_poll_one_of.g.dart';

/// PairingPollOneOf
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class PairingPollOneOf implements Built<PairingPollOneOf, PairingPollOneOfBuilder> {
  @BuiltValueField(wireName: r'status')
  JsonObject? get status;

  PairingPollOneOf._();

  factory PairingPollOneOf([void updates(PairingPollOneOfBuilder b)]) = _$PairingPollOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PairingPollOneOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PairingPollOneOf> get serializer => _$PairingPollOneOfSerializer();
}

class _$PairingPollOneOfSerializer implements PrimitiveSerializer<PairingPollOneOf> {
  @override
  final Iterable<Type> types = const [PairingPollOneOf, _$PairingPollOneOf];

  @override
  final String wireName = r'PairingPollOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PairingPollOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield object.status == null ? null : serializers.serialize(
      object.status,
      specifiedType: const FullType.nullable(JsonObject),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PairingPollOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PairingPollOneOfBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PairingPollOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PairingPollOneOfBuilder();
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


