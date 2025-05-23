import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/baracodegenerator.dart';
import '../utils/utils.dart';
import 'seatmapscreen.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  String? regNo;
  final utils = Utils();

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 15),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _fetchRegNo();
  }

  Future<void> _fetchCurrentLocation() async {
    await utils.requestNotificationPermission();
    await utils.requestLocationPermission();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _fetchRegNo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      setState(() {
        regNo = doc.data()!['regNo'] ?? '-';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _currentPosition == null || regNo == null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset('assets/images/logo.jpg', height: 30),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bus Tracking', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Last updated: 1 min ago', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                GestureDetector(
                  onTap: () async => await _fetchCurrentLocation(),
                  child: Text('Refresh',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 180,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(target: _currentPosition!, zoom: 15.0),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 180,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.check_circle_outline, size: 24),
                    label: Text("Check In", style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('Your Check-In Barcode', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              MyBarcodeWidget(
                                data: regNo ?? '-',
                                width: 200,
                                height: 80,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 180,
                  height: 60,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.grid_view, size: 24),
                    label: Text("Seat Map", style: TextStyle(fontSize: 16)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SeatMapScreen(bookedSeats: [20])),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bus Status',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('On Time', style: GoogleFonts.poppins(fontSize: 14, color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusCard('ETA', '5 min', Icons.access_time),
                      _statusCard('Bus No.', 'C102', Icons.directions_bus),
                      _statusCard('Seat', '23A', Icons.event_seat),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('Next stop: Central Library (2 min)',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {},
        child: Icon(Icons.sos, color: Colors.white, size: 28),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  Widget _statusCard(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blueAccent, size: 24),
        SizedBox(height: 5),
        Text(title, style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
        Text(value, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
