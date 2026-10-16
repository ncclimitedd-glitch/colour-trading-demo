# Colour Trading Demo (Flutter)

A simple colour-selection demo with a 30-second round timer and result history.
It uses no real money, deposits, withdrawals, accounts, or network services.

## Requirements
- Flutter SDK (stable)
- Android Studio with Android SDK
- A terminal/command prompt

## Run the app
1. Extract this ZIP.
2. Open a terminal in the `colour_trading_demo_flutter` folder.
3. Run:
   ```bash
   flutter doctor
   flutter pub get
   flutter run
   ```

## Build an Android APK
From the project folder, run:
```bash
flutter build apk --release
```
The APK will be created at:
`build/app/outputs/flutter-apk/app-release.apk`

To build a smaller APK for the connected device's CPU architecture:
```bash
flutter build apk --split-per-abi
```
Those APKs will be under `build/app/outputs/flutter-apk/`.

## Notes
- Results are randomly generated locally and are only for demonstration.
- History is kept in memory while the app is open; it resets when the app restarts.
- This ZIP contains source code, not a prebuilt APK. Flutter/Android SDK is required to compile it.
