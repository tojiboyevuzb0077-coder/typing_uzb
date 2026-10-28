import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../screens/home_screen.dart';
import '../../screens/lessons_screen.dart';
import '../../screens/typing_screen.dart';
import '../../screens/speed_test_screen.dart';
import '../../screens/stats_screen.dart';
import '../../screens/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/lessons',
        name: 'lessons',
        builder: (context, state) => const LessonsScreen(),
      ),
      GoRoute(
        path: '/lesson/:id',
        name: 'lesson',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'l1';
          return TypingScreen(lessonId: id);
        },
      ),
      GoRoute(
        path: '/speed-test',
        name: 'speed-test',
        builder: (context, state) => const SpeedTestScreen(),
      ),
      GoRoute(
        path: '/stats',
        name: 'stats',
        builder: (context, state) => const StatsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
