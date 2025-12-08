import 'package:ackathon/features/pdp_page/upi_bottomsheet.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';

class ExecutedMissionScreen extends StatefulWidget {
  final double lat;
  final double lng;

  const ExecutedMissionScreen({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  State<ExecutedMissionScreen> createState() => _ExecutedMissionScreenState();
}

class _ExecutedMissionScreenState extends State<ExecutedMissionScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = true; // This screen is always dark UI

    return Scaffold(
      backgroundColor: const Color(0xFF140F23),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMissionSummaryCard(),
                    _buildSectionTitle("Mission Progress"),
                    _buildTimeline(),
                    _buildSectionTitle("Vendor Updates & Photos"),
                    _buildPhotosCarousel(),
                    _buildPaymentCard(),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  // ------------------------------------------------------------
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 26)),
          Expanded(
            child: Text(
              "Mission: Pothole on Elm Street",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // const Icon(Symbols.more_vert, color: Colors.white, size: 26),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  Widget _buildMissionSummaryCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1B27),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            // -------------------------
            // REPLACING IMAGE WITH MAP
            // -------------------------
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: 190,
                width: double.infinity,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.lat, widget.lng),
                    zoom: 16.5,
                  ),
                  zoomControlsEnabled: false,
                  markers: {
                    Marker(
                      markerId: const MarkerId("issue_location"),
                      position: LatLng(widget.lat, widget.lng),
                    ),
                  },
                  // gestureRecognizers: {
                  //   Factory<OneSequenceGestureRecognizer>(
                  //           () => EagerGestureRecognizer()),
                  // },
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),

            // -------------------------
            // TEXT CONTENT
            // -------------------------
            Padding(
              padding: const EdgeInsets.all( 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("In Progress",
                          style: GoogleFonts.publicSans(
                            color: const Color(0xFF6F3DFA),
                            fontSize: 14,
                          )),
                      const SizedBox(height: 4),
                      Text("Pothole Fix on Elm Street",
                          style: GoogleFonts.publicSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          )),
                      const SizedBox(height: 8),
                      Text("Location:",
                          style: GoogleFonts.publicSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                      Text("Lat: ${widget.lat},  Lng: ${widget.lng}",
                          style: GoogleFonts.publicSans(
                            color: const Color(0xFFA39BBB),
                          )),
                      const SizedBox(height: 4),
                      Text("Assigned to: Reliable Contractors",
                          style: GoogleFonts.publicSans(
                            color: const Color(0xFFA39BBB),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        text,
        style: GoogleFonts.publicSans(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  Widget _buildTimeline() {
    final List<Map<String, dynamic>> steps = [
      {
        "title": "Materials Procured",
        "date": "Jun 10",
        "done": true,
      },
      {
        "title": "Work Started",
        "date": "Jun 11",
        "done": true,
      },
      {
        "title": "Patching Complete",
        "date": "Jun 12",
        "done": true,
      },
      {
        "title": "Final Inspection",
        "date": "Pending",
        "done": false,
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(steps.length, (i) {
          final step = steps[i];
          final isLast = i == steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + timeline line
              Column(
                children: [
                  Icon(
                    step['done'] ? Symbols.check_circle : Symbols.radio_button_unchecked,
                    color: step['done']
                        ? const Color(0xFF6F3DFA)
                        : const Color(0xFFA39BBB),
                    size: 26,
                  ),
                  if (!isLast)
                    Container(
                      height: 40,
                      width: 2,
                      color: step['done']
                          ? const Color(0xFF6F3DFA)
                          : const Color(0xFF413A55),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Text
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step['title'],
                          style: GoogleFonts.publicSans(
                              color: step['done'] ? Colors.white : const Color(0xFFA39BBB),
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      Text(step['date'],
                          style: GoogleFonts.publicSans(
                            color: const Color(0xFFA39BBB),
                          )),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  // ------------------------------------------------------------
  Widget _buildPhotosCarousel() {
    final images = [
      {
        "label": "Before",
        "url":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuCct31RcztamOB7bhIfGu2Qsc44R4mo1Sxc2F97h6X3q5MNfmz8f7J1Fkk52OJt_SoxxrtVG3Pt2bKvVgM9nzW0X_399-eLRHBU25FNQaVD6EEIYfUxBllGY4NMhqLAppm1vyXUij4LWffi960oEPUrDowm3tsOV0v9f5wCb4xAzWoTWx9C0_xZp1BPCxKnZzwrifX99LaKvBITAifq5k03AZU0nyZUQ5zijzXwRsNcpui3Eu-W7TGbms7mQ6aZAZjhNa2YX1o4Hgw"
      },
      {
        "label": "During",
        "url":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBKeOXBj5O2tZWyT1RohQYoydVVQKSeBwoGx_HsGPJ9ItVKXR_CYcDJfLDDv-tOOvNDUg9-xtVVm7lo-RPPoXFHuj6aYPhfgDlzJuXislnc1Uj9ALBEu0sHHE5cgkmG7WIfAlRBBODl6p9AT8NDOiXsOXCPyBV59OZna5YFmZOlnntbHwFhk_OwVOGf5sw9C1bAsiEErPNQruoZtlk01XGIpt72FJAZ5L-Yz3URyyKoj3NRl4TZHE7MFOPMLnZy6UzO4A64LAT_mLU"
      },
      {
        "label": "After",
        "url":
        "https://lh3.googleusercontent.com/aida-public/AB6AXuDLcC2Fo7Bit3b1rsK5Md-iAw9RuVr8yzoKiKB52VXApNXSkclFfY-HQ18xwcVg3aHGJjljDMF3FScO26aliU67aWiTRHkQGqF2JTCAMK26hevERW5iP1v7sn-iXDej5v4kktuC8890GXXi1ynLgY3abAhTGEEaUF4sW07wX9WKkNhuad_XvRXEnO3bwtAleKD379-aD9V6a6unzXsTEiKRbFebKl3aESJNzSMbbHRMOMhM2lMUrd0AUHgTVkai3DWfnXQfhFDDnrE"
      },
    ];

    return SizedBox(
      height: 260,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, i) {
          return SizedBox(
            width: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    images[i]['url']!,
                    width: 220,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  images[i]['label']!,
                  style: GoogleFonts.publicSans(
                    color: const Color(0xFFA39BBB),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  Widget _buildPaymentCard() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1B27),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Demand for Payment",
                style: GoogleFonts.publicSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount Requested",
                    style:
                    GoogleFonts.publicSans(color: const Color(0xFFA39BBB))),
                Text("₹450.00",
                    style: GoogleFonts.publicSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26)),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: const Color(0xFF413A55)),
            const SizedBox(height: 16),
            Text(
              "Please review photos and completed milestones before approving. Payment will be released to Reliable Contractors upon approval.",
              style: GoogleFonts.publicSans(
                color: const Color(0xFFA39BBB),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 10),
            Text("View Invoice Details",
                style: GoogleFonts.publicSans(
                    color: const Color(0xFF6F3DFA),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  Widget _buildBottomCTA() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF140F23),
      ),
      child: SizedBox(
        height: 56,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6F3DFA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const UpiPaymentBottomSheet(),
            );
          },
          child: Text(
            "Approve Payment",
            style: GoogleFonts.publicSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
