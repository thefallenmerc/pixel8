import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixel8_mobile/main.dart';

void main() {
  testWidgets('sign in asks for email before verification code', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(432, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.text('Welcome to Pixel8'), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Send verification code'), findsOneWidget);
    expect(find.text('Verification code'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('screen list distinguishes playing and offline status', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          screensProvider.overrideWith(
            (ref) async => {
              'items': [
                {
                  'id': 'screen-1',
                  'name': 'Lobby display',
                  'status': 'playing',
                  'campaignId': 'campaign-1',
                },
                {
                  'id': 'screen-2',
                  'name': 'Meeting room',
                  'status': 'offline',
                  'campaignId': null,
                },
              ],
            },
          ),
        ],
        child: const MaterialApp(home: ScreensPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('playing · Campaign assigned'), findsOneWidget);
    expect(find.text('offline · No campaign'), findsOneWidget);
    expect(find.text('Lobby display'), findsOneWidget);
    expect(find.text('Meeting room'), findsOneWidget);
  });
}
