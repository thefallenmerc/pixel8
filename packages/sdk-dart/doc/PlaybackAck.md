# pixel8_sdk.model.PlaybackAck

## Load the model package
```dart
import 'package:pixel8_sdk/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**version** | **int** |  | 
**status** | **String** | idle is valid only when the acknowledged manifest has no items; playing is valid only when it has items. | 
**currentItemId** | **String** |  | [optional] 
**playingVersion** | **int** | For error acknowledgements, the manifest version still playing, or null if playback stopped. If omitted, existing playback state is left unchanged. | [optional] 
**error** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


