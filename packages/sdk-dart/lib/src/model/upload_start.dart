//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/asset.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'upload_start.g.dart';

/// UploadStart
///
/// Properties:
/// * [asset] 
/// * [uploadId] 
/// * [partSizeBytes] 
@BuiltValue()
abstract class UploadStart implements Built<UploadStart, UploadStartBuilder> {
  @BuiltValueField(wireName: r'asset')
  Asset get asset;

  @BuiltValueField(wireName: r'uploadId')
  String get uploadId;

  @BuiltValueField(wireName: r'partSizeBytes')
  int get partSizeBytes;

  UploadStart._();

  factory UploadStart([void updates(UploadStartBuilder b)]) = _$UploadStart;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UploadStartBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UploadStart> get serializer => _$UploadStartSerializer();
}

class _$UploadStartSerializer implements PrimitiveSerializer<UploadStart> {
  @override
  final Iterable<Type> types = const [UploadStart, _$UploadStart];

  @override
  final String wireName = r'UploadStart';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UploadStart object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asset';
    yield serializers.serialize(
      object.asset,
      specifiedType: const FullType(Asset),
    );
    yield r'uploadId';
    yield serializers.serialize(
      object.uploadId,
      specifiedType: const FullType(String),
    );
    yield r'partSizeBytes';
    yield serializers.serialize(
      object.partSizeBytes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UploadStart object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UploadStartBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asset':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Asset),
          ) as Asset;
          result.asset.replace(valueDes);
          break;
        case r'uploadId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.uploadId = valueDes;
          break;
        case r'partSizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.partSizeBytes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UploadStart deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UploadStartBuilder();
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


