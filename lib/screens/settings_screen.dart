import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/progress_provider.dart';
import '../widgets/app_nav_bar.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final loc = AppLocalizations(settings.language);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const AppNavBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.get('settingsTitle'),
                  style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Language
                        ListTile(
                          title: Text(loc.get('language')),
                          trailing: DropdownButton<AppLanguage>(
                            value: settings.language,
                            items: const [
                              DropdownMenuItem(value: AppLanguage.uz, child: Text('O\'zbekcha')),
                              DropdownMenuItem(value: AppLanguage.en, child: Text('English')),
                              DropdownMenuItem(value: AppLanguage.ru, child: Text('Русский')),
                            ],
                            onChanged: (lang) {
                              if (lang != null) {
                                ref.read(settingsProvider.notifier).setLanguage(lang);
                              }
                            },
                          ),
                        ),
                        const Divider(),
                        // Theme
                        ListTile(
                          title: Text(loc.get('theme')),
                          trailing: DropdownButton<ThemeMode>(
                            value: settings.themeMode,
                            items: [
                              DropdownMenuItem(value: ThemeMode.light, child: Text(loc.get('light'))),
                              DropdownMenuItem(value: ThemeMode.dark, child: Text(loc.get('dark'))),
                              DropdownMenuItem(value: ThemeMode.system, child: Text(loc.get('system'))),
                            ],
                            onChanged: (mode) {
                              if (mode != null) {
                                ref.read(settingsProvider.notifier).setThemeMode(mode);
                              }
                            },
                          ),
                        ),
                        const Divider(),
                        // Font Size
                        ListTile(
                          title: Text(loc.get('fontSize')),
                          subtitle: Text('${settings.fontSize.toInt()}px'),
                          trailing: Slider(
                            value: settings.fontSize,
                            min: 20,
                            max: 48,
                            divisions: 7,
                            label: '${settings.fontSize.toInt()}px',
                            onChanged: (size) {
                              ref.read(settingsProvider.notifier).setFontSize(size);
                            },
                          ),
                        ),
                        const Divider(),
                        // Sound Effects
                        SwitchListTile(
                          title: Text(loc.get('sound')),
                          value: settings.soundEnabled,
                          onChanged: (val) {
                            ref.read(settingsProvider.notifier).setSoundEnabled(val);
                          },
                        ),
                        const Divider(),
                        // On-screen Keyboard
                        SwitchListTile(
                          title: Text(loc.get('showKeyboard')),
                          value: settings.showKeyboard,
                          onChanged: (val) {
                            ref.read(settingsProvider.notifier).setShowKeyboard(val);
                          },
                        ),
                        const Divider(),
                        // Reset Progress
                        ListTile(
                          title: Text(loc.get('resetProgress'), style: const TextStyle(color: Colors.red)),
                          trailing: OutlinedButton(
                            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(loc.get('resetProgress')),
                                  content: Text(loc.get('resetConfirm')),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(loc.get('cancel')),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: () {
                                        ref.read(progressProvider.notifier).resetAll();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Progress has been reset.')),
                                        );
                                      },
                                      child: Text(loc.get('reset')),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(loc.get('reset')),
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
      ),
    );
  }
}
