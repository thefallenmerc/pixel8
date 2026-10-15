import 'package:built_value/serializer.dart';
import 'package:test/test.dart';
import 'package:pixel8_sdk/pixel8_sdk.dart';

// tests for ScreenPatch
void main() {
  test('campaignId distinguishes omitted from explicit null', () {
    final omitted = ScreenPatch(
      (builder) => builder.expectedDesiredVersion = 2,
    );
    final unassigned = ScreenPatch(
      (builder) => builder
        ..expectedDesiredVersion = 2
        ..campaignId = const Optional.present(null),
    );
    final assigned = ScreenPatch(
      (builder) => builder
        ..expectedDesiredVersion = 2
        ..campaignId = const Optional.present('campaign-id'),
    );

    Map<String, dynamic> body(ScreenPatch patch) =>
        standardSerializers.serialize(
              patch,
              specifiedType: const FullType(ScreenPatch),
            )!
            as Map<String, dynamic>;

    expect(body(omitted).containsKey('campaignId'), isFalse);
    expect(body(unassigned).containsKey('campaignId'), isTrue);
    expect(body(unassigned)['campaignId'], isNull);
    expect(body(assigned)['campaignId'], 'campaign-id');
  });
}
