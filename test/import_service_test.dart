import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/services/import_service.dart';

void main() {
  group('ImportService parsing', () {
    test('parse boarding pass text', () {
      const text = 'Flight AB123 from JFK to LAX on 2024-01-01';
      final flight = ImportService.parseItineraryText(text);
      expect(flight, isNotNull);
      expect(flight!.callsign, 'AB123');
      expect(flight.origin, 'JFK');
      expect(flight.destination, 'LAX');
      expect(flight.date, '2024-01-01');
    });

    test('invalid text returns null', () {
      const text = 'Welcome aboard!';
      final flight = ImportService.parseItineraryText(text);
      expect(flight, isNull);
    });
  });
}
