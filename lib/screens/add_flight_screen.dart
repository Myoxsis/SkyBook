import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import '../models/flight.dart';
import '../models/aircraft.dart';
import '../models/airport.dart';
import '../models/airline.dart';
import '../data/airport_data.dart';
import '../data/aircraft_data.dart';
import '../data/airline_data.dart';
import '../widgets/skybook_app_bar.dart';
import '../widgets/skybook_card.dart';
import '../utils/text_formatters.dart';
import '../utils/carbon_utils.dart';
import '../utils/duration_utils.dart';
import '../widgets/app_dialog.dart';
import '../widgets/star_rating.dart';
import '../widgets/premium_badge.dart';
import '../constants.dart';
import '../services/import_service.dart';
import '../services/wallet_service.dart';

class AddFlightScreen extends StatefulWidget {
  final Flight? flight;
  final List<Flight> flights;
  final ValueNotifier<bool> premiumNotifier;

  const AddFlightScreen({
    super.key,
    this.flight,
    required this.flights,
    required this.premiumNotifier,
  });

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
  final _scrollController = ScrollController();

  bool _premium = false;
  late VoidCallback _premiumListener;

  final _dateFieldKey = GlobalKey<FormFieldState>();
  final _aircraftFieldKey = GlobalKey<FormFieldState>();
  final _originFieldKey = GlobalKey<FormFieldState>();
  final _destinationFieldKey = GlobalKey<FormFieldState>();
  final _durationFieldKey = GlobalKey<FormFieldState>();
  String _travelClass = 'Economy';
  String _seatLocation = 'Window';
  bool _isBusiness = false;

  int _originRating = 0;
  int _destinationRating = 0;
  int _seatRating = 0;

  double? _distanceKm;
  double? _carbonKg;

  LatLng? _originLatLng;
  LatLng? _destinationLatLng;

  Aircraft? _selectedAircraft;
  Airline? _selectedAirline;
  late final Set<String> _flightAirportCodes;

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
        _carbonKg = estimateEmissions(
          km,
          _selectedAircraft?.display ?? _aircraftController.text,
          _travelClass,
        );
        _originLatLng = LatLng(origin.latitude, origin.longitude);
        _destinationLatLng = LatLng(dest.latitude, dest.longitude);
      });
    } else {
      setState(() {
        _distanceKm = null;
        _carbonKg = null;
        _originLatLng = null;
        _destinationLatLng = null;
      });
    }
  }

  void _scrollToFirstError([GlobalKey<FormFieldState>? preferred]) {
    final keys = [
      preferred,
      _dateFieldKey,
      _aircraftFieldKey,
      _originFieldKey,
      _destinationFieldKey,
      _durationFieldKey,
    ].whereType<GlobalKey<FormFieldState>>();
    for (final key in keys) {
      if (key.currentState?.hasError ?? false || key == preferred) {
        final context = key.currentContext;
        if (context != null) {
          Scrollable.ensureVisible(
            context,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        break;
      }
    }
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
    _scrollController.dispose();
    widget.premiumNotifier.removeListener(_premiumListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _premium = widget.premiumNotifier.value;
    _premiumListener = () {
      if (mounted) {
        setState(() {
          _premium = widget.premiumNotifier.value;
        });
      }
    };
    widget.premiumNotifier.addListener(_premiumListener);
    final flight = widget.flight;
    if (flight != null) {
      _dateController.text = flight.date;
      _selectedAircraft = aircraftByDisplay[flight.aircraft];
      _aircraftController.text = flight.aircraft;
      _flightNumberController.text = flight.callsign;
      if (flight.callsign.length >= 2) {
        _selectedAirline = airlineByCode[flight.callsign.substring(0, 2).toUpperCase()];
      }
      _durationController.text =
          formatDuration(parseDuration(flight.duration));
      _notesController.text = flight.notes;
      _originController.text = flight.origin;
      _destinationController.text = flight.destination;
      _travelClass = flight.travelClass.isNotEmpty ? flight.travelClass : 'Economy';
      _seatNumberController.text = flight.seatNumber;
      _seatLocation = flight.seatLocation.isNotEmpty ? flight.seatLocation : 'Window';
      _carbonKg = flight.carbonKg > 0 ? flight.carbonKg : null;
      _isBusiness = flight.isBusiness;
      _originRating = flight.originRating;
      _destinationRating = flight.destinationRating;
      _seatRating = flight.seatRating;
    } else {
      _selectedAircraft = aircrafts.first;
      _aircraftController.text = _selectedAircraft!.display;
      _selectedAirline = null;
    }
    _flightAirportCodes = {
      for (final f in widget.flights) ...[
        f.origin.toUpperCase(),
        f.destination.toUpperCase(),
      ]
    };
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

  Future<void> _pickDuration() async {
    final current = parseDuration(_durationController.text);
    Duration temp = current;
    final picked = await showModalBottomSheet<Duration>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hm,
                  initialTimerDuration: current,
                  onTimerDurationChanged: (d) => temp = d,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, temp),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _durationController.text = formatDuration(picked);
      });
    }
  }

  Future<void> _scanBoardingPass() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked == null) return;
    final flight = await ImportService.scanBoardingPassImage(picked.path);
    if (flight == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to read boarding pass')),
      );
      return;
    }
    setState(() {
      if (flight.date.isNotEmpty) _dateController.text = flight.date;
      _flightNumberController.text = flight.callsign;
      _originController.text = flight.origin;
      _destinationController.text = flight.destination;
    });
    _updateAirline(flight.callsign);
    _computeDistance();
  }

  Future<void> _importItinerary() async {
    final text = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AppDialog(
          title: const Text('Paste Itinerary'),
          content: TextField(
            controller: controller,
            maxLines: 8,
            decoration: const InputDecoration(labelText: 'Itinerary text'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );

    if (text == null || text.trim().isEmpty) return;
    final flight = ImportService.parseItineraryText(text);
    if (flight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to parse itinerary')),
      );
      return;
    }
    setState(() {
      if (flight.date.isNotEmpty) _dateController.text = flight.date;
      _flightNumberController.text = flight.callsign;
      _originController.text = flight.origin;
      _destinationController.text = flight.destination;
    });
    _updateAirline(flight.callsign);
    _computeDistance();
  }

  Future<void> _importFromWallet() async {
    final flight = await WalletService.importFromWallet();
    if (flight == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No boarding pass found')),
      );
      return;
    }
    setState(() {
      if (flight.date.isNotEmpty) _dateController.text = flight.date;
      _flightNumberController.text = flight.callsign;
      _originController.text = flight.origin;
      _destinationController.text = flight.destination;
    });
    _updateAirline(flight.callsign);
    _computeDistance();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      _scrollToFirstError();
      return;
    }
    if (_originController.text.trim().toUpperCase() ==
        _destinationController.text.trim().toUpperCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Origin and destination cannot be the same')),
      );
      _scrollToFirstError(_originFieldKey);
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
      carbonKg: _carbonKg ?? widget.flight?.carbonKg ?? 0,
      isFavorite: widget.flight?.isFavorite ?? false,
      isBusiness: _isBusiness,
      originRating: _originRating,
      destinationRating: _destinationRating,
      seatRating: _seatRating,
    );
    Navigator.of(context).pop(flight);
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
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
      GlobalKey<FormFieldState>? fieldKey,
      void Function(String)? onChanged,
    }) {
    return RawAutocomplete<Airport>(
      key: key,
      textEditingController: controller,
      focusNode: focusNode,
      optionsBuilder: (TextEditingValue value) {
        if (value.text.isEmpty) {
          // When no text is entered show only airports that are already
          // part of the registered flights so the list is manageable.
          return airports
              .where((a) => _flightAirportCodes.contains(a.code));
        }
        return airports.where((a) =>
            a.code.toLowerCase().contains(value.text.toLowerCase()) ||
            a.name.toLowerCase().contains(value.text.toLowerCase()));
      },
      displayStringForOption: (a) => a.display,
      fieldViewBuilder:
          (context, textEditingController, fieldFocusNode, onFieldSubmitted) {
        return TextFormField(
          key: fieldKey,
          controller: textEditingController,
          focusNode: fieldFocusNode,
          inputFormatters: [
            UpperCaseTextFormatter(),
          ],
          decoration: InputDecoration(
            labelText: label,
            suffixIcon: textEditingController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        textEditingController.clear();
                        if (onChanged != null) onChanged('');
                      });
                    },
                    tooltip: 'Clear $label',
                  ),
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
          onChanged: (v) {
            setState(() {});
            if (onChanged != null) onChanged(v);
          },
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
                padding: const EdgeInsets.all(AppSpacing.xs),
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

  Widget _buildRatedAirportRow(
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    int rating,
    ValueChanged<int> onRatingChanged, {
    Key? key,
    GlobalKey<FormFieldState>? fieldKey,
    void Function(String)? onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildAirportField(
            controller,
            focusNode,
            label,
            key: key,
            fieldKey: fieldKey,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        StarRating(rating: rating, onRatingChanged: onRatingChanged, size: 20),
      ],
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
          key: _aircraftFieldKey,
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: 'Aircraft',
            prefixIcon:
                const Icon(Icons.airplanemode_active, semanticLabel: 'Aircraft'),
            suffixIcon: textEditingController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        textEditingController.clear();
                      });
                    },
                    tooltip: 'Clear Aircraft',
                  ),
          ),
          onFieldSubmitted: (_) => onFieldSubmitted(),
          onChanged: (_) => setState(() {}),
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
                padding: const EdgeInsets.all(AppSpacing.xs),
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
      decoration: InputDecoration(
        labelText: 'Flight Number',
        prefixIcon: const Icon(Icons.flight, semanticLabel: 'Flight number'),
        suffixIcon: _flightNumberController.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _flightNumberController.clear();
                    _updateAirline('');
                  });
                },
                tooltip: 'Clear Flight Number',
              ),
      ),
      inputFormatters: [UpperCaseTextFormatter()],
      onChanged: (v) {
        setState(() {});
        _updateAirline(v);
      },
    );
  }
  Widget _buildFlightInfoCard() {
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flight Info',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              key: _dateFieldKey,
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date',
                suffixIcon:
                    Icon(Icons.calendar_today, semanticLabel: 'Select date'),
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
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Row(
                  children: [
                    Image.network(
                      'https://pics.avs.io/60/60/${_selectedAirline!.code}.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.flight,
                        size: 32,
                        semanticLabel: 'Flight',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Airline: ${_selectedAirline!.name}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _scanBoardingPass,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Scan Boarding Pass'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _importItinerary,
                    icon: const Icon(Icons.email),
                    label: const Text('Import Itinerary'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_premium)
              ElevatedButton.icon(
                onPressed: _importFromWallet,
                icon:
                    const Icon(Icons.account_balance_wallet, semanticLabel: 'Wallet'),
                label: const Text('Import from Wallet'),
              )
            else
              const PremiumBadge(message: 'Wallet import'),
          ],
        ),

    );
  }

  Widget _buildRouteDetailsCard() {
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Route Details',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildRatedAirportRow(
              _originController,
              _originFocusNode,
              'Origin',
              _originRating,
              (r) => setState(() => _originRating = r),
              key: const ValueKey('origin'),
              fieldKey: _originFieldKey,
              onChanged: (_) => _computeDistance(),
            ),
            _buildRatedAirportRow(
              _destinationController,
              _destinationFocusNode,
              'Destination',
              _destinationRating,
              (r) => setState(() => _destinationRating = r),
              key: const ValueKey('destination'),
              fieldKey: _destinationFieldKey,
              onChanged: (_) => _computeDistance(),
            ),
            if (_distanceKm != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'Distance: ${_distanceKm!.round()} km',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        ),
      
    );
  }

  Widget _buildTravelDetailsCard() {
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Travel Details',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              key: _durationFieldKey,
              controller: _durationController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Duration'),
              onTap: _pickDuration,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter duration';
                }
                final d = parseDuration(value);
                if (d == Duration.zero) {
                  return 'Enter a valid duration';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _travelClass,
              decoration: const InputDecoration(labelText: 'Class'),
              items: const [
                const DropdownMenuItem(value: 'Economy', child: Text('Economy')),
                const DropdownMenuItem(value: 'Premium', child: Text('Premium')),
                const DropdownMenuItem(value: 'Business', child: Text('Business')),
                const DropdownMenuItem(value: 'First', child: Text('First')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _travelClass = value;
                  });
                }
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _seatNumberController,
                    decoration: InputDecoration(
                      labelText: 'Seat Number',
                      suffixIcon: _seatNumberController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _seatNumberController.clear();
                                });
                              },
                              tooltip: 'Clear Seat Number',
                            ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                StarRating(
                  rating: _seatRating,
                  onRatingChanged: (r) => setState(() => _seatRating = r),
                  size: 20,
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _seatLocation,
              decoration: const InputDecoration(labelText: 'Seat Location'),
              items: const [
                const DropdownMenuItem(value: 'Window', child: Text('Window')),
                const DropdownMenuItem(value: 'Middle', child: Text('Middle')),
                const DropdownMenuItem(value: 'Aisle', child: Text('Aisle')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _seatLocation = value;
                  });
                }
              },
            ),
            SwitchListTile(
              title: const Text('Business Trip'),
              value: _isBusiness,
              onChanged: (v) {
                setState(() {
                  _isBusiness = v;
                });
              },
              subtitle: Text(_isBusiness ? 'Marked as business' : 'Personal trip'),
            ),
          ],
        ),
      
    );
  }

  Widget _buildNotesCard() {
    return SkyBookCard(
      padding: const EdgeInsets.all(AppSpacing.s),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
            ),
          ],
        ),
      
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SkyBookAppBar(
        title: widget.flight == null ? 'Add Flight' : 'Edit Flight',
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.s),
        child: Form(
          key: _formKey,
          child: ListView(
            controller: _scrollController,
            children: [
              _buildFlightInfoCard(),
              const SizedBox(height: 8),
              _buildRouteDetailsCard(),
              const SizedBox(height: 8),
              _buildTravelDetailsCard(),
              const SizedBox(height: 8),
              _buildNotesCard(),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.flight == null ? 'Add Flight' : 'Save Changes'),
              ),
              if (widget.flight != null) ...[
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _delete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  child: const Text('Delete Flight'),
                ),
              ],
            ],
          ),
      ),
    ));
  }
}
