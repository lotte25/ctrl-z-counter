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
  return colors;
}

String formatDuration(int milliseconds) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');

  final duration = Duration(milliseconds: milliseconds);

  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  
  return "$hours:$minutes:$seconds";
}

String calculateAverageClicksPerDay(List<DateTime> timestamps) {
  if (timestamps.isEmpty) return "0.0";

  final clicksPerDay = <String, int>{};
  
  for (final timestamp in timestamps) {
    final date = "${timestamp.year}-${timestamp.month}-${timestamp.day}";
    clicksPerDay.update(date, (value) => value + 1, ifAbsent: () => 1);      
  }

  final totalClicks = clicksPerDay.values.reduce((a, b) => a + b);
  final average = totalClicks / clicksPerDay.length;

  return average.toStringAsFixed(2);
}

Future<String> getProgramVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}