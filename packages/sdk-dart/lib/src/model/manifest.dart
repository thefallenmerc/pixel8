//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/manifest_item.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'manifest.g.dart';

/// Manifest
///
/// Properties:
/// * [schemaVersion] 
/// * [screenId] 
/// * [version] 
/// * [profile] 
/// * [orientation] 
/// * [muted] 
/// * [volume] 
/// * [items] 
@BuiltValue()
abstract class Manifest implements Built<Manifest, ManifestBuilder> {
  @BuiltValueField(wireName: r'schemaVersion')
  ManifestSchemaVersionEnum get schemaVersion;
  // enum schemaVersionEnum {  1,  };

  @BuiltValueField(wireName: r'screenId')
  String get screenId;

  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'profile')
  ManifestProfileEnum get profile;
  // enum profileEnum {  720p30-v1,  1080p30-v1,  };

  @BuiltValueField(wireName: r'orientation')
  int get orientation;

  @BuiltValueField(wireName: r'muted')
  bool get muted;

  @BuiltValueField(wireName: r'volume')
  int get volume;

  @BuiltValueField(wireName: r'items')
  BuiltList<ManifestItem> get items;

  Manifest._();

  factory Manifest([void updates(ManifestBuilder b)]) = _$Manifest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ManifestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Manifest> get serializer => _$ManifestSerializer();
}

class _$ManifestSerializer implements PrimitiveSerializer<Manifest> {
  @override
  final Iterable<Type> types = const [Manifest, _$Manifest];

  @override
  final String wireName = r'Manifest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Manifest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'schemaVersion';
    yield serializers.serialize(
      object.schemaVersion,
      specifiedType: const FullType(ManifestSchemaVersionEnum),
    );
    yield r'screenId';
    yield serializers.serialize(
      object.screenId,
      specifiedType: const FullType(String),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'profile';
    yield serializers.serialize(
      object.profile,
      specifiedType: const FullType(ManifestProfileEnum),
    );
    yield r'orientation';
    yield serializers.serialize(
      object.orientation,
      specifiedType: const FullType(int),
    );
    yield r'muted';
    yield serializers.serialize(
      object.muted,
      specifiedType: const FullType(bool),
    );
    yield r'volume';
    yield serializers.serialize(
      object.volume,
      specifiedType: const FullType(int),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [FullType(ManifestItem)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Manifest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ManifestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'schemaVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManifestSchemaVersionEnum),
          ) as ManifestSchemaVersionEnum;
          result.schemaVersion = valueDes;
          break;
        case r'screenId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.screenId = valueDes;
          break;
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'profile':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ManifestProfileEnum),
          ) as ManifestProfileEnum;
          result.profile = valueDes;
          break;
        case r'orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.orientation = valueDes;
          break;
        case r'muted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.muted = valueDes;
          break;
        case r'volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.volume = valueDes;
          break;
        case r'items':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(ManifestItem)]),
          ) as BuiltList<ManifestItem>;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Manifest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ManifestBuilder();
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


class ManifestSchemaVersionEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 1)
  static const ManifestSchemaVersionEnum number1 = _$manifestSchemaVersionEnum_number1;

  static Serializer<ManifestSchemaVersionEnum> get serializer => _$manifestSchemaVersionEnumSerializer;

  const ManifestSchemaVersionEnum._(String name): super(name);

  static BuiltSet<ManifestSchemaVersionEnum> get values => _$manifestSchemaVersionEnumValues;
  static ManifestSchemaVersionEnum valueOf(String name) => _$manifestSchemaVersionEnumValueOf(name);
}

class ManifestProfileEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'720p30-v1')
  static const ManifestProfileEnum n720p30V1 = _$manifestProfileEnum_n720p30V1;
  @BuiltValueEnumConst(wireName: r'1080p30-v1')
  static const ManifestProfileEnum n1080p30V1 = _$manifestProfileEnum_n1080p30V1;

  static Serializer<ManifestProfileEnum> get serializer => _$manifestProfileEnumSerializer;

  const ManifestProfileEnum._(String name): super(name);

  static BuiltSet<ManifestProfileEnum> get values => _$manifestProfileEnumValues;
  static ManifestProfileEnum valueOf(String name) => _$manifestProfileEnumValueOf(name);
}

