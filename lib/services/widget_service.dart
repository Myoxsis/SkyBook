import 'package:home_widget/home_widget.dart';

import '../models/flight.dart';
import '../models/premium_storage.dart';

/// Simple data holder for aggregated totals shown in the widget.
class KpiTotals {
  final int flights;
  final double distanceKm;
  final double carbonKg;

  const KpiTotals({
    required this.flights,
    required this.distanceKm,
    required this.carbonKg,
  });
}

/// Data holder for the values displayed in the medium status widget.
class StatusTotals {
  final int flights;
  final double durationHours;
  final double carbonKg;
  final String favoritePlane;
  final String favoriteAirline;
  final String favoriteDestination;

  const StatusTotals({
    required this.flights,
    required this.durationHours,
    required this.carbonKg,
    required this.favoritePlane,
    required this.favoriteAirline,
    required this.favoriteDestination,
  });
}

class WidgetService {
  /// Aggregates totals from a list of flights.
  static KpiTotals aggregate(List<Flight> flights) {
    final totalFlights = flights.length;
    final totalDistance = flights.fold<double>(
      0,
      (sum, f) => sum + (f.distanceKm.isNaN ? 0 : f.distanceKm),
    );
    final totalCarbon = flights.fold<double>(
      0,
      (sum, f) => sum + (f.carbonKg.isNaN ? 0 : f.carbonKg),
    );
    return KpiTotals(
      flights: totalFlights,
      distanceKm: totalDistance,
      carbonKg: totalCarbon,
    );
  }

  /// Data holder for the values shown on the medium status widget.
  static String _topKey(Map<String, int> counts) {
    if (counts.isEmpty) return 'N/A';
    return counts.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
  }

  /// Aggregates the metrics displayed in the status tiles.
  static StatusTotals aggregateStatus(List<Flight> flights) {
    final totalFlights = flights.length;
    final totalDuration = flights.fold<double>(
      0,
      (sum, f) => sum + (double.tryParse(f.duration) ?? 0),
    );
    final totalCarbon = flights.fold<double>(
      0,
      (sum, f) => sum + (f.carbonKg.isNaN ? 0 : f.carbonKg),
    );

    final aircraftCounts = <String, int>{};
    final airlineCounts = <String, int>{};
    final destCounts = <String, int>{};

    for (final f in flights) {
      aircraftCounts[f.aircraft] = (aircraftCounts[f.aircraft] ?? 0) + 1;
      if (f.airline.isNotEmpty) {
        airlineCounts[f.airline] = (airlineCounts[f.airline] ?? 0) + 1;
      }
      if (f.destination.isNotEmpty) {
        destCounts[f.destination] = (destCounts[f.destination] ?? 0) + 1;
      }
    }

    return StatusTotals(
      flights: totalFlights,
      durationHours: totalDuration,
      carbonKg: totalCarbon,
      favoritePlane: _topKey(aircraftCounts),
      favoriteAirline: _topKey(airlineCounts),
      favoriteDestination: _topKey(destCounts),
    );
  }

  /// Writes aggregated flight data to the native widget and triggers a refresh.
  static Future<void> updateKpiWidget(List<Flight> flights) async {
    final premium = await PremiumStorage.loadPremium();
    if (!premium) return;

    final totals = aggregate(flights);

    await HomeWidget.saveWidgetData<int>('totalFlights', totals.flights);
    await HomeWidget.saveWidgetData<double>('totalDistance', totals.distanceKm);
    await HomeWidget.saveWidgetData<double>('totalCarbon', totals.carbonKg);

    // These names must correspond to the platform specific widget providers.
    await HomeWidget.updateWidget(
      name: 'HomeKpiWidgetProvider',
      iOSName: 'SkyBookWidget',
    );
  }

  /// Writes status tile data to the medium home widget and refreshes it.
  static Future<void> updateStatusWidget(List<Flight> flights) async {
    final premium = await PremiumStorage.loadPremium();
    if (!premium) return;

    final totals = aggregateStatus(flights);

    await HomeWidget.saveWidgetData<int>('statusFlights', totals.flights);
    await HomeWidget.saveWidgetData<double>('statusDuration', totals.durationHours);
    await HomeWidget.saveWidgetData<double>('statusCarbon', totals.carbonKg);
    await HomeWidget.saveWidgetData<String>('statusFavoritePlane', totals.favoritePlane);
    await HomeWidget.saveWidgetData<String>('statusFavoriteAirline', totals.favoriteAirline);
    await HomeWidget.saveWidgetData<String>('statusFavoriteDestination', totals.favoriteDestination);

    await HomeWidget.updateWidget(
      name: 'HomeStatusWidgetProvider',
      iOSName: 'SkyBookStatusWidget',
    );
  }
}
