import 'dart:io';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:palette_generator/palette_generator.dart';

String formatDate(DateTime date, {bool includeHour = true}) {
  String formattedDate = "${date.day}/${date.month}/${date.year}";
  if (includeHour) formattedDate += " ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
  return formattedDate;
}

Future<List<Color>> extractDominantColors(String path) async {
  PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
    FileImage(File(path)),
    size: const Size(512, 512),
    maximumColorCount: 7
  );
  final List<Color> colors = palette.colors.toList();

  for (var color in colors) {
    print("Dominant color: ${color.value.toRadixString(16)}");
  }
  return colors;
}

Future<String> getProgramVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}