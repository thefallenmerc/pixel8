//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:pixel8_sdk/src/date_serializer.dart';
import 'package:pixel8_sdk/src/model/date.dart';

import 'package:pixel8_sdk/src/model/accepted.dart';
import 'package:pixel8_sdk/src/model/app.dart';
import 'package:pixel8_sdk/src/model/app_create.dart';
import 'package:pixel8_sdk/src/model/app_patch.dart';
import 'package:pixel8_sdk/src/model/apps_page.dart';
import 'package:pixel8_sdk/src/model/asset.dart';
import 'package:pixel8_sdk/src/model/assets_page.dart';
import 'package:pixel8_sdk/src/model/campaign.dart';
import 'package:pixel8_sdk/src/model/campaign_create.dart';
import 'package:pixel8_sdk/src/model/campaign_item.dart';
import 'package:pixel8_sdk/src/model/campaign_update.dart';
import 'package:pixel8_sdk/src/model/campaigns_page.dart';
import 'package:pixel8_sdk/src/model/capabilities.dart';
import 'package:pixel8_sdk/src/model/delete_campaign.dart';
import 'package:pixel8_sdk/src/model/display_mode.dart';
import 'package:pixel8_sdk/src/model/download.dart';
import 'package:pixel8_sdk/src/model/downloads.dart';
import 'package:pixel8_sdk/src/model/downloads_request.dart';
import 'package:pixel8_sdk/src/model/error.dart';
import 'package:pixel8_sdk/src/model/error_error.dart';
import 'package:pixel8_sdk/src/model/manifest.dart';
import 'package:pixel8_sdk/src/model/manifest_item.dart';
import 'package:pixel8_sdk/src/model/ok.dart';
import 'package:pixel8_sdk/src/model/pairing_poll.dart';
import 'package:pixel8_sdk/src/model/pairing_poll_one_of.dart';
import 'package:pixel8_sdk/src/model/pairing_poll_one_of1.dart';
import 'package:pixel8_sdk/src/model/pairing_poll_request.dart';
import 'package:pixel8_sdk/src/model/pairing_request.dart';
import 'package:pixel8_sdk/src/model/pairing_start.dart';
import 'package:pixel8_sdk/src/model/playback_ack.dart';
import 'package:pixel8_sdk/src/model/preview.dart';
import 'package:pixel8_sdk/src/model/screen.dart';
import 'package:pixel8_sdk/src/model/screen_pair_request.dart';
import 'package:pixel8_sdk/src/model/screen_patch.dart';
import 'package:pixel8_sdk/src/model/screen_telemetry.dart';
import 'package:pixel8_sdk/src/model/screens_page.dart';
import 'package:pixel8_sdk/src/model/telemetry_page.dart';
import 'package:pixel8_sdk/src/model/telemetry_request.dart';
import 'package:pixel8_sdk/src/model/telemetry_sample.dart';
import 'package:pixel8_sdk/src/model/upload_complete_request.dart';
import 'package:pixel8_sdk/src/model/upload_complete_request_parts_inner.dart';
import 'package:pixel8_sdk/src/model/upload_create.dart';
import 'package:pixel8_sdk/src/model/upload_part.dart';
import 'package:pixel8_sdk/src/model/upload_parts.dart';
import 'package:pixel8_sdk/src/model/upload_parts_request.dart';
import 'package:pixel8_sdk/src/model/upload_start.dart';

part 'serializers.g.dart';

@SerializersFor([
  Accepted,
  App,
  AppCreate,
  AppPatch,
  AppsPage,
  Asset,
  AssetsPage,
  Campaign,
  CampaignCreate,$CampaignCreate,
  CampaignItem,
  CampaignUpdate,
  CampaignsPage,
  Capabilities,
  DeleteCampaign,
  DisplayMode,
  Download,
  Downloads,
  DownloadsRequest,
  Error,
  ErrorError,
  Manifest,
  ManifestItem,
  Ok,
  PairingPoll,
  PairingPollOneOf,
  PairingPollOneOf1,
  PairingPollRequest,
  PairingRequest,
  PairingStart,
  PlaybackAck,
  Preview,
  Screen,
  ScreenPairRequest,
  ScreenPatch,
  ScreenTelemetry,
  ScreensPage,
  TelemetryPage,
  TelemetryRequest,
  TelemetrySample,
  UploadCompleteRequest,
  UploadCompleteRequestPartsInner,
  UploadCreate,
  UploadPart,
  UploadParts,
  UploadPartsRequest,
  UploadStart,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Screen)]),
        () => ListBuilder<Screen>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UploadPart)]),
        () => ListBuilder<UploadPart>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(TelemetrySample)]),
        () => ListBuilder<TelemetrySample>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(App)]),
        () => ListBuilder<App>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Campaign)]),
        () => ListBuilder<Campaign>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(DisplayMode)]),
        () => ListBuilder<DisplayMode>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Asset)]),
        () => ListBuilder<Asset>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(CampaignItem)]),
        () => ListBuilder<CampaignItem>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(UploadCompleteRequestPartsInner)]),
        () => ListBuilder<UploadCompleteRequestPartsInner>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Download)]),
        () => ListBuilder<Download>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(int)]),
        () => ListBuilder<int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ManifestItem)]),
        () => ListBuilder<ManifestItem>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(String)]),
        () => ListBuilder<String>(),
      )
      ..add(CampaignCreate.serializer)
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
