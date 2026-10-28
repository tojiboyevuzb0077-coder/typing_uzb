import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../widgets/app_nav_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/feature_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppNavBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroSection(),
            const SizedBox(height: 32),
            // Features Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    Text(
                      loc.get('featuresTitle'),
                      style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 800;
                        return Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(isWide ? 8.0 : 0),
                                child: FeatureCard(
                                  icon: Icons.school_outlined,
                                  title: loc.get('feature1Title'),
                                  description: loc.get('feature1Desc'),
                                ),
                              ),
                            ),
                            SizedBox(height: isWide ? 0 : 16, width: isWide ? 16 : 0),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(isWide ? 8.0 : 0),
                                child: FeatureCard(
                                  icon: Icons.speed_outlined,
                                  title: loc.get('feature2Title'),
                                  description: loc.get('feature2Desc'),
                                ),
                              ),
                            ),
                            SizedBox(height: isWide ? 0 : 16, width: isWide ? 16 : 0),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(isWide ? 8.0 : 0),
                                child: FeatureCard(
                                  icon: Icons.trending_up,
                                  title: loc.get('feature3Title'),
                                  description: loc.get('feature3Desc'),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            // Footer
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '© 2026 TypeUz. Touch-typing trainer web app built with Flutter.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
