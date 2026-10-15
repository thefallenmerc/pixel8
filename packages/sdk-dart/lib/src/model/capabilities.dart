//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/display_mode.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'capabilities.g.dart';

/// Capabilities
///
/// Properties:
/// * [displayModes] 
/// * [selectedMode] 
/// * [decoders] 
/// * [supports1080p] 
/// * [softwareVersion] 
@BuiltValue()
abstract class Capabilities implements Built<Capabilities, CapabilitiesBuilder> {
  @BuiltValueField(wireName: r'displayModes')
  BuiltList<DisplayMode> get displayModes;

  @BuiltValueField(wireName: r'selectedMode')
  DisplayMode get selectedMode;

  @BuiltValueField(wireName: r'decoders')
  BuiltList<String> get decoders;

  @BuiltValueField(wireName: r'supports1080p')
  bool get supports1080p;

  @BuiltValueField(wireName: r'softwareVersion')
  String get softwareVersion;

  Capabilities._();

  factory Capabilities([void updates(CapabilitiesBuilder b)]) = _$Capabilities;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CapabilitiesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Capabilities> get serializer => _$CapabilitiesSerializer();
}

class _$CapabilitiesSerializer implements PrimitiveSerializer<Capabilities> {
  @override
  final Iterable<Type> types = const [Capabilities, _$Capabilities];

  @override
  final String wireName = r'Capabilities';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Capabilities object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'displayModes';
    yield serializers.serialize(
      object.displayModes,
      specifiedType: const FullType(BuiltList, [FullType(DisplayMode)]),
    );
    yield r'selectedMode';
    yield serializers.serialize(
      object.selectedMode,
      specifiedType: const FullType(DisplayMode),
    );
    yield r'decoders';
    yield serializers.serialize(
      object.decoders,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'supports1080p';
    yield serializers.serialize(
      object.supports1080p,
      specifiedType: const FullType(bool),
    );
    yield r'softwareVersion';
    yield serializers.serialize(
      object.softwareVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    Capabilities object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CapabilitiesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'displayModes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(DisplayMode)]),
          ) as BuiltList<DisplayMode>;
          result.displayModes.replace(valueDes);
          break;
        case r'selectedMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisplayMode),
          ) as DisplayMode;
          result.selectedMode.replace(valueDes);
          break;
        case r'decoders':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.decoders.replace(valueDes);
          break;
        case r'supports1080p':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.supports1080p = valueDes;
          break;
        case r'softwareVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.softwareVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Capabilities deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CapabilitiesBuilder();
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


