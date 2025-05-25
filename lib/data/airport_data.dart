import '../models/airport.dart';

/// List of major airports grouped by geographic region.
const List<Airport> airports = [
  // North America
  Airport(
      code: 'JFK',
      name: 'New York John F. Kennedy',
      country: 'United States',
      region: 'North America',
      latitude: 40.6413,
      longitude: -73.7781),
  Airport(
      code: 'LAX',
      name: 'Los Angeles',
      country: 'United States',
      region: 'North America',
      latitude: 33.9416,
      longitude: -118.4085),
  Airport(
      code: 'YYZ',
      name: 'Toronto Pearson',
      country: 'Canada',
      region: 'North America',
      latitude: 43.6777,
      longitude: -79.6248),
  Airport(
      code: 'ATL',
      name: 'Hartsfield-Jackson Atlanta',
      country: 'United States',
      region: 'North America',
      latitude: 33.6407,
      longitude: -84.4277),
  Airport(
      code: 'ORD',
      name: 'Chicago O\'Hare',
      country: 'United States',
      region: 'North America',
      latitude: 41.9742,
      longitude: -87.9073),
  Airport(
      code: 'DFW',
      name: 'Dallas/Fort Worth',
      country: 'United States',
      region: 'North America',
      latitude: 32.8998,
      longitude: -97.0403),
  Airport(
      code: 'DEN',
      name: 'Denver International',
      country: 'United States',
      region: 'North America',
      latitude: 39.8561,
      longitude: -104.6737),
  Airport(
      code: 'SFO',
      name: 'San Francisco',
      country: 'United States',
      region: 'North America',
      latitude: 37.6213,
      longitude: -122.3790),
  Airport(
      code: 'SEA',
      name: 'Seattle-Tacoma',
      country: 'United States',
      region: 'North America',
      latitude: 47.4502,
      longitude: -122.3088),
  Airport(
      code: 'MIA',
      name: 'Miami International',
      country: 'United States',
      region: 'North America',
      latitude: 25.7959,
      longitude: -80.2870),

  // Europe
  Airport(
      code: 'CDG',
      name: 'Paris Charles De Gaulle',
      country: 'France',
      region: 'Europe',
      latitude: 49.0097,
      longitude: 2.5479),
  Airport(
      code: 'LHR',
      name: 'London Heathrow',
      country: 'United Kingdom',
      region: 'Europe',
      latitude: 51.4700,
      longitude: -0.4543),
  Airport(
      code: 'FRA',
      name: 'Frankfurt',
      country: 'Germany',
      region: 'Europe',
      latitude: 50.0379,
      longitude: 8.5622),
  Airport(
      code: 'AMS',
      name: 'Amsterdam Schiphol',
      country: 'Netherlands',
      region: 'Europe',
      latitude: 52.3105,
      longitude: 4.7683),
  Airport(
      code: 'MAD',
      name: 'Madrid Barajas',
      country: 'Spain',
      region: 'Europe',
      latitude: 40.4983,
      longitude: -3.5676),
  Airport(
      code: 'IST',
      name: 'Istanbul',
      country: 'Turkey',
      region: 'Europe',
      latitude: 41.2753,
      longitude: 28.7519),
  Airport(
      code: 'FCO',
      name: 'Rome Fiumicino',
      country: 'Italy',
      region: 'Europe',
      latitude: 41.8003,
      longitude: 12.2389),
  Airport(
      code: 'BCN',
      name: 'Barcelona El Prat',
      country: 'Spain',
      region: 'Europe',
      latitude: 41.2974,
      longitude: 2.0833),
  Airport(
      code: 'ZRH',
      name: 'Zurich',
      country: 'Switzerland',
      region: 'Europe',
      latitude: 47.4581,
      longitude: 8.5555),
  Airport(
      code: 'CPH',
      name: 'Copenhagen',
      country: 'Denmark',
      region: 'Europe',
      latitude: 55.6181,
      longitude: 12.6560),

  // Asia
  Airport(
      code: 'HND',
      name: 'Tokyo Haneda',
      country: 'Japan',
      region: 'Asia',
      latitude: 35.5494,
      longitude: 139.7798),
  Airport(
      code: 'PEK',
      name: 'Beijing Capital',
      country: 'China',
      region: 'Asia',
      latitude: 40.0799,
      longitude: 116.6031),
  Airport(
      code: 'PVG',
      name: 'Shanghai Pudong',
      country: 'China',
      region: 'Asia',
      latitude: 31.1443,
      longitude: 121.8083),
  Airport(
      code: 'HKG',
      name: 'Hong Kong',
      country: 'Hong Kong',
      region: 'Asia',
      latitude: 22.3080,
      longitude: 113.9185),
  Airport(
      code: 'ICN',
      name: 'Seoul Incheon',
      country: 'South Korea',
      region: 'Asia',
      latitude: 37.4602,
      longitude: 126.4407),
  Airport(
      code: 'BKK',
      name: 'Bangkok Suvarnabhumi',
      country: 'Thailand',
      region: 'Asia',
      latitude: 13.6900,
      longitude: 100.7501),
  Airport(
      code: 'DEL',
      name: 'Delhi Indira Gandhi',
      country: 'India',
      region: 'Asia',
      latitude: 28.5562,
      longitude: 77.1000),
  Airport(
      code: 'BOM',
      name: 'Mumbai Chhatrapati Shivaji',
      country: 'India',
      region: 'Asia',
      latitude: 19.0896,
      longitude: 72.8656),
  Airport(
      code: 'SIN',
      name: 'Singapore Changi',
      country: 'Singapore',
      region: 'Asia',
      latitude: 1.3644,
      longitude: 103.9915),
  Airport(
      code: 'KUL',
      name: 'Kuala Lumpur',
      country: 'Malaysia',
      region: 'Asia',
      latitude: 2.7456,
      longitude: 101.7090),

  // Middle East
  Airport(
      code: 'DXB',
      name: 'Dubai',
      country: 'United Arab Emirates',
      region: 'Middle East',
      latitude: 25.2532,
      longitude: 55.3657),
  Airport(
      code: 'DOH',
      name: 'Hamad International',
      country: 'Qatar',
      region: 'Middle East',
      latitude: 25.2731,
      longitude: 51.6081),
  Airport(
      code: 'AUH',
      name: 'Abu Dhabi',
      country: 'United Arab Emirates',
      region: 'Middle East',
      latitude: 24.4539,
      longitude: 54.3773),
  Airport(
      code: 'JED',
      name: 'Jeddah King Abdulaziz',
      country: 'Saudi Arabia',
      region: 'Middle East',
      latitude: 21.6702,
      longitude: 39.1525),
  Airport(
      code: 'RUH',
      name: 'Riyadh King Khalid',
      country: 'Saudi Arabia',
      region: 'Middle East',
      latitude: 24.9576,
      longitude: 46.6988),
  Airport(
      code: 'MCT',
      name: 'Muscat',
      country: 'Oman',
      region: 'Middle East',
      latitude: 23.5933,
      longitude: 58.2844),
  Airport(
      code: 'BAH',
      name: 'Bahrain International',
      country: 'Bahrain',
      region: 'Middle East',
      latitude: 26.2708,
      longitude: 50.6336),
  Airport(
      code: 'AMM',
      name: 'Queen Alia Amman',
      country: 'Jordan',
      region: 'Middle East',
      latitude: 31.7226,
      longitude: 35.9932),
  Airport(
      code: 'CAI',
      name: 'Cairo',
      country: 'Egypt',
      region: 'Middle East',
      latitude: 30.1121,
      longitude: 31.4009),
  Airport(
      code: 'TLV',
      name: 'Tel Aviv Ben Gurion',
      country: 'Israel',
      region: 'Middle East',
      latitude: 32.0004,
      longitude: 34.8708),

  // Oceania
  Airport(
      code: 'SYD',
      name: 'Sydney',
      country: 'Australia',
      region: 'Oceania',
      latitude: -33.9399,
      longitude: 151.1753),
  Airport(
      code: 'MEL',
      name: 'Melbourne',
      country: 'Australia',
      region: 'Oceania',
      latitude: -37.6733,
      longitude: 144.8433),
  Airport(
      code: 'BNE',
      name: 'Brisbane',
      country: 'Australia',
      region: 'Oceania',
      latitude: -27.3842,
      longitude: 153.1175),
  Airport(
      code: 'PER',
      name: 'Perth',
      country: 'Australia',
      region: 'Oceania',
      latitude: -31.9403,
      longitude: 115.9672),
  Airport(
      code: 'AKL',
      name: 'Auckland',
      country: 'New Zealand',
      region: 'Oceania',
      latitude: -37.0082,
      longitude: 174.7850),
  Airport(
      code: 'WLG',
      name: 'Wellington',
      country: 'New Zealand',
      region: 'Oceania',
      latitude: -41.3272,
      longitude: 174.8053),
  Airport(
      code: 'CHC',
      name: 'Christchurch',
      country: 'New Zealand',
      region: 'Oceania',
      latitude: -43.4894,
      longitude: 172.5323),
  Airport(
      code: 'ADL',
      name: 'Adelaide',
      country: 'Australia',
      region: 'Oceania',
      latitude: -34.9450,
      longitude: 138.5306),
  Airport(
      code: 'CNS',
      name: 'Cairns',
      country: 'Australia',
      region: 'Oceania',
      latitude: -16.8858,
      longitude: 145.7553),
  Airport(
      code: 'DRW',
      name: 'Darwin',
      country: 'Australia',
      region: 'Oceania',
      latitude: -12.4083,
      longitude: 130.8727),
];

final Map<String, Airport> airportByCode = {
  for (final a in airports) a.code: a,
};

/// Returns airports organized by their region.
Map<String, List<Airport>> get airportsByRegion {
  final map = <String, List<Airport>>{};
  for (final a in airports) {
    map.putIfAbsent(a.region, () => []).add(a);
  }
  return map;
}
