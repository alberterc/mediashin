import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:mediashin/collections/routes.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  assert(Platform.isWindows);
  WidgetsFlutterBinding.ensureInitialized();
  _initWindow();
  runApp(const MediashinApp());
}

void _initWindow() => doWhenWindowReady(() async {
  await SystemTheme.accentColor.load();
  const initialSize = Size(960, 540);
  appWindow
    ..minSize = initialSize
    ..size = initialSize
    ..alignment = Alignment.center
    ..show();
});

class MediashinApp extends StatelessWidget {
  const MediashinApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      debugShowCheckedModeBanner: false, // remove after development
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
      title: 'Mediashin',
      color: SystemTheme.accentColor.accent.toAccentColor(),
      locale: const Locale('en', 'US'),
      darkTheme: _createTheme(Brightness.dark),
      theme: _createTheme(Brightness.light),
    );
  }
}

FluentThemeData _createTheme(Brightness brightness) => FluentThemeData(
  brightness: brightness,
  accentColor: SystemTheme.accentColor.accent.toAccentColor(),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.transparent,
  fontFamily: 'NotoSans',
  typography: const Typography.raw(
    caption: TextStyle(
      fontVariations: [
        FontVariation('wght', 400)
      ],
      fontSize: 12,
      height: 16 / 12
    ),
    body: TextStyle(
      fontVariations: [
        FontVariation('wght', 400)
      ],
      fontSize: 14,
      height: 20 / 14
    ),
    bodyStrong: TextStyle(
      fontVariations: [
        FontVariation('wght', 600)
      ],
      fontSize: 14,
      height: 20 / 14
    ),
    bodyLarge: TextStyle(
      fontVariations: [
        FontVariation('wght', 400)
      ],
      fontSize: 18,
      height: 24 / 18
    ),
    subtitle: TextStyle(
      fontVariations: [
        FontVariation('wght', 600)
      ],
      fontSize: 20,
      height: 28 / 20
    ),
    title: TextStyle(
      fontVariations: [
        FontVariation('wght', 600)
      ],
      fontSize: 28,
      height: 36 / 28
    ),
    titleLarge: TextStyle(
      fontVariations: [
        FontVariation('wght', 600)
      ],
      fontSize: 40,
      height: 52 / 40
    ),
    display: TextStyle(
      fontVariations: [
        FontVariation('wght', 600)
      ],
      fontSize: 68,
      height: 92 / 68
    ),
  )
);