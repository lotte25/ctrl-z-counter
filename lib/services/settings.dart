import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static final Box _box = Hive.box("ctrlz_counter");

  static Future<void> saveSettings({
    bool? minimizeToTray,
    bool? discordRPC,
    bool? launchAtStartup
  }) async {
    Map<String, dynamic> settings = _box.get("settings", defaultValue: {
      "minimizeToTray": true,
      "discordRPC": true,
      "launchAtStartup": false
    });

    if (minimizeToTray != null) settings["minimizeToTray"] = minimizeToTray;
    if (discordRPC != null) settings["discordRPC"] = discordRPC;
    if (launchAtStartup != null) settings["launchAtStartup"] = launchAtStartup;

    await _box.put("settings", settings);
  }

  static Map<String, dynamic> getSettings() {
    return _box.get("settings", defaultValue: {
      "minimizeToTray": true,
      "discordRPC": true,
      "launchAtStartup": false
    });
  }
}