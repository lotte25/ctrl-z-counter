import 'package:flutter/material.dart';

class IconOnlyButton extends StatelessWidget {
  final Icon icon;
  final Function()? onPressed;

  const IconOnlyButton({
    super.key,
    required this.icon,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(18),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size(40, 40)
      ),
      child: icon
    );
  }
}