import 'package:flutter/material.dart';
import 'package:elapsed_time_display/elapsed_time_display.dart';

String formatSessionDuration(Duration duration) {
  int totalDays = duration.inDays;
  int months = totalDays ~/ 30;  // Aproximado
  int weeks = (totalDays % 30) ~/ 7;
  int days = totalDays % 7;
  int hours = duration.inHours % 24;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  List<String> parts = [];
  if (months > 0) parts.add("${months}mo");
  if (weeks > 0) parts.add("${weeks}w");
  if (days > 0) parts.add("${days}d");
  if (hours > 0) parts.add("${hours}h");
  if (minutes > 0) parts.add("${minutes}m");
  if (seconds > 0) parts.add("${seconds}s");

  return parts.isEmpty ? "0m" : parts.join(" ");
}

class ElapsedCounter extends StatelessWidget {
  final String currentSession;
  final DateTime currentSessionTime;
  final ColorScheme colorScheme;
  final DateTime? finishedAt;
  
  const ElapsedCounter({
    super.key, 
    required this.currentSession,
    required this.currentSessionTime,
    required this.colorScheme,
    this.finishedAt
  });


  @override
  Widget build(BuildContext context) {
    if (finishedAt != null) {
      final duration = finishedAt!.difference(currentSessionTime);
      final formattedDuration = formatSessionDuration(duration); 
      
      return Tooltip(
        message: formattedDuration,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Text(
          "Took $formattedDuration",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
        ),
      );
    }
    return ElapsedTimeDisplay(
      startTime: currentSession == "default" 
        ? DateTime.now() 
        : currentSessionTime,
      immediateRebuildOnUpdate: true,
      formatter: (elapsedTime) {
        String hours = elapsedTime.hours.toString().padLeft(2, "0");
        String minutes = elapsedTime.minutes.toString().padLeft(2, "0");
        String seconds = elapsedTime.seconds.toString().padLeft(2, "0");
        
        return "Elapsed: $hours:$minutes:$seconds";
      },
      style: TextStyle(
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurface,
      ),
    );
  }
}