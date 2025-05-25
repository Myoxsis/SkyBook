# SkyBook

SkyBook is a simple flight logbook mobile app built with Flutter. It lets you record flights and keep notes about each one. This is an MVP designed to work offline using `shared_preferences` for persistence.

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
- Data is stored locally on the device
- View your routes on an interactive map
- Quickly access Map, Flights, Progress and Status using the bottom navigation bar

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

Since this repository does not include compiled dependencies, you will need to install them via `flutter pub get` before running the app.
