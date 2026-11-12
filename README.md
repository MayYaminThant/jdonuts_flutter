# J’Donuts Flutter — Offline-first Demo

A Flutter starter implementation of the 15-page Senior Flutter Developer code test. Source design screenshots are not redistributed.

## Setup

Use a current stable Flutter SDK with Dart >=3.5. Flutter SDK is **not installed in the generation environment**, so this project has not been compiled or analyzed here. Record the exact versions used with `flutter --version` after setup.

```bash
flutter create --platforms=android,ios .
flutter pub get
flutter run
flutter analyze
flutter test
flutter build apk --release
flutter build ios --simulator
```

`flutter create` generates the Android/iOS host folders; no imports or source files need to be changed. iOS build requires macOS and Xcode.

## Demo flow

Register: phone → OTP (`123456`) → first/last name → DOB → welcome → Home. Login: registered phone → OTP → Home. Settings contains Log out. Data is bundled in `assets/data/seed.json` and seeded into a SQLite database on first launch.

## Structure

- `lib/core`: theme, routing, providers, common widgets
- `lib/features/auth`: domain validators/repository, fake local implementation, onboarding and registration
- `lib/features/home`: catalog domain, SQLite seed repository, home screen
- `lib/features/product`: product detail
- `lib/features/rewards`: animated rewards and CustomPainter progress art
- `assets/images`: original programmatically drawn PNG donuts and banners
- `assets/icons`: original PNG navigation symbols

## Architecture and limitations

Riverpod is used for dependency injection and async state; go_router handles navigation; SQLite stores catalog data, secure storage stores session and SharedPreferences stores mock registered users. Domain files contain no Flutter imports.

**Known gaps:** This is a source-code starter, not a verified final submission. The images are original stylized stand-ins rather than exact client product photography. The full OTP six-box behavior, backspace handling, animation choreography, reachability/offline banner, background synchronization, ARB localization, comprehensive widget/integration tests, and simulator binaries still need completion. Network refresh is omitted because the brief allows local-only data. There is no APK or iOS .app included. No claim is made that analyzer/tests pass without running Flutter locally.
