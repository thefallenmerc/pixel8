//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'screen_pair_request.g.dart';

/// ScreenPairRequest
///
/// Properties:
/// * [code] 
/// * [name] 
@BuiltValue()
abstract class ScreenPairRequest implements Built<ScreenPairRequest, ScreenPairRequestBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  ScreenPairRequest._();

  factory ScreenPairRequest([void updates(ScreenPairRequestBuilder b)]) = _$ScreenPairRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScreenPairRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ScreenPairRequest> get serializer => _$ScreenPairRequestSerializer();
}

class _$ScreenPairRequestSerializer implements PrimitiveSerializer<ScreenPairRequest> {
  @override
  final Iterable<Type> types = const [ScreenPairRequest, _$ScreenPairRequest];

  @override
  final String wireName = r'ScreenPairRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScreenPairRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ScreenPairRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScreenPairRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScreenPairRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScreenPairRequestBuilder();
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


