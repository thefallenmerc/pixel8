//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_complete_request_parts_inner.g.dart';

/// UploadCompleteRequestPartsInner
///
/// Properties:
/// * [partNumber] 
/// * [etag] 
@BuiltValue()
abstract class UploadCompleteRequestPartsInner implements Built<UploadCompleteRequestPartsInner, UploadCompleteRequestPartsInnerBuilder> {
  @BuiltValueField(wireName: r'partNumber')
  int get partNumber;

  @BuiltValueField(wireName: r'etag')
  String get etag;

  UploadCompleteRequestPartsInner._();

  factory UploadCompleteRequestPartsInner([void updates(UploadCompleteRequestPartsInnerBuilder b)]) = _$UploadCompleteRequestPartsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadCompleteRequestPartsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadCompleteRequestPartsInner> get serializer => _$UploadCompleteRequestPartsInnerSerializer();
}

class _$UploadCompleteRequestPartsInnerSerializer implements PrimitiveSerializer<UploadCompleteRequestPartsInner> {
  @override
  final Iterable<Type> types = const [UploadCompleteRequestPartsInner, _$UploadCompleteRequestPartsInner];

  @override
  final String wireName = r'UploadCompleteRequestPartsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadCompleteRequestPartsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'partNumber';
    yield serializers.serialize(
      object.partNumber,
      specifiedType: const FullType(int),
    );
    yield r'etag';
    yield serializers.serialize(
      object.etag,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UploadCompleteRequestPartsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadCompleteRequestPartsInnerBuilder result,
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
        case r'etag':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.etag = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UploadCompleteRequestPartsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadCompleteRequestPartsInnerBuilder();
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


