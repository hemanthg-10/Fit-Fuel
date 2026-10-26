# FitFuel

FitFuel is a Flutter classroom demo for calorie and macronutrient tracking. It presents a welcome screen, validates demo login input, and displays a sample nutrition dashboard.

## Features

- Responsive welcome screen and custom fitness illustration
- Login form with name and password validation
- Dashboard with calorie gauge and sample macro progress
- Logout navigation back to the welcome screen
- Flutter web, Android, iOS, Windows, macOS, and Linux project scaffolding

## Demo behavior

This is a front-end classroom demo. It does not connect to a server, authenticate a real account, save entries, or calculate nutrition dynamically.

- Any name of at least two characters with no digits passes the name rule.
- Any password of at least six characters passes the password rule.
- Dashboard values are fixed sample values: 2,200 kcal goal, 1,450 kcal eaten, 420 kcal burned, and 750 kcal remaining.

## Run locally

Install Flutter with Dart SDK 3.13.5 or newer, then run from the repository root:

```powershell
flutter pub get
flutter run -d chrome
```

To build the static web release:

```powershell
flutter build web --release
```

Flutter writes the web output to `build/web`.

## Test and analysis

```powershell
flutter test
flutter analyze
```

The included widget suite verifies the compact Start page layout, empty and invalid login input, successful navigation to the dashboard, dashboard values, and logout. See [docs/TESTING.md](docs/TESTING.md), the [PDF QA report](docs/FitFuel-QA-Report.pdf), and captured command output under [docs/evidence](docs/evidence/).

## Repository layout

- `lib/main.dart` - FitFuel Flutter application
- `test/widget_test.dart` - widget-level regression tests
- `android/`, `ios/`, `linux/`, `macos/`, `windows/` - platform runner projects
- `web/` - Flutter web bootstrap assets
- `docs/design/` - original SVG screen designs
- `docs/FitFuel-QA-Report.pdf` - QA report with test results and limitations
- `docs/evidence/` - captured Flutter test, analyzer, and web build output

## QA status

The current source passes four widget tests, `flutter analyze`, and a release web build. The QA report records that live browser verification and native platform builds were not completed in the test environment.

## License

No license has been added. Ask the project owner before reusing or redistributing this classroom project.
