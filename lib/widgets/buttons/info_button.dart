import 'package:ctrlz_counter/widgets/buttons/left_rail_button.dart';
import 'package:flutter/material.dart';

class InfoButton extends StatelessWidget {
  final ColorScheme colorScheme;
  
  const InfoButton({super.key, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return LeftRailButton(
      icon: Icon(Icons.info_outline), 
      colorScheme: colorScheme,
      onPressed: () {},
    );
  }
}