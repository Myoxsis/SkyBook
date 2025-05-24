import '../models/airport.dart';

const List<Airport> airports = [
  Airport(
      code: 'CDG',
      name: 'Paris Charles De Gaulle',
      country: 'France',
      latitude: 49.0097,
      longitude: 2.5479),
  Airport(
      code: 'LHR',
      name: 'London Heathrow',
      country: 'United Kingdom',
      latitude: 51.4700,
      longitude: -0.4543),
  Airport(
      code: 'JFK',
      name: 'New York John F. Kennedy',
      country: 'United States',
      latitude: 40.6413,
      longitude: -73.7781),
  Airport(
      code: 'LAX',
      name: 'Los Angeles',
      country: 'United States',
      latitude: 33.9416,
      longitude: -118.4085),
  Airport(
      code: 'HND',
      name: 'Tokyo Haneda',
      country: 'Japan',
      latitude: 35.5494,
      longitude: 139.7798),
  Airport(
      code: 'DXB',
      name: 'Dubai',
      country: 'United Arab Emirates',
      latitude: 25.2532,
      longitude: 55.3657),
  Airport(
      code: 'SIN',
      name: 'Singapore Changi',
      country: 'Singapore',
      latitude: 1.3644,
      longitude: 103.9915),
  Airport(
      code: 'SYD',
      name: 'Sydney',
      country: 'Australia',
      latitude: -33.9399,
      longitude: 151.1753),
  Airport(
      code: 'FRA',
      name: 'Frankfurt',
      country: 'Germany',
      latitude: 50.0379,
      longitude: 8.5622),
  Airport(
      code: 'AMS',
      name: 'Amsterdam Schiphol',
      country: 'Netherlands',
      latitude: 52.3105,
      longitude: 4.7683),
  Airport(
      code: 'MAD',
      name: 'Madrid Barajas',
      country: 'Spain',
      latitude: 40.4983,
      longitude: -3.5676),
  Airport(
      code: 'YYZ',
      name: 'Toronto Pearson',
      country: 'Canada',
      latitude: 43.6777,
      longitude: -79.6248),
  Airport(
      code: 'PEK',
      name: 'Beijing Capital',
      country: 'China',
      latitude: 40.0799,
      longitude: 116.6031),
];

final Map<String, Airport> airportByCode = {
  for (final a in airports) a.code: a,
};
