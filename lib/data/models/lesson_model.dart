enum LessonCategory {
  homeRow,
  topRow,
  bottomRow,
  numbers,
  words,
  sentences,
}

class Lesson {
  final String id;
  final int number;
  final String title;
  final LessonCategory category;
  final String content;
  final bool isLockedDefault;

  const Lesson({
    required this.id,
    required this.number,
    required this.title,
    required this.category,
    required this.content,
    this.isLockedDefault = false,
  });
}
