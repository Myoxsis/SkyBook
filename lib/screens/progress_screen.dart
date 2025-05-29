import 'package:flutter/material.dart';

import '../models/flight.dart';
import '../models/flight_storage.dart';
import '../utils/achievement_utils.dart';
import '../models/achievement.dart';
import 'package:intl/intl.dart' as intl;
import '../widgets/skybook_app_bar.dart';
import 'achievement_detail_screen.dart';
import '../widgets/skybook_card.dart';
import '../theme/achievement_theme.dart';
import '../constants.dart';

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

  List<Achievement> _applyTierFilter(List<Achievement> achievements) {
    const tierGroups = {
      'frequentFlyer': [
        'frequentFlyer10',
        'frequentFlyer25',
        'frequentFlyer50',
        'globeTrotter',
      ],
      'distance': [
        'shortHaul',
        'aroundWorld',
        'longHaul',
      ],
    };

    String _groupFor(String id) {
      for (final entry in tierGroups.entries) {
        if (entry.value.contains(id)) return entry.key;
      }
      return id;
    }

    final Map<String, List<Achievement>> groups = {};
    for (final a in achievements) {
      final key = _groupFor(a.id);
      groups.putIfAbsent(key, () => []).add(a);
    }

    final allowedIds = <String>{};
    for (final group in groups.values) {
      group.sort((a, b) => a.tier.compareTo(b.tier));
      int maxUnlocked = 0;
      for (final a in group) {
        if (a.achieved && a.tier > maxUnlocked) maxUnlocked = a.tier;
      }
      final maxTier = (maxUnlocked + 1).clamp(1, group.length);
      allowedIds.addAll(group.where((a) => a.tier <= maxTier).map((e) => e.id));
    }

    return achievements.where((a) => allowedIds.contains(a.id)).toList();
  }

  Widget _buildStatusMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list, semanticLabel: 'Filter list'),
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
                  const Icon(Icons.check, size: 16, semanticLabel: 'Selected'),
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
      appBar: SkyBookAppBar(
        title: 'Progress',
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((c) => Tab(text: c)).toList(),
        ),
        actions: [
          _buildStatusMenu(),
          IconButton(
            icon:
                const Icon(Icons.settings, semanticLabel: 'Open settings'),
            onPressed: widget.onOpenSettings,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _reloadFromStorage,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.s),
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
    final visible = _applyTierFilter(filtered);

    final unlocked = visible.where((a) => a.achieved).length;
    final ratio = visible.isEmpty ? 0.0 : unlocked / visible.length;

    final summaryCard = SkyBookCard(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$unlocked of ${visible.length} Achievements unlocked',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Semantics(
              label:
                  '$unlocked of ${visible.length} achievements unlocked',
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
    );

    final List<Widget> items = [summaryCard, const SizedBox(height: 8)]
      ..addAll(visible.map(
        (a) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: SkyBookCard(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AchievementDetailScreen(achievement: a),
                ),
              );
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: a.buildIcon(
                    color: a.achieved
                        ? (achievementTypeThemes[a.category]?.color ??
                            Theme.of(context).colorScheme.primary)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 24,
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
                          intl.DateFormat.yMMMd().format(a.unlockedAt!),
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
                    ],
                  ),
                ),
                if (a.achieved)
                  const Padding(
                    padding: EdgeInsets.only(left: AppSpacing.xs),
                    child: Icon(Icons.check,
                        color: Colors.green, semanticLabel: 'Completed'),
                  ),
              ],
            ),
          ),
        ),
      ));

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
