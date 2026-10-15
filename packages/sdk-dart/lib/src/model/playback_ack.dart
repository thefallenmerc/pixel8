//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pixel8_sdk/src/optional.dart';

part 'playback_ack.g.dart';

/// PlaybackAck
///
/// Properties:
/// * [version] 
/// * [status] - idle is valid only when the acknowledged manifest has no items; playing is valid only when it has items.
/// * [currentItemId] 
/// * [playingVersion] - For error acknowledgements, the manifest version still playing, or null if playback stopped. If omitted, existing playback state is left unchanged.
/// * [error] 
@BuiltValue()
abstract class PlaybackAck implements Built<PlaybackAck, PlaybackAckBuilder> {
  @BuiltValueField(wireName: r'version')
  int get version;

  /// idle is valid only when the acknowledged manifest has no items; playing is valid only when it has items.
  @BuiltValueField(wireName: r'status')
  PlaybackAckStatusEnum get status;
  // enum statusEnum {  downloading,  playing,  idle,  error,  };

  @BuiltValueField(wireName: r'currentItemId')
  String? get currentItemId;

  /// For error acknowledgements, the manifest version still playing, or null if playback stopped. If omitted, existing playback state is left unchanged.
  @BuiltValueField(wireName: r'playingVersion')
  Optional<int?> get playingVersion;

  @BuiltValueField(wireName: r'error')
  String? get error;

  PlaybackAck._();

  factory PlaybackAck([void updates(PlaybackAckBuilder b)]) = _$PlaybackAck;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PlaybackAckBuilder b) => b
      ..playingVersion = Optional.absent();

  @BuiltValueSerializer(custom: true)
  static Serializer<PlaybackAck> get serializer => _$PlaybackAckSerializer();
}

class _$PlaybackAckSerializer implements PrimitiveSerializer<PlaybackAck> {
  @override
  final Iterable<Type> types = const [PlaybackAck, _$PlaybackAck];

  @override
  final String wireName = r'PlaybackAck';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PlaybackAck object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(PlaybackAckStatusEnum),
    );
    if (object.currentItemId != null) {
      yield r'currentItemId';
      yield serializers.serialize(
        object.currentItemId,
        specifiedType: const FullType(String),
      );
    }
    if (object.playingVersion.isPresent) {
      yield r'playingVersion';
      final optionalValue = object.playingVersion.value;
      if (optionalValue == null) {
        yield null;
      } else {
        yield serializers.serialize(
          optionalValue,
          specifiedType: const FullType.nullable(int),
        );
      }
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
    PlaybackAck object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PlaybackAckBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.version = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PlaybackAckStatusEnum),
          ) as PlaybackAckStatusEnum;
          result.status = valueDes;
          break;
        case r'currentItemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentItemId = valueDes;
          break;
        case r'playingVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          result.playingVersion = Optional.present(valueDes);
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
  PlaybackAck deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PlaybackAckBuilder();
    final serializedList = serialized is Map
        ? serialized.entries.expand((entry) => [entry.key, entry.value]).toList()
        : (serialized as Iterable<Object?>).toList();
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


/// idle is valid only when the acknowledged manifest has no items; playing is valid only when it has items.
class PlaybackAckStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'downloading')
  static const PlaybackAckStatusEnum downloading = _$playbackAckStatusEnum_downloading;
  @BuiltValueEnumConst(wireName: r'playing')
  static const PlaybackAckStatusEnum playing = _$playbackAckStatusEnum_playing;
  @BuiltValueEnumConst(wireName: r'idle')
  static const PlaybackAckStatusEnum idle = _$playbackAckStatusEnum_idle;
  @BuiltValueEnumConst(wireName: r'error')
  static const PlaybackAckStatusEnum error = _$playbackAckStatusEnum_error;

  static Serializer<PlaybackAckStatusEnum> get serializer => _$playbackAckStatusEnumSerializer;

  const PlaybackAckStatusEnum._(String name): super(name);

  static BuiltSet<PlaybackAckStatusEnum> get values => _$playbackAckStatusEnumValues;
  static PlaybackAckStatusEnum valueOf(String name) => _$playbackAckStatusEnumValueOf(name);
}

