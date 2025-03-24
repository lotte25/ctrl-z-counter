import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
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
  await WindowsSingleInstance.ensureSingleInstance(args, "ctrlz_counter");
  await windowManager.ensureInitialized();
  await DatabaseProvider.instance.initialize();

  ThemeConfig.storage = HiveStorage();
  
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
    const initialSize = Size(854, 480);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
  
    await windowManager.show();
    await windowManager.focus();
  });
}