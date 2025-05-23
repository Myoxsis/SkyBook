import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SkyBookApp());
}

class SkyBookApp extends StatefulWidget {
  const SkyBookApp({super.key});

  @override
  State<SkyBookApp> createState() => _SkyBookAppState();
}

class _SkyBookAppState extends State<SkyBookApp> {
  bool _darkMode = false;

  void _toggleTheme() {
    setState(() {
      _darkMode = !_darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyBook',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}
