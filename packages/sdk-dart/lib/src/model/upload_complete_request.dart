//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/upload_complete_request_parts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_complete_request.g.dart';

/// UploadCompleteRequest
///
/// Properties:
/// * [parts] 
@BuiltValue()
abstract class UploadCompleteRequest implements Built<UploadCompleteRequest, UploadCompleteRequestBuilder> {
  @BuiltValueField(wireName: r'parts')
  BuiltList<UploadCompleteRequestPartsInner> get parts;

  UploadCompleteRequest._();

  factory UploadCompleteRequest([void updates(UploadCompleteRequestBuilder b)]) = _$UploadCompleteRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadCompleteRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadCompleteRequest> get serializer => _$UploadCompleteRequestSerializer();
}

class _$UploadCompleteRequestSerializer implements PrimitiveSerializer<UploadCompleteRequest> {
  @override
  final Iterable<Type> types = const [UploadCompleteRequest, _$UploadCompleteRequest];

  @override
  final String wireName = r'UploadCompleteRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadCompleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'parts';
    yield serializers.serialize(
      object.parts,
      specifiedType: const FullType(BuiltList, [FullType(UploadCompleteRequestPartsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UploadCompleteRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadCompleteRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'parts':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(UploadCompleteRequestPartsInner)]),
          ) as BuiltList<UploadCompleteRequestPartsInner>;
          result.parts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UploadCompleteRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadCompleteRequestBuilder();
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


