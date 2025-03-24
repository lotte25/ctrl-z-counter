import 'package:contador_de_ctrl_z/widgets/buttons/discord_button.dart';
import 'package:flutter/material.dart';
import 'package:contador_de_ctrl_z/widgets/dialogs/personalization_modal.dart';

class LeftRail extends StatelessWidget {
  const LeftRail({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 50,
        margin: EdgeInsets.all(16),
        // padding: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(40)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PersonalizationModal(colorScheme: colorScheme),
            DiscordButton(colorScheme: colorScheme)
          ]
        ),
      ),
    );
  }
}
