import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/localization/app_localizations.dart';
import '../data/mock/lessons_data.dart';
import '../data/models/lesson_model.dart';
import '../providers/progress_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/typing_text_view.dart';
import '../widgets/virtual_keyboard.dart';
import '../widgets/hand_guide.dart';
import '../widgets/stat_chip.dart';
import '../widgets/result_dialog.dart';
import '../widgets/pause_dialog.dart';

class TypingScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const TypingScreen({super.key, required this.lessonId});

  @override
  ConsumerState<TypingScreen> createState() => _TypingScreenState();
}

class _TypingScreenState extends ConsumerState<TypingScreen> {
  late Lesson lesson;
  int currentIndex = 0;
  List<bool?> typedResults = [];
  int errorsCount = 0;
  int correctKeystrokes = 0;
  int totalKeystrokes = 0;

  Timer? _timer;
  int secondsElapsed = 0;
  bool isStarted = false;
  bool isCompleted = false;

  String? pressedChar;
  bool isWrongKey = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    lesson = LessonsData.allLessons.firstWhere(
      (l) => l.id == widget.lessonId,
      orElse: () => LessonsData.allLessons.first,
    );
    typedResults = List.filled(lesson.content.length, null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (isStarted) return;
    isStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void _handleKey(KeyEvent event) {
    if (isCompleted) return;
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _showPauseDialog();
        return;
      }

      _startTimer();

      String? char;
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        _handleBackspace();
        return;
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        char = ' ';
      } else {
        char = event.character;
      }

      if (char != null && char.length == 1 && currentIndex < lesson.content.length) {
        final expectedChar = lesson.content[currentIndex];
        setState(() {
          pressedChar = char;
          totalKeystrokes++;
          if (char == expectedChar) {
            typedResults[currentIndex] = true;
            correctKeystrokes++;
            currentIndex++;
            isWrongKey = false;
          } else {
            typedResults[currentIndex] = false;
            errorsCount++;
            isWrongKey = true;
          }
        });

        // Check if lesson completed
        if (currentIndex >= lesson.content.length) {
          _completeLesson();
        }

        // Reset pressed char animation after 150ms
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              pressedChar = null;
              isWrongKey = false;
            });
          }
        });
      }
    }
  }

  void _handleBackspace() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        typedResults[currentIndex] = null;
      });
    }
  }

  int get wpm {
    if (secondsElapsed == 0) return 0;
    final minutes = secondsElapsed / 60.0;
    return ((correctKeystrokes / 5) / minutes).round();
  }

  int get accuracy {
    if (totalKeystrokes == 0) return 100;
    return ((correctKeystrokes / totalKeystrokes) * 100).clamp(0, 100).round();
  }

  void _completeLesson() {
    _timer?.cancel();
    setState(() {
      isCompleted = true;
    });

    int stars = 0;
    final acc = accuracy;
    if (acc >= 95) {
      stars = 3;
    } else if (acc >= 85) {
      stars = 2;
    } else if (acc >= 70) {
      stars = 1;
    } else {
      stars = 0;
    }

    ref.read(progressProvider.notifier).saveLessonResult(
          lessonId: lesson.id,
          stars: stars,
          wpm: wpm,
          accuracy: acc,
          errors: errorsCount,
        );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        wpm: wpm,
        accuracy: acc,
        errors: errorsCount,
        timeSeconds: secondsElapsed,
        stars: stars,
        onNext: () {
          Navigator.pop(context);
          _goToNextLesson();
        },
        onRetry: () {
          Navigator.pop(context);
          _restartLesson();
        },
        onExit: () {
          Navigator.pop(context);
          context.go('/lessons');
        },
      ),
    );
  }

  void _restartLesson() {
    setState(() {
      currentIndex = 0;
      typedResults = List.filled(lesson.content.length, null);
      errorsCount = 0;
      correctKeystrokes = 0;
      totalKeystrokes = 0;
      secondsElapsed = 0;
      isStarted = false;
      isCompleted = false;
    });
    _timer?.cancel();
  }

  void _goToNextLesson() {
    final nextNum = lesson.number + 1;
    final nextLesson = LessonsData.allLessons.firstWhere(
      (l) => l.number == nextNum,
      orElse: () => lesson,
    );
    if (nextLesson.id != lesson.id) {
      context.go('/lesson/${nextLesson.id}');
    } else {
      context.go('/lessons');
    }
  }

  void _showPauseDialog() {
    _timer?.cancel();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PauseDialog(
        onResume: () {
          Navigator.pop(context);
          if (isStarted) {
            _startTimer();
          }
        },
        onRestart: () {
          Navigator.pop(context);
          _restartLesson();
        },
        onExit: () {
          Navigator.pop(context);
          context.go('/lessons');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    if (width < 700) {
      return Scaffold(
        appBar: AppBar(title: Text(lesson.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              loc.get('mobileNotice'),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final nextChar = currentIndex < lesson.content.length ? lesson.content[currentIndex] : null;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKey,
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/lessons'),
            ),
            title: Text(lesson.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: _showPauseDialog,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Live Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StatChip(icon: Icons.speed, label: loc.get('wpm'), value: '$wpm'),
                        const SizedBox(width: 16),
                        StatChip(icon: Icons.gps_fixed, label: loc.get('accuracy'), value: '$accuracy%'),
                        const SizedBox(width: 16),
                        StatChip(icon: Icons.timer, label: loc.get('time'), value: '${secondsElapsed}s'),
                        const SizedBox(width: 16),
                        StatChip(icon: Icons.error_outline, label: loc.get('errors'), value: '$errorsCount', color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Typing Text View
                    TypingTextView(
                      text: lesson.content,
                      currentIndex: currentIndex,
                      typedResults: typedResults,
                      fontSize: settings.fontSize,
                    ),
                    const SizedBox(height: 32),

                    // Hand Guide
                    HandGuide(nextChar: nextChar),
                    const SizedBox(height: 16),

                    // Virtual Keyboard
                    if (settings.showKeyboard)
                      VirtualKeyboard(
                        nextChar: nextChar,
                        pressedChar: pressedChar,
                        isWrong: isWrongKey,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
