import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';

class WindowTitleBar extends StatelessWidget {
  const WindowTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: MoveWindow()),
          const WindowButtons()
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    var darkTheme = FluentTheme.of(context).brightness.isDark;

    return Row(
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
        MaximizeWindowButton(
          colors: WindowButtonColors(
            iconNormal: darkTheme ? Colors.white : Colors.black,
            normal: Colors.transparent,
            iconMouseOver: Colors.white,
            iconMouseDown: Colors.white,
            mouseOver: Colors.white.withOpacity(0.1),
            mouseDown: Colors.white.withOpacity(0.2),
          ),
        ),
        CloseWindowButton(
          colors: WindowButtonColors(
            iconNormal: darkTheme ? Colors.white : Colors.black,
            normal: Colors.transparent,
            iconMouseOver: Colors.white,
            iconMouseDown: Colors.black,
            mouseOver: Colors.red,
            mouseDown: Colors.red.withOpacity(0.8)
          ),
        ),
      ],
    );
  }
}