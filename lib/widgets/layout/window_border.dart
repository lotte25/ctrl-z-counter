import 'package:flutter/material.dart';

class WindowBorder extends StatelessWidget {
  const WindowBorder({
    super.key,
    required this.colorScheme,
  });

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.secondary, // Color del borde
            width: 5, // Grosor del borde
          ),
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
        ),
      ),
    );
  }
}