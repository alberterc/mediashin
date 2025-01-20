import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mediashin/components/mediashin_route_page.dart';
import 'package:mediashin/pages/analyze_page.dart';
import 'package:mediashin/pages/convert_page.dart';
import 'package:mediashin/pages/extract_page.dart';
import 'package:mediashin/pages/home_page.dart';

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