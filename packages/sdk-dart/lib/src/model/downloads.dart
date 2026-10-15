//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/download.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'downloads.g.dart';

/// Downloads
///
/// Properties:
/// * [downloads] 
@BuiltValue()
abstract class Downloads implements Built<Downloads, DownloadsBuilder> {
  @BuiltValueField(wireName: r'downloads')
  BuiltList<Download> get downloads;

  Downloads._();

  factory Downloads([void updates(DownloadsBuilder b)]) = _$Downloads;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DownloadsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Downloads> get serializer => _$DownloadsSerializer();
}

class _$DownloadsSerializer implements PrimitiveSerializer<Downloads> {
  @override
  final Iterable<Type> types = const [Downloads, _$Downloads];

  @override
  final String wireName = r'Downloads';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Downloads object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'downloads';
    yield serializers.serialize(
      object.downloads,
      specifiedType: const FullType(BuiltList, [FullType(Download)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Downloads object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DownloadsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'downloads':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(Download)]),
          ) as BuiltList<Download>;
          result.downloads.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Downloads deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DownloadsBuilder();
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


