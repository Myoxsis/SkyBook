import '../models/airport.dart';

const List<Airport> airports = [
  Airport(code: 'CDG', name: 'Paris Charles De Gaulle', country: 'France'),
  Airport(code: 'LHR', name: 'London Heathrow', country: 'United Kingdom'),
  Airport(code: 'JFK', name: 'New York John F. Kennedy', country: 'United States'),
  Airport(code: 'LAX', name: 'Los Angeles', country: 'United States'),
  Airport(code: 'HND', name: 'Tokyo Haneda', country: 'Japan'),
  Airport(code: 'DXB', name: 'Dubai', country: 'United Arab Emirates'),
  Airport(code: 'SIN', name: 'Singapore Changi', country: 'Singapore'),
  Airport(code: 'SYD', name: 'Sydney', country: 'Australia'),
  Airport(code: 'FRA', name: 'Frankfurt', country: 'Germany'),
  Airport(code: 'AMS', name: 'Amsterdam Schiphol', country: 'Netherlands'),
  Airport(code: 'MAD', name: 'Madrid Barajas', country: 'Spain'),
  Airport(code: 'YYZ', name: 'Toronto Pearson', country: 'Canada'),
  Airport(code: 'PEK', name: 'Beijing Capital', country: 'China'),
];

final Map<String, Airport> airportByCode = {
  for (final a in airports) a.code: a,
};
