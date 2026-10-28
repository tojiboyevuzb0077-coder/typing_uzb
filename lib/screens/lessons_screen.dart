import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_localizations.dart';
import '../data/mock/lessons_data.dart';
import '../data/models/lesson_model.dart';
import '../providers/progress_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/lesson_card.dart';
import '../widgets/progress_bar.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final progressState = ref.watch(progressProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);

    final completedCount = progressState.completedLessonsCount;
    final totalCount = LessonsData.allLessons.length;
    final overallProgress = completedCount / totalCount;

    // Group lessons by category
    final Map<LessonCategory, List<Lesson>> categories = {};
    for (var lesson in LessonsData.allLessons) {
      categories.putIfAbsent(lesson.category, () => []).add(lesson);
    }

    return Scaffold(
      appBar: const AppNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      loc.get('lessonsTitle'),
                      style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Chip(
                      label: Text('$completedCount / $totalCount Completed'),
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                      labelStyle: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ProgressBar(
                  progress: overallProgress,
                  height: 16,
                  label: loc.get('overallProgress'),
                ),
                const SizedBox(height: 32),
                ...categories.entries.map((entry) {
                  final categoryTitle = _getCategoryTitle(entry.key);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          categoryTitle,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 260,
                          mainAxisExtent: 170,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          final lesson = entry.value[index];
                          final progress = progressState.lessonProgressMap[lesson.id];
                          final isUnlocked = ref.read(progressProvider.notifier).isLessonUnlocked(lesson.id);

                          return LessonCard(
                            lesson: lesson,
                            progress: progress,
                            isUnlocked: isUnlocked,
                            onTap: () => context.go('/lesson/${lesson.id}'),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoryTitle(LessonCategory category) {
    switch (category) {
      case LessonCategory.homeRow:
        return 'Home Row';
      case LessonCategory.topRow:
        return 'Top Row';
      case LessonCategory.bottomRow:
        return 'Bottom Row';
      case LessonCategory.numbers:
        return 'Numbers & Symbols';
      case LessonCategory.words:
        return 'Common Words';
      case LessonCategory.sentences:
        return 'Sentences & Paragraphs';
    }
  }
}
