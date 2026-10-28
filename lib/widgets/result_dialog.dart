import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';
import 'star_row.dart';
import 'stat_chip.dart';

class ResultDialog extends ConsumerStatefulWidget {
  final int wpm;
  final int accuracy;
  final int errors;
  final int timeSeconds;
  final int stars;
  final VoidCallback onNext;
  final VoidCallback onRetry;
  final VoidCallback onExit;

  const ResultDialog({
    super.key,
    required this.wpm,
    required this.accuracy,
    required this.errors,
    required this.timeSeconds,
    required this.stars,
    required this.onNext,
    required this.onRetry,
    required this.onExit,
  });

  @override
  ConsumerState<ResultDialog> createState() => _ResultDialogState();
}

class _ResultDialogState extends ConsumerState<ResultDialog> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (widget.stars == 3) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.center,
      children: [
        AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StarRow(stars: widget.stars, size: 36),
              const SizedBox(height: 20),
              Text(
                loc.get('lessonComplete'),
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatChip(icon: Icons.speed, label: loc.get('wpm'), value: '${widget.wpm}'),
                  const SizedBox(width: 16),
                  StatChip(icon: Icons.gps_fixed, label: loc.get('accuracy'), value: '${widget.accuracy}%'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatChip(icon: Icons.error_outline, label: loc.get('errors'), value: '${widget.errors}', color: Colors.red),
                  const SizedBox(width: 16),
                  StatChip(icon: Icons.timer, label: loc.get('time'), value: '${widget.timeSeconds}s'),
                ],
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: widget.onExit,
                    child: Text(loc.get('backToLessons')),
                  ),
                  OutlinedButton(
                    onPressed: widget.onRetry,
                    child: Text(loc.get('tryAgain')),
                  ),
                  ElevatedButton(
                    onPressed: widget.onNext,
                    child: Text(loc.get('nextLesson')),
                  ),
                ],
              ),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.orange, Colors.yellow, Colors.purple],
        ),
      ],
    );
  }
}
