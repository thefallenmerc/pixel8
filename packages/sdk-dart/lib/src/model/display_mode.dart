//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'display_mode.g.dart';

/// DisplayMode
///
/// Properties:
/// * [width] 
/// * [height] 
/// * [refreshHz] 
@BuiltValue()
abstract class DisplayMode implements Built<DisplayMode, DisplayModeBuilder> {
  @BuiltValueField(wireName: r'width')
  int get width;

  @BuiltValueField(wireName: r'height')
  int get height;

  @BuiltValueField(wireName: r'refreshHz')
  num get refreshHz;

  DisplayMode._();

  factory DisplayMode([void updates(DisplayModeBuilder b)]) = _$DisplayMode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(DisplayModeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<DisplayMode> get serializer => _$DisplayModeSerializer();
}

class _$DisplayModeSerializer implements PrimitiveSerializer<DisplayMode> {
  @override
  final Iterable<Type> types = const [DisplayMode, _$DisplayMode];

  @override
  final String wireName = r'DisplayMode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    DisplayMode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'width';
    yield serializers.serialize(
      object.width,
      specifiedType: const FullType(int),
    );
    yield r'height';
    yield serializers.serialize(
      object.height,
      specifiedType: const FullType(int),
    );
    yield r'refreshHz';
    yield serializers.serialize(
      object.refreshHz,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    DisplayMode object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required DisplayModeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'width':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.width = valueDes;
          break;
        case r'height':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.height = valueDes;
          break;
        case r'refreshHz':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.refreshHz = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  DisplayMode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DisplayModeBuilder();
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


