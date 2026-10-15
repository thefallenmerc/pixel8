//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:pixel8_sdk/src/model/capabilities.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'screen.g.dart';

/// Screen
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [campaignId] 
/// * [orientation] 
/// * [muted] 
/// * [volume] 
/// * [desiredVersion] 
/// * [playingVersion] 
/// * [status] 
/// * [lastSeenAt] 
/// * [error] 
/// * [capabilities] 
@BuiltValue()
abstract class Screen implements Built<Screen, ScreenBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'campaignId')
  String? get campaignId;

  @BuiltValueField(wireName: r'orientation')
  ScreenOrientationEnum get orientation;
  // enum orientationEnum {  0,  90,  180,  270,  };

  @BuiltValueField(wireName: r'muted')
  bool get muted;

  @BuiltValueField(wireName: r'volume')
  int get volume;

  @BuiltValueField(wireName: r'desiredVersion')
  int get desiredVersion;

  @BuiltValueField(wireName: r'playingVersion')
  int? get playingVersion;

  @BuiltValueField(wireName: r'status')
  ScreenStatusEnum get status;
  // enum statusEnum {  offline,  preparing,  ready,  downloading,  playing,  error,  };

  @BuiltValueField(wireName: r'lastSeenAt')
  DateTime? get lastSeenAt;

  @BuiltValueField(wireName: r'error')
  String? get error;

  @BuiltValueField(wireName: r'capabilities')
  Capabilities? get capabilities;

  Screen._();

  factory Screen([void updates(ScreenBuilder b)]) = _$Screen;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ScreenBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Screen> get serializer => _$ScreenSerializer();
}

class _$ScreenSerializer implements PrimitiveSerializer<Screen> {
  @override
  final Iterable<Type> types = const [Screen, _$Screen];

  @override
  final String wireName = r'Screen';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Screen object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'campaignId';
    yield object.campaignId == null ? null : serializers.serialize(
      object.campaignId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'orientation';
    yield serializers.serialize(
      object.orientation,
      specifiedType: const FullType(ScreenOrientationEnum),
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
    yield r'desiredVersion';
    yield serializers.serialize(
      object.desiredVersion,
      specifiedType: const FullType(int),
    );
    yield r'playingVersion';
    yield object.playingVersion == null ? null : serializers.serialize(
      object.playingVersion,
      specifiedType: const FullType.nullable(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(ScreenStatusEnum),
    );
    if (object.lastSeenAt != null) {
      yield r'lastSeenAt';
      yield serializers.serialize(
        object.lastSeenAt,
        specifiedType: const FullType(DateTime),
      );
    }
    if (object.error != null) {
      yield r'error';
      yield serializers.serialize(
        object.error,
        specifiedType: const FullType(String),
      );
    }
    if (object.capabilities != null) {
      yield r'capabilities';
      yield serializers.serialize(
        object.capabilities,
        specifiedType: const FullType(Capabilities),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Screen object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ScreenBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'campaignId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.campaignId = valueDes;
          break;
        case r'orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScreenOrientationEnum),
          ) as ScreenOrientationEnum;
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
        case r'desiredVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.desiredVersion = valueDes;
          break;
        case r'playingVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.playingVersion = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ScreenStatusEnum),
          ) as ScreenStatusEnum;
          result.status = valueDes;
          break;
        case r'lastSeenAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.lastSeenAt = valueDes;
          break;
        case r'error':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.error = valueDes;
          break;
        case r'capabilities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(Capabilities),
          ) as Capabilities?;
          if (valueDes == null) continue;
          result.capabilities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Screen deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ScreenBuilder();
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


class ScreenOrientationEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 0)
  static const ScreenOrientationEnum number0 = _$screenOrientationEnum_number0;
  @BuiltValueEnumConst(wireNumber: 90)
  static const ScreenOrientationEnum number90 = _$screenOrientationEnum_number90;
  @BuiltValueEnumConst(wireNumber: 180)
  static const ScreenOrientationEnum number180 = _$screenOrientationEnum_number180;
  @BuiltValueEnumConst(wireNumber: 270)
  static const ScreenOrientationEnum number270 = _$screenOrientationEnum_number270;

  static Serializer<ScreenOrientationEnum> get serializer => _$screenOrientationEnumSerializer;

  const ScreenOrientationEnum._(String name): super(name);

  static BuiltSet<ScreenOrientationEnum> get values => _$screenOrientationEnumValues;
  static ScreenOrientationEnum valueOf(String name) => _$screenOrientationEnumValueOf(name);
}

class ScreenStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'offline')
  static const ScreenStatusEnum offline = _$screenStatusEnum_offline;
  @BuiltValueEnumConst(wireName: r'preparing')
  static const ScreenStatusEnum preparing = _$screenStatusEnum_preparing;
  @BuiltValueEnumConst(wireName: r'ready')
  static const ScreenStatusEnum ready = _$screenStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'downloading')
  static const ScreenStatusEnum downloading = _$screenStatusEnum_downloading;
  @BuiltValueEnumConst(wireName: r'playing')
  static const ScreenStatusEnum playing = _$screenStatusEnum_playing;
  @BuiltValueEnumConst(wireName: r'error')
  static const ScreenStatusEnum error = _$screenStatusEnum_error;

  static Serializer<ScreenStatusEnum> get serializer => _$screenStatusEnumSerializer;

  const ScreenStatusEnum._(String name): super(name);

  static BuiltSet<ScreenStatusEnum> get values => _$screenStatusEnumValues;
  static ScreenStatusEnum valueOf(String name) => _$screenStatusEnumValueOf(name);
}

