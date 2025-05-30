import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../data/airport_data.dart';
import '../widgets/month_bar_chart.dart';
import '../widgets/skybook_app_bar.dart';
import '../widgets/day_of_week_bar_chart.dart';
import '../widgets/skybook_card.dart';
import '../widgets/premium_badge.dart';
import '../constants.dart';

class StatusScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final ValueNotifier<bool> premiumNotifier;

  const StatusScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
    required this.premiumNotifier,
  });

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  List<Flight> _flights = [];
  late VoidCallback _listener;
  bool _premium = false;
  late VoidCallback _premiumListener;

  @override
  void initState() {
    super.initState();
    _flights = widget.flightsNotifier.value;
    _premium = widget.premiumNotifier.value;
    _premiumListener = () {
      if (mounted) {
        setState(() {
          _premium = widget.premiumNotifier.value;
        });
      }
    };
    widget.premiumNotifier.addListener(_premiumListener);
    _listener = () {
      setState(() {
        _flights = widget.flightsNotifier.value;
      });
    };
    widget.flightsNotifier.addListener(_listener);
  }

  @override
  void dispose() {
    widget.flightsNotifier.removeListener(_listener);
    widget.premiumNotifier.removeListener(_premiumListener);
    super.dispose();
  }

  Future<void> refresh() async {
    final flights = await FlightStorage.loadFlights();
    widget.flightsNotifier.value = flights;
  }

  double get _totalDuration {
    return _flights.fold(0.0, (previousValue, element) {
      final dur = double.tryParse(element.duration) ?? 0;
      return previousValue + dur;
    });
  }

  double get _totalCarbon {
    return _flights.fold(0.0, (previousValue, element) {
      final carbon = element.carbonKg;
      return previousValue + (carbon.isNaN ? 0 : carbon);
    });
  }

  int get _favoriteCount =>
      _flights.where((f) => f.isFavorite).length;

  Map<String, int> get _aircraftCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      counts[f.aircraft] = (counts[f.aircraft] ?? 0) + 1;
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topAircraft {
    final entries = _aircraftCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  Map<String, int> get _airlineCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.airline.isNotEmpty) {
        counts[f.airline] = (counts[f.airline] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topAirlines {
    final entries = _airlineCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  Map<String, int> get _countryCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      final origin = airportByCode[f.origin]?.country;
      final dest = airportByCode[f.destination]?.country;
      if (origin != null) counts[origin] = (counts[origin] ?? 0) + 1;
      if (dest != null) counts[dest] = (counts[dest] ?? 0) + 1;
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topCountries {
    final entries = _countryCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }

  Map<String, int> get _classCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.travelClass.isNotEmpty) {
        counts[f.travelClass] = (counts[f.travelClass] ?? 0) + 1;
      }
    }
    return counts;
  }

  Map<String, int> get _tripTypeCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      final key = f.isBusiness ? 'Business' : 'Personal';
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  Map<String, int> get _seatLocationCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.seatLocation.isNotEmpty) {
        counts[f.seatLocation] = (counts[f.seatLocation] ?? 0) + 1;
      }
    }
    return counts;
  }

  Map<String, int> get _airportCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.origin.isNotEmpty) {
        counts[f.origin] = (counts[f.origin] ?? 0) + 1;
      }
      if (f.destination.isNotEmpty) {
        counts[f.destination] = (counts[f.destination] ?? 0) + 1;
      }
    }
    return counts;
  }


  Map<String, int> get _destinationCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.destination.isNotEmpty) {
        counts[f.destination] = (counts[f.destination] ?? 0) + 1;
      }
    }
    return counts;
  }

  List<MapEntry<String, int>> get _topDestinations {
    final entries = _destinationCount.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(5).toList();
  }

  Map<String, int> get _routeCount {
    final counts = <String, int>{};
    for (final f in _flights) {
      if (f.origin.isNotEmpty && f.destination.isNotEmpty) {
        final route = '${f.origin} → ${f.destination}';
        counts[route] = (counts[route] ?? 0) + 1;
      }
    }
    return counts;
  }


  String get _favoritePlane =>
      _topAircraft.isNotEmpty ? _topAircraft.first.key : 'N/A';

  String get _favoriteAirline =>
      _topAirlines.isNotEmpty ? _topAirlines.first.key : 'N/A';

  String get _favoriteDestination =>
      _topDestinations.isNotEmpty ? _topDestinations.first.key : 'N/A';

  Map<DateTime, int> get _monthlyFlightCounts {
    final counts = <DateTime, int>{};
    for (final f in _flights) {
      final date = DateTime.tryParse(f.date);
      if (date != null) {
        final key = DateTime(date.year, date.month);
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }
    final keys = counts.keys.toList()..sort();
    return {for (final k in keys) k: counts[k]!};
  }

  Map<DateTime, double> get _monthlyAverageDistance {
    final totals = <DateTime, double>{};
    final counts = <DateTime, int>{};
    for (final f in _flights) {
      final date = DateTime.tryParse(f.date);
      if (date != null) {
        final key = DateTime(date.year, date.month);
        totals[key] = (totals[key] ?? 0) + (f.distanceKm.isNaN ? 0 : f.distanceKm);
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }
    final keys = totals.keys.toList()..sort();
    final averages = <DateTime, double>{};
    for (final k in keys) {
      final total = totals[k] ?? 0;
      final count = counts[k] ?? 1;
      averages[k] = count == 0 ? 0 : total / count;
    }
    return averages;
  }

  Map<DateTime, double> get _monthlyCarbonTotals {
    final totals = <DateTime, double>{};
    for (final f in _flights) {
      final date = DateTime.tryParse(f.date);
      if (date != null) {
        final key = DateTime(date.year, date.month);
        final value = f.carbonKg.isNaN ? 0 : f.carbonKg;
        totals[key] = (totals[key] ?? 0) + value;
      }
    }
    final keys = totals.keys.toList()..sort();
    return {for (final k in keys) k: totals[k]!};
  }

  Map<String, int> get _dayOfWeekCount {
    final counts = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };
    for (final f in _flights) {
      final date = DateTime.tryParse(f.date);
      if (date != null) {
        final day = date.weekday; // 1 = Mon
        final key = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];
        counts[key] = (counts[key] ?? 0) + 1;
      }
    }
    return counts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyBookAppBar(
        title: 'Status',
        actions: [
          IconButton(
            icon:
                const Icon(Icons.settings, semanticLabel: 'Open settings'),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s),
          children: [
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _StatusTile(
                  icon: Icons.flight,
                  label: 'Total flights',
                  value: _flights.length.toString(),
                ),
                _StatusTile(
                  icon: Icons.schedule,
                  label: 'Total duration',
                  value: '${_totalDuration.toStringAsFixed(1)} hrs',
                ),
                if (_premium)
                  _StatusTile(
                    icon: Icons.cloud,
                    label: 'Total CO₂',
                    value: '${_totalCarbon.round()} kg',
                  )
                else
                  const PremiumBadge(message: 'CO₂ data'),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _StatusTile(
                  icon: Icons.airplanemode_active,
                  label: 'Favorite plane',
                  value: _favoritePlane,
                ),
                _StatusTile(
                  icon: Icons.airlines,
                  label: 'Favorite airline',
                  value: _favoriteAirline,
                ),
                _StatusTile(
                  icon: Icons.place,
                  label: 'Favorite destination',
                  value: _favoriteDestination,
                ),
              ],
            ),
            if (_flights.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildAirportChart(),
            ],
            if (_premium) ...[
              const SizedBox(height: 24),
              _buildAirlineChart(),
              const SizedBox(height: 24),
              _buildRouteChart(),
              const SizedBox(height: 24),
              _buildAircraftChart(),
              const SizedBox(height: 24),
              _buildMonthlyChart(),
              const SizedBox(height: 24),
              _buildAverageDistanceChart(),
              const SizedBox(height: 24),
              _buildCarbonTrendChart(),
              const SizedBox(height: 24),
              _buildDayOfWeekChart(),
              const SizedBox(height: 24),
              _buildCountryChart(),
              const SizedBox(height: 24),
              _buildClassChart(),
              const SizedBox(height: 24),
              _buildTripTypeChart(),
              const SizedBox(height: 24),
              _buildSeatLocationChart(),
            ],
            if (!_premium)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.m),
                child: PremiumBadge(message: 'Detailed charts'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAircraftChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildTopTile(
      icon: Icons.airplanemode_active,
      title: 'Top Aircraft',
      counts: _aircraftCount,
    );
  }

  Widget _buildAirportChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildTopTile(
      icon: Icons.place,
      title: 'Top Airports',
      counts: _airportCount,
    );
  }

  Widget _buildAirlineChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildTopTile(
      icon: Icons.airlines,
      title: 'Top Airlines',
      counts: _airlineCount,
    );
  }

  Widget _buildCountryChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _ExpandableBarListTile(
      title: 'Top Countries',
      counts: _countryCount,
    );
  }

  Widget _buildRouteChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildTopTile(
      icon: Icons.alt_route,
      title: 'Top Routes',
      counts: _routeCount,
    );
  }

  Widget _buildClassChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _ExpandableBarListTile(
      title: 'Class Distribution',
      counts: _classCount,
    );
  }

  Widget _buildTripTypeChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _ExpandableBarListTile(
      title: 'Trip Type Distribution',
      counts: _tripTypeCount,
    );
  }

  Widget _buildSeatLocationChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _ExpandableBarListTile(
      title: 'Seat Location Usage',
      counts: _seatLocationCount,
    );
  }

  Widget _buildTopTile({
    required IconData icon,
    required String title,
    required Map<String, int> counts,
  }) {
    return _ExpandableBarListTile(
      icon: icon,
      title: title,
      counts: counts,
    );
  }

  Widget _buildChartTile({required String title, required Widget child}) {
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildChartTile(
      title: 'Flights per Month',
      child: MonthBarChart(values: _monthlyFlightCounts),
    );
  }

  Widget _buildAverageDistanceChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildChartTile(
      title: 'Avg Distance per Month',
      child: MonthBarChart(values: _monthlyAverageDistance),
    );
  }

  Widget _buildCarbonTrendChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildChartTile(
      title: 'CO₂ per Month',
      child: MonthBarChart(values: _monthlyCarbonTotals),
    );
  }

  Widget _buildDayOfWeekChart() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildChartTile(
      title: 'Flights by Day of Week',
      child: DayOfWeekBarChart(counts: _dayOfWeekCount),
    );
  }

  Widget _buildBarRow(String label, int value, double fraction) {
    return buildBarRow(context, label, value, fraction);
  }
}

Widget buildBarRow(BuildContext context, String label, int value, double fraction) {
  final barColor = Theme.of(context).colorScheme.primary;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
    child: Semantics(
      label: '$label: $value',
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: fraction,
                child: Container(
                  height: 16,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(value.toString()),
        ],
      ),
    ),
  );
}

class _StatusTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatusTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Icon(
              icon,
              size: 24,
              color: colors.primary,
              semanticLabel: label,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: colors.onSurface),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.onSurface),
            ),
        ],
      ),
    );
  }
}

class _ExpandableBarListTile extends StatefulWidget {
  final String title;
  final Map<String, int> counts;
  final IconData? icon;

  const _ExpandableBarListTile({
    required this.title,
    required this.counts,
    this.icon,
  });

  @override
  State<_ExpandableBarListTile> createState() => _ExpandableBarListTileState();
}

class _ExpandableBarListTileState extends State<_ExpandableBarListTile> {
  bool _expanded = false;

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCount = entries.isNotEmpty ? entries.first.value : 1;
    final display = _expanded ? entries : entries.take(3).toList();

    Widget content;
    if (widget.icon != null) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.s),
            child: Column(
              children: [
                Icon(widget.icon!,
                    color: Theme.of(context).colorScheme.primary,
                    semanticLabel: widget.title),
                const SizedBox(height: 4),
                Text(widget.title,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text('total ${entries.length}',
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final e in display)
                  buildBarRow(context, e.key, e.value, e.value / maxCount),
              ],
            ),
          ),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (final e in display)
            buildBarRow(context, e.key, e.value, e.value / maxCount),
        ],
      );
    }

    return SkyBookCard(
      onTap: _toggle,
      padding: const EdgeInsets.all(AppSpacing.s),
      child: content,
    );
  }
}
