# Testing and QA

## Environment

The project was checked with Flutter 3.47.7 stable and Dart 3.13.5 on Windows x64.

## Commands and results

| Command | Result |
|---|---|
| `flutter test` | Passed: 4 widget tests |
| `flutter analyze` | Passed: no issues found |
| `flutter build web --release` | Passed: release output generated in `build/web` |

The complete report is in [`FitFuel-QA-Report.pdf`](FitFuel-QA-Report.pdf). Captured command output is stored in `evidence/`.

## Covered scenarios

1. Start page renders at 320 x 568 without a layout exception.
2. Empty name and password are rejected with required-field messages.
3. One-character names, names containing digits, and passwords shorter than six characters are rejected.
4. Valid demo credentials open the dashboard with the expected greeting and 750 kcal remaining.
5. Logout returns to the Start page.

The four widget tests cover these five scenario groups (the invalid input boundaries are combined in one widget test).

## Defects corrected

- Replaced the generated counter smoke test, which did not match FitFuel, with FitFuel widget coverage.
- Fixed the new logout test to scroll the off-screen control into view before tapping.
- Fixed a Start page `RenderFlex` overflow of 44 pixels at a 320 x 568 viewport by making the page scrollable and sizing the hero illustration for available height.

## Verification limits

Flutter's managed Chrome launch failed in the QA environment, so live browser visuals and browser-console behavior were not verified. Android, iOS, desktop native builds, and device launches were not performed. This demo has no backend or persistence.
