import 'package:flutter/material.dart';


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
              onFinish();
            }, 
            label: Text("Continue"),
            icon: Icon(Icons.check_circle_outline)
          )
        ],
      );
    }
  );
}