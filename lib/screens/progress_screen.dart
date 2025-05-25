import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../utils/achievement_utils.dart';
import 'package:intl/intl.dart';
import '../widgets/skybook_app_bar.dart';
import 'package:share_plus/share_plus.dart';
import '../widgets/app_dialog.dart';

class ProgressScreen extends StatefulWidget {
  final VoidCallback onOpenSettings;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final Map<String, DateTime> unlockedAchievements;

  const ProgressScreen({
    super.key,
    required this.onOpenSettings,
    required this.flightsNotifier,
    required this.unlockedAchievements,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  List<Flight> _flights = [];
  late VoidCallback _listener;
  late TabController _tabController;
  final List<String> _categories = const [
    'All',
    'Flights',
    'Distance',
    'Destinations',
  ];
  final List<String> _statusOptions = const [
    'All',
    'Unlocked',
    'In Progress',
  ];
  String _statusFilter = 'All';

  @override
  void initState() {
    super.initState();
    _flights = widget.flightsNotifier.value;
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
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
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _reloadFromStorage() async {
    final flights = await FlightStorage.loadFlights();
    widget.flightsNotifier.value = flights;
  }

  Widget _buildStatusMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list),
      tooltip: 'Filter achievements',
      onSelected: (value) {
        setState(() {
          _statusFilter = value;
        });
      },
      itemBuilder: (context) {
        return _statusOptions.map((s) {
          return PopupMenuItem<String>(
            value: s,
            child: Row(
              children: [
                if (_statusFilter == s) ...[
                  const Icon(Icons.check, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(s),
              ],
            ),
          );
        }).toList();
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
        actions: [
          _buildStatusMenu(),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reloadFromStorage,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    if (_flights.isEmpty) {
      return const SizedBox.shrink();
    }

    final achievements =
        calculateAchievements(_flights, widget.unlockedAchievements);
    final selected = _categories[_tabController.index];
    final filtered = achievements
        .where((a) => selected == 'All' || a.category == selected)
        .where((a) {
          if (_statusFilter == 'Unlocked') return a.achieved;
          if (_statusFilter == 'In Progress') return !a.achieved;
          return true;
        })
        .toList();

    final unlocked = filtered.where((a) => a.achieved).length;
    final ratio = filtered.isEmpty ? 0.0 : unlocked / filtered.length;

    final summaryCard = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$unlocked of ${filtered.length} Achievements unlocked',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Semantics(
              label:
                  '$unlocked of ${filtered.length} achievements unlocked',
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 6,
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withOpacity(0.12),
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );

    final List<Widget> items = [summaryCard, const SizedBox(height: 8)]
      ..addAll(filtered.map(
        (a) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                  builder: (context) => AppDialog(
                    title: Text(a.title),
                    content: Text(a.description),
                    actions: [
                      if (a.achieved)
                        TextButton(
                          onPressed: () => Share.share(a.description),
                          child: const Text('Share'),
                        ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: a.assetPath != null
                        ? Image.asset(
                            a.assetPath!,
                            width: 24,
                            height: 24,
                            color: a.achieved ? Colors.amber : Colors.grey,
                          )
                        : Icon(
                            a.icon,
                            color: a.achieved ? Colors.amber : Colors.grey,
                          ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title,
                            style: Theme.of(context).textTheme.bodyMedium),
                        if (a.unlockedAt != null)
                          Text(
                            DateFormat.yMMMd().format(a.unlockedAt!),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        const SizedBox(height: 2),
                        Semantics(
                          label:
                              '${a.title} progress: ${a.progress} of ${a.target}',
                          child: LinearProgressIndicator(
                            value: a.progress / a.target,
                            minHeight: 6,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.12),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text('${a.progress}/${a.target}',
                            style: Theme.of(context).textTheme.labelSmall),
                      ],
                    ),
                  ),
                  if (a.achieved)
                    const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(Icons.check, color: Colors.green),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Progress', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        ...items,
      ],
    );
  }
}
