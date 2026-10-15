import { readFile, writeFile } from "node:fs/promises";

const modelPath = new URL(
  "../packages/sdk-dart/lib/src/model/screen_patch.dart",
  import.meta.url,
);
const source = await readFile(modelPath, "utf8");
const generated = `        case r'orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          result.orientation = Optional.present(valueDes);`;
const corrected = `        case r'orientation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ScreenPatchOrientationEnum),
          ) as ScreenPatchOrientationEnum?;
          result.orientation = Optional.present(valueDes);`;
if (source.includes(generated)) {
  await writeFile(modelPath, source.replace(generated, corrected));
} else if (!source.includes(corrected)) {
  throw new Error("Could not locate generated ScreenPatch orientation decoder");
}

await writeFile(
  new URL("../packages/sdk-dart/analysis_options.yaml", import.meta.url),
  `analyzer:\n  language:\n    strict-inference: true\n    strict-raw-types: true\n    strict-casts: false\n  exclude:\n    - test/*.dart\n  errors:\n    deprecated_member_use_from_same_package: ignore\n    unused_import: ignore\n    unused_element_parameter: ignore\n    strict_raw_type: ignore\n`,
);

const ackPath = new URL(
  "../packages/sdk-dart/lib/src/model/playback_ack.dart",
  import.meta.url,
);
let ackSource = await readFile(ackPath, "utf8");
const replaceOnce = (source, before, after, label) => {
  if (source.includes(after)) return source;
  if (!source.includes(before))
    throw new Error(`Could not locate generated PlaybackAck ${label}`);
  return source.replace(before, after);
};
if (!ackSource.includes("package:pixel8_sdk/src/optional.dart"))
  ackSource = replaceOnce(
    ackSource,
    "import 'package:built_value/serializer.dart';\n",
    "import 'package:built_value/serializer.dart';\nimport 'package:pixel8_sdk/src/optional.dart';\n",
    "imports",
  );
if (!ackSource.includes("Optional<int?> get playingVersion;")) {
  const generatedPlayingVersionField =
    "  @BuiltValueField(wireName: r'playingVersion')\n  int? get playingVersion;";
  if (ackSource.includes(generatedPlayingVersionField)) {
    ackSource = ackSource.replace(
      generatedPlayingVersionField,
      "  @BuiltValueField(wireName: r'playingVersion')\n  Optional<int?> get playingVersion;",
    );
  } else {
    ackSource = replaceOnce(
      ackSource,
      "  @BuiltValueField(wireName: r'error')\n  String? get error;",
      "  @BuiltValueField(wireName: r'playingVersion')\n  Optional<int?> get playingVersion;\n\n  @BuiltValueField(wireName: r'error')\n  String? get error;",
      "playingVersion field",
    );
  }
}
ackSource = replaceOnce(
  ackSource,
  "  static void _defaults(PlaybackAckBuilder b) => b;",
  "  static void _defaults(PlaybackAckBuilder b) => b\n      ..playingVersion = Optional.absent();",
  "playingVersion builder default",
);
const optionalPlayingVersionSerializer = `    if (object.playingVersion.isPresent) {
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
`;
if (!ackSource.includes("if (object.playingVersion.isPresent)")) {
  const generatedSerializer =
    /    if \(object\.playingVersion != null\) \{[\s\S]*?\n    \}\n(?=    if \(object\.error != null\) \{)/;
  if (generatedSerializer.test(ackSource))
    ackSource = ackSource.replace(
      generatedSerializer,
      optionalPlayingVersionSerializer,
    );
  else
    ackSource = replaceOnce(
      ackSource,
      "    if (object.error != null) {",
      `${optionalPlayingVersionSerializer}    if (object.error != null) {`,
      "playingVersion serializer",
    );
}
const optionalPlayingVersionDeserializer = `        case r'playingVersion':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          result.playingVersion = Optional.present(valueDes);
          break;
`;
if (!ackSource.includes("result.playingVersion = Optional.present(valueDes);")) {
  const generatedDeserializer =
    /        case r'playingVersion':[\s\S]*?(?=        case r'error':)/;
  if (generatedDeserializer.test(ackSource))
    ackSource = ackSource.replace(
      generatedDeserializer,
      optionalPlayingVersionDeserializer,
    );
  else
    ackSource = replaceOnce(
      ackSource,
      "        case r'error':",
      `${optionalPlayingVersionDeserializer}        case r'error':`,
      "playingVersion deserializer",
    );
}
ackSource = replaceOnce(
  ackSource,
  "    final serializedList = (serialized as Iterable<Object?>).toList();",
  "    final serializedList = serialized is Map\n        ? serialized.entries.expand((entry) => [entry.key, entry.value]).toList()\n        : (serialized as Iterable<Object?>).toList();",
  "map deserializer",
);
await writeFile(ackPath, ackSource);

const pubspecPath = new URL(
  "../packages/sdk-dart/pubspec.yaml",
  import.meta.url,
);
let pubspec = await readFile(pubspecPath, "utf8");
if (!pubspec.includes("  json_annotation:"))
  pubspec = replaceOnce(
    pubspec,
    "dependencies:\n  dio:",
    "dependencies:\n  json_annotation: '^4.9.0'\n  dio:",
    "json_annotation dependency",
  );
await writeFile(pubspecPath, pubspec);
