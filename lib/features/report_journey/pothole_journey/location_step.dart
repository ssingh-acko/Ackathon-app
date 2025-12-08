import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../incident_details/pothole_incident_details.dart';
import 'desc_step.dart';

class ReportLocationStep extends StatefulWidget {
  final List<File> imagesList;
  const ReportLocationStep({super.key, required this.imagesList});

  @override
  State<ReportLocationStep> createState() =>
      _ReportLocationStepState();
}

class _ReportLocationStepState extends State<ReportLocationStep> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? selectedLatLng;

  static const LatLng _defaultCenter = LatLng(19.0760, 72.8777); // Mumbai fallback

  @override
  void initState() {
    super.initState();
    _initCurrentLocation();
  }

  Future<void> _initCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    final controller = await _controller.future;

    selectedLatLng = LatLng(pos.latitude, pos.longitude);

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(selectedLatLng!, 17),
    );

    setState(() {});
  }

  Future<void> _moveToMyLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    final controller = await _controller.future;

    selectedLatLng = LatLng(pos.latitude, pos.longitude);

    controller.animateCamera(
      CameraUpdate.newLatLngZoom(selectedLatLng!, 17),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // ----------------- TOP BAR -----------------
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF111111), size: 20,)),
                  Expanded(
                    child: Text(
                      "Step 2 of 2: Choose Location",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.publicSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                        isDark ? Colors.white : const Color(0xFF111111),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ----------------- PROGRESS BAR -----------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: _bar(1, active: true),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _bar(2, active: true),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _bar(3, active: false),
                  ),
                ],
              ),
            ),

            // ----------------- MAP -----------------
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: _defaultCenter,
                      zoom: 15,
                    ),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onCameraMove: (position) {
                      selectedLatLng = position.target;
                      setState(() {});
                    },
                  ),

                  // Marker in center
                  Center(
                    child: Icon(
                      Symbols.location_on,
                      color: const Color(0xFF6D38FF),
                      size: 48,
                    ),
                  ),

                  // "Use my location" floating button
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: _moveToMyLocation,
                      child: const Icon(Icons.my_location,
                          color: Color(0xFF6D38FF)),
                    ),
                  ),
                ],
              ),
            ),

            // ----------------- LOCATION DATA -----------------
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    selectedLatLng == null
                        ? "Move the map to set issue location"
                        : "Location Selected:\nLat: ${selectedLatLng!.latitude.toStringAsFixed(6)}  "
                        "Lng: ${selectedLatLng!.longitude.toStringAsFixed(6)}",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedLatLng != null
                            ? const Color(0xFF6D38FF)
                            : const Color(0xFF6D38FF).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: selectedLatLng == null
                          ? null
                          : () async {
                        final String? address = await getAddressFromLatLng(selectedLatLng?.latitude, selectedLatLng?.longitude);
                        Navigator.push(context, CupertinoPageRoute(builder: (_) => IncidentDetailsPage(data: incidentDummy,)));
                        // Navigator.push(context, CupertinoPageRoute(builder: (context) => ReportDescriptionStep(
                        //   address: address??"",
                        //   latitude: selectedLatLng!.latitude,
                        //   longitude: selectedLatLng!.longitude,
                        // )));
                      },
                      child: Text(
                        "Next",
                        style: GoogleFonts.publicSans(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ----------------- Progress bar widgets -----------------
  Widget _bar(int step, {required bool active}) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF6D38FF)
            : const Color(0xFF6D38FF).withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Future<String?> getAddressFromLatLng(double? lat, double? lng) async {
    try {
      if(lat == null || lng == null){
        return null;
      }
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) return null;

      final p = placemarks.first;

      // Combine a readable address
      return "${p.name}, ${p.subLocality}, ${p.locality}, "
          "${p.administrativeArea}, ${p.postalCode}, ${p.country}";
    } catch (e) {
      print("Error getting address: $e");
      return null;
    }
  }
}
