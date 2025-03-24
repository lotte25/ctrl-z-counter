import 'package:flutter/material.dart';

class LeftRailButton extends StatelessWidget {
  final Icon icon;
  final ColorScheme colorScheme;
  final Function()? onPressed;

  const LeftRailButton({
    super.key, 
    this.onPressed, 
    required this.icon,
    required this.colorScheme
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.onSurface,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: onPressed, 
          icon: icon,
          color: colorScheme.surface
        ),
      ),
    );
  }
}