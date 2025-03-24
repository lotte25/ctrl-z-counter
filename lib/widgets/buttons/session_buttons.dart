import 'package:contador_de_ctrl_z/widgets/buttons/icon_only_button.dart';
import 'package:flutter/material.dart';

class SessionButtons extends StatelessWidget {
  final VoidCallback onSet;
  final VoidCallback onDelete;
  final VoidCallback onAdd;

  const SessionButtons({
    super.key,
    required this.onSet,
    required this.onDelete,
    required this.onAdd
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton.icon(
          onPressed: onSet, 
          label: Text("Set"),
          icon: Icon(Icons.check)
        ),
        IconOnlyButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
        IconOnlyButton(
          icon: Icon(Icons.add),
          onPressed: onAdd,  
        ) 
      ]
    );
  }
}