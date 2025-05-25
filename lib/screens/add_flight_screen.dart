import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:math' as math;
import '../models/flight.dart';
import '../models/aircraft.dart';
import '../models/airport.dart';
import '../models/airline.dart';
import '../data/airport_data.dart';
import '../data/aircraft_data.dart';
import '../data/airline_data.dart';
import '../widgets/skybook_app_bar.dart';
import '../utils/text_formatters.dart';

class AddFlightScreen extends StatefulWidget {
  final Flight? flight;

  const AddFlightScreen({super.key, this.flight});

  @override
  State<AddFlightScreen> createState() => _AddFlightScreenState();
}

class _AddFlightScreenState extends State<AddFlightScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _aircraftController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _seatNumberController = TextEditingController();
  final _originFocusNode = FocusNode();
  final _destinationFocusNode = FocusNode();
  final _aircraftFocusNode = FocusNode();
  String _travelClass = 'Economy';
  String _seatLocation = 'Window';

  double? _distanceKm;

  LatLng? _originLatLng;
  LatLng? _destinationLatLng;

  Aircraft? _selectedAircraft;
  Airline? _selectedAirline;

  void _computeDistance() {
    final origin =
        airportByCode[_originController.text.trim().toUpperCase()];
    final dest =
        airportByCode[_destinationController.text.trim().toUpperCase()];
    if (origin != null && dest != null) {
      final d = const Distance();
      final km = d.as(
          LengthUnit.Kilometer,
          LatLng(origin.latitude, origin.longitude),
          LatLng(dest.latitude, dest.longitude));
      setState(() {
        _distanceKm = km;
        _originLatLng = LatLng(origin.latitude, origin.longitude);
        _destinationLatLng = LatLng(dest.latitude, dest.longitude);
      });
    } else {
      setState(() {
        _distanceKm = null;
        _originLatLng = null;
        _destinationLatLng = null;
      });
    }
  }

  List<LatLng> _arcPoints(LatLng start, LatLng end) {
    const steps = 50;
    final latDiff = end.latitude - start.latitude;
    final lonDiff = end.longitude - start.longitude;
    final distance = math.sqrt(latDiff * latDiff + lonDiff * lonDiff);
    if (distance == 0) {
      return [start, end];
    }
    final perpLat = -lonDiff;
    final perpLon = latDiff;
    final norm = math.sqrt(perpLat * perpLat + perpLon * perpLon);
    if (norm == 0) {
      return [start, end];
    }
    final offsetLat = perpLat / norm;
    final offsetLon = perpLon / norm;
    final amp = distance * 0.2;

    final pts = <LatLng>[];
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final curve = math.sin(math.pi * t);
      final lat = start.latitude + latDiff * t + offsetLat * amp * curve;
      final lon = start.longitude + lonDiff * t + offsetLon * amp * curve;
      pts.add(LatLng(lat, lon));
    }
    return pts;
  }

  @override
  void dispose() {
    _dateController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    _originController.dispose();
    _destinationController.dispose();
    _aircraftController.dispose();
    _flightNumberController.dispose();
    _seatNumberController.dispose();
    _originFocusNode.dispose();
    _destinationFocusNode.dispose();
    _aircraftFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final flight = widget.flight;
    if (flight != null) {
      _dateController.text = flight.date;
      _selectedAircraft = aircraftByDisplay[flight.aircraft];
      _aircraftController.text = flight.aircraft;
      _flightNumberController.text = flight.callsign;
      if (flight.callsign.length >= 2) {
        _selectedAirline = airlineByCode[flight.callsign.substring(0, 2).toUpperCase()];
      }
      _durationController.text = flight.duration;
      _notesController.text = flight.notes;
      _originController.text = flight.origin;
      _destinationController.text = flight.destination;
      _travelClass = flight.travelClass.isNotEmpty ? flight.travelClass : 'Economy';
      _seatNumberController.text = flight.seatNumber;
      _seatLocation = flight.seatLocation.isNotEmpty ? flight.seatLocation : 'Window';
    } else {
      _selectedAircraft = aircrafts.first;
      _aircraftController.text = _selectedAircraft!.display;
      _selectedAirline = null;
    }
    _computeDistance();
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.now();
    if (widget.flight != null) {
      final parsed = DateTime.tryParse(widget.flight!.date);
      if (parsed != null) initial = parsed;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted =
          '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        _dateController.text = formatted;
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_originController.text.trim().toUpperCase() ==
        _destinationController.text.trim().toUpperCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Origin and destination cannot be the same')),
      );
      return;
    }
    _updateAirline(_flightNumberController.text);
    final flight = Flight(
      id: widget.flight?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      date: _dateController.text,
      aircraft: _selectedAircraft?.display ?? _aircraftController.text,
      manufacturer: _selectedAircraft?.manufacturer ?? '',
      airline: _selectedAirline?.name ?? '',
      callsign: _flightNumberController.text,
      duration: _durationController.text,
      notes: _notesController.text,
      origin: _originController.text,
      destination: _destinationController.text,
      travelClass: _travelClass,
      seatNumber: _seatNumberController.text,
      seatLocation: _seatLocation,
      distanceKm: _distanceKm ?? widget.flight?.distanceKm ?? 0,
      isFavorite: widget.flight?.isFavorite ?? false,
    );
    Navigator.of(context).pop(flight);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Flight'),
        content: const Text('Are you sure you want to delete this flight?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.of(context).pop('delete');
    }
  }

  Widget _buildAirportField(
      TextEditingController controller,
      FocusNode focusNode,
      String label, {
      Key? key,
      void Function(String)? onChanged,
    }) {
    return RawAutocomplete<Airport>(
      key: key,
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return const Iterable<Airport>.empty();
        }
        return airports.where((a) =>
            a.code.toLowerCase().contains(value.text.toLowerCase()) ||
            a.name.toLowerCase().contains(value.text.toLowerCase()));
      },
      displayStringForOption: (a) => a.display,
      fieldViewBuilder:
          (context, textEditingController, fieldFocusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: fieldFocusNode,
          inputFormatters: const [
            LengthLimitingTextInputFormatter(3),
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(labelText: label),
          onFieldSubmitted: (_) => onFieldSubmitted(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
        );
      },
      optionsViewBuilder:
          (context, AutocompleteOnSelected<Airport> onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final Airport option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.display),
                    onTap: () {
                      onSelected(option);
                      focusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (a) {
        controller.text = a.code;
        if (onChanged != null) onChanged(a.code);
      },
    );
  }

  Widget _buildAircraftField() {
    return RawAutocomplete<Aircraft>(
      textEditingController: _aircraftController,
      focusNode: _aircraftFocusNode,
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          return aircrafts;
        }
        return aircrafts.where(
            (a) => a.display.toLowerCase().contains(value.text.toLowerCase()));
      },
      displayStringForOption: (a) => a.display,
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            labelText: 'Aircraft',
            prefixIcon: Icon(Icons.airplanemode_active),
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter Aircraft';
            }
            return null;
          },
        );
      },
      optionsViewBuilder:
          (context, AutocompleteOnSelected<Aircraft> onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final Aircraft option = options.elementAt(index);
                  return ListTile(
                    title: Text(option.display),
                    onTap: () {
                      onSelected(option);
                      _aircraftFocusNode.unfocus();
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
      onSelected: (a) {
        setState(() {
          _selectedAircraft = a;
          _aircraftController.text = a.display;
        });
      },
    );
  }

  void _updateAirline(String value) {
    if (value.length >= 2) {
      setState(() {
        _selectedAirline =
            airlineByCode[value.substring(0, 2).toUpperCase()];
      });
    } else {
      setState(() {
        _selectedAirline = null;
      });
    }
  }

  Widget _buildFlightNumberField() {
    return TextFormField(
      controller: _flightNumberController,
      decoration: const InputDecoration(
        labelText: 'Flight Number',
        prefixIcon: Icon(Icons.flight),
      ),
      onChanged: _updateAirline,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyBookAppBar(
        title: widget.flight == null ? 'Add Flight' : 'Edit Flight',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: const Icon(Icons.save),
      ),
      bottomNavigationBar: widget.flight != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _delete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.error,
                    foregroundColor:
                        Theme.of(context).colorScheme.onError,
                  ),
                  child: const Text('Delete Flight'),
                ),
              ),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
            TextFormField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: _pickDate,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),
            _buildAircraftField(),
            _buildFlightNumberField(),
            if (_selectedAirline != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      'https://pics.avs.io/60/60/${_selectedAirline!.code}.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.flight, size: 32),
                    ),
                    const SizedBox(width: 8),
                    Text('Airline: ${_selectedAirline!.name}'),
                  ],
                ),
              ),
            _buildAirportField(
              _originController,
              _originFocusNode,
              'Origin',
              key: const ValueKey('origin'),
              onChanged: (_) => _computeDistance(),
            ),
            _buildAirportField(
              _destinationController,
              _destinationFocusNode,
              'Destination',
              key: const ValueKey('destination'),
              onChanged: (_) => _computeDistance(),
            ),
            if (_distanceKm != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Distance: ${_distanceKm!.round()} km'),
              ),
            if (_distanceKm != null)
              SizedBox(
                height: 200,
                child: Builder(
                  builder: (context) {
                    final markers = <Marker>[];
                    if (_originLatLng != null) {
                      markers.add(
                        Marker(
                          point: _originLatLng!,
                          width: 30,
                          height: 30,
                          builder: (_) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.flight_takeoff,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    if (_destinationLatLng != null) {
                      markers.add(
                        Marker(
                          point: _destinationLatLng!,
                          width: 30,
                          height: 30,
                          builder: (_) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.flight_land,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }

                    final lines = <Polyline>[];
                    if (_originLatLng != null && _destinationLatLng != null) {
                      lines.add(
                        Polyline(
                          points: _arcPoints(_originLatLng!, _destinationLatLng!),
                          color: Theme.of(context).colorScheme.secondary,
                          strokeWidth: 3,
                        ),
                      );
                    }

                    final center = _originLatLng != null && _destinationLatLng != null
                        ? LatLng(
                            (_originLatLng!.latitude + _destinationLatLng!.latitude) / 2,
                            (_originLatLng!.longitude + _destinationLatLng!.longitude) / 2,
                          )
                        : _originLatLng ?? _destinationLatLng ?? LatLng(20, 0);

                    return FlutterMap(
                      options: MapOptions(
                        center: center,
                        zoom: 3,
                        interactiveFlags: InteractiveFlag.pinchZoom |
                            InteractiveFlag.drag |
                            InteractiveFlag.doubleTapZoom,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        if (lines.isNotEmpty) PolylineLayer(polylines: lines),
                        if (markers.isNotEmpty) MarkerLayer(markers: markers),
                      ],
                    );
                  },
                ),
              ),
            TextFormField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Duration (hrs)'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter duration';
                }
                final d = double.tryParse(value);
                if (d == null || d <= 0) {
                  return 'Enter a valid duration';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _travelClass,
              decoration: const InputDecoration(labelText: 'Class'),
              items: const [
                DropdownMenuItem(value: 'Economy', child: Text('Economy')),
                DropdownMenuItem(value: 'Premium', child: Text('Premium')),
                DropdownMenuItem(value: 'Business', child: Text('Business')),
                DropdownMenuItem(value: 'First', child: Text('First')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _travelClass = value;
                  });
                }
              },
            ),
            TextField(
              controller: _seatNumberController,
              decoration: const InputDecoration(labelText: 'Seat Number'),
            ),
            DropdownButtonFormField<String>(
              value: _seatLocation,
              decoration: const InputDecoration(labelText: 'Seat Location'),
              items: const [
                DropdownMenuItem(value: 'Window', child: Text('Window')),
                DropdownMenuItem(value: 'Middle', child: Text('Middle')),
                DropdownMenuItem(value: 'Aisle', child: Text('Aisle')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _seatLocation = value;
                  });
                }
              },
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
