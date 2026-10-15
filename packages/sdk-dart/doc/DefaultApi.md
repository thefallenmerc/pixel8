# pixel8_sdk.api.DefaultApi

## Load the API package
```dart
import 'package:pixel8_sdk/api.dart';
```

All URIs are relative to *http://localhost:3001*

Method | HTTP request | Description
------------- | ------------- | -------------
[**abortUpload**](DefaultApi.md#abortupload) | **DELETE** /v1/uploads/{uploadId} | 
[**acknowledgePlayback**](DefaultApi.md#acknowledgeplayback) | **POST** /v1/device/ack | 
[**authGet**](DefaultApi.md#authget) | **GET** /api/auth/{path} | 
[**authPost**](DefaultApi.md#authpost) | **POST** /api/auth/{path} | 
[**beginPairing**](DefaultApi.md#beginpairing) | **POST** /v1/device/pairing | 
[**claimPairing**](DefaultApi.md#claimpairing) | **POST** /v1/screens/pair | 
[**completeUpload**](DefaultApi.md#completeupload) | **POST** /v1/uploads/{uploadId}/complete | 
[**createApp**](DefaultApi.md#createapp) | **POST** /v1/apps | 
[**createCampaign**](DefaultApi.md#createcampaign) | **POST** /v1/apps/{appId}/campaigns | 
[**createDownloads**](DefaultApi.md#createdownloads) | **POST** /v1/device/downloads | 
[**createUpload**](DefaultApi.md#createupload) | **POST** /v1/apps/{appId}/uploads | 
[**deleteApp**](DefaultApi.md#deleteapp) | **DELETE** /v1/apps/{id} | 
[**deleteAsset**](DefaultApi.md#deleteasset) | **DELETE** /v1/assets/{id} | 
[**deleteCampaign**](DefaultApi.md#deletecampaign) | **DELETE** /v1/campaigns/{id} | 
[**deviceEvents**](DefaultApi.md#deviceevents) | **GET** /v1/device/events | 
[**getApp**](DefaultApi.md#getapp) | **GET** /v1/apps/{id} | 
[**getAssetPreview**](DefaultApi.md#getassetpreview) | **GET** /v1/assets/{id}/preview | 
[**getAssetThumbnail**](DefaultApi.md#getassetthumbnail) | **GET** /v1/assets/{id}/thumbnail | 
[**getCampaign**](DefaultApi.md#getcampaign) | **GET** /v1/campaigns/{id} | 
[**getManifest**](DefaultApi.md#getmanifest) | **GET** /v1/device/manifest | 
[**getScreen**](DefaultApi.md#getscreen) | **GET** /v1/screens/{id} | 
[**listApps**](DefaultApi.md#listapps) | **GET** /v1/apps | 
[**listAssets**](DefaultApi.md#listassets) | **GET** /v1/apps/{appId}/assets | 
[**listCampaigns**](DefaultApi.md#listcampaigns) | **GET** /v1/apps/{appId}/campaigns | 
[**listScreens**](DefaultApi.md#listscreens) | **GET** /v1/screens | 
[**patchApp**](DefaultApi.md#patchapp) | **PATCH** /v1/apps/{id} | 
[**pollPairing**](DefaultApi.md#pollpairing) | **POST** /v1/device/pairing/{pairingId}/poll | 
[**revokeScreen**](DefaultApi.md#revokescreen) | **DELETE** /v1/screens/{id} | 
[**screenTelemetry**](DefaultApi.md#screentelemetry) | **GET** /v1/screens/{id}/telemetry | 
[**sendTelemetry**](DefaultApi.md#sendtelemetry) | **POST** /v1/device/telemetry | 
[**signUploadParts**](DefaultApi.md#signuploadparts) | **POST** /v1/uploads/{uploadId}/parts | 
[**updateCampaign**](DefaultApi.md#updatecampaign) | **PUT** /v1/campaigns/{id} | 
[**updateCapabilities**](DefaultApi.md#updatecapabilities) | **PUT** /v1/device/capabilities | 
[**updateScreen**](DefaultApi.md#updatescreen) | **PATCH** /v1/screens/{id} | 


# **abortUpload**
> Ok abortUpload(uploadId)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String uploadId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.abortUpload(uploadId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->abortUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadId** | **String**|  | 

### Return type

[**Ok**](Ok.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **acknowledgePlayback**
> Ok acknowledgePlayback(playbackAck)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final PlaybackAck playbackAck = ; // PlaybackAck | 

try {
    final response = api.acknowledgePlayback(playbackAck);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->acknowledgePlayback: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **playbackAck** | [**PlaybackAck**](PlaybackAck.md)|  | 

### Return type

[**Ok**](Ok.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authGet**
> authGet(path)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String path = path_example; // String | 

try {
    api.authGet(path);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **path** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **authPost**
> authPost(path)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String path = path_example; // String | 

try {
    api.authPost(path);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->authPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **path** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **beginPairing**
> PairingStart beginPairing(pairingRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final PairingRequest pairingRequest = ; // PairingRequest | 

try {
    final response = api.beginPairing(pairingRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->beginPairing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pairingRequest** | [**PairingRequest**](PairingRequest.md)|  | 

### Return type

[**PairingStart**](PairingStart.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **claimPairing**
> Screen claimPairing(screenPairRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final ScreenPairRequest screenPairRequest = ; // ScreenPairRequest | 

try {
    final response = api.claimPairing(screenPairRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->claimPairing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **screenPairRequest** | [**ScreenPairRequest**](ScreenPairRequest.md)|  | 

### Return type

[**Screen**](Screen.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeUpload**
> Asset completeUpload(uploadId, uploadCompleteRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String uploadId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UploadCompleteRequest uploadCompleteRequest = ; // UploadCompleteRequest | 

try {
    final response = api.completeUpload(uploadId, uploadCompleteRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->completeUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadId** | **String**|  | 
 **uploadCompleteRequest** | [**UploadCompleteRequest**](UploadCompleteRequest.md)|  | 

### Return type

[**Asset**](Asset.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createApp**
> App createApp(appCreate)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final AppCreate appCreate = ; // AppCreate | 

try {
    final response = api.createApp(appCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->createApp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appCreate** | [**AppCreate**](AppCreate.md)|  | 

### Return type

[**App**](App.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createCampaign**
> Campaign createCampaign(appId, campaignCreate)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String appId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CampaignCreate campaignCreate = ; // CampaignCreate | 

try {
    final response = api.createCampaign(appId, campaignCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->createCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String**|  | 
 **campaignCreate** | [**CampaignCreate**](CampaignCreate.md)|  | 

### Return type

[**Campaign**](Campaign.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createDownloads**
> Downloads createDownloads(downloadsRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final DownloadsRequest downloadsRequest = ; // DownloadsRequest | 

try {
    final response = api.createDownloads(downloadsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->createDownloads: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **downloadsRequest** | [**DownloadsRequest**](DownloadsRequest.md)|  | 

### Return type

[**Downloads**](Downloads.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createUpload**
> UploadStart createUpload(appId, uploadCreate)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String appId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UploadCreate uploadCreate = ; // UploadCreate | 

try {
    final response = api.createUpload(appId, uploadCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->createUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String**|  | 
 **uploadCreate** | [**UploadCreate**](UploadCreate.md)|  | 

### Return type

[**UploadStart**](UploadStart.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteApp**
> Ok deleteApp(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.deleteApp(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->deleteApp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Ok**](Ok.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAsset**
> Ok deleteAsset(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.deleteAsset(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->deleteAsset: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Ok**](Ok.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteCampaign**
> Ok deleteCampaign(id, deleteCampaign)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final DeleteCampaign deleteCampaign = ; // DeleteCampaign | 

try {
    final response = api.deleteCampaign(id, deleteCampaign);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->deleteCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **deleteCampaign** | [**DeleteCampaign**](DeleteCampaign.md)|  | [optional] 

### Return type

[**Ok**](Ok.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deviceEvents**
> deviceEvents()



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();

try {
    api.deviceEvents();
} on DioException catch (e) {
    print('Exception when calling DefaultApi->deviceEvents: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getApp**
> App getApp(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getApp(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->getApp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**App**](App.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetPreview**
> Preview getAssetPreview(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getAssetPreview(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->getAssetPreview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Preview**](Preview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAssetThumbnail**
> getAssetThumbnail(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api.getAssetThumbnail(id);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->getAssetThumbnail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getCampaign**
> Campaign getCampaign(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getCampaign(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->getCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Campaign**](Campaign.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getManifest**
> Manifest getManifest()



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();

try {
    final response = api.getManifest();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->getManifest: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Manifest**](Manifest.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getScreen**
> Screen getScreen(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getScreen(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->getScreen: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Screen**](Screen.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listApps**
> AppsPage listApps()



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();

try {
    final response = api.listApps();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->listApps: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AppsPage**](AppsPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAssets**
> AssetsPage listAssets(appId)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String appId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.listAssets(appId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->listAssets: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String**|  | 

### Return type

[**AssetsPage**](AssetsPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listCampaigns**
> CampaignsPage listCampaigns(appId)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String appId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.listCampaigns(appId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->listCampaigns: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appId** | **String**|  | 

### Return type

[**CampaignsPage**](CampaignsPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listScreens**
> ScreensPage listScreens()



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();

try {
    final response = api.listScreens();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->listScreens: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ScreensPage**](ScreensPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **patchApp**
> App patchApp(id, appPatch)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final AppPatch appPatch = ; // AppPatch | 

try {
    final response = api.patchApp(id, appPatch);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->patchApp: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **appPatch** | [**AppPatch**](AppPatch.md)|  | 

### Return type

[**App**](App.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pollPairing**
> PairingPoll pollPairing(pairingId, pairingPollRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String pairingId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final PairingPollRequest pairingPollRequest = ; // PairingPollRequest | 

try {
    final response = api.pollPairing(pairingId, pairingPollRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->pollPairing: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pairingId** | **String**|  | 
 **pairingPollRequest** | [**PairingPollRequest**](PairingPollRequest.md)|  | 

### Return type

[**PairingPoll**](PairingPoll.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **revokeScreen**
> Ok revokeScreen(id)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.revokeScreen(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->revokeScreen: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Ok**](Ok.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **screenTelemetry**
> TelemetryPage screenTelemetry(id, hours)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final int hours = 56; // int | 

try {
    final response = api.screenTelemetry(id, hours);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->screenTelemetry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **hours** | **int**|  | [optional] [default to 24]

### Return type

[**TelemetryPage**](TelemetryPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **sendTelemetry**
> Accepted sendTelemetry(telemetryRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final TelemetryRequest telemetryRequest = ; // TelemetryRequest | 

try {
    final response = api.sendTelemetry(telemetryRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->sendTelemetry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **telemetryRequest** | [**TelemetryRequest**](TelemetryRequest.md)|  | 

### Return type

[**Accepted**](Accepted.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signUploadParts**
> UploadParts signUploadParts(uploadId, uploadPartsRequest)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String uploadId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final UploadPartsRequest uploadPartsRequest = ; // UploadPartsRequest | 

try {
    final response = api.signUploadParts(uploadId, uploadPartsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->signUploadParts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **uploadId** | **String**|  | 
 **uploadPartsRequest** | [**UploadPartsRequest**](UploadPartsRequest.md)|  | 

### Return type

[**UploadParts**](UploadParts.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCampaign**
> Campaign updateCampaign(id, campaignUpdate)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final CampaignUpdate campaignUpdate = ; // CampaignUpdate | 

try {
    final response = api.updateCampaign(id, campaignUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->updateCampaign: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **campaignUpdate** | [**CampaignUpdate**](CampaignUpdate.md)|  | 

### Return type

[**Campaign**](Campaign.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCapabilities**
> Screen updateCapabilities(capabilities)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final Capabilities capabilities = ; // Capabilities | 

try {
    final response = api.updateCapabilities(capabilities);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->updateCapabilities: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **capabilities** | [**Capabilities**](Capabilities.md)|  | 

### Return type

[**Screen**](Screen.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateScreen**
> Screen updateScreen(id, screenPatch)



### Example
```dart
import 'package:pixel8_sdk/api.dart';

final api = Pixel8Sdk().getDefaultApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 
final ScreenPatch screenPatch = ; // ScreenPatch | 

try {
    final response = api.updateScreen(id, screenPatch);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefaultApi->updateScreen: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **screenPatch** | [**ScreenPatch**](ScreenPatch.md)|  | 

### Return type

[**Screen**](Screen.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

