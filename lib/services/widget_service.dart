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
}
