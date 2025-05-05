import 'package:ctrlz_counter/services/settings.dart';
import 'package:ctrlz_counter/utils/window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:dynamik_theme/dynamik_theme.dart';

import 'package:ctrlz_counter/providers/database.dart';
import 'package:ctrlz_counter/providers/discord.dart';
import 'package:ctrlz_counter/pages/main_page.dart';

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
    DatabaseProvider.instance.initialize();
    Provider.of<RPCProvider>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
  }

  @override
  Widget build(BuildContext context) {
    final initialColor = Colors.tealAccent.shade700;

    return DynamikTheme(
      config: ThemeConfig(
        useMaterial3: true,
        lightScheme: ColorScheme.fromSeed(seedColor: initialColor),
        darkScheme: ColorScheme.fromSeed(
          seedColor: initialColor,
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
          title: "Ctrl+Z Counter",
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
    fadeOutWindow();

    if (SettingsService.getSettings()["minimizeToTray"]) return;
    
    await windowManager.destroy();
  }
}