//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'downloads_request.g.dart';

/// DownloadsRequest
///
/// Properties:
/// * [renditionIds] 
@BuiltValue()
abstract class DownloadsRequest implements Built<DownloadsRequest, DownloadsRequestBuilder> {
  @BuiltValueField(wireName: r'renditionIds')
  BuiltList<String> get renditionIds;

  DownloadsRequest._();

  factory DownloadsRequest([void updates(DownloadsRequestBuilder b)]) = _$DownloadsRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadsRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DownloadsRequest> get serializer => _$DownloadsRequestSerializer();
}

class _$DownloadsRequestSerializer implements PrimitiveSerializer<DownloadsRequest> {
  @override
  final Iterable<Type> types = const [DownloadsRequest, _$DownloadsRequest];

  @override
  final String wireName = r'DownloadsRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DownloadsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'renditionIds';
    yield serializers.serialize(
      object.renditionIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DownloadsRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadsRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'renditionIds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.renditionIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DownloadsRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadsRequestBuilder();
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


