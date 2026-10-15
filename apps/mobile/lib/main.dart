import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mime/mime.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:video_player/video_player.dart';
import 'package:pixel8_sdk/pixel8_sdk.dart';

const ink = Color(0xff18233f),
    blue = Color(0xff3559e8),
    pale = Color(0xfff5f7fb),
    mint = Color(0xffd9f5e9),
    coral = Color(0xffffe6df);
final storage = const FlutterSecureStorage();
final authChanges = ValueNotifier<int>(0);
final apiProvider = Provider((ref) => PixelApi());
final routerProvider = Provider(
  (ref) => GoRouter(
    refreshListenable: authChanges,
    initialLocation: '/apps',
    redirect: (context, state) async {
      final token = await storage.read(key: 'token');
      final isLogin = state.uri.path == '/login';
      if (token == null && !isLogin) return '/login';
      if (token != null && isLogin) return '/apps';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ShellRoute(
        builder: (_, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(path: '/apps', builder: (_, __) => const AppsPage()),
          GoRoute(path: '/library', builder: (_, __) => const LibraryPage()),
          GoRoute(path: '/screens', builder: (_, __) => const ScreensPage()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
          GoRoute(
            path: '/campaign/:id',
            builder: (_, s) => CampaignPage(id: s.pathParameters['id']!),
          ),
          GoRoute(
            path: '/screen/:id',
            builder: (_, s) => ScreenDetailPage(id: s.pathParameters['id']!),
          ),
        ],
      ),
    ],
  ),
);
final appsProvider = FutureProvider(
  (ref) => ref.read(apiProvider).get('/v1/apps'),
);
final assetsProvider = FutureProvider(
  (ref) => ref
      .read(apiProvider)
      .get('/v1/apps/${ref.watch(selectedAppProvider)}/assets'),
);
final screensProvider = FutureProvider(
  (ref) => ref.read(apiProvider).get('/v1/screens'),
);
final selectedAppProvider = StateProvider<String>((ref) => '');

class PixelApi {
  PixelApi({
    Dio? client,
    Future<String?> Function()? tokenReader,
    Future<void> Function(String)? tokenWriter,
  }) : _tokenReader = tokenReader ?? (() => storage.read(key: 'token')),
       _tokenWriter =
           tokenWriter ??
           ((value) => storage.write(key: 'token', value: value)) {
    dio =
        client ??
        Dio(
          BaseOptions(
            baseUrl: const String.fromEnvironment(
              'PIXEL8_API',
              defaultValue: 'http://localhost:3001',
            ),
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 30),
          ),
        );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) async {
          final t = await _tokenReader();
          if (t != null) o.headers['Authorization'] = 'Bearer $t';
          h.next(o);
        },
        onResponse: (r, h) async {
          final token = r.headers.value('set-auth-token');
          if (token != null && token.isNotEmpty) {
            _receivedToken = token;
            await _tokenWriter(token);
          }
          h.next(r);
        },
        onError: (e, h) async {
          if (e.response?.statusCode == 401) {
            await storage.delete(key: 'token');
            authChanges.value++;
          }
          h.next(e);
        },
      ),
    );
    generated = Pixel8Sdk(dio: dio).getDefaultApi();
  }
  final Future<String?> Function() _tokenReader;
  final Future<void> Function(String) _tokenWriter;
  String? _receivedToken;
  late final Dio dio;
  late final DefaultApi generated;
  Future<dynamic> get(String p, [Map<String, dynamic>? q]) async =>
      await _get(p, q);

  Future<dynamic> _get(String p, Map<String, dynamic>? q) async {
    if (q == null && p == '/v1/apps') {
      final page = (await generated.listApps()).data!;
      return {
        'items': page.items
            .map(
              (x) => {
                'id': x.id,
                'name': x.name,
                'description': x.description,
                'createdAt': x.createdAt.toIso8601String(),
              },
            )
            .toList(),
      };
    }
    if (q == null && p == '/v1/screens') {
      final page = (await generated.listScreens()).data!;
      return {
        'items': page.items
            .map(
              (x) => {
                'id': x.id,
                'name': x.name,
                'campaignId': x.campaignId,
                'orientation':
                    int.tryParse(
                      x.orientation.name.replaceFirst('number', ''),
                    ) ??
                    0,
                'muted': x.muted,
                'volume': x.volume,
                'desiredVersion': x.desiredVersion,
                'playingVersion': x.playingVersion,
                'status': x.status.name,
                'lastSeenAt': x.lastSeenAt?.toIso8601String(),
                'error': x.error,
              },
            )
            .toList(),
      };
    }
    final assets = RegExp(r'^/v1/apps/([^/]+)/assets$').firstMatch(p);
    if (q == null && assets != null) {
      final page = (await generated.listAssets(appId: assets.group(1)!)).data!;
      return {
        'items': page.items
            .map(
              (x) => {
                'id': x.id,
                'appId': x.appId,
                'name': x.name,
                'mimeType': x.mimeType,
                'sizeBytes': x.sizeBytes,
                'status': x.status.name,
                'thumbnailUrl': x.thumbnailUrl,
                'error': x.error,
              },
            )
            .toList(),
      };
    }
    final campaigns = RegExp(r'^/v1/apps/([^/]+)/campaigns$').firstMatch(p);
    if (q == null && campaigns != null) {
      final page = (await generated.listCampaigns(appId: campaigns.group(1)!))
          .data!;
      return {
        'items': page.items
            .map(
              (x) => {
                'id': x.id,
                'appId': x.appId,
                'name': x.name,
                'description': x.description,
                'revision': x.revision,
                'currentRevision': x.currentRevision,
                'status': x.status.name,
                'items': x.items
                    .map(
                      (i) => {
                        'assetId': i.assetId,
                        'durationSeconds': i.durationSeconds,
                        'fit': i.fit.name,
                      },
                    )
                    .toList(),
                'error': x.error,
              },
            )
            .toList(),
      };
    }
    return (await dio.get(p, queryParameters: q)).data;
  }

  Future<dynamic> post(String p, [Object? d]) async =>
      (await dio.post(p, data: d)).data;
  Future<dynamic> patch(String p, Object d) async =>
      (await dio.patch(p, data: d)).data;
  Future<dynamic> put(String p, Object d) async =>
      (await dio.put(p, data: d)).data;
  Future<void> delete(String p, [Object? d]) async {
    await dio.delete(p, data: d);
  }

  Future<void> sendOtp(String email) async {
    await post('/api/auth/email-otp/send-verification-otp', {
      'email': email,
      'type': 'sign-in',
    });
  }

  Future<void> signIn(String email, String otp) async {
    final r = await post('/api/auth/sign-in/email-otp', {
      'email': email,
      'otp': otp,
    });
    final token = r is Map ? (r['token'] ?? r['session']?['token']) : null;
    if (token != null) await _tokenWriter('$token');
    if (token == null && _receivedToken == null)
      throw Exception('The server did not return a bearer token.');
  }

  Future<void> logout() async {
    try {
      await post('/api/auth/sign-out');
    } finally {
      await storage.delete(key: 'token');
      authChanges.value++;
    }
  }
}

void main() => runApp(const ProviderScope(child: Pixel8App()));

class Pixel8App extends ConsumerWidget {
  const Pixel8App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    title: 'Pixel8',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: blue, surface: Colors.white),
      scaffoldBackgroundColor: pale,
      useMaterial3: true,
      fontFamily: 'Avenir',
      appBarTheme: const AppBarTheme(
        backgroundColor: pale,
        foregroundColor: ink,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pale,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    ),
    routerConfig: ref.watch(routerProvider),
  );
}

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child, required this.location});
  final Widget child;
  final String location;
  static const paths = ['/apps', '/library', '/screens', '/settings'];
  static const labels = ['Apps', 'Library', 'Screens', 'Settings'];
  static const icons = [
    Icons.grid_view_rounded,
    Icons.perm_media_rounded,
    Icons.tv_rounded,
    Icons.settings_rounded,
  ];
  @override
  Widget build(BuildContext context) {
    final idx = paths.indexWhere((p) => location.startsWith(p)).clamp(0, 3);
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (MediaQuery.sizeOf(context).width > 760)
              NavigationRail(
                selectedIndex: idx,
                onDestinationSelected: (i) => context.go(paths[i]),
                labelType: NavigationRailLabelType.all,
                destinations: List.generate(
                  4,
                  (i) => NavigationRailDestination(
                    icon: Icon(icons[i]),
                    label: Text(labels[i]),
                  ),
                ),
              ),
            Expanded(child: child),
          ],
        ),
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width <= 760
          ? NavigationBar(
              selectedIndex: idx,
              onDestinationSelected: (i) => context.go(paths[i]),
              destinations: List.generate(
                4,
                (i) => NavigationDestination(
                  icon: Icon(icons[i]),
                  label: labels[i],
                ),
              ),
            )
          : null,
    );
  }
}

class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    required this.child,
  });
  final String title;
  final String? subtitle;
  final Widget? action, child;
  @override
  Widget build(BuildContext context) => CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
        sliver: SliverToBoxAdapter(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: ink,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.7,
                      ),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          subtitle!,
                          style: TextStyle(
                            color: ink.withValues(alpha: .57),
                            fontSize: 14,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        sliver: SliverToBoxAdapter(child: child),
      ),
    ],
  );
}

class Notice extends StatelessWidget {
  const Notice(this.text, {super.key, this.icon = Icons.info_outline_rounded});
  final String text;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(icon, color: blue),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: const TextStyle(color: ink)),
        ),
      ],
    ),
  );
}

Widget errorBox(Object e, VoidCallback retry) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Notice('Could not load data: $e', icon: Icons.wifi_off_rounded),
    TextButton.icon(
      onPressed: retry,
      icon: const Icon(Icons.refresh),
      label: const Text('Try again'),
    ),
  ],
);

class AppsPage extends ConsumerWidget {
  const AppsPage({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) => PageFrame(
    title: 'Your apps',
    subtitle: 'Organize the campaigns playing across your screens.',
    action: FilledButton.icon(
      onPressed: () => _newApp(c, r),
      icon: const Icon(Icons.add),
      label: const Text('New app'),
    ),
    child: r
        .watch(appsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => errorBox(e, () => r.invalidate(appsProvider)),
          data: (raw) {
            final items = (raw['items'] as List? ?? []);
            if (items.isEmpty)
              return const Notice(
                'No apps yet. Create an app to start building your screen content.',
                icon: Icons.auto_awesome_rounded,
              );
            return LayoutBuilder(
              builder: (c, b) => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: b.maxWidth > 850
                      ? 3
                      : b.maxWidth > 540
                      ? 2
                      : 1,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.45,
                ),
                itemCount: items.length,
                itemBuilder: (c, i) {
                  final a = items[i] as Map;
                  return InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      r.read(selectedAppProvider.notifier).state = '${a['id']}';
                      c.go('/library');
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: i.isEven ? mint : coral,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Icon(
                                    Icons.apps_rounded,
                                    color: i.isEven
                                        ? const Color(0xff28845b)
                                        : const Color(0xffdb654f),
                                  ),
                                ),
                                const Spacer(),
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') _editApp(c, r, a);
                                    if (value == 'delete') _deleteApp(c, r, a);
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit app'),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Text('Delete app'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              '${a['name']}',
                              style: const TextStyle(
                                color: ink,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${a['description'] ?? 'No description'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ink.withValues(alpha: .57),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Open library  →',
                              style: TextStyle(
                                color: blue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
  );
}

Future<void> _editApp(BuildContext c, WidgetRef r, Map app) async {
  final name = TextEditingController(text: '${app['name']}');
  final description = TextEditingController(
    text: '${app['description'] ?? ''}',
  );
  final save = await showDialog<bool>(
    context: c,
    builder: (context) => AlertDialog(
      title: const Text('Edit app'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'App name'),
          ),
          TextField(
            controller: description,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Save'),
        ),
      ],
    ),
  );
  if (save == true) {
    try {
      await r.read(apiProvider).patch('/v1/apps/${app['id']}', {
        'name': name.text,
        'description': description.text,
      });
      r.invalidate(appsProvider);
    } catch (e) {
      if (c.mounted) _snack(c, 'Could not update app: $e');
    }
  }
}

Future<void> _deleteApp(BuildContext c, WidgetRef r, Map app) async {
  final yes = await showDialog<bool>(
    context: c,
    builder: (context) => AlertDialog(
      title: const Text('Delete app?'),
      content: Text('Delete ${app['name']} and its unreferenced content?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Delete'),
        ),
      ],
    ),
  );
  if (yes == true) {
    try {
      await r.read(apiProvider).delete('/v1/apps/${app['id']}');
      r.invalidate(appsProvider);
    } catch (e) {
      if (c.mounted) _snack(c, 'Could not delete app: $e');
    }
  }
}

Future<void> _newApp(BuildContext c, WidgetRef r) async {
  final n = TextEditingController(), d = TextEditingController();
  final ok = await showDialog<bool>(
    context: c,
    builder: (c) => AlertDialog(
      title: const Text('Create app'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: n,
            decoration: const InputDecoration(labelText: 'App name'),
          ),
          TextField(
            controller: d,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Create'),
        ),
      ],
    ),
  );
  if (ok == true)
    try {
      await r.read(apiProvider).post('/v1/apps', {
        'name': n.text,
        'description': d.text,
      });
      r.invalidate(appsProvider);
    } catch (e) {
      if (c.mounted) _snack(c, 'Could not create app: $e');
    }
}

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) {
    final appId = r.watch(selectedAppProvider);
    return PageFrame(
      title: 'Library',
      subtitle: 'Your uploaded media and screen campaigns.',
      child: appId.isEmpty
          ? Column(
              children: [
                const Notice(
                  'Choose an app from Apps to view its media and campaigns.',
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => c.go('/apps'),
                  child: const Text('Browse apps'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Campaigns',
                        style: TextStyle(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () => _newCampaign(c, r, appId),
                      icon: const Icon(Icons.add),
                      label: const Text('New campaign'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CampaignList(appId: appId),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Media',
                        style: TextStyle(
                          color: ink,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _upload(c, r, appId),
                      icon: const Icon(Icons.upload_rounded),
                      label: const Text('Upload'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                r
                    .watch(assetsProvider)
                    .when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, s) =>
                          errorBox(e, () => r.invalidate(assetsProvider)),
                      data: (x) {
                        final list = x['items'] as List? ?? [];
                        return list.isEmpty
                            ? const Notice(
                                'Uploaded images and videos will appear here.',
                              )
                            : Column(
                                children: list.map((v) {
                                  final a = v as Map;
                                  return Card(
                                    child: ListTile(
                                      leading: const CircleAvatar(
                                        backgroundColor: mint,
                                        child: Icon(
                                          Icons.image_outlined,
                                          color: ink,
                                        ),
                                      ),
                                      title: Text('${a['name']}'),
                                      subtitle: Text(
                                        '${a['status']} · ${a['mimeType']}',
                                      ),
                                      trailing: Wrap(
                                        children: [
                                          if (a['status'] == 'failed')
                                            IconButton(
                                              tooltip: 'Retry upload',
                                              onPressed: () =>
                                                  _upload(c, r, appId),
                                              icon: const Icon(Icons.refresh),
                                            ),
                                          IconButton(
                                            tooltip: 'Delete media',
                                            onPressed: () async {
                                              try {
                                                await r
                                                    .read(apiProvider)
                                                    .delete(
                                                      '/v1/assets/${a['id']}',
                                                    );
                                                r.invalidate(assetsProvider);
                                              } catch (e) {
                                                if (c.mounted)
                                                  _snack(
                                                    c,
                                                    'Could not delete media: $e',
                                                  );
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                      },
                    ),
              ],
            ),
    );
  }
}

class CampaignList extends ConsumerWidget {
  const CampaignList({super.key, required this.appId});
  final String appId;
  @override
  Widget build(BuildContext c, WidgetRef r) => FutureBuilder(
    future: r.read(apiProvider).get('/v1/apps/$appId/campaigns'),
    builder: (c, s) {
      if (s.connectionState != ConnectionState.done)
        return const Center(child: CircularProgressIndicator());
      if (s.hasError)
        return errorBox(s.error!, () => r.invalidate(assetsProvider));
      final a = s.data?['items'] as List? ?? [];
      if (a.isEmpty)
        return const Notice(
          'No campaigns yet. Create one, add media, then assign it to a screen.',
        );
      return Column(
        children: a.map((e) {
          final x = e as Map;
          return Card(
            child: ListTile(
              onTap: () => c.go('/campaign/${x['id']}'),
              title: Text('${x['name']}'),
              subtitle: Text(
                '${x['status']} · revision ${x['revision']} · ${(x['items'] as List? ?? []).length} items',
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        }).toList(),
      );
    },
  );
}

Future<void> _newCampaign(BuildContext c, WidgetRef r, String app) async {
  final n = TextEditingController();
  if (await showDialog<bool>(
        context: c,
        builder: (c) => AlertDialog(
          title: const Text('New campaign'),
          content: TextField(
            controller: n,
            decoration: const InputDecoration(labelText: 'Campaign name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Create'),
            ),
          ],
        ),
      ) ==
      true) {
    try {
      await r.read(apiProvider).post('/v1/apps/$app/campaigns', {
        'name': n.text,
        'description': '',
        'items': [],
      });
      r.invalidate(assetsProvider);
      if (c.mounted) _snack(c, 'Campaign created.');
    } catch (e) {
      if (c.mounted) _snack(c, 'Could not create campaign: $e');
    }
  }
}

Future<void> _upload(BuildContext c, WidgetRef r, String app) async {
  final picked = await FilePicker.platform.pickFiles(withData: true);
  if (!c.mounted) return;
  if (picked == null) return;
  final f = picked.files.single;
  final bytes = f.bytes;
  if (bytes == null) {
    if (c.mounted) _snack(c, 'Unable to read selected file.');
    return;
  }
  final api = r.read(apiProvider);
  final key = 'upload:$app:${base64Url.encode(utf8.encode(f.name))}:${f.size}';
  final progress = ValueNotifier<double>(0);
  unawaited(
    showDialog<void>(
      context: c,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Uploading ${f.name}'),
        content: ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (_, value, __) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LinearProgressIndicator(value: value == 0 ? null : value),
              const SizedBox(height: 12),
              Text('${(value * 100).round()}% complete'),
            ],
          ),
        ),
      ),
    ),
  );
  try {
    final raw = await storage.read(key: key);
    Map<String, dynamic>? session;
    if (raw != null) {
      final candidate = jsonDecode(raw) as Map<String, dynamic>;
      if (candidate['name'] == f.name && candidate['sizeBytes'] == f.size)
        session = candidate;
    }
    if (session == null) {
      final init = await api.post('/v1/apps/$app/uploads', {
        'name': f.name,
        'mimeType': lookupMimeType(f.name) ?? 'application/octet-stream',
        'sizeBytes': f.size,
      });
      session = {
        'uploadId': init['uploadId'],
        'partSizeBytes': init['partSizeBytes'],
        'name': f.name,
        'sizeBytes': f.size,
        'etags': <String, String>{},
      };
      await storage.write(key: key, value: jsonEncode(session));
    }
    final uploadId = session['uploadId'] as String;
    final partSize = session['partSizeBytes'] as int;
    final count = (bytes.length / partSize).ceil();
    final etags = Map<String, dynamic>.from(session['etags'] as Map);
    progress.value = etags.length / count;
    final missing = missingUploadParts(count, etags);
    if (missing.isNotEmpty) {
      final presigned = await api.post('/v1/uploads/$uploadId/parts', {
        'partNumbers': missing,
      });
      for (final number in missing) {
        final part = (presigned['parts'] as List).firstWhere(
          (p) => p['partNumber'] == number,
        );
        final start = (number - 1) * partSize;
        final end = (start + partSize).clamp(0, bytes.length);
        final response = await Dio().put(
          part['url'],
          data: bytes.sublist(start, end),
          options: Options(
            headers: {'Content-Length': end - start},
            responseType: ResponseType.plain,
          ),
        );
        final etag = response.headers.value('etag');
        recordUploadedPart(etags, number, etag);
        progress.value = etags.length / count;
        session['etags'] = etags;
        await storage.write(key: key, value: jsonEncode(session));
      }
    }
    final parts = List.generate(
      count,
      (i) => {'partNumber': i + 1, 'etag': etags['${i + 1}']},
    );
    await api.post('/v1/uploads/$uploadId/complete', {'parts': parts});
    await storage.delete(key: key);
    if (c.mounted) Navigator.of(c, rootNavigator: true).pop();
    r.invalidate(assetsProvider);
    if (c.mounted) _snack(c, 'Upload complete.');
  } catch (e) {
    if (c.mounted) Navigator.of(c, rootNavigator: true).pop();
    if (c.mounted)
      _snack(c, 'Upload paused. Select the same file to resume: $e');
  } finally {
    progress.dispose();
  }
}

class CampaignPage extends ConsumerStatefulWidget {
  const CampaignPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<CampaignPage> createState() => _CampaignPageState();
}

class _CampaignPageState extends ConsumerState<CampaignPage> {
  Map? data;
  bool busy = false;
  String? err;
  Future<void> load() async {
    setState(() => busy = true);
    try {
      data = await ref.read(apiProvider).get('/v1/campaigns/${widget.id}');
      err = null;
    } catch (e) {
      err = '$e';
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campaign'),
        actions: [
          IconButton(
            tooltip: 'Delete campaign',
            onPressed: data == null ? null : _delete,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: busy
          ? const Center(child: CircularProgressIndicator())
          : err != null
          ? Center(child: errorBox(err!, load))
          : data == null
          ? const SizedBox()
          : _body(c),
    );
  }

  Widget _body(BuildContext c) {
    final d = data!, items = (d['items'] as List? ?? []).cast<Map>();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        TextFormField(
          initialValue: '${d['name']}',
          decoration: const InputDecoration(labelText: 'Campaign name'),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
          onChanged: (value) => d['name'] = value,
        ),
        TextFormField(
          initialValue: '${d['description'] ?? ''}',
          decoration: const InputDecoration(labelText: 'Description'),
          onChanged: (value) => d['description'] = value,
        ),
        Text(
          '${d['status']} · revision ${d['revision']}',
          style: const TextStyle(color: blue),
        ),
        const SizedBox(height: 20),
        if (items.isNotEmpty)
          MediaPreview(assetId: '${items.first['assetId']}', height: 210),
        if (items.isEmpty)
          const Notice(
            'Preview will appear after you add media to this campaign.',
          ),
        const SizedBox(height: 18),
        const Text(
          'Playlist',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Notice(
              'This campaign is empty. Add items from your app media library.',
            ),
          ),
        if (items.isNotEmpty)
          ReorderableListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorder: (a, b) => setState(() => reorderPlaylist(items, a, b)),
            children: items
                .asMap()
                .entries
                .map(
                  (e) => Card(
                    key: ValueKey(e.value['assetId']),
                    child: Column(
                      children: [
                        MediaPreview(
                          assetId: '${e.value['assetId']}',
                          height: 150,
                        ),
                        ListTile(
                          leading: ReorderableDragStartListener(
                            index: e.key,
                            child: const Icon(Icons.drag_handle),
                          ),
                          title: Text(
                            'Media ${e.key + 1} · ${e.value['durationSeconds']} sec',
                          ),
                          trailing: IconButton(
                            onPressed: () => _remove(e.key),
                            icon: const Icon(Icons.delete_outline),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                          child: Row(
                            children: [
                              const Text('Duration'),
                              const SizedBox(width: 8),
                              DropdownButton<int>(
                                value:
                                    [
                                      5,
                                      10,
                                      15,
                                      20,
                                      30,
                                      60,
                                    ].contains(e.value['durationSeconds'])
                                    ? e.value['durationSeconds']
                                    : 10,
                                items: [5, 10, 15, 20, 30, 60]
                                    .map(
                                      (v) => DropdownMenuItem(
                                        value: v,
                                        child: Text('$v sec'),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) {
                                  if (v != null)
                                    setState(
                                      () => e.value['durationSeconds'] = v,
                                    );
                                },
                              ),
                              const Spacer(),
                              const Text('Fit'),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: e.value['fit'] == 'cover'
                                    ? 'cover'
                                    : 'contain',
                                items: const [
                                  DropdownMenuItem(
                                    value: 'contain',
                                    child: Text('Contain'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'cover',
                                    child: Text('Cover'),
                                  ),
                                ],
                                onChanged: (v) {
                                  if (v != null)
                                    setState(() => e.value['fit'] = v);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _addItem(c),
          icon: const Icon(Icons.add),
          label: const Text('Add media'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.save_outlined),
          label: const Text('Save changes'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => _publish(c),
          icon: const Icon(Icons.tv),
          label: const Text('Show on screen'),
        ),
      ],
    );
  }

  void _remove(int i) {
    setState(() => (data!['items'] as List).removeAt(i));
  }

  Future<void> _delete() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete campaign?'),
        content: const Text(
          'Screens assigned to this campaign will be unassigned.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes == true) {
      try {
        await ref.read(apiProvider).delete('/v1/campaigns/${widget.id}', {
          'unassignScreens': true,
        });
        if (mounted) context.go('/library');
      } catch (e) {
        if (mounted) _snack(context, 'Could not delete campaign: $e');
      }
    }
  }

  Future<void> _addItem(BuildContext c) async {
    final app = data!['appId'];
    final assets = await ref.read(apiProvider).get('/v1/apps/$app/assets');
    if (!c.mounted) return;
    final ready = (assets['items'] as List? ?? [])
        .where((a) => a['status'] == 'ready')
        .toList();
    if (ready.isEmpty) {
      _snack(c, 'Upload ready media in Library first.');
      return;
    }
    final selected = await showDialog<Map>(
      context: c,
      builder: (c) => SimpleDialog(
        title: const Text('Add ready media'),
        children: ready
            .map(
              (a) => SimpleDialogOption(
                onPressed: () => Navigator.pop(c, a as Map),
                child: Text('${a['name']}'),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null)
      setState(
        () => (data!['items'] as List).add({
          'assetId': selected['id'],
          'durationSeconds': 10,
          'fit': 'contain',
        }),
      );
  }

  Future<void> _save() async {
    try {
      await ref.read(apiProvider).put('/v1/campaigns/${widget.id}', {
        'name': data!['name'],
        'description': data!['description'] ?? '',
        'expectedRevision': data!['revision'],
        'items': data!['items'],
      });
      await load();
      if (mounted) _snack(context, 'Campaign saved.');
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        await load();
        if (mounted)
          _snack(
            context,
            'Another change was saved. Latest revision loaded; review and save again.',
          );
      } else if (mounted)
        _snack(context, 'Save failed: $e');
    } catch (e) {
      if (mounted) _snack(context, 'Save failed: $e');
    }
  }

  Future<void> _publish(BuildContext c) async {
    final screens = await ref.read(apiProvider).get('/v1/screens');
    final list = screens['items'] as List? ?? [];
    if (!c.mounted) return;
    final sel = await showDialog<Map>(
      context: c,
      builder: (c) => SimpleDialog(
        title: const Text('Choose a screen'),
        children: list
            .map(
              (x) => SimpleDialogOption(
                onPressed: () => Navigator.pop(c, x as Map),
                child: Text('${x['name']}'),
              ),
            )
            .toList(),
      ),
    );
    if (sel != null) {
      try {
        await ref.read(apiProvider).patch('/v1/screens/${sel['id']}', {
          'expectedDesiredVersion': sel['desiredVersion'],
          'campaignId': widget.id,
        });
        if (c.mounted) _snack(c, 'Campaign assigned to ${sel['name']}.');
      } catch (e) {
        if (c.mounted) _snack(c, 'Could not assign screen: $e');
      }
    }
  }
}

class MediaPreview extends ConsumerStatefulWidget {
  const MediaPreview({super.key, required this.assetId, required this.height});
  final String assetId;
  final double height;
  @override
  ConsumerState<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends ConsumerState<MediaPreview> {
  late Future<dynamic> preview;
  @override
  void initState() {
    super.initState();
    preview = ref.read(apiProvider).get('/v1/assets/${widget.assetId}/preview');
  }

  @override
  void didUpdateWidget(covariant MediaPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetId != widget.assetId)
      preview = ref
          .read(apiProvider)
          .get('/v1/assets/${widget.assetId}/preview');
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(18),
    child: SizedBox(
      height: widget.height,
      width: double.infinity,
      child: FutureBuilder<dynamic>(
        future: preview,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Container(
              color: ink,
              alignment: Alignment.center,
              child: Text(
                'Preview unavailable: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final url = snapshot.data['url'] as String;
          final mime = snapshot.data['mimeType'] as String? ?? '';
          if (mime.startsWith('video/')) return _VideoPreview(url: url);
          return Image.network(
            url,
            fit: BoxFit.contain,
            errorBuilder: (_, error, stack) => Container(
              color: ink,
              alignment: Alignment.center,
              child: const Text(
                'Image preview unavailable',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _VideoPreview extends StatefulWidget {
  const _VideoPreview({required this.url});
  final String url;
  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  late final VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => controller.value.isInitialized
      ? Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            IconButton.filled(
              onPressed: () => setState(
                () => controller.value.isPlaying
                    ? controller.pause()
                    : controller.play(),
              ),
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          ],
        )
      : const Center(child: CircularProgressIndicator());
}

class ScreensPage extends ConsumerWidget {
  const ScreensPage({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) => PageFrame(
    title: 'Screens',
    subtitle: 'Pair displays and manage what is playing.',
    action: FilledButton.icon(
      onPressed: () => _pair(c, r),
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('Pair screen'),
    ),
    child: r
        .watch(screensProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => errorBox(e, () => r.invalidate(screensProvider)),
          data: (raw) {
            final list = raw['items'] as List? ?? [];
            if (list.isEmpty)
              return const Notice(
                'No screens paired yet. Open the Pixel8 player on a display and enter its pairing code.',
                icon: Icons.tv_off,
              );
            return Column(
              children: list.map((x) {
                final s = x as Map;
                return Card(
                  child: ListTile(
                    onTap: () => c.go('/screen/${s['id']}'),
                    leading: CircleAvatar(
                      backgroundColor: s['status'] == 'offline' ? coral : mint,
                      child: Icon(
                        Icons.tv,
                        color: s['status'] == 'offline'
                            ? Colors.deepOrange
                            : Colors.green,
                      ),
                    ),
                    title: Text('${s['name']}'),
                    subtitle: Text(
                      '${s['status']} · ${s['campaignId'] == null ? 'No campaign' : 'Campaign assigned'}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              }).toList(),
            );
          },
        ),
  );
}

Future<void> _pair(BuildContext c, WidgetRef r) async {
  final code = TextEditingController(),
      name = TextEditingController(text: 'Living room');
  final ok = await showDialog<bool>(
    context: c,
    builder: (c) => AlertDialog(
      title: const Text('Pair a screen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: code,
            decoration: InputDecoration(
              labelText: 'Pairing code',
              suffixIcon: IconButton(
                tooltip: 'Scan QR code',
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () async {
                  final value = await Navigator.of(c).push<String>(
                    MaterialPageRoute(builder: (_) => const ScanCodePage()),
                  );
                  if (value != null) code.text = value;
                },
              ),
            ),
          ),
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Screen name'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(c, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(c, true),
          child: const Text('Pair'),
        ),
      ],
    ),
  );
  if (ok == true)
    try {
      await r.read(apiProvider).post('/v1/screens/pair', {
        'code': code.text.trim(),
        'name': name.text.trim(),
      });
      r.invalidate(screensProvider);
      if (c.mounted) _snack(c, 'Screen paired.');
    } catch (e) {
      if (c.mounted) _snack(c, 'Could not pair: $e');
    }
}

class ScanCodePage extends StatelessWidget {
  const ScanCodePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scan pairing code')),
    body: MobileScanner(
      onDetect: (capture) {
        final value = capture.barcodes.firstOrNull?.rawValue;
        if (value != null && value.isNotEmpty) {
          Navigator.of(context).pop(extractPairingCode(value));
        }
      },
    ),
  );
}

class ScreenDetailPage extends ConsumerStatefulWidget {
  const ScreenDetailPage({super.key, required this.id});
  final String id;
  @override
  ConsumerState<ScreenDetailPage> createState() => _ScreenDetailState();
}

class _ScreenDetailState extends ConsumerState<ScreenDetailPage> {
  Map? s;
  String? error;
  bool loading = true;
  bool refreshing = false;
  Timer? poller;
  Future<void> load() async {
    if (refreshing) return;
    refreshing = true;
    try {
      s = await ref.read(apiProvider).get('/v1/screens/${widget.id}');
      error = null;
    } catch (e) {
      error = '$e';
    } finally {
      refreshing = false;
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    load();
    poller = Timer.periodic(const Duration(seconds: 5), (_) => load());
  }

  @override
  void dispose() {
    poller?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
    appBar: AppBar(title: const Text('Screen details')),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
        ? Center(child: errorBox(error!, load))
        : s == null
        ? const SizedBox()
        : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                '${s!['name']}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: ink,
                ),
              ),
              Text(
                '${s!['status']} · desired v${s!['desiredVersion']} · playing v${s!['playingVersion'] ?? '—'}',
                style: const TextStyle(color: blue),
              ),
              const SizedBox(height: 18),
              Notice(
                'Last seen: ${s!['lastSeenAt'] ?? 'No heartbeat received yet'}',
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () => _assign(c),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Assign campaign'),
              ),
              const SizedBox(height: 10),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Muted'),
                      value: s!['muted'] ?? false,
                      onChanged: (v) => _update({'muted': v}),
                    ),
                    ListTile(
                      title: const Text('Volume'),
                      subtitle: Slider(
                        value: (s!['volume'] ?? 70).toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 20,
                        label: '${s!['volume']}%',
                        onChanged: (v) =>
                            setState(() => s!['volume'] = v.round()),
                        onChangeEnd: (v) => _update({'volume': v.round()}),
                      ),
                    ),
                    ListTile(
                      title: const Text('Orientation'),
                      trailing: DropdownButton<int>(
                        value: s!['orientation'] ?? 0,
                        items: [0, 90, 180, 270]
                            .map(
                              (v) => DropdownMenuItem(
                                value: v,
                                child: Text('$v°'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) _update({'orientation': v});
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Recent telemetry',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              FutureBuilder(
                future: ref.read(apiProvider).get(
                  '/v1/screens/${widget.id}/telemetry',
                  {'hours': 24},
                ),
                builder: (c, x) {
                  if (!x.hasData)
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(),
                    );
                  if (x.hasError)
                    return Notice('Telemetry unavailable: ${x.error}');
                  final a = x.data['items'] as List? ?? [];
                  if (a.isEmpty)
                    return const Notice(
                      'No telemetry received in the last 24 hours.',
                    );
                  final t = a.first as Map;
                  return Card(
                    child: ListTile(
                      title: Text(
                        'CPU ${t['cpuPercent']}% · ${t['temperatureC'] ?? '—'}°C',
                      ),
                      subtitle: Text(
                        'Memory ${t['memoryUsedBytes']}/${t['memoryTotalBytes']} bytes · ${t['droppedFrames']} dropped frames',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
  );
  Future<void> _update(Map<String, dynamic> v) async {
    try {
      s = await ref.read(apiProvider).patch('/v1/screens/${widget.id}', {
        'expectedDesiredVersion': s!['desiredVersion'],
        ...v,
      });
      setState(() {});
    } catch (e) {
      if (mounted) _snack(context, 'Update failed: $e');
    }
  }

  Future<void> _assign(BuildContext c) async {
    final apps = await ref.read(apiProvider).get('/v1/apps');
    final all = <Map>[];
    for (final a in apps['items'] as List? ?? []) {
      final cs = await ref
          .read(apiProvider)
          .get('/v1/apps/${a['id']}/campaigns');
      for (final x in cs['items'] as List? ?? []) {
        if (x['status'] == 'ready') all.add(x as Map);
      }
    }
    if (!c.mounted) return;
    final pick = await showDialog<Map>(
      context: c,
      builder: (c) => SimpleDialog(
        title: const Text('Ready campaigns'),
        children: all
            .map(
              (x) => SimpleDialogOption(
                onPressed: () => Navigator.pop(c, x),
                child: Text('${x['name']}'),
              ),
            )
            .toList(),
      ),
    );
    if (pick != null) _update({'campaignId': pick['id']});
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext c, WidgetRef r) => PageFrame(
    title: 'Settings',
    subtitle: 'Account and connection preferences.',
    child: Column(
      children: [
        const Notice(
          'Pixel8 keeps your sign-in token in secure device storage.',
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.language, color: blue),
            title: const Text('API address'),
            subtitle: const Text(
              'Set with --dart-define=PIXEL8_API=https://your-api',
            ),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.tonalIcon(
          onPressed: () async {
            try {
              await r.read(apiProvider).logout();
              r.read(selectedAppProvider.notifier).state = '';
              r.invalidate(appsProvider);
              r.invalidate(assetsProvider);
              r.invalidate(screensProvider);
              if (c.mounted) c.go('/login');
            } catch (e) {
              if (c.mounted) _snack(c, 'Sign out failed: $e');
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign out'),
        ),
      ],
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController(), otp = TextEditingController();
  bool sent = false, busy = false;
  String? error;
  @override
  Widget build(BuildContext c) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: blue,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(Icons.tv_rounded, color: Colors.white),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Welcome to Pixel8',
                    style: TextStyle(
                      color: ink,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sent
                        ? 'Enter the verification code sent to your email.'
                        : 'Sign in to manage your screens and campaigns.',
                    style: TextStyle(color: ink.withValues(alpha: .62)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                  ),
                  if (sent) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: otp,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Verification code',
                      ),
                    ),
                  ],
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: busy ? null : _submit,
                      child: busy
                          ? const CircularProgressIndicator()
                          : Text(
                              sent
                                  ? 'Verify and sign in'
                                  : 'Send verification code',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Future<void> _submit() async {
    setState(() => busy = true);
    try {
      final api = PixelApi();
      if (!sent) {
        await api.sendOtp(email.text.trim());
        setState(() => sent = true);
      } else {
        await api.signIn(email.text.trim(), otp.text.trim());
        if (mounted) context.go('/apps');
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}

String extractPairingCode(String input) {
  final uri = Uri.tryParse(input);
  return uri?.queryParameters['code'] ?? input.trim();
}

List<int> missingUploadParts(int count, Map<dynamic, dynamic> etags) =>
    List.generate(
      count,
      (i) => i + 1,
    ).where((number) => !etags.containsKey('$number')).toList();

void recordUploadedPart(
  Map<String, dynamic> etags,
  int partNumber,
  String? etag,
) {
  if (etag == null || etag.isEmpty) {
    throw Exception(
      'Object storage did not return an ETag for part $partNumber.',
    );
  }
  etags['$partNumber'] = etag;
}

void reorderPlaylist(List<Map> items, int oldIndex, int newIndex) {
  if (newIndex > oldIndex) newIndex--;
  final item = items.removeAt(oldIndex);
  items.insert(newIndex, item);
}

void _snack(BuildContext c, String s) =>
    ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(s)));
