import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import '../models/flight.dart';

/// Provides utilities for importing flight details from external sources.
class ImportService {
  /// Scans the image at [path] for a barcode or QR code and attempts to
  /// extract flight details. Returns a [Flight] with any discovered fields or
  /// `null` if parsing failed.
  static Future<Flight?> scanBoardingPassImage(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final scanner = BarcodeScanner(formats: [
      BarcodeFormat.qrCode,
      BarcodeFormat.pdf417,
    ]);
    final barcodes = await scanner.processImage(inputImage);
    scanner.close();

    for (final barcode in barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;
      final flight = parseBarcodeData(raw);
      if (flight != null) return flight;
    }
    return null;
  }

  /// Attempts to parse flight details from plain text, such as an itinerary
  /// email. Returns a [Flight] with any discovered fields or `null` if parsing
  /// failed.
  static Flight? parseItineraryText(String text) {
    return _parse(text);
  }

  /// Attempts to parse flight information from raw barcode or QR code data.
  static Flight? parseBarcodeData(String data) {
    return _parse(data);
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
      originRating: 0,
      destinationRating: 0,
      seatRating: 0,
    );
  }
}

