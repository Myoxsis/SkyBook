import '../models/airport.dart';
import '../models/airport_storage.dart';

/// Seed list of major airports grouped by geographic region.
const List<Airport> seedAirports = [
  // North America
  Airport(code: 'JFK', name: 'New York John F. Kennedy', country: 'United States', region: 'North America', latitude: 40.6413, longitude: -73.7781),
  Airport(code: 'LAX', name: 'Los Angeles', country: 'United States', region: 'North America', latitude: 33.9416, longitude: -118.4085),
  Airport(code: 'YYZ', name: 'Toronto Pearson', country: 'Canada', region: 'North America', latitude: 43.6777, longitude: -79.6248),
  Airport(code: 'ATL', name: 'Hartsfield-Jackson Atlanta', country: 'United States', region: 'North America', latitude: 33.6407, longitude: -84.4277),
  Airport(code: 'ORD', name: 'Chicago O\'Hare', country: 'United States', region: 'North America', latitude: 41.9742, longitude: -87.9073),
  Airport(code: 'DFW', name: 'Dallas/Fort Worth', country: 'United States', region: 'North America', latitude: 32.8998, longitude: -97.0403),
  Airport(code: 'DEN', name: 'Denver International', country: 'United States', region: 'North America', latitude: 39.8561, longitude: -104.6737),
  Airport(code: 'SFO', name: 'San Francisco', country: 'United States', region: 'North America', latitude: 37.6213, longitude: -122.3790),
  Airport(code: 'SEA', name: 'Seattle-Tacoma', country: 'United States', region: 'North America', latitude: 47.4502, longitude: -122.3088),
  Airport(code: 'MIA', name: 'Miami International', country: 'United States', region: 'North America', latitude: 25.7959, longitude: -80.2870),
  Airport(code: 'BOS', name: 'Boston Logan', country: 'United States', region: 'North America', latitude: 42.3656, longitude: -71.0096),
  Airport(code: 'MCO', name: 'Orlando International', country: 'United States', region: 'North America', latitude: 28.4312, longitude: -81.3081),
  Airport(code: 'IAH', name: 'Houston George Bush', country: 'United States', region: 'North America', latitude: 29.9902, longitude: -95.3368),
  Airport(code: 'IAD', name: 'Washington Dulles', country: 'United States', region: 'North America', latitude: 38.9531, longitude: -77.4565),
  Airport(code: 'YVR', name: 'Vancouver', country: 'Canada', region: 'North America', latitude: 49.1951, longitude: -123.1779),
  Airport(code: 'YUL', name: 'Montreal Trudeau', country: 'Canada', region: 'North America', latitude: 45.4706, longitude: -73.7408),
  Airport(code: 'LAS', name: 'Las Vegas Harry Reid', country: 'United States', region: 'North America', latitude: 36.0840, longitude: -115.1537),
  Airport(code: 'PHL', name: 'Philadelphia', country: 'United States', region: 'North America', latitude: 39.8744, longitude: -75.2424),
  Airport(code: 'CLT', name: 'Charlotte Douglas', country: 'United States', region: 'North America', latitude: 35.2140, longitude: -80.9431),
  Airport(code: 'MSP', name: 'Minneapolis–St Paul', country: 'United States', region: 'North America', latitude: 44.8830, longitude: -93.2289),
  Airport(code: 'DTW', name: 'Detroit Metropolitan', country: 'United States', region: 'North America', latitude: 42.2162, longitude: -83.3554),
  Airport(code: 'PHX', name: 'Phoenix Sky Harbor', country: 'United States', region: 'North America', latitude: 33.4353, longitude: -112.0000),

  // Europe
  Airport(code: 'CDG', name: 'Paris Charles De Gaulle', country: 'France', region: 'Europe', latitude: 49.0097, longitude: 2.5479),
  Airport(code: 'LHR', name: 'London Heathrow', country: 'United Kingdom', region: 'Europe', latitude: 51.4700, longitude: -0.4543),
  Airport(code: 'FRA', name: 'Frankfurt', country: 'Germany', region: 'Europe', latitude: 50.0379, longitude: 8.5622),
  Airport(code: 'AMS', name: 'Amsterdam Schiphol', country: 'Netherlands', region: 'Europe', latitude: 52.3105, longitude: 4.7683),
  Airport(code: 'MAD', name: 'Madrid Barajas', country: 'Spain', region: 'Europe', latitude: 40.4983, longitude: -3.5676),
  Airport(code: 'IST', name: 'Istanbul', country: 'Turkey', region: 'Europe', latitude: 41.2753, longitude: 28.7519),
  Airport(code: 'FCO', name: 'Rome Fiumicino', country: 'Italy', region: 'Europe', latitude: 41.8003, longitude: 12.2389),
  Airport(code: 'BCN', name: 'Barcelona El Prat', country: 'Spain', region: 'Europe', latitude: 41.2974, longitude: 2.0833),
  Airport(code: 'ZRH', name: 'Zurich', country: 'Switzerland', region: 'Europe', latitude: 47.4581, longitude: 8.5555),
  Airport(code: 'CPH', name: 'Copenhagen', country: 'Denmark', region: 'Europe', latitude: 55.6181, longitude: 12.6560),
  Airport(code: 'DUB', name: 'Dublin', country: 'Ireland', region: 'Europe', latitude: 53.4213, longitude: -6.2701),
  Airport(code: 'OSL', name: 'Oslo Gardermoen', country: 'Norway', region: 'Europe', latitude: 60.1976, longitude: 11.1004),
  Airport(code: 'BRU', name: 'Brussels', country: 'Belgium', region: 'Europe', latitude: 50.9010, longitude: 4.4844),
  Airport(code: 'VIE', name: 'Vienna', country: 'Austria', region: 'Europe', latitude: 48.1103, longitude: 16.5697),
  Airport(code: 'ATH', name: 'Athens', country: 'Greece', region: 'Europe', latitude: 37.9364, longitude: 23.9445),
  Airport(code: 'MAN', name: 'Manchester', country: 'United Kingdom', region: 'Europe', latitude: 53.3537, longitude: -2.2749),
  Airport(code: 'HEL', name: 'Helsinki', country: 'Finland', region: 'Europe', latitude: 60.3172, longitude: 24.9633),
  Airport(code: 'ARN', name: 'Stockholm Arlanda', country: 'Sweden', region: 'Europe', latitude: 59.6519, longitude: 17.9186),
  Airport(code: 'LIS', name: 'Lisbon', country: 'Portugal', region: 'Europe', latitude: 38.7742, longitude: -9.1342),
  Airport(code: 'PRG', name: 'Prague Vaclav Havel', country: 'Czech Republic', region: 'Europe', latitude: 50.1008, longitude: 14.2632),
  Airport(code: 'SVO', name: 'Moscow Sheremetyevo', country: 'Russia', region: 'Europe', latitude: 55.9726, longitude: 37.4146),
  Airport(code: 'LYS', name: 'Lyon Saint Exupéry', country: 'France', region: 'Europe', latitude: 45.7256, longitude: 5.0811),

  // Asia
  Airport(code: 'HND', name: 'Tokyo Haneda', country: 'Japan', region: 'Asia', latitude: 35.5494, longitude: 139.7798),
  Airport(code: 'PEK', name: 'Beijing Capital', country: 'China', region: 'Asia', latitude: 40.0799, longitude: 116.6031),
  Airport(code: 'PVG', name: 'Shanghai Pudong', country: 'China', region: 'Asia', latitude: 31.1443, longitude: 121.8083),
  Airport(code: 'HKG', name: 'Hong Kong', country: 'Hong Kong', region: 'Asia', latitude: 22.3080, longitude: 113.9185),
  Airport(code: 'ICN', name: 'Seoul Incheon', country: 'South Korea', region: 'Asia', latitude: 37.4602, longitude: 126.4407),
  Airport(code: 'BKK', name: 'Bangkok Suvarnabhumi', country: 'Thailand', region: 'Asia', latitude: 13.6900, longitude: 100.7501),
  Airport(code: 'DEL', name: 'Delhi Indira Gandhi', country: 'India', region: 'Asia', latitude: 28.5562, longitude: 77.1000),
  Airport(code: 'BOM', name: 'Mumbai Chhatrapati Shivaji', country: 'India', region: 'Asia', latitude: 19.0896, longitude: 72.8656),
  Airport(code: 'SIN', name: 'Singapore Changi', country: 'Singapore', region: 'Asia', latitude: 1.3644, longitude: 103.9915),
  Airport(code: 'KUL', name: 'Kuala Lumpur', country: 'Malaysia', region: 'Asia', latitude: 2.7456, longitude: 101.7090),
  Airport(code: 'NRT', name: 'Tokyo Narita', country: 'Japan', region: 'Asia', latitude: 35.7720, longitude: 140.3929),
  Airport(code: 'KIX', name: 'Osaka Kansai', country: 'Japan', region: 'Asia', latitude: 34.4347, longitude: 135.2442),
  Airport(code: 'TPE', name: 'Taipei Taoyuan', country: 'Taiwan', region: 'Asia', latitude: 25.0799, longitude: 121.2325),
  Airport(code: 'CGK', name: 'Jakarta Soekarno-Hatta', country: 'Indonesia', region: 'Asia', latitude: -6.1256, longitude: 106.6559),
  Airport(code: 'MNL', name: 'Manila Ninoy Aquino', country: 'Philippines', region: 'Asia', latitude: 14.5086, longitude: 121.0198),
  Airport(code: 'SGN', name: 'Ho Chi Minh Tan Son Nhat', country: 'Vietnam', region: 'Asia', latitude: 10.8188, longitude: 106.6520),
  Airport(code: 'DPS', name: 'Bali Ngurah Rai', country: 'Indonesia', region: 'Asia', latitude: -8.7482, longitude: 115.1670),
  Airport(code: 'KMG', name: 'Kunming Changshui', country: 'China', region: 'Asia', latitude: 25.1019, longitude: 102.9292),
  Airport(code: 'KTM', name: 'Kathmandu Tribhuvan', country: 'Nepal', region: 'Asia', latitude: 27.6979, longitude: 85.3591),
  Airport(code: 'CMB', name: 'Colombo Bandaranaike', country: 'Sri Lanka', region: 'Asia', latitude: 7.1808, longitude: 79.8841),
  Airport(code: 'HAN', name: 'Hanoi Noi Bai', country: 'Vietnam', region: 'Asia', latitude: 21.2142, longitude: 105.8042),
  Airport(code: 'DAC', name: 'Dhaka Shahjalal', country: 'Bangladesh', region: 'Asia', latitude: 23.8433, longitude: 90.3978),

  // Middle East
  Airport(code: 'DXB', name: 'Dubai', country: 'United Arab Emirates', region: 'Middle East', latitude: 25.2532, longitude: 55.3657),
  Airport(code: 'DOH', name: 'Hamad International', country: 'Qatar', region: 'Middle East', latitude: 25.2731, longitude: 51.6081),
  Airport(code: 'AUH', name: 'Abu Dhabi', country: 'United Arab Emirates', region: 'Middle East', latitude: 24.4539, longitude: 54.3773),
  Airport(code: 'JED', name: 'Jeddah King Abdulaziz', country: 'Saudi Arabia', region: 'Middle East', latitude: 21.6702, longitude: 39.1525),
  Airport(code: 'RUH', name: 'Riyadh King Khalid', country: 'Saudi Arabia', region: 'Middle East', latitude: 24.9576, longitude: 46.6988),
  Airport(code: 'MCT', name: 'Muscat', country: 'Oman', region: 'Middle East', latitude: 23.5933, longitude: 58.2844),
  Airport(code: 'BAH', name: 'Bahrain International', country: 'Bahrain', region: 'Middle East', latitude: 26.2708, longitude: 50.6336),
  Airport(code: 'AMM', name: 'Queen Alia Amman', country: 'Jordan', region: 'Middle East', latitude: 31.7226, longitude: 35.9932),
  Airport(code: 'CAI', name: 'Cairo', country: 'Egypt', region: 'Middle East', latitude: 30.1121, longitude: 31.4009),
  Airport(code: 'TLV', name: 'Tel Aviv Ben Gurion', country: 'Israel', region: 'Middle East', latitude: 32.0004, longitude: 34.8708),
  Airport(code: 'KWI', name: 'Kuwait', country: 'Kuwait', region: 'Middle East', latitude: 29.2266, longitude: 47.9689),
  Airport(code: 'BEY', name: 'Beirut Rafic Hariri', country: 'Lebanon', region: 'Middle East', latitude: 33.8209, longitude: 35.4884),

  // Oceania
  Airport(code: 'SYD', name: 'Sydney', country: 'Australia', region: 'Oceania', latitude: -33.9399, longitude: 151.1753),
  Airport(code: 'MEL', name: 'Melbourne', country: 'Australia', region: 'Oceania', latitude: -37.6733, longitude: 144.8433),
  Airport(code: 'BNE', name: 'Brisbane', country: 'Australia', region: 'Oceania', latitude: -27.3842, longitude: 153.1175),
  Airport(code: 'PER', name: 'Perth', country: 'Australia', region: 'Oceania', latitude: -31.9403, longitude: 115.9672),
  Airport(code: 'AKL', name: 'Auckland', country: 'New Zealand', region: 'Oceania', latitude: -37.0082, longitude: 174.7850),
  Airport(code: 'WLG', name: 'Wellington', country: 'New Zealand', region: 'Oceania', latitude: -41.3272, longitude: 174.8053),
  Airport(code: 'CHC', name: 'Christchurch', country: 'New Zealand', region: 'Oceania', latitude: -43.4894, longitude: 172.5323),
  Airport(code: 'ADL', name: 'Adelaide', country: 'Australia', region: 'Oceania', latitude: -34.9450, longitude: 138.5306),
  Airport(code: 'CNS', name: 'Cairns', country: 'Australia', region: 'Oceania', latitude: -16.8858, longitude: 145.7553),
  Airport(code: 'DRW', name: 'Darwin', country: 'Australia', region: 'Oceania', latitude: -12.4083, longitude: 130.8727),
  Airport(code: 'NAN', name: 'Nadi International', country: 'Fiji', region: 'Oceania', latitude: -17.7554, longitude: 177.4434),
  Airport(code: 'POM', name: 'Port Moresby Jacksons', country: 'Papua New Guinea', region: 'Oceania', latitude: -9.4434, longitude: 147.2200),

  // Africa
  Airport(code: 'JNB', name: 'Johannesburg O. R. Tambo', country: 'South Africa', region: 'Africa', latitude: -26.1337, longitude: 28.2420),
  Airport(code: 'CPT', name: 'Cape Town', country: 'South Africa', region: 'Africa', latitude: -33.9706, longitude: 18.6021),
  Airport(code: 'DUR', name: 'Durban King Shaka', country: 'South Africa', region: 'Africa', latitude: -29.6144, longitude: 31.1197),
  Airport(code: 'NBO', name: 'Nairobi Jomo Kenyatta', country: 'Kenya', region: 'Africa', latitude: -1.3192, longitude: 36.9278),
  Airport(code: 'ADD', name: 'Addis Ababa Bole', country: 'Ethiopia', region: 'Africa', latitude: 8.9779, longitude: 38.7990),
  Airport(code: 'DAR', name: 'Dar es Salaam', country: 'Tanzania', region: 'Africa', latitude: -6.8781, longitude: 39.2026),
  Airport(code: 'CMN', name: 'Casablanca Mohammed V', country: 'Morocco', region: 'Africa', latitude: 33.3672, longitude: -7.5898),
  Airport(code: 'ABJ', name: 'Abidjan Houphouet-Boigny', country: 'Ivory Coast', region: 'Africa', latitude: 5.2556, longitude: -3.9297),
  Airport(code: 'ACC', name: 'Accra Kotoka', country: 'Ghana', region: 'Africa', latitude: 5.6050, longitude: -0.1682),
  Airport(code: 'ALG', name: 'Algiers Houari Boumediene', country: 'Algeria', region: 'Africa', latitude: 36.6930, longitude: 3.2154),

  // South America
  Airport(code: 'GRU', name: 'Sao Paulo Guarulhos', country: 'Brazil', region: 'South America', latitude: -23.4356, longitude: -46.4731),
  Airport(code: 'GIG', name: 'Rio de Janeiro Galeao', country: 'Brazil', region: 'South America', latitude: -22.8090, longitude: -43.2506),
  Airport(code: 'EZE', name: 'Buenos Aires Ezeiza', country: 'Argentina', region: 'South America', latitude: -34.8222, longitude: -58.5358),
  Airport(code: 'SCL', name: 'Santiago', country: 'Chile', region: 'South America', latitude: -33.3928, longitude: -70.7858),
  Airport(code: 'LIM', name: 'Lima Jorge Chavez', country: 'Peru', region: 'South America', latitude: -12.0219, longitude: -77.1143),
  Airport(code: 'BOG', name: 'Bogota El Dorado', country: 'Colombia', region: 'South America', latitude: 4.7016, longitude: -74.1469),
  Airport(code: 'UIO', name: 'Quito Mariscal Sucre', country: 'Ecuador', region: 'South America', latitude: -0.1252, longitude: -78.3540),
  Airport(code: 'CCS', name: 'Caracas Simon Bolivar', country: 'Venezuela', region: 'South America', latitude: 10.6031, longitude: -66.9912),
  Airport(code: 'MVD', name: 'Montevideo Carrasco', country: 'Uruguay', region: 'South America', latitude: -34.8384, longitude: -56.0308),
  Airport(code: 'POS', name: 'Port of Spain Piarco', country: 'Trinidad and Tobago', region: 'South America', latitude: 10.5954, longitude: -61.3372),
];

List<Airport> airports = [];
Map<String, Airport> airportByCode = {};

Future<void> loadAirportData() async {
  airports = await AirportStorage.loadAirports();
  if (airports.isEmpty) {
    airports = seedAirports;
  }
  airportByCode = {for (final a in airports) a.code: a};
}

/// Returns airports organized by their region.
Map<String, List<Airport>> get airportsByRegion {
  final map = <String, List<Airport>>{};
  for (final a in airports) {
    map.putIfAbsent(a.region, () => []).add(a);
  }
  return map;
}

