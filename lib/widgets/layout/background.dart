import 'dart:io';

import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final String? bgImage;
  final ColorScheme colorScheme;
  
  const BackgroundContainer({
    super.key, 
    this.bgImage, 
    required this.colorScheme
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: bgImage != null
            ? DecorationImage(image: FileImage(File(bgImage!)), fit: BoxFit.cover)
            : null,
          color: bgImage == null
            ? colorScheme.surface
            : null
        ),
      )
    );
  }
}