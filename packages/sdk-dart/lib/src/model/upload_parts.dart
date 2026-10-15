//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/upload_part.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_parts.g.dart';

/// UploadParts
///
/// Properties:
/// * [parts] 
/// * [expiresAt] 
@BuiltValue()
abstract class UploadParts implements Built<UploadParts, UploadPartsBuilder> {
  @BuiltValueField(wireName: r'parts')
  BuiltList<UploadPart> get parts;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  UploadParts._();

  factory UploadParts([void updates(UploadPartsBuilder b)]) = _$UploadParts;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadPartsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadParts> get serializer => _$UploadPartsSerializer();
}

class _$UploadPartsSerializer implements PrimitiveSerializer<UploadParts> {
  @override
  final Iterable<Type> types = const [UploadParts, _$UploadParts];

  @override
  final String wireName = r'UploadParts';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadParts object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'parts';
    yield serializers.serialize(
      object.parts,
      specifiedType: const FullType(BuiltList, [FullType(UploadPart)]),
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
    UploadParts object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadPartsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'parts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UploadPart)]),
          ) as BuiltList<UploadPart>;
          result.parts.replace(valueDes);
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
  UploadParts deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadPartsBuilder();
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


