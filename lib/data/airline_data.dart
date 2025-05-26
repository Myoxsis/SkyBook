import '../models/airline.dart';
import '../models/airline_storage.dart';

const List<Airline> seedAirlines = [
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
  // South America
  Airline(name: 'LATAM Airlines', callsign: 'LAN', code: 'LA'),
  Airline(name: 'Aerol\u00edneas Argentinas', callsign: 'ARG', code: 'AR'),
  Airline(name: 'Aerom\u00e9xico', callsign: 'AMX', code: 'AM'),
  // Middle East
  Airline(name: 'Saudia', callsign: 'SVA', code: 'SV'),
  // Africa
  Airline(name: 'South African Airways', callsign: 'SAA', code: 'SA'),
  Airline(name: 'Kenya Airways', callsign: 'KQA', code: 'KQ'),
  // Europe (additional)
  Airline(name: 'Virgin Atlantic', callsign: 'VIR', code: 'VS'),
  Airline(name: 'Iberia', callsign: 'IBE', code: 'IB'),
  Airline(name: 'Finnair', callsign: 'FIN', code: 'AY'),
  Airline(name: 'Scandinavian Airlines', callsign: 'SAS', code: 'SK'),
  // Asia (additional)
  Airline(name: 'Air China', callsign: 'CCA', code: 'CA'),
  Airline(name: 'Korean Air', callsign: 'KAL', code: 'KE'),
  Airline(name: 'AirAsia', callsign: 'AXM', code: 'AK'),
  Airline(name: 'Philippine Airlines', callsign: 'PAL', code: 'PR'),
  // Additional Airlines
  Airline(name: 'Vietnam Airlines', callsign: 'HVN', code: 'VN'),
  Airline(name: 'Thai Airways', callsign: 'THA', code: 'TG'),
  Airline(name: 'Icelandair', callsign: 'ICE', code: 'FI'),
  Airline(name: 'Malaysia Airlines', callsign: 'MAS', code: 'MH'),
  Airline(name: 'Garuda Indonesia', callsign: 'GIA', code: 'GA'),
  Airline(name: 'AirBaltic', callsign: 'BTI', code: 'BT'),
  Airline(name: 'TAP Air Portugal', callsign: 'TAP', code: 'TP'),
  Airline(name: 'Virgin Australia', callsign: 'VOZ', code: 'VA'),
  Airline(name: 'Hawaiian Airlines', callsign: 'HAL', code: 'HA'),
  Airline(name: 'Copa Airlines', callsign: 'CMP', code: 'CM'),
];

List<Airline> airlines = [];
Map<String, Airline> airlineByName = {};
Map<String, Airline> airlineByCode = {};

Future<void> loadAirlineData() async {
  airlines = await AirlineStorage.loadAirlines();
  if (airlines.isEmpty) {
    airlines = seedAirlines;
  }
  airlineByName = {for (final a in airlines) a.name: a};
  airlineByCode = {for (final a in airlines) a.code: a};
}

