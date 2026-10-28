import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';

class HeroSection extends ConsumerWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Flex(
            direction: width >= 900 ? Axis.horizontal : Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left text
              Expanded(
                flex: width >= 900 ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '🚀 #1 Touch Typing Platform for Uzbek & English',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      loc.get('heroTitle'),
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: width >= 900 ? 48 : 36,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      loc.get('heroSubtitle'),
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18, height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.go('/lessons'),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(loc.get('startLearning')),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            minimumSize: const Size(160, 52),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/speed-test'),
                          icon: const Icon(Icons.speed),
                          label: Text(loc.get('takeSpeedTest')),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                            minimumSize: const Size(160, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: theme.colorScheme.primary, width: 2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (width >= 900) const SizedBox(width: 48),
              if (width < 900) const SizedBox(height: 48),

              // Right illustration (Keyboard visual grid)
              Expanded(
                flex: width >= 900 ? 1 : 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P']
                            .map((k) => _buildKeyVisual(k, theme))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ';']
                            .map((k) => _buildKeyVisual(k, theme, isHighlighted: k == 'F' || k == 'J'))
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['Z', 'X', 'C', 'V', 'B', 'N', 'M', ',', '.']
                            .map((k) => _buildKeyVisual(k, theme))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 220,
                        height: 38,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.colorScheme.primary, width: 1.5),
                        ),
                        child: const Center(
                          child: Text('SPACE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyVisual(String label, ThemeData theme, {bool isHighlighted = false}) {
    return Container(
      width: 42,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: isHighlighted ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isHighlighted ? Colors.white : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
