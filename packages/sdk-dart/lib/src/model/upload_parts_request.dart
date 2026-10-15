//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_parts_request.g.dart';

/// UploadPartsRequest
///
/// Properties:
/// * [partNumbers] 
@BuiltValue()
abstract class UploadPartsRequest implements Built<UploadPartsRequest, UploadPartsRequestBuilder> {
  @BuiltValueField(wireName: r'partNumbers')
  BuiltList<int> get partNumbers;

  UploadPartsRequest._();

  factory UploadPartsRequest([void updates(UploadPartsRequestBuilder b)]) = _$UploadPartsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadPartsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadPartsRequest> get serializer => _$UploadPartsRequestSerializer();
}

class _$UploadPartsRequestSerializer implements PrimitiveSerializer<UploadPartsRequest> {
  @override
  final Iterable<Type> types = const [UploadPartsRequest, _$UploadPartsRequest];

  @override
  final String wireName = r'UploadPartsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadPartsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'partNumbers';
    yield serializers.serialize(
      object.partNumbers,
      specifiedType: const FullType(BuiltList, [FullType(int)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UploadPartsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadPartsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'partNumbers':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(int)]),
          ) as BuiltList<int>;
          result.partNumbers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UploadPartsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadPartsRequestBuilder();
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


