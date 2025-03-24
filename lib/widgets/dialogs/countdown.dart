import 'dart:async';

import 'package:flutter/material.dart';

void showCountdown({
  required BuildContext context, 
  required Future<void> Function() onEnd}
  ) {
  showDialog(
    context: context, 
    barrierDismissible: false,
    builder: (BuildContext context) {
      int secondsLeft = 3;
      Timer? timer;

      return StatefulBuilder(
        builder: (builderContext, setState) {
          timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
            if (secondsLeft == 1) {
              timer.cancel();
              Navigator.of(builderContext).pop();
              onEnd();
            } else {
              setState(() {
                secondsLeft--;
              });
            }
          });

          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  "$secondsLeft", 
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  );
}