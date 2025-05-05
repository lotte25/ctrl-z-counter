import 'dart:io';

import 'package:ctrlz_counter/services/settings.dart';
import 'package:ctrlz_counter/services/system_tray.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:provider/provider.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

import 'services/theme_hive.dart';
import 'providers/keyboard.dart';
import 'providers/background.dart';
import 'providers/database.dart';
import 'providers/discord.dart';

import 'pages/main_app.dart';

void main(List<String> args) async {
  await Hive.initFlutter();
  await Hive.openBox("ctrlz_counter");

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await WindowsSingleInstance.ensureSingleInstance(args, "ctrlz_counter");

  await DatabaseProvider.instance.initialize();
  
  ThemeConfig.storage = HiveStorage();
  
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  launchAtStartup.setup(
    appName: packageInfo.appName,
    appPath: Platform.resolvedExecutable,
    packageName: packageInfo.packageName
  );

  final settings = SettingsService.getSettings();

  bool minimizeToTray = settings["minimizeToTray"];
  bool launchAtWinStartup = settings["launchAtStartup"];

  if (minimizeToTray) {
    await TrayService().initTray();
  }

  launchAtWinStartup ? await launchAtStartup.enable() : await launchAtStartup.disable();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>  RPCProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundProvider()),
        ChangeNotifierProvider(create: (context) => KeyboardProvider(context.read<RPCProvider>()))
      ],
      child: MainApp()
    )
  );

  doWhenWindowReady(() async {
    Size size = Size(854, 480);

    appWindow.minSize = size;
    appWindow.size = size;

    await windowManager.setTitle("Ctrl+Z Counter");
    
    await windowManager.setPreventClose(true);
    await windowManager.setMinimizable(false);
    await windowManager.setAsFrameless();
    await windowManager.setAlignment(Alignment.center, animate: true);

    await windowManager.show();
    await windowManager.focus();
  });
}