import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationCard extends StatefulWidget {
  final LatLng? initialCoordinates;

  LocationCard({this.initialCoordinates});

  @override
  _LocationCardState createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  final MapController mapController = MapController();
  Location location = Location();
  LocationData? _locationData;
  double _zoomLevel = 16.0;
  LatLng _selectedLocation = LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();
    _loadLocationFromStorage();
  }

  Future<void> _loadLocationFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lng = prefs.getDouble('longitude');

    if (lat != null && lng != null) {
      setState(() {
        _selectedLocation = LatLng(lat, lng);
      });
    } else if (widget.initialCoordinates != null) {
      setState(() {
        _selectedLocation = widget.initialCoordinates!;
      });
    } else {
      _fetchLocation();
    }
  }

  Future<void> _fetchLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if (_locationData != null && mounted) {
      setState(() {
        _selectedLocation = LatLng(_locationData!.latitude!, _locationData!.longitude!);
      });
      await _saveLocationToStorage(_selectedLocation);
    }
  }

  Future<void> _saveLocationToStorage(LatLng location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', location.latitude);
    await prefs.setDouble('longitude', location.longitude);
  }

  void _updateLocationMarker() {
    mapController.move(_selectedLocation, _zoomLevel);
  }

  void _saveLocation() {
    // Guardar la ubicación seleccionada.
    _saveLocationToStorage(_selectedLocation);
    log('Ubicación guardada: $_selectedLocation');
    Fluttertoast.showToast(
      msg: "Ubicación actualizada con éxito",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }

  @override
  void dispose() {
    // No es necesario liberar manualmente la referencia a Location
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          width: double.infinity,
          height: 350, // Ajustamos la altura para incluir el botón
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: mapController,
                      options: MapOptions(
                        initialCenter: _selectedLocation,
                        initialZoom: _zoomLevel,
                        onTap: (tapPosition, point) {
                          setState(() {
                            _selectedLocation = point;
                          });
                          _updateLocationMarker();
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: _selectedLocation,
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xff051937),
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      right: 10,
                      top: 50,
                      child: Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.zoom_in),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _zoomLevel++;
                                _updateLocationMarker();
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.zoom_out),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                _zoomLevel--;
                                _updateLocationMarker();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: _saveLocation,
                  icon: const Icon(Icons.save, color: Colors.blue), // Color resaltante para el ícono
                  label: const Text('Guardar Ubicación', style: TextStyle(color: Colors.blue)), // Color resaltante para el texto
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fondo transparente
                    foregroundColor: Colors.blue, // Color del texto
                    side: const BorderSide(color: Colors.blue), // Borde azul
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
