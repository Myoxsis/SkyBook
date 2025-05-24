import '../models/airline.dart';

const List<Airline> airlines = [
  Airline(name: 'Air France', callsign: 'AFR', code: 'AF'),
  Airline(name: 'British Airways', callsign: 'BAW', code: 'BA'),
  Airline(name: 'Emirates', callsign: 'UAE', code: 'EK'),
  Airline(name: 'Lufthansa', callsign: 'DLH', code: 'LH'),
  Airline(name: 'Delta Air Lines', callsign: 'DAL', code: 'DL'),
  Airline(name: 'American Airlines', callsign: 'AAL', code: 'AA'),
  Airline(name: 'United Airlines', callsign: 'UAL', code: 'UA'),
  Airline(name: 'Qantas', callsign: 'QFA', code: 'QF'),
];

final Map<String, Airline> airlineByName = {
  for (final a in airlines) a.name: a,
};

final Map<String, Airline> airlineByCode = {
  for (final a in airlines) a.code: a,
};
