import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/skybook_app_bar.dart';
import '../models/developer_storage.dart';
import '../models/premium_storage.dart';

class SettingsScreen extends StatefulWidget {
  final bool darkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback? onClearData;

  const SettingsScreen({
    super.key,
    required this.darkMode,
    required this.onToggleTheme,
    this.onClearData,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _developerMode = false;
  bool _premium = false;

  @override
  void initState() {
    super.initState();
    _loadDeveloperMode();
    _loadPremium();
  }

  Future<void> _loadDeveloperMode() async {
    final saved = await DeveloperStorage.loadDeveloperMode();
    if (mounted) {
      setState(() {
        _developerMode = saved;
      });
    }
  }

  Future<void> _loadPremium() async {
    final saved = await PremiumStorage.loadPremium();
    if (mounted) {
      setState(() {
        _premium = saved;
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
          SwitchListTile(
            title: const Text('Premium'),
            value: _premium,
            onChanged: (val) {
              setState(() {
                _premium = val;
              });
              PremiumStorage.savePremium(val);
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
