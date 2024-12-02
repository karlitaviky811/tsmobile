import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';



class LocationCard extends StatefulWidget {
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
    _fetchLocation();
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

    if (_locationData != null) {
      setState(() {
        _selectedLocation = LatLng(_locationData!.latitude!, _locationData!.longitude!);
      });
    }
  }

  void _updateLocationMarker() {
    mapController.move(_selectedLocation, _zoomLevel);
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
          height: 200,
          child: Stack(
            children: [
              Column(
                children: [
                  if (_locationData != null)
                    Expanded(
                      child: FlutterMap(
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
                                  color:     Color(0xff051937),
                                  size: 40.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  else
                    const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        if (_locationData != null) ...[
      
                        ],
                      ],
                    ),
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
      ),
    );
  }
}

