//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pairing_poll_request.g.dart';

/// PairingPollRequest
///
/// Properties:
/// * [pollToken] 
@BuiltValue()
abstract class PairingPollRequest implements Built<PairingPollRequest, PairingPollRequestBuilder> {
  @BuiltValueField(wireName: r'pollToken')
  String get pollToken;

  PairingPollRequest._();

  factory PairingPollRequest([void updates(PairingPollRequestBuilder b)]) = _$PairingPollRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PairingPollRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PairingPollRequest> get serializer => _$PairingPollRequestSerializer();
}

class _$PairingPollRequestSerializer implements PrimitiveSerializer<PairingPollRequest> {
  @override
  final Iterable<Type> types = const [PairingPollRequest, _$PairingPollRequest];

  @override
  final String wireName = r'PairingPollRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PairingPollRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pollToken';
    yield serializers.serialize(
      object.pollToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PairingPollRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PairingPollRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pollToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pollToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PairingPollRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PairingPollRequestBuilder();
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


