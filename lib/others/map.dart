import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  Location _location = Location();
  LatLng _currentPosition = LatLng(37.7749, -122.4194); // Default (San Francisco)
  bool _locationFetched = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Function to fetch the user's location
  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    // Check for location permission
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get current location
    LocationData locationData = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
      _locationFetched = true;
    });

    // Move camera to user's location
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: _currentPosition, zoom: 15),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Current Location')),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          if (_locationFetched) {
            mapController.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentPosition, zoom: 15),
            ));
          }
        },
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 10, // Default zoom before fetching location
        ),
        markers: {
          Marker(
            markerId: MarkerId('current_location'),
            position: _currentPosition,
            infoWindow: InfoWindow(title: 'You are here'),
          ),
        },
        myLocationEnabled: true, // Enables blue dot on the map
        myLocationButtonEnabled: true, // Shows "My Location" button
      ),
    );
  }
}
