import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:mediashin/collections/colors.dart';

class MediashinRoutePage extends CustomTransitionPage {
  MediashinRoutePage({
    super.key,
    required super.child
  }) : super(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    }
  );

  @override
  Route createRoute(BuildContext context) {
    return FluentPageRoute(
      builder: (context) => WindowBorder(
        color: AppColors.primaryColor,
        child: Container(
          color: AppColors.primaryColor,
          child: child,
        )
      ),
      settings: this,
      maintainState: maintainState,
      barrierLabel: barrierLabel,
      fullscreenDialog: fullscreenDialog
    );
  }
}