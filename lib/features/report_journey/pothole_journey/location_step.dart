import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:image/image.dart' as IMG;
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../incident_details/pothole_incident_details.dart';
import '../../login/payment_page.dart';
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
  bool showLoader = false;
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
        child: Stack(
          children: [
            Column(
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
                      // const SizedBox(width: 6),
                      // Expanded(
                      //   child: _bar(3, active: false),
                      // ),
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
                        child: Image.asset("assets/map_icon.png", height: 64,)
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
                            setState(() {
                              showLoader = true;
                            });

                            final List<String?> addressResponse = await getAddressFromLatLng(selectedLatLng?.latitude, selectedLatLng?.longitude);
                            String? address = addressResponse.first;
                            String? locality = addressResponse[1];

                            List<String> uploadedUrls = await uploadImages();

                            String? issueId = await createIssue(
                              latitude: selectedLatLng!.latitude,
                              longitude: selectedLatLng!.longitude,
                              address: address??"",
                              locality: locality??"",
                              imageLinks: uploadedUrls
                            );

                            setState(() {
                              showLoader = false;
                            });

                            Navigator.push(context, CupertinoPageRoute(builder: (_) => IncidentDetailsPage(
                              issueId: issueId!,
                            )));

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
            if(showLoader)Container(width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
              child: Center(child: SizedBox(height: 36, width: 36, child: CircularProgressIndicator(),),),
            )
          ],
        ),
      ),
    );
  }

  Future<String?> createIssue({
    required double latitude,
    required double longitude,
    required String address,
    required String locality,
    required List<String> imageLinks,
  }) async {
    final dio = Dio();

    final url = "http://3.109.152.78:8080/api/v1/issues";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // try {
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            "X-User-Id": sharedPreferences.getString("userId"),
            "Content-Type": "application/json",
          },
        ),
        data: {
          "latitude": latitude,
          "longitude": longitude,
          "category": "POTHOLE",
          "address": address,
          "locality": locality,
          "imageLinks": imageLinks,
          "description": "identified a very dangerous pothole",
        },
      );

      return response.data["data"]["id"];
    // } catch (e) {
    //   print("Create issue error => $e");
    //   return null;
    // }
  }



  Future<List<String>> uploadImages() async {
    Dio dio = Dio();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // 1️⃣ Get signed URLs
    final signedUrlsList = await dio.post(
      'http://3.109.152.78:8080/api/v1/storage/presigned-urls',
      options: Options(
        headers: {
          "X-User-Id": sharedPreferences.getString("userId"),
          'Content-Type': 'application/json',
        },
      ),
      data: {
        "count": widget.imagesList.length,
      },
    );

    final List<String> uploadedUrls = [];
    final List imageUrlsList = signedUrlsList.data["data"]["urls"];

    // 2️⃣ Loop & compress + upload
    for (int i = 0; i < widget.imagesList.length; i++) {
      final file = widget.imagesList[i];

      // ---- IMAGE COMPRESSION ----
      final bytes = await file.readAsBytes();
      IMG.Image? image = IMG.decodeImage(bytes);
      if (image == null) continue;

      // Resize to max 1080px (prevents very large uploads)
      final resized = IMG.copyResize(
        image,
        width: image.width > 1080 ? 1080 : image.width,
      );

      // Compress jpeg (70% quality)
      final compressedBytes = IMG.encodeJpg(resized, quality: 70);

      // ---- UPLOAD TO S3 ----
      await dio.put(
        imageUrlsList[i]['url'],
        data: compressedBytes,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "text/plain",
            HttpHeaders.contentLengthHeader: compressedBytes.length,
          },
        ),
      );

      uploadedUrls.add(imageUrlsList[i]['url']);
    }

    return uploadedUrls;
  }


  // uploadImages() async{
  //   Dio dio = Dio();
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //
  //   final signedUrlsList = await dio.post(
  //     'http://3.109.152.78:8080/api/v1/storage/presigned-urls',
  //     options: Options(
  //       headers: {
  //         "X-User-Id": sharedPreferences.getString("userId"),
  //         'Content-Type': 'application/json',
  //       },
  //     ),
  //     data: {
  //       "count": widget.imagesList.length,
  //     },
  //   );
  //
  //   final List<String> uploadedUrls = [];
  //   final List imageUrlsList = signedUrlsList.data["data"]["urls"];
  //
  //   for (int i = 0; i < widget.imagesList.length; i++) {
  //     final file = widget.imagesList[i];
  //
  //     // 1. Read bytes
  //     final bytes = await file.readAsBytes();
  //
  //     // 2. Upload to S3 (presigned URL)
  //     final res = await dio.put(
  //       imageUrlsList[i]['url'],
  //       data: bytes,
  //       options: Options(
  //         headers: {
  //           HttpHeaders.contentTypeHeader: "text/plain",      // required by your presigned URL
  //           HttpHeaders.contentLengthHeader: bytes.length,    // required
  //         },
  //       ),
  //     );
  //     uploadedUrls.add(imageUrlsList[i]['url']);
  //   }
  //
  //   return uploadedUrls;
  // }

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

  Future<List<String?>> getAddressFromLatLng(double? lat, double? lng) async {
    try {
      if(lat == null || lng == null){
        return [];
      }
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) return [];

      final p = placemarks.first;

      // Combine a readable address
      return ["${p.name}, ${p.subLocality}, ${p.locality}, "
          "${p.administrativeArea}, ${p.postalCode}, ${p.country}", p.locality];
    } catch (e) {
      print("Error getting address: $e");
      return [];
    }
  }
}
