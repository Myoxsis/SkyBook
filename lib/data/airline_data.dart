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
  // North America
  Airline(name: 'Air Canada', callsign: 'ACA', code: 'AC'),
  Airline(name: 'Alaska Airlines', callsign: 'ASA', code: 'AS'),
  Airline(name: 'JetBlue', callsign: 'JBU', code: 'B6'),
  Airline(name: 'Southwest Airlines', callsign: 'SWA', code: 'WN'),
  Airline(name: 'Spirit Airlines', callsign: 'NKS', code: 'NK'),
  Airline(name: 'Frontier Airlines', callsign: 'FFT', code: 'F9'),
  Airline(name: 'WestJet', callsign: 'WJA', code: 'WS'),
  // Europe
  Airline(name: 'KLM', callsign: 'KLM', code: 'KL'),
  Airline(name: 'Swiss', callsign: 'SWR', code: 'LX'),
  Airline(name: 'Turkish Airlines', callsign: 'THY', code: 'TK'),
  Airline(name: 'Ryanair', callsign: 'RYR', code: 'FR'),
  Airline(name: 'easyJet', callsign: 'EZY', code: 'U2'),
  Airline(name: 'Aer Lingus', callsign: 'EIN', code: 'EI'),
  // Asia & Oceania
  Airline(name: 'Singapore Airlines', callsign: 'SIA', code: 'SQ'),
  Airline(name: 'All Nippon Airways', callsign: 'ANA', code: 'NH'),
  Airline(name: 'Air New Zealand', callsign: 'ANZ', code: 'NZ'),
  Airline(name: 'Qatar Airways', callsign: 'QTR', code: 'QR'),
  Airline(name: 'Cathay Pacific', callsign: 'CPA', code: 'CX'),
  Airline(name: 'Air India', callsign: 'AIC', code: 'AI'),
  Airline(name: 'EVA Air', callsign: 'EVA', code: 'BR'),
  Airline(name: 'Etihad Airways', callsign: 'ETD', code: 'EY'),
  Airline(name: 'Ethiopian Airlines', callsign: 'ETH', code: 'ET'),
];

final Map<String, Airline> airlineByName = {
  for (final a in airlines) a.name: a,
};

final Map<String, Airline> airlineByCode = {
  for (final a in airlines) a.code: a,
};
