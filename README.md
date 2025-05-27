# SkyBook

SkyBook is a simple flight logbook mobile app built with Flutter. It lets you record flights and keep notes about each one. Data is stored offline in a local SQLite database using the `sqflite` package.

## Features

- Add flights with date, aircraft, duration and optional notes
- Enter the flight number and the airline will be detected automatically
<!-- - Prefill details by scanning a boarding pass or importing itinerary text -->
- View a list of all recorded flights
- View overall stats like total flights and hours
- See your top airlines in the Status section
- Analyze seat location preferences with a dedicated chart in the Status section
- View total CO₂ emissions per passenger in the Status section
- Track progress with detailed achievements for flight counts, distance and destinations, including advanced tiers like Jet Setter, World Explorer and Airport Master
- Switch between light and dark themes
- Theme preference is saved so your choice is remembered
- Enable a developer section with an option to clear local data
- Developer section preference is saved so your choice is remembered
- Unlock Premium mode in settings to view CO₂ data and detailed graphs
- Premium users can quickly add flights via a home screen shortcut
- Premium users can view key stats from a home screen widget on iOS and Android
- Data is stored locally on the device
- View your routes on an interactive map
- Quickly access Map, Flights, Progress and Status using the bottom navigation bar
- Custom badge images are included under `assets/badges` for achievements
- The iOS app icon is generated from `assets/logo.png`
- Fonts scale with the device's text size thanks to Flutter's `TextTheme` and `MediaQuery`
- Icons and progress indicators include semantic labels and all tap targets are at least 48×48 dp
- Light and dark themes have been tested for contrast and readability
- A style guide documenting colors, spacing and typography is available in `docs/style-guide.md`

## Getting Started

1. Install Flutter on your machine.
2. Fetch dependencies:
   ```sh
   flutter pub get
   ```
   Ensure the `home_widget` package is kept at version `0.5.0` in
   `pubspec.yaml`. If this version is upgraded, iOS builds may fail due to the
   missing `WidgetConfigurationIntent` definition required by newer releases.
3. In `ios/Podfile`, uncomment the `platform :ios` line and set the version to
   `15.5` so the app builds correctly.
4. Run the app:
   ```sh
   flutter run
   ```

To update the iOS app icon after modifying `assets/logo.png`, run:
```sh
flutter pub run flutter_launcher_icons:main
```

Since this repository does not include compiled dependencies, you will need to install them via `flutter pub get` before running the app.

## Releasing

To publish a production build:

1. Update the `version` field in `pubspec.yaml`.
2. Fetch packages and rebuild the icon if needed:
   ```sh
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```
3. Build the binaries:
   ```sh
   flutter build apk --release       # Android
   flutter build ipa --release       # iOS (requires Xcode)
   ```
4. Upload the generated files in `build/` to their respective stores.

## Exporting Data

Premium users can export or import flights from **Settings → Import / Export**. Data can be shared in JSON or CSV format using the built‑in share sheet.

## Updating Datasets

Seed datasets for airlines, airports and aircraft live under `lib/data`. They are inserted into the local database when it is created or upgraded. If you edit these lists:

1. Bump the database `version` in `AppDatabase.open()` so `_seed` runs again.
2. Run the app once to apply the new data.

## Contributing

1. Fork the repository and create a new branch for your change.
2. Run `flutter pub get` followed by `flutter test` to ensure all tests pass.
3. Submit a pull request describing your changes.
