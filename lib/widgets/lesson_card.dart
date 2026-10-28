import 'package:flutter/material.dart';
import '../data/models/lesson_model.dart';
import '../providers/progress_provider.dart';
import 'star_row.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final LessonProgress? progress;
  final bool isUnlocked;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.progress,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = progress?.isCompleted ?? false;
    final stars = progress?.stars ?? 0;

    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.5,
      child: Card(
        elevation: isUnlocked ? 3 : 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: isUnlocked ? onTap : null,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withOpacity(0.1)
                            : (isUnlocked ? theme.colorScheme.primary.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${lesson.number}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? Colors.green
                              : (isUnlocked ? theme.colorScheme.primary : Colors.grey),
                        ),
                      ),
                    ),
                    if (!isUnlocked)
                      const Icon(Icons.lock, color: Colors.grey, size: 20)
                    else if (isCompleted)
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  lesson.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StarRow(stars: stars, size: 18),
                    if (progress != null && progress!.bestWpm > 0)
                      Text(
                        '${progress!.bestWpm} WPM',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
