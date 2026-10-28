import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';

class AppNavBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          InkWell(
            onTap: () => context.go('/'),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'TU',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    loc.get('appName'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),

          // Navigation Links (Desktop)
          if (MediaQuery.of(context).size.width >= 700) ...[
            TextButton(
              onPressed: () => context.go('/lessons'),
              child: Text(loc.get('navLessons')),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () => context.go('/speed-test'),
              child: Text(loc.get('navPractice')),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () => context.go('/stats'),
              child: Text(loc.get('navStats')),
            ),
            const SizedBox(width: 16),
            TextButton(
              onPressed: () => context.go('/settings'),
              child: Text(loc.get('navSettings')),
            ),
            const SizedBox(width: 24),
          ],

          // Language Switcher
          DropdownButton<AppLanguage>(
            value: settings.language,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: AppLanguage.uz, child: Text('UZ')),
              DropdownMenuItem(value: AppLanguage.en, child: Text('EN')),
              DropdownMenuItem(value: AppLanguage.ru, child: Text('RU')),
            ],
            onChanged: (lang) {
              if (lang != null) {
                ref.read(settingsProvider.notifier).setLanguage(lang);
              }
            },
          ),
          const SizedBox(width: 12),

          // Theme Toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () {
              ref.read(settingsProvider.notifier).setThemeMode(
                    isDark ? ThemeMode.light : ThemeMode.dark,
                  );
            },
          ),
          const SizedBox(width: 12),

          // Start Button
          ElevatedButton(
            onPressed: () => context.go('/lessons'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 40),
            ),
            child: Text(loc.get('startLearning')),
          ),
        ],
      ),
    );
  }
}
