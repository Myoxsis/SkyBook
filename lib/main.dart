import 'package:flutter/material.dart';
import 'screens/flight_screen.dart';

void main() {
  runApp(const SkyBookApp());
}

class SkyBookApp extends StatelessWidget {
  const SkyBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SkyBook',
      home: FlightScreen(),
    );
  }
}
