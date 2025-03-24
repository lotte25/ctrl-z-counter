import 'package:flutter/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    
    final buttonColors = WindowButtonColors(
      iconNormal: colorScheme.primary,
      mouseOver: colorScheme.primaryFixed,
      mouseDown: colorScheme.primaryFixed,
      iconMouseOver: colorScheme.primaryContainer,
      iconMouseDown: colorScheme.primaryContainer
    );

    final closeButtonColors = WindowButtonColors(
      mouseOver: colorScheme.primaryFixed,
      mouseDown: colorScheme.primaryFixed,
      iconNormal: colorScheme.primary,
      iconMouseOver: colorScheme.primaryContainer
    );

    return WindowTitleBarBox(
      child: Row(
        children: [
          Expanded(child: MoveWindow()),
          Row(
            children: [
            MinimizeWindowButton(
              colors: buttonColors, 
              animate: true
            ),
            CloseWindowButton(
              colors: closeButtonColors, 
              animate: true
            )
          ]),
          const SizedBox(width: 8)
        ]
      ),
    );
  }
}