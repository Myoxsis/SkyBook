import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../models/flight.dart';

/// Provides utilities for importing flight details from external sources.
class ImportService {
  /// Runs text recognition on the image at [path] and attempts to parse flight
  /// details from the recognized text. Returns a [Flight] with any discovered
  /// fields or `null` if parsing failed.
  static Future<Flight?> scanBoardingPassImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final result = await recognizer.processImage(inputImage);
    recognizer.close();
    return _parse(result.text);
  }

  /// Attempts to parse flight details from plain text, such as an itinerary
  /// email. Returns a [Flight] with any discovered fields or `null` if parsing
  /// failed.
  static Flight? parseItineraryText(String text) {
    return _parse(text);
  }

  /// Extracts a flight number, origin, destination and optional date from
  /// [text]. The date may be expressed as `yyyy-mm-dd` or `yyyy/mm/dd`.
  static Flight? _parse(String text) {
    final flightMatch = RegExp(r'\b([A-Z]{2}\d{1,4})\b').firstMatch(text);
    final airportMatches =
        RegExp(r'\b([A-Z]{3})\b').allMatches(text).map((m) => m.group(1)!).toList();
    final dateMatch = RegExp(r'(\d{4}[-/]\d{2}[-/]\d{2})').firstMatch(text);

    if (flightMatch == null || airportMatches.length < 2) {
      return null;
    }

    final date = dateMatch != null
        ? dateMatch.group(1)!.replaceAll('/', '-')
        : '';

    return Flight(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      aircraft: '',
      manufacturer: '',
      airline: '',
      callsign: flightMatch.group(1) ?? '',
      duration: '',
      notes: '',
      origin: airportMatches[0],
      destination: airportMatches[1],
      travelClass: '',
      seatNumber: '',
      seatLocation: '',
    );
  }
}

