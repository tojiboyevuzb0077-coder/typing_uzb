# TypeUz - Touch-Typing Trainer Web App

TypeUz is a modern touch-typing trainer web application built with Flutter Web, Riverpod, go_router, shared_preferences, fl_chart, and confetti. It supports multi-language localization (Uzbek, English, Russian), light/dark theme toggling, virtual keyboard with finger color-coding (TypingClub style), interactive lessons, speed tests, and rich progress statistics.

## Tech Stack
- **Framework:** Flutter Web (Dart 3, null-safe)
- **State Management:** Riverpod (`flutter_riverpod`)
- **Navigation:** `go_router` (URL-friendly web routes)
- **Local Storage:** `shared_preferences` (Lesson progress, stars, settings)
- **Fonts:** Inter & JetBrains Mono (`google_fonts`)
- **Charts:** `fl_chart`
- **Celebration:** `confetti`

## Getting Started & Run Instructions

1. Ensure Flutter is installed and configured for Web:
   ```bash
   flutter doctor
   flutter config --enable-web
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app in Chrome:
   ```bash
   flutter run -d chrome
   ```

## GitHub Pages Deployment

To build and deploy TypeUz to GitHub Pages with the appropriate base URL:

1. Build the release version:
   ```bash
   flutter build web --release --base-href "/typing_uz/"
   ```

2. The output files will be generated in `build/web/`. Deploy the contents of `build/web/` to your GitHub Pages branch (e.g., `gh-pages`).
