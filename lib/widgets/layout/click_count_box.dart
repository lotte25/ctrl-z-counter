import 'package:ctrlz_counter/providers/keyboard.dart';
import 'package:ctrlz_counter/utils/utils.dart';
import 'package:elapsed_time_display/elapsed_time_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClickCountBox extends StatelessWidget {
  final ColorScheme colorScheme;
  final DateTime? selectedDate;
  final int? clicksForSelectedDate;
  final DateTime currentSessionTime;

  const ClickCountBox({
    super.key,
    required this.colorScheme,
    required this.selectedDate,
    required this.clicksForSelectedDate,
    required this.currentSessionTime
  });

  @override
  Widget build(BuildContext context) {
    final counts = context.select<KeyboardProvider, SessionCounts>((kbState) => kbState.counts);
    final currentSession = context.select<KeyboardProvider, String>((kbState) => kbState.currentSession);

    return SizedBox(
      height: 250,
      width: 250,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedDate != null)
                Text(
                  "Clicks from ${formatDate(selectedDate!, includeHour: false).split(" ")[0]}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                  ),
                ),
              Text(
                "${clicksForSelectedDate ?? counts.undoCount}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 40, 
                  fontWeight: FontWeight.bold, 
                  color: colorScheme.onPrimaryContainer
                ),
              ),
              Container(
                height: 5,
                width: 70,
                decoration: BoxDecoration(
                  color: colorScheme.onPrimaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 4),
              Text(
                "${counts.todayCount == counts.undoCount ? "^" : counts.todayCount}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                ),
              ),
              Text(
                "Today",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onPrimaryContainer.withValues(alpha: 0.7),
                  
                ),
              ),
              SizedBox(height: 16),
              Container(
                width: 200,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Tooltip(
                      message: currentSession,
                      child: Text(
                        "Session: $currentSession",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface
                        ),
                      ),
                    ),
                    ElapsedTimeDisplay(
                      startTime: currentSession == "default" 
                        ? DateTime.now() 
                        : currentSessionTime,
                      immediateRebuildOnUpdate: true,
                      formatter: (elapsedTime) {
                        String hours = elapsedTime.hours.toString().padRight(2, "0");
                        String minutes = elapsedTime.minutes.toString().padLeft(2, "0");
                        String seconds = elapsedTime.seconds.toString().padLeft(2, "0");
    
                        return "Elapsed: $hours:$minutes:$seconds";
                      },
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}