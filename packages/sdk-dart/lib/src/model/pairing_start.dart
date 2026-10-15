//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'pairing_start.g.dart';

/// PairingStart
///
/// Properties:
/// * [pairingId] 
/// * [code] 
/// * [pollToken] 
/// * [expiresAt] 
@BuiltValue()
abstract class PairingStart implements Built<PairingStart, PairingStartBuilder> {
  @BuiltValueField(wireName: r'pairingId')
  String get pairingId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'pollToken')
  String get pollToken;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  PairingStart._();

  factory PairingStart([void updates(PairingStartBuilder b)]) = _$PairingStart;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PairingStartBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PairingStart> get serializer => _$PairingStartSerializer();
}

class _$PairingStartSerializer implements PrimitiveSerializer<PairingStart> {
  @override
  final Iterable<Type> types = const [PairingStart, _$PairingStart];

  @override
  final String wireName = r'PairingStart';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PairingStart object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'pairingId';
    yield serializers.serialize(
      object.pairingId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'pollToken';
    yield serializers.serialize(
      object.pollToken,
      specifiedType: const FullType(String),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PairingStart object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PairingStartBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'pairingId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pairingId = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'pollToken':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.pollToken = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PairingStart deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PairingStartBuilder();
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


