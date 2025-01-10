import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  LatLng _selectedLocation = const LatLng(0.0, 0.0);

  @override
  void initState() {
    super.initState();

    if (widget.initialCoordinates != null) {
      _selectedLocation = widget.initialCoordinates!;
    } else {
      _fetchLocation();
    }
  }

  Future<void> validLocation() async {
   /* SharedPreferences prefs = await SharedPreferences.getInstance();
    final coordinatesEncode = jsonEncode(widget.initialCoordinates);
    await prefs.setString('coordinates_user', coordinatesEncode);
*/
    if (widget.initialCoordinates != null) {
      _selectedLocation = widget.initialCoordinates!;
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
        _selectedLocation =
            LatLng(_locationData!.latitude!, _locationData!.longitude!);
      });
    }
  }

  void _updateLocationMarker() {
    mapController.move(_selectedLocation, _zoomLevel);
  }

  void _saveLocation() {
    // Guardar la ubicación seleccionada.
    // Aquí puedes realizar cualquier acción necesaria para guardar la ubicación.
    log('Ubicación guardada: $_selectedLocation');
    Fluttertoast.showToast(
        msg: "Ubicación actualizada con éxito",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
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
                    if (_locationData != null ||
                        widget.initialCoordinates != null)
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
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                      )
                    else
                      const Center(
                        child: CircularProgressIndicator(),
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
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton.icon(
                  onPressed: _saveLocation,
                  icon: Icon(Icons.save,
                      color: Colors.blue), // Color resaltante para el ícono
                  label: Text('Guardar Ubicación',
                      style: TextStyle(
                          color:
                              Colors.blue)), // Color resaltante para el texto
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fondo transparente
                    foregroundColor: Colors.blue, // Color del texto
                    side: BorderSide(color: Colors.blue), // Borde azul
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
