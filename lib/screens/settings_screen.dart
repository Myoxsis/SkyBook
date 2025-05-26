import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/skybook_app_bar.dart';
import '../models/developer_storage.dart';
import '../models/premium_storage.dart';
import '../models/flight.dart';
import 'data_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback? onClearData;
  final ValueNotifier<bool> premiumNotifier;
  final ValueNotifier<List<Flight>> flightsNotifier;
  final Future<void> Function() onFlightsChanged;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onToggleTheme,
    this.onClearData,
    required this.premiumNotifier,
    required this.flightsNotifier,
    required this.onFlightsChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _developerMode = false;

  @override
  void initState() {
    super.initState();
    _loadDeveloperMode();
  }

  Future<void> _loadDeveloperMode() async {
    final saved = await DeveloperStorage.loadDeveloperMode();
    if (mounted) {
      setState(() {
        _developerMode = saved;
      });
    }
  }

  Future<void> _clearData() async {
    widget.onClearData?.call();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('flights');
    await prefs.remove('achievements');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Local data cleared')),
      );
    }
  }

  void _openDataManagement() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DataManagementScreen(
          flightsNotifier: widget.flightsNotifier,
          onFlightsChanged: widget.onFlightsChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SkyBookAppBar(title: 'Settings'),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: widget.darkMode,
            onChanged: (_) => widget.onToggleTheme(),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.premiumNotifier,
            builder: (context, value, _) {
              return SwitchListTile(
                title: const Text('Premium'),
                value: value,
                onChanged: (val) {
                  widget.premiumNotifier.value = val;
                  PremiumStorage.savePremium(val);
                },
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.premiumNotifier,
            builder: (context, premium, _) {
              if (!premium) return const SizedBox.shrink();
              return ListTile(
                title: const Text('Import / Export'),
                trailing: const Icon(Icons.file_upload),
                onTap: _openDataManagement,
              );
            },
          ),
          SwitchListTile(
            title: const Text('Developer section'),
            value: _developerMode,
            onChanged: (val) {
              setState(() {
                _developerMode = val;
              });
              DeveloperStorage.saveDeveloperMode(val);
            },
          ),
          if (_developerMode)
            ListTile(
              title: const Text('Remove local data'),
              subtitle: const Text('Used for debugging'),
              trailing: const Icon(Icons.delete),
              onTap: _clearData,
            ),
          const Divider(),
          const ListTile(
            title: Text('About'),
            subtitle:
                Text('Developed by Myoxsis - Maxime Alain & some fortunate help'),
          ),
        ],
      ),
    );
  }
}
