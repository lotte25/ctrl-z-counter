import 'package:ctrlz_counter/providers/keyboard.dart';
import 'package:ctrlz_counter/services/database.dart';
import 'package:flutter/material.dart';
import 'package:ctrlz_counter/utils/utils.dart';
import 'package:provider/provider.dart';

void showSessionResults(BuildContext context, Session session) {
  showDialog(
    context: context, 
    builder: (BuildContext ctx) {
      final colorScheme = Theme.of(ctx).colorScheme;
      final counts = ctx.select<KeyboardProvider, SessionCounts>((kbState) => kbState.counts);
      final sessionTime = formatDuration(DateTime.now().difference(session.createdAt).inMilliseconds);

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 380,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Text(
                     "Session finished!",
                     style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary
                     ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      width: 1
                    )
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            context,
                            title: "Total Clicks",
                            value: "${counts.undoCount}",
                            icon: Icons.touch_app,
                          ),
                          _buildStatCard(
                            context,
                            title: "Days",
                            value: "${session.createdAt.difference(DateTime.now()).inDays.abs()}",
                            icon: Icons.calendar_today,
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(
                            context, 
                            title: "Session time", 
                            value: sessionTime, 
                            icon: Icons.timer
                          ),
                          // Calculation for average clicks/day
                          FutureBuilder(
                            future: AppDatabase.instance.getClickTimestamps(sessionName: session.name),
                            builder: (context, snapshot) {
                              late final String averageText;
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                averageText = "oops..";
                              } else {
                                averageText = calculateAverageClicksPerDay(
                                  snapshot.data!.map((date) => DateTime.parse(date)).toList()
                                );
                              }

                              return _buildStatCard(
                                context, 
                                title: "Avg. clicks/day", 
                                value: averageText, 
                                icon: Icons.timelapse
                              );
                            }
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.date_range,
                              size: 18,
                              color: colorScheme.onSurfaceVariant
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Started: ${formatDate(DateTime.now())}",
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant
                              ),
                            ),
                          ],
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
  );
}

Widget _buildStatCard(BuildContext context, {required String title, required String value, required IconData icon}) {
  return Container(
    width: 120,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}