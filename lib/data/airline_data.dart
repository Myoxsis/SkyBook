import '../models/airline.dart';

const List<Airline> airlines = [
  Airline(name: 'Air France', callsign: 'AFR'),
  Airline(name: 'British Airways', callsign: 'BAW'),
  Airline(name: 'Emirates', callsign: 'UAE'),
  Airline(name: 'Lufthansa', callsign: 'DLH'),
  Airline(name: 'Delta Air Lines', callsign: 'DAL'),
  Airline(name: 'American Airlines', callsign: 'AAL'),
  Airline(name: 'United Airlines', callsign: 'UAL'),
  Airline(name: 'Qantas', callsign: 'QFA'),
];

final Map<String, Airline> airlineByName = {
  for (final a in airlines) a.name: a,
};
