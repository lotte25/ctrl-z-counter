import 'package:ctrlz_counter/widgets/dialogs/personalization_dialog.dart';
import 'package:flutter/material.dart';

import 'package:ctrlz_counter/widgets/buttons/left_rail_button.dart';

class PersonalizationButton extends StatelessWidget {
  final ColorScheme colorScheme;

  const PersonalizationButton({
    super.key,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return LeftRailButton(
      icon: Icon(Icons.brush_outlined),
      colorScheme: colorScheme,
      onPressed: () {
        showPersonalizationDialog(context: context);
      }
    );
  }
}
