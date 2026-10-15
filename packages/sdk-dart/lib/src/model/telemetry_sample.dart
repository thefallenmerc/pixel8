//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:pixel8_sdk/src/model/display_mode.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'telemetry_sample.g.dart';

/// TelemetrySample
///
/// Properties:
/// * [sampledAt] 
/// * [cpuPercent] 
/// * [memoryUsedBytes] 
/// * [memoryTotalBytes] 
/// * [temperatureC] 
/// * [throttled] 
/// * [diskFreeBytes] 
/// * [cacheBytes] 
/// * [currentItemId] 
/// * [desiredVersion] 
/// * [playingVersion] 
/// * [droppedFrames] 
/// * [softwareVersion] 
/// * [displayMode] 
/// * [decoder] 
/// * [error] 
@BuiltValue()
abstract class TelemetrySample implements Built<TelemetrySample, TelemetrySampleBuilder> {
  @BuiltValueField(wireName: r'sampledAt')
  DateTime get sampledAt;

  @BuiltValueField(wireName: r'cpuPercent')
  num get cpuPercent;

  @BuiltValueField(wireName: r'memoryUsedBytes')
  int get memoryUsedBytes;

  @BuiltValueField(wireName: r'memoryTotalBytes')
  int get memoryTotalBytes;

  @BuiltValueField(wireName: r'temperatureC')
  num? get temperatureC;

  @BuiltValueField(wireName: r'throttled')
  bool get throttled;

  @BuiltValueField(wireName: r'diskFreeBytes')
  int get diskFreeBytes;

  @BuiltValueField(wireName: r'cacheBytes')
  int get cacheBytes;

  @BuiltValueField(wireName: r'currentItemId')
  String? get currentItemId;

  @BuiltValueField(wireName: r'desiredVersion')
  int get desiredVersion;

  @BuiltValueField(wireName: r'playingVersion')
  int? get playingVersion;

  @BuiltValueField(wireName: r'droppedFrames')
  int get droppedFrames;

  @BuiltValueField(wireName: r'softwareVersion')
  String get softwareVersion;

  @BuiltValueField(wireName: r'displayMode')
  DisplayMode get displayMode;

  @BuiltValueField(wireName: r'decoder')
  String get decoder;

  @BuiltValueField(wireName: r'error')
  String? get error;

  TelemetrySample._();

  factory TelemetrySample([void updates(TelemetrySampleBuilder b)]) = _$TelemetrySample;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TelemetrySampleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TelemetrySample> get serializer => _$TelemetrySampleSerializer();
}

class _$TelemetrySampleSerializer implements PrimitiveSerializer<TelemetrySample> {
  @override
  final Iterable<Type> types = const [TelemetrySample, _$TelemetrySample];

  @override
  final String wireName = r'TelemetrySample';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TelemetrySample object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sampledAt';
    yield serializers.serialize(
      object.sampledAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'cpuPercent';
    yield serializers.serialize(
      object.cpuPercent,
      specifiedType: const FullType(num),
    );
    yield r'memoryUsedBytes';
    yield serializers.serialize(
      object.memoryUsedBytes,
      specifiedType: const FullType(int),
    );
    yield r'memoryTotalBytes';
    yield serializers.serialize(
      object.memoryTotalBytes,
      specifiedType: const FullType(int),
    );
    if (object.temperatureC != null) {
      yield r'temperatureC';
      yield serializers.serialize(
        object.temperatureC,
        specifiedType: const FullType(num),
      );
    }
    yield r'throttled';
    yield serializers.serialize(
      object.throttled,
      specifiedType: const FullType(bool),
    );
    yield r'diskFreeBytes';
    yield serializers.serialize(
      object.diskFreeBytes,
      specifiedType: const FullType(int),
    );
    yield r'cacheBytes';
    yield serializers.serialize(
      object.cacheBytes,
      specifiedType: const FullType(int),
    );
    if (object.currentItemId != null) {
      yield r'currentItemId';
      yield serializers.serialize(
        object.currentItemId,
        specifiedType: const FullType(String),
      );
    }
    yield r'desiredVersion';
    yield serializers.serialize(
      object.desiredVersion,
      specifiedType: const FullType(int),
    );
    if (object.playingVersion != null) {
      yield r'playingVersion';
      yield serializers.serialize(
        object.playingVersion,
        specifiedType: const FullType(int),
      );
    }
    yield r'droppedFrames';
    yield serializers.serialize(
      object.droppedFrames,
      specifiedType: const FullType(int),
    );
    yield r'softwareVersion';
    yield serializers.serialize(
      object.softwareVersion,
      specifiedType: const FullType(String),
    );
    yield r'displayMode';
    yield serializers.serialize(
      object.displayMode,
      specifiedType: const FullType(DisplayMode),
    );
    yield r'decoder';
    yield serializers.serialize(
      object.decoder,
      specifiedType: const FullType(String),
    );
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
    TelemetrySample object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TelemetrySampleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sampledAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.sampledAt = valueDes;
          break;
        case r'cpuPercent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.cpuPercent = valueDes;
          break;
        case r'memoryUsedBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memoryUsedBytes = valueDes;
          break;
        case r'memoryTotalBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.memoryTotalBytes = valueDes;
          break;
        case r'temperatureC':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(num),
          ) as num?;
          if (valueDes == null) continue;
          result.temperatureC = valueDes;
          break;
        case r'throttled':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.throttled = valueDes;
          break;
        case r'diskFreeBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.diskFreeBytes = valueDes;
          break;
        case r'cacheBytes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.cacheBytes = valueDes;
          break;
        case r'currentItemId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.currentItemId = valueDes;
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
        case r'droppedFrames':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.droppedFrames = valueDes;
          break;
        case r'softwareVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.softwareVersion = valueDes;
          break;
        case r'displayMode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DisplayMode),
          ) as DisplayMode;
          result.displayMode.replace(valueDes);
          break;
        case r'decoder':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.decoder = valueDes;
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
  TelemetrySample deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TelemetrySampleBuilder();
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


