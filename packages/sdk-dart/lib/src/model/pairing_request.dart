//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/capabilities.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pairing_request.g.dart';

/// PairingRequest
///
/// Properties:
/// * [deviceId] 
/// * [capabilities] 
@BuiltValue()
abstract class PairingRequest implements Built<PairingRequest, PairingRequestBuilder> {
  @BuiltValueField(wireName: r'deviceId')
  String get deviceId;

  @BuiltValueField(wireName: r'capabilities')
  Capabilities get capabilities;

  PairingRequest._();

  factory PairingRequest([void updates(PairingRequestBuilder b)]) = _$PairingRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PairingRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PairingRequest> get serializer => _$PairingRequestSerializer();
}

class _$PairingRequestSerializer implements PrimitiveSerializer<PairingRequest> {
  @override
  final Iterable<Type> types = const [PairingRequest, _$PairingRequest];

  @override
  final String wireName = r'PairingRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PairingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'deviceId';
    yield serializers.serialize(
      object.deviceId,
      specifiedType: const FullType(String),
    );
    yield r'capabilities';
    yield serializers.serialize(
      object.capabilities,
      specifiedType: const FullType(Capabilities),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PairingRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PairingRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'deviceId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deviceId = valueDes;
          break;
        case r'capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Capabilities),
          ) as Capabilities;
          result.capabilities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PairingRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PairingRequestBuilder();
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


