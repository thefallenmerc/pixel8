//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/pairing_poll_one_of1.dart';
import 'package:pixel8_sdk/src/model/pairing_poll_one_of.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'pairing_poll.g.dart';

/// PairingPoll
///
/// Properties:
/// * [status] 
/// * [deviceToken] 
/// * [screenId] 
@BuiltValue()
abstract class PairingPoll implements Built<PairingPoll, PairingPollBuilder> {
  /// One Of [PairingPollOneOf], [PairingPollOneOf1]
  OneOf get oneOf;

  PairingPoll._();

  factory PairingPoll([void updates(PairingPollBuilder b)]) = _$PairingPoll;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PairingPollBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PairingPoll> get serializer => _$PairingPollSerializer();
}

class _$PairingPollSerializer implements PrimitiveSerializer<PairingPoll> {
  @override
  final Iterable<Type> types = const [PairingPoll, _$PairingPoll];

  @override
  final String wireName = r'PairingPoll';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PairingPoll object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
  }

  @override
  Object serialize(
    Serializers serializers,
    PairingPoll object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(oneOf.value, specifiedType: FullType(oneOf.valueType))!;
  }

  @override
  PairingPoll deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PairingPollBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [FullType(PairingPollOneOf), FullType(PairingPollOneOf), FullType(PairingPollOneOf1), ]);
    oneOfDataSrc = serialized;
    result.oneOf = serializers.deserialize(oneOfDataSrc, specifiedType: targetType) as OneOf;
    return result.build();
  }
}


