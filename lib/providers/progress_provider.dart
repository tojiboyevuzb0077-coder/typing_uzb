import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonProgress {
  final int stars; // 0 to 3
  final int bestWpm;
  final bool isCompleted;

  const LessonProgress({
    this.stars = 0,
    this.bestWpm = 0,
    this.isCompleted = false,
  });
}

class ProgressState {
  final Map<String, LessonProgress> lessonProgressMap;
  final List<Map<String, dynamic>> recentHistory;

  ProgressState({
    required this.lessonProgressMap,
    required this.recentHistory,
  });

  int get totalStars {
    int sum = 0;
    lessonProgressMap.forEach((_, p) => sum += p.stars);
    return sum;
  }

  int get completedLessonsCount {
    int count = 0;
    lessonProgressMap.forEach((_, p) => {if (p.isCompleted) count++});
    return count;
  }

  int get bestWpmOverall {
    int maxWpm = 0;
    lessonProgressMap.forEach((_, p) => {if (p.bestWpm > maxWpm) maxWpm = p.bestWpm});
    return maxWpm;
  }
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  ProgressNotifier() : super(ProgressState(lessonProgressMap: {}, recentHistory: [])) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, LessonProgress> map = {};
    
    // Lesson 1 is unlocked by default
    map['l1'] = const LessonProgress(stars: 0, bestWpm: 0, isCompleted: false);

    for (int i = 1; i <= 20; i++) {
      final id = 'l$i';
      final stars = prefs.getInt('${id}_stars') ?? 0;
      final wpm = prefs.getInt('${id}_wpm') ?? 0;
      final completed = prefs.getBool('${id}_completed') ?? false;
      if (stars > 0 || completed || i == 1) {
        map[id] = LessonProgress(stars: stars, bestWpm: wpm, isCompleted: completed);
      }
    }

    state = ProgressState(lessonProgressMap: map, recentHistory: state.recentHistory);
  }

  Future<void> saveLessonResult({
    required String lessonId,
    required int stars,
    required int wpm,
    required int accuracy,
    required int errors,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = state.lessonProgressMap[lessonId] ?? const LessonProgress();

    final newStars = stars > existing.stars ? stars : existing.stars;
    final newWpm = wpm > existing.bestWpm ? wpm : existing.bestWpm;
    final isCompleted = existing.isCompleted || stars > 0;

    await prefs.setInt('${lessonId}_stars', newStars);
    await prefs.setInt('${lessonId}_wpm', newWpm);
    await prefs.setBool('${lessonId}_completed', isCompleted);

    // Also unlock next lesson if applicable
    final lessonNum = int.tryParse(lessonId.replaceAll('L', '').replaceAll('l', '')) ?? 1;
    final nextId = 'l${lessonNum + 1}';
    if (stars > 0 && !state.lessonProgressMap.containsKey(nextId)) {
      state.lessonProgressMap[nextId] = const LessonProgress();
    }

    final updatedMap = Map<String, LessonProgress>.from(state.lessonProgressMap);
    updatedMap[lessonId] = LessonProgress(stars: newStars, bestWpm: newWpm, isCompleted: isCompleted);

    final history = List<Map<String, dynamic>>.from(state.recentHistory);
    history.insert(0, {
      'lessonId': lessonId,
      'wpm': wpm,
      'accuracy': accuracy,
      'errors': errors,
      'stars': stars,
      'date': DateTime.now().toIso8601String(),
    });

    state = ProgressState(lessonProgressMap: updatedMap, recentHistory: history);
  }

  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    state = ProgressState(lessonProgressMap: {'l1': const LessonProgress()}, recentHistory: []);
  }

  bool isLessonUnlocked(String lessonId) {
    if (lessonId == 'l1') return true;
    final lessonNum = int.tryParse(lessonId.replaceAll('L', '').replaceAll('l', '')) ?? 1;
    final prevId = 'l${lessonNum - 1}';
    final prevProgress = state.lessonProgressMap[prevId];
    return prevProgress != null && prevProgress.isCompleted;
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
