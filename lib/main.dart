import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:mediashin/collections/colors.dart';
import 'package:mediashin/collections/fix_window_stretch_at_launch.dart';
import 'package:mediashin/collections/routes.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(Platform.isWindows);
  _initWindow();
  runApp(const MediashinApp());
}


void _initWindow() async{
  const initSize = Size(960, 540);
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: initSize,
    minimumSize: initSize,
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
    title: 'Mediashin'
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MediashinApp extends StatefulWidget {
  const MediashinApp({super.key});

  @override
  State<MediashinApp> createState() => _MediashinAppState();
}

class _MediashinAppState extends State<MediashinApp> {
  @override
  Widget build(BuildContext context) {
    fixWindowStretchAtLaunch();

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
  accentColor: AppColors.accentColor.toAccentColor(),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Colors.transparent,
  fontFamily: 'NotoSans',
  acrylicBackgroundColor: const Color(0xFF545454),
  menuColor: AppColors.primaryColor,
  dialogTheme: ContentDialogThemeData(
    titleStyle: const TextStyle(
      fontVariations: [
        FontVariation('wght', 600)
      ],
      fontSize: 20,
      height: 28 / 20
    ),
    decoration: BoxDecoration(
      color: AppColors.primaryColor,
      borderRadius: BorderRadius.circular(12),
      boxShadow: kElevationToShadow[6]
    ),
    actionsDecoration: const BoxDecoration(
      color: AppColors.primaryColorDark,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))
    ),
  ),
  buttonTheme: const ButtonThemeData(
    hyperlinkButtonStyle: ButtonStyle(
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontVariations: [
            FontVariation('wght', 400)
          ],
          fontSize: 14,
          height: 20 / 14
        )
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(vertical: 8.0)
      )
    )
  ),
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