//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'accepted.g.dart';

/// Accepted
///
/// Properties:
/// * [accepted] 
@BuiltValue()
abstract class Accepted implements Built<Accepted, AcceptedBuilder> {
  @BuiltValueField(wireName: r'accepted')
  int get accepted;

  Accepted._();

  factory Accepted([void updates(AcceptedBuilder b)]) = _$Accepted;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AcceptedBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Accepted> get serializer => _$AcceptedSerializer();
}

class _$AcceptedSerializer implements PrimitiveSerializer<Accepted> {
  @override
  final Iterable<Type> types = const [Accepted, _$Accepted];

  @override
  final String wireName = r'Accepted';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Accepted object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Accepted object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AcceptedBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.accepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Accepted deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AcceptedBuilder();
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


