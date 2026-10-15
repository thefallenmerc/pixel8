//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pixel8_sdk/src/optional.dart';

part 'screen_patch.g.dart';

/// ScreenPatch
///
/// Properties:
/// * [expectedDesiredVersion] 
/// * [name] 
/// * [campaignId] 
/// * [orientation] 
/// * [muted] 
/// * [volume] 
@BuiltValue()
abstract class ScreenPatch implements Built<ScreenPatch, ScreenPatchBuilder> {
  @BuiltValueField(wireName: r'expectedDesiredVersion')
  int get expectedDesiredVersion;

  @BuiltValueField(wireName: r'name')
  Optional<String?> get name;

  @BuiltValueField(wireName: r'campaignId')
  Optional<String?> get campaignId;

  @BuiltValueField(wireName: r'orientation')
  Optional<ScreenPatchOrientationEnum?> get orientation;
  // enum orientationEnum {  0,  90,  180,  270,  };

  @BuiltValueField(wireName: r'muted')
  Optional<bool?> get muted;

  @BuiltValueField(wireName: r'volume')
  Optional<int?> get volume;

  ScreenPatch._();

  factory ScreenPatch([void updates(ScreenPatchBuilder b)]) = _$ScreenPatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScreenPatchBuilder b) => b
      ..name = Optional.absent()
      ..campaignId = Optional.absent()
      ..orientation = Optional.absent()
      ..muted = Optional.absent()
      ..volume = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<ScreenPatch> get serializer => _$ScreenPatchSerializer();
}

class _$ScreenPatchSerializer implements PrimitiveSerializer<ScreenPatch> {
  @override
  final Iterable<Type> types = const [ScreenPatch, _$ScreenPatch];

  @override
  final String wireName = r'ScreenPatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ScreenPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'expectedDesiredVersion';
    yield serializers.serialize(
      object.expectedDesiredVersion,
      specifiedType: const FullType(int),
    );
    if (object.name.isPresent) {
      yield r'name';
      final optionalValue = object.name.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    if (object.campaignId.isPresent) {
      yield r'campaignId';
      final optionalValue = object.campaignId.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
    if (object.orientation.isPresent) {
      yield r'orientation';
      final optionalValue = object.orientation.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(int),
        );
      }
    }
    if (object.muted.isPresent) {
      yield r'muted';
      final optionalValue = object.muted.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(bool),
        );
      }
    }
    if (object.volume.isPresent) {
      yield r'volume';
      final optionalValue = object.volume.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(int),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ScreenPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScreenPatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'expectedDesiredVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expectedDesiredVersion = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          result.name = Optional.present(valueDes);
          break;
        case r'campaignId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          result.campaignId = Optional.present(valueDes);
          break;
        case r'orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ScreenPatchOrientationEnum),
          ) as ScreenPatchOrientationEnum?;
          result.orientation = Optional.present(valueDes);
          break;
        case r'muted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          result.muted = Optional.present(valueDes);
          break;
        case r'volume':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          result.volume = Optional.present(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ScreenPatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScreenPatchBuilder();
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


class ScreenPatchOrientationEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const ScreenPatchOrientationEnum number0 = _$screenPatchOrientationEnum_number0;
  @BuiltValueEnumConst(wireNumber: 90)
  static const ScreenPatchOrientationEnum number90 = _$screenPatchOrientationEnum_number90;
  @BuiltValueEnumConst(wireNumber: 180)
  static const ScreenPatchOrientationEnum number180 = _$screenPatchOrientationEnum_number180;
  @BuiltValueEnumConst(wireNumber: 270)
  static const ScreenPatchOrientationEnum number270 = _$screenPatchOrientationEnum_number270;

  static Serializer<ScreenPatchOrientationEnum> get serializer => _$screenPatchOrientationEnumSerializer;

  const ScreenPatchOrientationEnum._(String name): super(name);

  static BuiltSet<ScreenPatchOrientationEnum> get values => _$screenPatchOrientationEnumValues;
  static ScreenPatchOrientationEnum valueOf(String name) => _$screenPatchOrientationEnumValueOf(name);
}

