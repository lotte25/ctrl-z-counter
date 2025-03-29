import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:palette_generator/palette_generator.dart';

String formatDate(DateTime date, {bool includeHour = true}) {
  String formattedDate = "${date.day}/${date.month}/${date.year}";
  if (includeHour) formattedDate += " ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}";
  return formattedDate;
}

Future<Color> extractDominantColor(String path) async {
  PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
    FileImage(File(path)),
    maximumColorCount: 3
  );

  return palette.dominantColor!.color;
}

Future<String> getProgramVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}