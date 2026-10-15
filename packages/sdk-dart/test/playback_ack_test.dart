import 'package:built_value/serializer.dart';
import 'package:pixel8_sdk/pixel8_sdk.dart';
import 'package:test/test.dart';

void main() {
  test('playingVersion preserves omitted, null, and actual playback versions', () {
    final omitted = PlaybackAck((builder) => builder
      ..version = 8
      ..status = PlaybackAckStatusEnum.error);
    final stopped = PlaybackAck((builder) => builder
      ..version = 8
      ..status = PlaybackAckStatusEnum.error
      ..playingVersion = const Optional.present(null));
    final fallback = PlaybackAck((builder) => builder
      ..version = 8
      ..status = PlaybackAckStatusEnum.error
      ..playingVersion = const Optional.present(7));

    Map<String, dynamic> body(PlaybackAck ack) =>
        standardSerializers.serialize(
              ack,
              specifiedType: const FullType(PlaybackAck),
            )!
            as Map<String, dynamic>;

    expect(body(omitted).containsKey('playingVersion'), isFalse);
    expect(body(stopped).containsKey('playingVersion'), isTrue);
    expect(body(stopped)['playingVersion'], isNull);
    expect(body(fallback)['playingVersion'], 7);

    final wire = standardSerializers.serialize(
      stopped,
      specifiedType: const FullType(PlaybackAck),
    )!;
    final decoded = (PlaybackAck.serializer as PrimitiveSerializer<PlaybackAck>)
        .deserialize(
      standardSerializers,
      wire,
      specifiedType: const FullType(PlaybackAck),
    );
    expect(decoded.playingVersion, const Optional<int?>.present(null));
  });
}
