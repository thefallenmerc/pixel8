//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pairing_poll_one_of1.g.dart';

/// PairingPollOneOf1
///
/// Properties:
/// * [status] 
/// * [deviceToken] 
/// * [screenId] 
@BuiltValue()
abstract class PairingPollOneOf1 implements Built<PairingPollOneOf1, PairingPollOneOf1Builder> {
  @BuiltValueField(wireName: r'status')
  JsonObject? get status;

  @BuiltValueField(wireName: r'deviceToken')
  String get deviceToken;

  @BuiltValueField(wireName: r'screenId')
  String get screenId;

  PairingPollOneOf1._();

  factory PairingPollOneOf1([void updates(PairingPollOneOf1Builder b)]) = _$PairingPollOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PairingPollOneOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PairingPollOneOf1> get serializer => _$PairingPollOneOf1Serializer();
}

class _$PairingPollOneOf1Serializer implements PrimitiveSerializer<PairingPollOneOf1> {
  @override
  final Iterable<Type> types = const [PairingPollOneOf1, _$PairingPollOneOf1];

  @override
  final String wireName = r'PairingPollOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PairingPollOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield object.status == null ? null : serializers.serialize(
      object.status,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'deviceToken';
    yield serializers.serialize(
      object.deviceToken,
      specifiedType: const FullType(String),
    );
    yield r'screenId';
    yield serializers.serialize(
      object.screenId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PairingPollOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PairingPollOneOf1Builder result,
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
        case r'deviceToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceToken = valueDes;
          break;
        case r'screenId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.screenId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PairingPollOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PairingPollOneOf1Builder();
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


