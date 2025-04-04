import 'package:ctrlz_counter/services/settings.dart';
import 'package:flutter/material.dart';

void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      Map<String, dynamic> settings = SettingsService.getSettings();
      bool minimizeToTray = settings["minimizeToTray"];
      bool discordRPC = settings["discordRPC"];
      bool launchAtStartup = settings["launchAtStartup"];

      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              width: 400,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SwitchListTile(
                      title: Text("Minimize to tray"),
                      subtitle: Text("Minimizes the program to the system tray instead of closing completely."),
                      value: minimizeToTray, 
                      onChanged: (value) {
                        setState(() {
                          minimizeToTray = value;
                        });
                        SettingsService.saveSettings(minimizeToTray: value);
                      },
                    ),
                    Divider(),
                    SwitchListTile(
                      title: Text("Discord RPC"),
                      subtitle: Text("Sends activity updates to Discord RPC"),
                      value: discordRPC, 
                      onChanged: (value) {
                        setState(() {
                          discordRPC = value;
                        });
                        SettingsService.saveSettings(discordRPC: value);
                      },
                    ),
                    Divider(),
                    SwitchListTile(
                      title: Text("Launch at startup"),
                      subtitle: Text("Launches the app after Windows finishes starting up"),
                      value: launchAtStartup, 
                      onChanged: (value) {
                        setState(() {
                          launchAtStartup = value;
                        });
                        SettingsService.saveSettings(launchAtStartup: value);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      );
    }
  );
}