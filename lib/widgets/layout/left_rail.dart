import 'package:ctrlz_counter/widgets/buttons/discord_button.dart';
import 'package:ctrlz_counter/widgets/buttons/info_button.dart';
import 'package:ctrlz_counter/widgets/buttons/personalization.dart';
import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(40)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PersonalizationButton(colorScheme: colorScheme),
            DiscordButton(colorScheme: colorScheme),
            InfoButton(colorScheme: colorScheme)
          ]
        ),
      ),
    );
  }
}
