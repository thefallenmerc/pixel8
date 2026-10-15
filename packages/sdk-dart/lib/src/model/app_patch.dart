//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pixel8_sdk/src/optional.dart';

part 'app_patch.g.dart';

/// AppPatch
///
/// Properties:
/// * [name] 
/// * [description] 
@BuiltValue()
abstract class AppPatch implements Built<AppPatch, AppPatchBuilder> {
  @BuiltValueField(wireName: r'name')
  Optional<String?> get name;

  @BuiltValueField(wireName: r'description')
  Optional<String?> get description;

  AppPatch._();

  factory AppPatch([void updates(AppPatchBuilder b)]) = _$AppPatch;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AppPatchBuilder b) => b
      ..name = Optional.absent()
      ..description = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<AppPatch> get serializer => _$AppPatchSerializer();
}

class _$AppPatchSerializer implements PrimitiveSerializer<AppPatch> {
  @override
  final Iterable<Type> types = const [AppPatch, _$AppPatch];

  @override
  final String wireName = r'AppPatch';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AppPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    if (object.description.isPresent) {
      yield r'description';
      final optionalValue = object.description.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(String),
        );
      }
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AppPatch object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AppPatchBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          result.name = Optional.present(valueDes);
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          result.description = Optional.present(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AppPatch deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppPatchBuilder();
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


