# SkyBook

SkyBook is a simple flight logbook mobile app built with Flutter. It lets you record flights and keep notes about each one. Data is stored offline in a local SQLite database using the `sqflite` package.

## Features

- Add flights with date, aircraft, duration and optional notes
- Enter the flight number and the airline will be detected automatically
- View a list of all recorded flights
- View overall stats like total flights and hours
- See your top airlines in the Status section
- View total CO₂ emissions per passenger in the Status section
- Track progress with detailed achievements for flight counts, distance and destinations
- Switch between light and dark themes
- Theme preference is saved so your choice is remembered
- Enable a developer section with an option to clear local data
- Developer section preference is saved so your choice is remembered
- Unlock Premium mode in settings to view CO₂ data and detailed graphs
- Premium users can quickly add flights via a home screen shortcut
- Data is stored locally on the device
- View your routes on an interactive map
- Quickly access Map, Flights, Progress and Status using the bottom navigation bar
- Custom badge images are included under `assets/badges` for achievements
- The iOS app icon is generated from `assets/logo.png`
- Fonts scale with the device's text size thanks to Flutter's `TextTheme` and `MediaQuery`

## Getting Started

1. Install Flutter on your machine.
2. Fetch dependencies:
   ```sh
   flutter pub get
   ```
3. Run the app:
   ```sh
   flutter run
   ```

To update the iOS app icon after modifying `assets/logo.png`, run:
```sh
flutter pub run flutter_launcher_icons:main
```

Since this repository does not include compiled dependencies, you will need to install them via `flutter pub get` before running the app.
