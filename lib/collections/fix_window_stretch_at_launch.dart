import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

void fixWindowStretchAtLaunch() {
  if (Platform.isWindows) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) async {
      await Future<void>.delayed(const Duration(milliseconds: 100), () {
        windowManager.getSize().then((Size value) {
          windowManager.setSize(
            Size(value.width + 1, value.height + 1)
          );
          windowManager.setSize(
            Size(value.width, value.height)
          );
        });
      });
    });
  }
}