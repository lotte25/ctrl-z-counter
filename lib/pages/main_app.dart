import 'package:contador_de_ctrl_z/providers/database.dart';
import 'package:contador_de_ctrl_z/providers/discord.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dynamik_theme/dynamik_theme.dart';

import 'package:contador_de_ctrl_z/pages/main_page.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    setPreventClose();
    DatabaseProvider.instance.initialize();
    Provider.of<RPCProvider>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
  }

  void setPreventClose() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DynamikTheme(
      config: ThemeConfig(
        useMaterial3: true,
        lightScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        darkScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.dark,
        ),
        defaultThemeState: SimpleThemeType.dynamik.themeState,
        builder: (themeData) {
          return themeData.copyWith(
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          );
        },
      ),
      builder: (theme, darkTheme, themeMode) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: [
            const Locale("en", "US")
          ],
          title: "Contador de CTRL + Z",
          themeMode: themeMode, 
          theme: theme,
          darkTheme: darkTheme,
          debugShowCheckedModeBanner: false,
          home: Scaffold(body: MainPage()),
        );
      },
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();

    if (isPreventClose) {
      windowManager.destroy();
    }
  }
}