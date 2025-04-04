import 'package:flutter/material.dart';

import 'package:ctrlz_counter/services/audio_player.dart';
import 'package:ctrlz_counter/widgets/dialogs/confetti_overlay.dart';
import 'package:ctrlz_counter/widgets/dialogs/countdown.dart';

void showFinishDialog(BuildContext context, ColorScheme colorScheme, {required VoidCallback onFinish}) {
  showDialog(
    context: context, 
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text("Are you sure to finish this session?"),
        content: Text("This action is irreversible, so be sure you've finished your drawing before marking it as finished.\nI'm watching you."),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(), 
            label: Text("Cancel"),
            icon: Icon(Icons.cancel_outlined),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              showCountdown(context: context, onEnd: () async {
                showConfetti(context, colorScheme);
                await playSound("yippie");  
                await playSound("confetti");
                onFinish(); 
              });
            }, 
            label: Text("Continue"),
            icon: Icon(Icons.check_circle_outline)
          )
        ],
      );
    }
  );
}