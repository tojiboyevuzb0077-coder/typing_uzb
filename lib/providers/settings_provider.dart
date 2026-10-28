import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/localization/app_localizations.dart';

class SettingsState {
  final AppLanguage language;
  final ThemeMode themeMode;
  final double fontSize;
  final bool soundEnabled;
  final bool showKeyboard;

  SettingsState({
    required this.language,
    required this.themeMode,
    required this.fontSize,
    required this.soundEnabled,
    required this.showKeyboard,
  });

  SettingsState copyWith({
    AppLanguage? language,
    ThemeMode? themeMode,
    double? fontSize,
    bool? soundEnabled,
    bool? showKeyboard,
  }) {
    return SettingsState(
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      showKeyboard: showKeyboard ?? this.showKeyboard,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier()
      : super(SettingsState(
          language: AppLanguage.en,
          themeMode: ThemeMode.system,
          fontSize: 32.0,
          soundEnabled: true,
          showKeyboard: true,
        )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final langIndex = prefs.getInt('lang_index') ?? 0;
    final themeIndex = prefs.getInt('theme_index') ?? 0;
    final fontSize = prefs.getDouble('font_size') ?? 32.0;
    final sound = prefs.getBool('sound') ?? true;
    final showKeyboard = prefs.getBool('show_keyboard') ?? true;

    state = SettingsState(
      language: AppLanguage.values[langIndex.clamp(0, AppLanguage.values.length - 1)],
      themeMode: ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)],
      fontSize: fontSize,
      soundEnabled: sound,
      showKeyboard: showKeyboard,
    );
  }

  Future<void> setLanguage(AppLanguage lang) async {
    state = state.copyWith(language: lang);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lang_index', lang.index);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_index', mode.index);
  }

  Future<void> setFontSize(double size) async {
    state = state.copyWith(fontSize: size);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', size);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound', enabled);
  }

  Future<void> setShowKeyboard(bool show) async {
    state = state.copyWith(showKeyboard: show);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_keyboard', show);
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
