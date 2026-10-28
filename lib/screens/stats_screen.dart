import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../providers/progress_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/stat_chip.dart';
import '../widgets/wpm_chart.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final progressState = ref.watch(progressProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);

    final history = progressState.recentHistory;
    final bestWpm = progressState.bestWpmOverall;
    final completedCount = progressState.completedLessonsCount;

    double avgWpm = 0;
    double avgAcc = 0;
    if (history.isNotEmpty) {
      int sumWpm = 0;
      int sumAcc = 0;
      for (var h in history) {
        sumWpm += (h['wpm'] as int);
        sumAcc += (h['accuracy'] as int);
      }
      avgWpm = sumWpm / history.length;
      avgAcc = sumAcc / history.length;
    }

    final wpmHistoryList = history.map((e) => e['wpm'] as int).toList().reversed.toList();

    return Scaffold(
      appBar: const AppNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.get('statsTitle'),
                  style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                // Stat Chips Grid
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    StatChip(icon: Icons.emoji_events, label: loc.get('bestWpm'), value: '$bestWpm'),
                    StatChip(icon: Icons.speed, label: loc.get('avgWpm'), value: '${avgWpm.toInt()}'),
                    StatChip(icon: Icons.gps_fixed, label: loc.get('avgAccuracy'), value: '${avgAcc.toInt()}%'),
                    StatChip(icon: Icons.check_circle, label: 'Completed', value: '$completedCount'),
                  ],
                ),
                const SizedBox(height: 32),
                Text('WPM History (Last Attempts)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                WpmChart(wpmHistory: wpmHistoryList),
                const SizedBox(height: 32),
                Text('Recent Practice History', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Card(
                  child: history.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('No practice history yet. Complete some lessons!')),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: history.length > 10 ? 10 : history.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                child: Text('${item['stars']}⭐', style: const TextStyle(fontSize: 14)),
                              ),
                              title: Text('Lesson ${item['lessonId']}'),
                              subtitle: Text('Date: ${item['date'].toString().substring(0, 10)}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${item['wpm']} WPM', style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 16),
                                  Text('${item['accuracy']}% Acc', style: const TextStyle(color: Colors.green)),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
