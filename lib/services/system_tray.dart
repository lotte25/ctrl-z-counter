import 'package:ctrlz_counter/utils/window.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayService with TrayListener {
  TrayService._internal();
  static final TrayService _instance = TrayService._internal();
  factory TrayService() => _instance;

  Future<void> initTray() async {
    trayManager.addListener(this);

    await trayManager.setIcon("assets/images/gatologo.ico");
    await trayManager.setToolTip("Ctrl + Z Counter");
    await trayManager.setContextMenu(Menu(items: [
        MenuItem(label: "Show program", onClick: (_) => fadeInWindow()),
        MenuItem(label: "Exit", onClick: (_) => exitApp())
      ])
    );
  }

  void exitApp() {
    trayManager.destroy();
    windowManager.destroy();
  }

  @override
  void onTrayIconMouseDown() {
    fadeInWindow(); 
  }

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }
}