import 'package:flutter_test/flutter_test.dart';
import 'package:skybook/utils/achievement_utils.dart';
import 'package:skybook/models/flight.dart';
import 'package:skybook/models/achievement.dart';

Flight _flight(String id, String origin, String destination, double distance) {
  return Flight(
    id: id,
    date: '2023-01-01',
    aircraft: 'Boeing 737',
    manufacturer: 'Boeing',
    airline: '',
    callsign: '',
    duration: '',
    notes: '',
    origin: origin,
    destination: destination,
    travelClass: '',
    seatNumber: '',
    seatLocation: '',
    distanceKm: distance,
    carbonKg: 0,
    originRating: 0,
    destinationRating: 0,
    seatRating: 0,
  );
}

void main() {
  group('calculateAchievements', () {
    test('no flights yields zero progress', () {
      final achievements = calculateAchievements([]);
      final first = achievements.firstWhere((a) => a.id == 'firstFlight');
      final short = achievements.firstWhere((a) => a.id == 'shortHaul');
      final horizons = achievements.firstWhere((a) => a.id == 'newHorizons');

      expect(first.progress, 0);
      expect(first.achieved, isFalse);
      expect(short.progress, 0);
      expect(short.achieved, isFalse);
      expect(horizons.progress, 0);
      expect(horizons.achieved, isFalse);
    });

    test('single flight unlocks first flight', () {
      final flights = [
        _flight('1', 'JFK', 'LAX', 4000),
      ];

      final achievements = calculateAchievements(flights);
      final first = achievements.firstWhere((a) => a.id == 'firstFlight');
      final short = achievements.firstWhere((a) => a.id == 'shortHaul');
      final horizons = achievements.firstWhere((a) => a.id == 'newHorizons');
      final airports = achievements.firstWhere((a) => a.id == 'airportAddict');

      expect(first.progress, 1);
      expect(first.achieved, isTrue);
      expect(short.progress, 4000);
      expect(short.achieved, isTrue);
      expect(horizons.progress, 1);
      expect(horizons.achieved, isFalse);
      expect(airports.progress, 2);
    });

    test('multiple flights accumulate distance and countries', () {
      final flights = [
        _flight('1', 'JFK', 'CDG', 5800),
        _flight('2', 'LHR', 'SYD', 17000),
        _flight('3', 'PEK', 'SIN', 4500),
        _flight('4', 'DXB', 'JFK', 11000),
        _flight('5', 'LAX', 'AKL', 10440),
      ];

      final achievements = calculateAchievements(flights);
      Achievement aroundWorld =
          achievements.firstWhere((a) => a.id == 'aroundWorld');
      Achievement horizons =
          achievements.firstWhere((a) => a.id == 'newHorizons');
      Achievement airports =
          achievements.firstWhere((a) => a.id == 'airportAddict');

      expect(aroundWorld.progress, 48740);
      expect(aroundWorld.achieved, isTrue);
      expect(horizons.progress, 8);
      expect(horizons.achieved, isTrue);
      expect(airports.progress, 9);
      expect(airports.achieved, isFalse);
    });

    test('flight count tiers unlock progressively', () {
      final flights = List.generate(
          30, (i) => _flight('${i + 1}', 'JFK', 'LAX', 4000));

      final achievements = calculateAchievements(flights);
      final tier10 = achievements.firstWhere((a) => a.id == 'frequentFlyer10');
      final tier25 = achievements.firstWhere((a) => a.id == 'frequentFlyer25');
      final tier50 = achievements.firstWhere((a) => a.id == 'frequentFlyer50');

      expect(tier10.achieved, isTrue);
      expect(tier25.achieved, isTrue);
      expect(tier50.achieved, isFalse);
    });

    test('all flight tiers unlock at higher counts', () {
      final flights = List.generate(
          60, (i) => _flight('${i + 1}', 'JFK', 'LAX', 4000));

      final achievements = calculateAchievements(flights);
      final tier10 = achievements.firstWhere((a) => a.id == 'frequentFlyer10');
      final tier25 = achievements.firstWhere((a) => a.id == 'frequentFlyer25');
      final tier50 = achievements.firstWhere((a) => a.id == 'frequentFlyer50');

      expect(tier10.achieved, isTrue);
      expect(tier25.achieved, isTrue);
      expect(tier50.achieved, isTrue);
    });

    test('extended achievements unlock with large dataset', () {
      final codes = [
        'JFK', 'LAX', 'YYZ', 'ATL', 'ORD', 'DFW', 'DEN', 'SFO', 'SEA', 'MIA',
        'BOS', 'MCO', 'IAH', 'IAD', 'YVR', 'YUL', 'LAS', 'PHL', 'CLT', 'MSP',
        'CDG', 'LHR', 'FRA', 'AMS', 'MAD', 'IST', 'FCO', 'ZRH', 'CPH', 'DUB',
        'OSL', 'BRU', 'VIE', 'ATH', 'HEL', 'ARN', 'LIS', 'PRG', 'HND', 'PEK',
        'PVG', 'HKG', 'ICN', 'BKK', 'DEL', 'BOM', 'SIN', 'KUL', 'NRT', 'KIX',
        'TPE', 'CGK', 'MNL', 'SGN', 'DPS', 'KMG', 'KTM', 'CMB', 'HAN', 'DAC',
        'DXB', 'DOH', 'AUH', 'JED', 'RUH', 'MCT', 'BAH', 'AMM', 'CAI', 'TLV',
        'KWI', 'BEY', 'SYD', 'MEL', 'BNE', 'PER', 'AKL', 'WLG', 'CHC', 'ADL',
        'CNS', 'DRW', 'NAN', 'POM', 'JNB', 'CPT', 'DUR', 'NBO', 'ADD', 'DAR',
        'CMN', 'ABJ', 'ACC', 'ALG', 'GRU', 'GIG', 'EZE', 'SCL', 'LIM', 'BOG'
      ];

      final flights = List.generate(
        codes.length,
        (i) => _flight(
          '${i + 1}',
          codes[i],
          codes[(i + 1) % codes.length],
          4000,
        ),
      );

      final achievements = calculateAchievements(flights);
      final jetSetter = achievements.firstWhere((a) => a.id == 'jetSetter');
      final explorer = achievements.firstWhere((a) => a.id == 'worldExplorer');
      final master = achievements.firstWhere((a) => a.id == 'airportMaster');
      final legend = achievements.firstWhere((a) => a.id == 'skyLegend');

      expect(jetSetter.achieved, isTrue);
      expect(explorer.achieved, isTrue);
      expect(master.achieved, isTrue);
      expect(legend.achieved, isTrue);
    });
  });
}
