// import 'package:flutter/material.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:location/location.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// class LocationMap extends StatefulWidget {
//   @override
//   _LocationMapState createState() => _LocationMapState();
// }
//
// class _LocationMapState extends State<LocationMap> {
//   MapboxMapController? mapController;
//   Location location = Location();
//   LatLng? userLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     dotenv.load();
//     _requestLocationPermission();
//   }
//
//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//   }
//
//   Future<void> _requestLocationPermission() async {
//     bool serviceEnabled = await location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await location.requestService();
//       if (!serviceEnabled) return;
//     }
//
//     PermissionStatus permissionGranted = await location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return;
//     }
//
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationData currentLocation = await location.getLocation();
//       setState(() {
//         userLocation = LatLng(currentLocation.latitude!, currentLocation.longitude!);
//       });
//
//       print("User Location: Lat: ${currentLocation.latitude}, Lng: ${currentLocation.longitude}");
//     } catch (e) {
//       print("Error getting location: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
//
//     return Scaffold(
//       appBar: AppBar(title: Text("User Location on Map")),
//       body: accessToken.isEmpty
//           ? Center(child: Text("API Key Not Found"))
//           : MapboxMap(
//         accessToken: accessToken,
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: userLocation ?? LatLng(37.7749, -122.4194), // Default: San Francisco
//           zoom: 14.0,
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.location_on),
//         onPressed: _getCurrentLocation,
//       ),
//     );
//   }
// }
