import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/typing_text_view.dart';
import '../widgets/stat_chip.dart';
import '../widgets/wpm_chart.dart';

class SpeedTestScreen extends ConsumerStatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  ConsumerState<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends ConsumerState<SpeedTestScreen> {
  int selectedDuration = 60; // seconds
  String textType = 'sentences'; // sentences or words
  bool isTestStarted = false;
  bool isTestFinished = false;

  late String testText;
  int currentIndex = 0;
  List<bool?> typedResults = [];
  int errorsCount = 0;
  int correctKeystrokes = 0;
  int totalKeystrokes = 0;

  Timer? _timer;
  int timeLeft = 60;
  final List<int> wpmHistoryOverTime = [];
  final FocusNode _focusNode = FocusNode();

  final String sampleSentences =
      'The quick brown fox jumps over the lazy dog. Touch typing is an essential skill for modern developers and writers. Practice makes perfect when building speed and accuracy on the keyboard.';
  final String sampleWords =
      'apple banana orange grape strawberry peach mango lemon cherry melon pineapple apricot blueberry raspberry blackberry watermelon plum pear kiwi papaya';

  @override
  void initState() {
    super.initState();
    _setupTestText();
  }

  void _setupTestText() {
    testText = textType == 'sentences' ? sampleSentences : sampleWords;
    typedResults = List.filled(testText.length, null);
    timeLeft = selectedDuration;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _startTest() {
    setState(() {
      isTestStarted = true;
      isTestFinished = false;
      currentIndex = 0;
      errorsCount = 0;
      correctKeystrokes = 0;
      totalKeystrokes = 0;
      timeLeft = selectedDuration;
      wpmHistoryOverTime.clear();
      typedResults = List.filled(testText.length, null);
    });

    _focusNode.requestFocus();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
          wpmHistoryOverTime.add(wpm);
        } else {
          _finishTest();
        }
      });
    });
  }

  void _finishTest() {
    _timer?.cancel();
    setState(() {
      isTestFinished = true;
      isTestStarted = false;
    });
  }

  void _handleKey(KeyEvent event) {
    if (!isTestStarted || isTestFinished) return;
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (currentIndex > 0) {
          setState(() {
            currentIndex--;
            typedResults[currentIndex] = null;
          });
        }
        return;
      }

      String? char = event.character;
      if (event.logicalKey == LogicalKeyboardKey.space) {
        char = ' ';
      }

      if (char != null && char.length == 1 && currentIndex < testText.length) {
        final expected = testText[currentIndex];
        setState(() {
          totalKeystrokes++;
          if (char == expected) {
            typedResults[currentIndex] = true;
            correctKeystrokes++;
            currentIndex++;
          } else {
            typedResults[currentIndex] = false;
            errorsCount++;
          }
        });

        if (currentIndex >= testText.length) {
          _finishTest();
        }
      }
    }
  }

  int get wpm {
    final elapsed = selectedDuration - timeLeft;
    if (elapsed == 0) return 0;
    final minutes = elapsed / 60.0;
    return ((correctKeystrokes / 5) / minutes).round();
  }

  int get accuracy {
    if (totalKeystrokes == 0) return 100;
    return ((correctKeystrokes / totalKeystrokes) * 100).clamp(0, 100).round();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);

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
                  loc.get('speedTestTitle'),
                  style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                if (!isTestStarted && !isTestFinished) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Select Duration', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          SegmentedButton<int>(
                            segments: const [
                              ButtonSegment(value: 30, label: Text('30s')),
                              ButtonSegment(value: 60, label: Text('60s')),
                              ButtonSegment(value: 120, label: Text('120s')),
                            ],
                            selected: {selectedDuration},
                            onSelectionChanged: (val) {
                              setState(() {
                                selectedDuration = val.first;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          Text('Select Text Type', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(value: 'sentences', label: Text('Sentences')),
                              ButtonSegment(value: 'words', label: Text('Words')),
                            ],
                            selected: {textType},
                            onSelectionChanged: (val) {
                              setState(() {
                                textType = val.first;
                                _setupTestText();
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: _startTest,
                              icon: const Icon(Icons.play_arrow),
                              label: Text(loc.get('startTest')),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else if (isTestStarted) ...[
                  KeyboardListener(
                    focusNode: _focusNode,
                    onKeyEvent: _handleKey,
                    child: GestureDetector(
                      onTap: () => _focusNode.requestFocus(),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StatChip(icon: Icons.timer, label: 'Time Left', value: '${timeLeft}s'),
                              const SizedBox(width: 16),
                              StatChip(icon: Icons.speed, label: loc.get('wpm'), value: '$wpm'),
                              const SizedBox(width: 16),
                              StatChip(icon: Icons.gps_fixed, label: loc.get('accuracy'), value: '$accuracy%'),
                            ],
                          ),
                          const SizedBox(height: 32),
                          TypingTextView(
                            text: testText,
                            currentIndex: currentIndex,
                            typedResults: typedResults,
                            fontSize: 28,
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'Type the text above. Timer is running!',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Text('Speed Test Results', style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              StatChip(icon: Icons.speed, label: loc.get('wpm'), value: '$wpm'),
                              const SizedBox(width: 16),
                              StatChip(icon: Icons.gps_fixed, label: loc.get('accuracy'), value: '$accuracy%'),
                              const SizedBox(width: 16),
                              StatChip(icon: Icons.error_outline, label: loc.get('errors'), value: '$errorsCount', color: Colors.red),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text('WPM Progress Over Time', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 12),
                          WpmChart(wpmHistory: wpmHistoryOverTime),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isTestFinished = false;
                              });
                            },
                            child: Text(loc.get('tryAgain')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
