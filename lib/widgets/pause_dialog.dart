import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';

class PauseDialog extends ConsumerWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onExit;

  const PauseDialog({
    super.key,
    required this.onResume,
    required this.onRestart,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(loc.get('pauseTitle'), textAlign: TextAlign.center),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: onResume,
            style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
            child: Text(loc.get('resume')),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRestart,
            style: OutlinedButton.styleFrom(minimumSize: const Size(200, 48)),
            child: Text(loc.get('restart')),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onExit,
            child: Text(loc.get('exit'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
