//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'asset.g.dart';

/// Asset
///
/// Properties:
/// * [id] 
/// * [appId] 
/// * [name] 
/// * [mimeType] 
/// * [sizeBytes] 
/// * [status] 
/// * [thumbnailUrl] 
/// * [error] 
@BuiltValue()
abstract class Asset implements Built<Asset, AssetBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'appId')
  String get appId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'mimeType')
  String get mimeType;

  @BuiltValueField(wireName: r'sizeBytes')
  int get sizeBytes;

  @BuiltValueField(wireName: r'status')
  AssetStatusEnum get status;
  // enum statusEnum {  uploading,  processing,  ready,  failed,  };

  @BuiltValueField(wireName: r'thumbnailUrl')
  String? get thumbnailUrl;

  @BuiltValueField(wireName: r'error')
  String? get error;

  Asset._();

  factory Asset([void updates(AssetBuilder b)]) = _$Asset;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AssetBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Asset> get serializer => _$AssetSerializer();
}

class _$AssetSerializer implements PrimitiveSerializer<Asset> {
  @override
  final Iterable<Type> types = const [Asset, _$Asset];

  @override
  final String wireName = r'Asset';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Asset object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'appId';
    yield serializers.serialize(
      object.appId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'mimeType';
    yield serializers.serialize(
      object.mimeType,
      specifiedType: const FullType(String),
    );
    yield r'sizeBytes';
    yield serializers.serialize(
      object.sizeBytes,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AssetStatusEnum),
    );
    if (object.thumbnailUrl != null) {
      yield r'thumbnailUrl';
      yield serializers.serialize(
        object.thumbnailUrl,
        specifiedType: const FullType(String),
      );
    }
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Asset object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AssetBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'appId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.appId = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'mimeType':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mimeType = valueDes;
          break;
        case r'sizeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.sizeBytes = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AssetStatusEnum),
          ) as AssetStatusEnum;
          result.status = valueDes;
          break;
        case r'thumbnailUrl':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.thumbnailUrl = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Asset deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AssetBuilder();
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


class AssetStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'uploading')
  static const AssetStatusEnum uploading = _$assetStatusEnum_uploading;
  @BuiltValueEnumConst(wireName: r'processing')
  static const AssetStatusEnum processing = _$assetStatusEnum_processing;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AssetStatusEnum ready = _$assetStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AssetStatusEnum failed = _$assetStatusEnum_failed;

  static Serializer<AssetStatusEnum> get serializer => _$assetStatusEnumSerializer;

  const AssetStatusEnum._(String name): super(name);

  static BuiltSet<AssetStatusEnum> get values => _$assetStatusEnumValues;
  static AssetStatusEnum valueOf(String name) => _$assetStatusEnumValueOf(name);
}

