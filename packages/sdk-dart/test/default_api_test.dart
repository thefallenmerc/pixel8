import 'package:test/test.dart';
import 'package:pixel8_sdk/pixel8_sdk.dart';


/// tests for DefaultApi
void main() {
  final instance = Pixel8Sdk().getDefaultApi();

  group(DefaultApi, () {
    //Future<Ok> abortUpload(String uploadId) async
    test('test abortUpload', () async {
      // TODO
    });

    //Future<Ok> acknowledgePlayback(PlaybackAck playbackAck) async
    test('test acknowledgePlayback', () async {
      // TODO
    });

    //Future authGet(String path) async
    test('test authGet', () async {
      // TODO
    });

    //Future authPost(String path) async
    test('test authPost', () async {
      // TODO
    });

    //Future<PairingStart> beginPairing(PairingRequest pairingRequest) async
    test('test beginPairing', () async {
      // TODO
    });

    //Future<Screen> claimPairing(ScreenPairRequest screenPairRequest) async
    test('test claimPairing', () async {
      // TODO
    });

    //Future<Asset> completeUpload(String uploadId, UploadCompleteRequest uploadCompleteRequest) async
    test('test completeUpload', () async {
      // TODO
    });

    //Future<App> createApp(AppCreate appCreate) async
    test('test createApp', () async {
      // TODO
    });

    //Future<Campaign> createCampaign(String appId, CampaignCreate campaignCreate) async
    test('test createCampaign', () async {
      // TODO
    });

    //Future<Downloads> createDownloads(DownloadsRequest downloadsRequest) async
    test('test createDownloads', () async {
      // TODO
    });

    //Future<UploadStart> createUpload(String appId, UploadCreate uploadCreate) async
    test('test createUpload', () async {
      // TODO
    });

    //Future<Ok> deleteApp(String id) async
    test('test deleteApp', () async {
      // TODO
    });

    //Future<Ok> deleteAsset(String id) async
    test('test deleteAsset', () async {
      // TODO
    });

    //Future<Ok> deleteCampaign(String id, { DeleteCampaign deleteCampaign }) async
    test('test deleteCampaign', () async {
      // TODO
    });

    //Future deviceEvents() async
    test('test deviceEvents', () async {
      // TODO
    });

    //Future<App> getApp(String id) async
    test('test getApp', () async {
      // TODO
    });

    //Future<Preview> getAssetPreview(String id) async
    test('test getAssetPreview', () async {
      // TODO
    });

    //Future getAssetThumbnail(String id) async
    test('test getAssetThumbnail', () async {
      // TODO
    });

    //Future<Campaign> getCampaign(String id) async
    test('test getCampaign', () async {
      // TODO
    });

    //Future<Manifest> getManifest() async
    test('test getManifest', () async {
      // TODO
    });

    //Future<Screen> getScreen(String id) async
    test('test getScreen', () async {
      // TODO
    });

    //Future<AppsPage> listApps() async
    test('test listApps', () async {
      // TODO
    });

    //Future<AssetsPage> listAssets(String appId) async
    test('test listAssets', () async {
      // TODO
    });

    //Future<CampaignsPage> listCampaigns(String appId) async
    test('test listCampaigns', () async {
      // TODO
    });

    //Future<ScreensPage> listScreens() async
    test('test listScreens', () async {
      // TODO
    });

    //Future<App> patchApp(String id, AppPatch appPatch) async
    test('test patchApp', () async {
      // TODO
    });

    //Future<PairingPoll> pollPairing(String pairingId, PairingPollRequest pairingPollRequest) async
    test('test pollPairing', () async {
      // TODO
    });

    //Future<Ok> revokeScreen(String id) async
    test('test revokeScreen', () async {
      // TODO
    });

    //Future<TelemetryPage> screenTelemetry(String id, { int hours }) async
    test('test screenTelemetry', () async {
      // TODO
    });

    //Future<Accepted> sendTelemetry(TelemetryRequest telemetryRequest) async
    test('test sendTelemetry', () async {
      // TODO
    });

    //Future<UploadParts> signUploadParts(String uploadId, UploadPartsRequest uploadPartsRequest) async
    test('test signUploadParts', () async {
      // TODO
    });

    //Future<Campaign> updateCampaign(String id, CampaignUpdate campaignUpdate) async
    test('test updateCampaign', () async {
      // TODO
    });

    //Future<Screen> updateCapabilities(Capabilities capabilities) async
    test('test updateCapabilities', () async {
      // TODO
    });

    //Future<Screen> updateScreen(String id, ScreenPatch screenPatch) async
    test('test updateScreen', () async {
      // TODO
    });

  });
}
