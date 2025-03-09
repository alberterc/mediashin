import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';

class WindowTitleBar extends StatefulWidget {
  const WindowTitleBar({super.key, this.backButton = false, this.title});

  final bool backButton;
  final Widget? title;

  @override
  State<WindowTitleBar> createState() => _WindowTitleBarState();
}

class _WindowTitleBarState extends State<WindowTitleBar> with WindowListener {
  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeBrightness = FluentTheme.of(context).brightness;
    return SizedBox(
      height: 31,
      child: Row(
        children: [
          widget.backButton
              ? BackButtonTwo(
                  onPressed: () => GoRouter.of(context).pop(),
                )
              : const SizedBox(),
          Expanded(
              child: DragToMoveArea(
                  child: SizedBox(
            height: double.infinity,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16),
                  child: DefaultTextStyle(
                    style: FluentTheme.of(context).typography.caption!,
                    child: widget.title ?? const SizedBox(),
                  ),
                ),
              ],
            ),
          ))),
          Row(
            children: [
              WindowCaptionButton.minimize(
                brightness: themeBrightness,
                onPressed: () async {
                  bool isMinimized = await windowManager.isMinimized();
                  if (isMinimized) {
                    windowManager.restore();
                  } else {
                    windowManager.minimize();
                  }
                },
              ),
              FutureBuilder<bool>(
                future: windowManager.isMaximized(),
                builder: (context, snapshot) {
                  if (snapshot.data == true) {
                    return WindowCaptionButton.unmaximize(
                      brightness: themeBrightness,
                      onPressed: () => windowManager.unmaximize(),
                    );
                  }
                  return WindowCaptionButton.maximize(
                    brightness: themeBrightness,
                    onPressed: () => windowManager.maximize(),
                  );
                },
              ),
              WindowCaptionButton.close(
                brightness: themeBrightness,
                onPressed: () => windowManager.close(),
              )
            ],
          )
        ],
      ),
    );
  }
}

class BackButtonTwo extends StatelessWidget {
  const BackButtonTwo({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    var res = FluentTheme.of(context).resources;
    return Center(
      child: Button(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.isPressed) {
                return const Color(0xffC42B1C).withOpacity(0.9);
              } else if (states.isHovered) {
                return const Color(0xffC42B1C);
              } else if (states.isDisabled) {
                return res.controlFillColorDisabled;
              } else {
                return Colors.transparent;
              }
            }),
            shape: const WidgetStatePropertyAll(RoundedRectangleBorder()),
            padding: const WidgetStatePropertyAll(EdgeInsets.all(0)),
          ),
          child: Container(
              constraints: const BoxConstraints(minWidth: 46, minHeight: 32),
              child: const Icon(FluentIcons.back,
                  color: Colors.white, size: 12.0))),
    );
  }
}
