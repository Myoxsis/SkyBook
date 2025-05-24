import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    widget.onClearData?.call();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Local data cleared')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: widget.darkMode,
            onChanged: (_) => widget.onToggleTheme(),
          ),
          SwitchListTile(
            title: const Text('Developer section'),
            value: _developerMode,
            onChanged: (val) {
              setState(() {
                _developerMode = val;
              });
            },
          ),
          if (_developerMode)
            ListTile(
              title: const Text('Remove local data'),
              subtitle: const Text('Used for debugging'),
              trailing: const Icon(Icons.delete),
              onTap: _clearData,
            ),
        ],
      ),
    );
  }
}
