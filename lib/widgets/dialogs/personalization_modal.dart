import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamik_theme/dynamik_theme.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ctrlz_counter/utils/utils.dart';
import 'package:ctrlz_counter/widgets/buttons/left_rail_button.dart';
import 'package:ctrlz_counter/providers/background.dart';

final _colors = List.generate(
  7,
  (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt()).withAlpha(255),
);

class PersonalizationModal extends StatelessWidget {
  final ColorScheme colorScheme;

  const PersonalizationModal({
    super.key,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    final themeState = DynamikTheme.of(context).themeState;

    return LeftRailButton(
      icon: Icon(Icons.brush_outlined),
      colorScheme: colorScheme,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Consumer<BackgroundProvider>(
                builder: (context, bgState, child) {
                  return Container(
                    width: 380,
                    padding: EdgeInsets.all(8),
                     decoration: BoxDecoration(
                      color: Colors.black.withAlpha(75),
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
                          Container(
                            width: 340,
                            height: 190,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              image: (bgState.previewImage ?? bgState.backgroundImage) != null 
                                ? DecorationImage(
                                    image: FileImage(File(bgState.previewImage ?? bgState.backgroundImage!)), 
                                    fit: BoxFit.cover
                                  )
                                : null
                            ),
                            alignment: Alignment.center,
                            child: (bgState.previewImage ?? bgState.backgroundImage) == null
                              ? Text("No image selected", style: TextStyle(color: colorScheme.primaryFixed))
                              : null,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FilledButton.icon(
                                onPressed: () async {
                                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    bgState.setPreview(pickedFile.path);
                                  }
                                }, 
                                label: Text("Examine"),
                                icon: Icon(Icons.image)
                              ),
                              SizedBox(width: 10),
                              FilledButton.icon(
                                onPressed: () async {
                                  bgState.applyBackground();
                                  Color color = await extractDominantColor(bgState.backgroundImage!);
                                  DynamikTheme.of(context).setCustomColorMode(color);
                                }, 
                                label: Text("Apply"),
                                icon: Icon(Icons.check_circle_outline_rounded)
                              ),
                              SizedBox(width: 10),
                              FilledButton.icon(
                                onPressed: () {
                                  bgState.reset();
                                }, 
                                label: Text("Reset"),
                                icon: Icon(Icons.restore)
                              )
                            ],
                          ),
                          Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: ThemeMode.values.map((v) => InputChip(
                              label: Text(v.name),
                              selected: themeState.themeMode == v,
                              onPressed: () {
                                DynamikTheme.of(context).setThemeMode(v);
                              },
                            )).toList(),
                          )
                        ],
                      ),
                    ),
                  );
                }
              ),
            );
          }
        );
      }
    );
  }
}