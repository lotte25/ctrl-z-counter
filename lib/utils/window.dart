  import 'package:window_manager/window_manager.dart';

void fadeInWindow() async {
    await windowManager.setOpacity(0.0);
    await windowManager.show();
    for (double opacity = 0.0; opacity <= 1.0; opacity += 0.1) {
      await Future.delayed(Duration(milliseconds: 15));
      await windowManager.setOpacity(opacity);
    }
  }

void fadeOutWindow() async {
  for (double opacity = 1.0; opacity >= 0.0; opacity -= 0.1) {
    await Future.delayed(Duration(milliseconds: 15));
    await windowManager.setOpacity(opacity);
  }
  await windowManager.hide();
}