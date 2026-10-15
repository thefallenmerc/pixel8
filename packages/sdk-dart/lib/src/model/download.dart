//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'download.g.dart';

/// Download
///
/// Properties:
/// * [renditionId] 
/// * [url] 
/// * [expiresAt] 
@BuiltValue()
abstract class Download implements Built<Download, DownloadBuilder> {
  @BuiltValueField(wireName: r'renditionId')
  String get renditionId;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  Download._();

  factory Download([void updates(DownloadBuilder b)]) = _$Download;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Download> get serializer => _$DownloadSerializer();
}

class _$DownloadSerializer implements PrimitiveSerializer<Download> {
  @override
  final Iterable<Type> types = const [Download, _$Download];

  @override
  final String wireName = r'Download';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Download object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'renditionId';
    yield serializers.serialize(
      object.renditionId,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
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
    Download object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'renditionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.renditionId = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
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
  Download deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadBuilder();
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


