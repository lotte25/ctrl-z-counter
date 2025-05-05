import 'dart:io';
import 'dart:math';

import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ctrlz_counter/providers/background.dart';
import 'package:ctrlz_counter/utils/utils.dart';

final _colors = List.generate(
  7,
  (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withAlpha(255),
);

void showPersonalizationDialog({
  required BuildContext context,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      final colorScheme = Theme.of(context).colorScheme;
      
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 380,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(16))
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    'Select a global color',
                    style:
                    Theme.of(
                      context,
                    ).textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 10, 
                  runSpacing: 10,
                  children: _colors.map((c) {
                    return GestureDetector(
                      onTap: () {
                        DynamikTheme.of(context).setCustomColorMode(c);
                      },
                      child: CircleAvatar(
                        backgroundColor: c,
                      ),
                    );
                  }).toList()
                ),
                SizedBox(height: 15),
                const Divider(),
                SizedBox(height: 15),
                Builder(
                  builder: (context) {
                    final imagePath = context.select<BackgroundProvider, String?>(
                      (bgState) => bgState.previewImage ?? bgState.backgroundImage
                    );

                    return Container(
                      width: 340,
                      height: 190,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        image: imagePath != null 
                          ? DecorationImage(
                              image: FileImage(File(imagePath)), 
                              fit: BoxFit.cover
                            )
                          : null
                      ),
                      alignment: Alignment.center,
                      child: imagePath == null
                        ? Text("No image selected", style: TextStyle(color: colorScheme.primaryFixed))
                        : null,
                    );
                  }
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        if (pickedFile != null && context.mounted) {
                          context.read<BackgroundProvider>().setPreview(pickedFile.path);
                        }
                      }, 
                      label: Text("Examine"),
                      icon: Icon(Icons.image)
                    ),
                    SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: () async {
                        context.read<BackgroundProvider>().applyBackground();
                        Color color = await extractDominantColor(
                          context.read<BackgroundProvider>().backgroundImage!
                        );
                        if (context.mounted) DynamikTheme.of(context).setCustomColorMode(color);
                      }, 
                      label: Text("Apply"),
                      icon: Icon(Icons.check_circle_outline_rounded)
                    ),
                    SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<BackgroundProvider>().reset();
                      }, 
                      label: Text("Reset"),
                      icon: Icon(Icons.restore)
                    )
                  ],
                ),
                SizedBox(height: 10),
                Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: ThemeMode.values.map((v) => StatefulBuilder(
                    builder: (context, setState) {
                      return InputChip(
                        label: Text(v.name),
                        selected: DynamikTheme.of(context).themeState.themeMode == v,
                        onPressed: () {
                          DynamikTheme.of(context).setThemeMode(v);
                          setState(() {});
                        },
                      );
                    }
                  )).toList(),
                )
              ],
            ),
          ),
        )
      );
    }
  );
}