import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mediashin/routes/mediashin_route_page.dart';
import 'package:mediashin/views/about/about_page.dart';
import 'package:mediashin/views/analyze/analyze_page.dart';
import 'package:mediashin/views/convert/convert_page.dart';
import 'package:mediashin/views/extract/extract_page.dart';
import 'package:mediashin/views/home/home_page.dart';
import 'package:mediashin/views/about/license/license_page.dart';

final rootNavigationkey = GlobalKey<NavigatorState>();
final router = GoRouter(
  navigatorKey: rootNavigationkey,
  routes: [
    GoRoute(
      path: '/',
      parentNavigatorKey: rootNavigationkey,
      pageBuilder: (context, state) => MediashinRoutePage(
        key: state.pageKey,
        child: const HomePage()
      ),
    ),
    GoRoute(
      path: '/about',
      parentNavigatorKey: rootNavigationkey,
      pageBuilder: (context, state) => MediashinRoutePage(
        key: state.pageKey,
        child: const AboutPage()
      ),
    ),
    GoRoute(
      path: '/licenses',
      parentNavigatorKey: rootNavigationkey,
      pageBuilder: (context, state) => MediashinRoutePage(
        key: state.pageKey,
        child: const LicensePage()
      ),
    ),
    GoRoute(
      path: '/analyze',
      parentNavigatorKey: rootNavigationkey,
      pageBuilder: (context, state) => MediashinRoutePage(
        key: state.pageKey,
        child: const AnalyzePage()
      ),
    ),
    GoRoute(
      path: '/convert',
      parentNavigatorKey: rootNavigationkey,
      pageBuilder: (context, state) => MediashinRoutePage(
        key: state.pageKey,
        child: const ConvertPage()
      ),
    ),
    GoRoute(
      path: '/extract',
      parentNavigatorKey: rootNavigationkey,
      pageBuilder: (context, state) => MediashinRoutePage(
        key: state.pageKey,
        child: const ExtractPage()
      )
    )
  ],
);