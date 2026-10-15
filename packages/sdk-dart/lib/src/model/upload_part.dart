//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_part.g.dart';

/// UploadPart
///
/// Properties:
/// * [partNumber] 
/// * [url] 
@BuiltValue()
abstract class UploadPart implements Built<UploadPart, UploadPartBuilder> {
  @BuiltValueField(wireName: r'partNumber')
  int get partNumber;

  @BuiltValueField(wireName: r'url')
  String get url;

  UploadPart._();

  factory UploadPart([void updates(UploadPartBuilder b)]) = _$UploadPart;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadPartBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadPart> get serializer => _$UploadPartSerializer();
}

class _$UploadPartSerializer implements PrimitiveSerializer<UploadPart> {
  @override
  final Iterable<Type> types = const [UploadPart, _$UploadPart];

  @override
  final String wireName = r'UploadPart';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadPart object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'partNumber';
    yield serializers.serialize(
      object.partNumber,
      specifiedType: const FullType(int),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UploadPart object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadPartBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'partNumber':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.partNumber = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UploadPart deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadPartBuilder();
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


