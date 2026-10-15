import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixel8_mobile/main.dart';

class RecordingAdapter implements HttpClientAdapter {
  RequestOptions? request;
  RecordingAdapter({this.authToken, this.responseBody});
  final String? authToken;
  final Object? responseBody;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    request = options;
    return ResponseBody.fromString(
      jsonEncode(responseBody ?? {'ok': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        if (authToken != null) 'set-auth-token': [authToken!],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'send OTP uses Better Auth email OTP endpoint and sign-in type',
    () async {
      final adapter = RecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://pixel8.test'))
        ..httpClientAdapter = adapter;
      await PixelApi(
        client: dio,
        tokenReader: () async => null,
        tokenWriter: (_) async {},
      ).sendOtp('owner@example.test');
      expect(
        adapter.request?.path,
        '/api/auth/email-otp/send-verification-otp',
      );
      expect(adapter.request?.method, 'POST');
      expect(adapter.request?.data, {
        'email': 'owner@example.test',
        'type': 'sign-in',
      });
    },
  );

  test('sign-in stores Better Auth bearer header', () async {
    final adapter = RecordingAdapter(authToken: 'issued-token');
    final dio = Dio(BaseOptions(baseUrl: 'https://pixel8.test'))
      ..httpClientAdapter = adapter;
    String? storedToken;
    final api = PixelApi(
      client: dio,
      tokenReader: () async => null,
      tokenWriter: (value) async {
        storedToken = value;
      },
    );
    await api.signIn('owner@example.test', '173902');
    expect(adapter.request?.path, '/api/auth/sign-in/email-otp');
    expect(adapter.request?.data, {
      'email': 'owner@example.test',
      'otp': '173902',
    });
    expect(storedToken, 'issued-token');
  });

  test('typed generated SDK decodes app list responses', () async {
    final adapter = RecordingAdapter(
      responseBody: {
        'items': [
          {
            'id': 'app-1',
            'name': 'Lobby',
            'description': 'Front desk',
            'createdAt': '2026-10-11T10:00:00.000Z',
          },
        ],
      },
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://pixel8.test'))
      ..httpClientAdapter = adapter;
    final result = await PixelApi(
      client: dio,
      tokenReader: () async => 'owner-token',
      tokenWriter: (_) async {},
    ).get('/v1/apps');
    expect(adapter.request?.path, '/v1/apps');
    expect(adapter.request?.headers['Authorization'], 'Bearer owner-token');
    expect(result['items'].single['id'], 'app-1');
    expect(result['items'].single['name'], 'Lobby');
  });

  test(
    'owner updates carry bearer authorization and expected campaign revision',
    () async {
      final adapter = RecordingAdapter();
      final dio = Dio(BaseOptions(baseUrl: 'https://pixel8.test'))
        ..httpClientAdapter = adapter;
      final api = PixelApi(
        client: dio,
        tokenReader: () async => 'owner-token',
        tokenWriter: (_) async {},
      );
      await api.put('/v1/campaigns/campaign-1', {
        'name': 'Lobby',
        'description': '',
        'expectedRevision': 7,
        'items': [
          {'assetId': 'asset-1', 'durationSeconds': 15, 'fit': 'cover'},
        ],
      });
      expect(adapter.request?.headers['Authorization'], 'Bearer owner-token');
      expect(adapter.request?.path, '/v1/campaigns/campaign-1');
      expect(adapter.request?.data['expectedRevision'], 7);
      expect(adapter.request?.data['items'], [
        {'assetId': 'asset-1', 'durationSeconds': 15, 'fit': 'cover'},
      ]);
    },
  );

  test('pairing scanner accepts URI and raw codes', () {
    expect(extractPairingCode('pixel8://pair?code=ABCDEFGH'), 'ABCDEFGH');
    expect(extractPairingCode('ABCDEFGH'), 'ABCDEFGH');
  });

  test(
    'multipart resume and playlist reorder preserve part state and order',
    () {
      expect(missingUploadParts(4, {'1': 'etag-1', '3': 'etag-3'}), [2, 4]);
      final etags = <String, dynamic>{};
      recordUploadedPart(etags, 2, '"part-2-etag"');
      expect(etags, {'2': '"part-2-etag"'});
      final items = <Map>[
        {'assetId': 'a'},
        {'assetId': 'b'},
        {'assetId': 'c'},
      ];
      reorderPlaylist(items, 0, 3);
      expect(items.map((item) => item['assetId']), ['b', 'c', 'a']);
    },
  );
}
