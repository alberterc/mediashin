import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

class WindowTitleBar extends StatefulWidget {
  const WindowTitleBar({
    super.key,
    this.backButton = false,
    this.title
  });

  final bool backButton;
  final String? title;

  @override
  State<WindowTitleBar> createState() => _WindowTitleBarState();
}

class _WindowTitleBarState extends State<WindowTitleBar> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    var darkTheme = FluentTheme.of(context).brightness.isDark;
    return WindowTitleBarBox(
      child: Row(
        children: [
          widget.backButton
            ? BackButton(
              colors: WindowButtonColors(
                iconNormal: darkTheme ? Colors.white : Colors.black,
                normal: Colors.transparent,
                iconMouseOver: Colors.white,
                mouseOver: Colors.red,
                mouseDown: Colors.red.withOpacity(0.8)
              ),
              onPressed: () => GoRouter.of(context).pop(),
            )
            : const SizedBox(),
          Expanded(
            child: MoveWindow(
              onDoubleTap: maximizeOrRestore,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title ?? '',
                    style: FluentTheme.of(context).typography.caption,
                  ),
                ),
              )
            )
          ),
          Row(
            children: [
              MinimizeWindowButton(
                colors: WindowButtonColors(
                  iconNormal: darkTheme ? Colors.white : Colors.black,
                  normal: Colors.transparent,
                  iconMouseOver: Colors.white,
                  iconMouseDown: Colors.white,
                  mouseOver: Colors.white.withOpacity(0.1),
                  mouseDown: Colors.white.withOpacity(0.2),
                ),
              ),
              appWindow.isMaximized
                ? RestoreWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: darkTheme ? Colors.white : Colors.black,
                    normal: Colors.transparent,
                    iconMouseOver: Colors.white,
                    iconMouseDown: Colors.white,
                    mouseOver: Colors.white.withOpacity(0.1),
                    mouseDown: Colors.white.withOpacity(0.2),
                  ),
                  onPressed: maximizeOrRestore,
                )
                : MaximizeWindowButton(
                  colors: WindowButtonColors(
                    iconNormal: darkTheme ? Colors.white : Colors.black,
                    normal: Colors.transparent,
                    iconMouseOver: Colors.white,
                    iconMouseDown: Colors.white,
                    mouseOver: Colors.white.withOpacity(0.1),
                    mouseDown: Colors.white.withOpacity(0.2),
                  ),
                  onPressed: maximizeOrRestore
                ),
              CloseWindowButton(
                colors: WindowButtonColors(
                  iconNormal: darkTheme ? Colors.white : Colors.black,
                  normal: Colors.transparent,
                  iconMouseOver: Colors.white,
                  iconMouseDown: Colors.black,
                  mouseOver: Colors.red,
                  mouseDown: Colors.red.withOpacity(0.8),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class BackButton extends WindowButton {
  BackButton({
    super.key,
    super.colors,
    super.onPressed,
    bool? animate
  }) : super(
    animate: animate ?? false,
    iconBuilder: (buttonContext) => Icon(
      FluentIcons.back,
      color: buttonContext.iconColor,
      size: 12.0,
    ),
    padding: EdgeInsets.zero
  );
}