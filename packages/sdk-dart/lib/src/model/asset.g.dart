// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AssetStatusEnum _$assetStatusEnum_uploading =
    const AssetStatusEnum._('uploading');
const AssetStatusEnum _$assetStatusEnum_processing =
    const AssetStatusEnum._('processing');
const AssetStatusEnum _$assetStatusEnum_ready =
    const AssetStatusEnum._('ready');
const AssetStatusEnum _$assetStatusEnum_failed =
    const AssetStatusEnum._('failed');

AssetStatusEnum _$assetStatusEnumValueOf(String name) {
  switch (name) {
    case 'uploading':
      return _$assetStatusEnum_uploading;
    case 'processing':
      return _$assetStatusEnum_processing;
    case 'ready':
      return _$assetStatusEnum_ready;
    case 'failed':
      return _$assetStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AssetStatusEnum> _$assetStatusEnumValues =
    BuiltSet<AssetStatusEnum>(const <AssetStatusEnum>[
  _$assetStatusEnum_uploading,
  _$assetStatusEnum_processing,
  _$assetStatusEnum_ready,
  _$assetStatusEnum_failed,
]);

Serializer<AssetStatusEnum> _$assetStatusEnumSerializer =
    _$AssetStatusEnumSerializer();

class _$AssetStatusEnumSerializer
    implements PrimitiveSerializer<AssetStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'uploading': 'uploading',
    'processing': 'processing',
    'ready': 'ready',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'uploading': 'uploading',
    'processing': 'processing',
    'ready': 'ready',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[AssetStatusEnum];
  @override
  final String wireName = 'AssetStatusEnum';

  @override
  Object serialize(Serializers serializers, AssetStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AssetStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AssetStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Asset extends Asset {
  @override
  final String id;
  @override
  final String appId;
  @override
  final String name;
  @override
  final String mimeType;
  @override
  final int sizeBytes;
  @override
  final AssetStatusEnum status;
  @override
  final String? thumbnailUrl;
  @override
  final String? error;

  factory _$Asset([void Function(AssetBuilder)? updates]) =>
      (AssetBuilder()..update(updates))._build();

  _$Asset._(
      {required this.id,
      required this.appId,
      required this.name,
      required this.mimeType,
      required this.sizeBytes,
      required this.status,
      this.thumbnailUrl,
      this.error})
      : super._();
  @override
  Asset rebuild(void Function(AssetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AssetBuilder toBuilder() => AssetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Asset &&
        id == other.id &&
        appId == other.appId &&
        name == other.name &&
        mimeType == other.mimeType &&
        sizeBytes == other.sizeBytes &&
        status == other.status &&
        thumbnailUrl == other.thumbnailUrl &&
        error == other.error;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, appId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, mimeType.hashCode);
    _$hash = $jc(_$hash, sizeBytes.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, thumbnailUrl.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Asset')
          ..add('id', id)
          ..add('appId', appId)
          ..add('name', name)
          ..add('mimeType', mimeType)
          ..add('sizeBytes', sizeBytes)
          ..add('status', status)
          ..add('thumbnailUrl', thumbnailUrl)
          ..add('error', error))
        .toString();
  }
}

class AssetBuilder implements Builder<Asset, AssetBuilder> {
  _$Asset? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _appId;
  String? get appId => _$this._appId;
  set appId(String? appId) => _$this._appId = appId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _mimeType;
  String? get mimeType => _$this._mimeType;
  set mimeType(String? mimeType) => _$this._mimeType = mimeType;

  int? _sizeBytes;
  int? get sizeBytes => _$this._sizeBytes;
  set sizeBytes(int? sizeBytes) => _$this._sizeBytes = sizeBytes;

  AssetStatusEnum? _status;
  AssetStatusEnum? get status => _$this._status;
  set status(AssetStatusEnum? status) => _$this._status = status;

  String? _thumbnailUrl;
  String? get thumbnailUrl => _$this._thumbnailUrl;
  set thumbnailUrl(String? thumbnailUrl) => _$this._thumbnailUrl = thumbnailUrl;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  AssetBuilder() {
    Asset._defaults(this);
  }

  AssetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _appId = $v.appId;
      _name = $v.name;
      _mimeType = $v.mimeType;
      _sizeBytes = $v.sizeBytes;
      _status = $v.status;
      _thumbnailUrl = $v.thumbnailUrl;
      _error = $v.error;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Asset other) {
    _$v = other as _$Asset;
  }

  @override
  void update(void Function(AssetBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Asset build() => _build();

  _$Asset _build() {
    final _$result = _$v ??
        _$Asset._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Asset', 'id'),
          appId:
              BuiltValueNullFieldError.checkNotNull(appId, r'Asset', 'appId'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Asset', 'name'),
          mimeType: BuiltValueNullFieldError.checkNotNull(
              mimeType, r'Asset', 'mimeType'),
          sizeBytes: BuiltValueNullFieldError.checkNotNull(
              sizeBytes, r'Asset', 'sizeBytes'),
          status:
              BuiltValueNullFieldError.checkNotNull(status, r'Asset', 'status'),
          thumbnailUrl: thumbnailUrl,
          error: error,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
