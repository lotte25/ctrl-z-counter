import 'package:ctrlz_counter/widgets/buttons/left_rail_button.dart';
import 'package:ctrlz_counter/widgets/dialogs/settings.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  final ColorScheme colorScheme;

  const SettingsButton({
    super.key, 
    required this.colorScheme
  });

  @override
  Widget build(BuildContext context) {
    return LeftRailButton(
      icon: Icon(Icons.settings),
      colorScheme: colorScheme,
      onPressed: () {
        showSettingsDialog(context);                                                                                    
      }
    );
  }
}