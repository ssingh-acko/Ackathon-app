import 'package:ackathon/features/home_page/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../report_journey/report_page.dart';

class LocationCommunityOnboarding extends StatefulWidget {
  const LocationCommunityOnboarding({super.key});

  @override
  State<LocationCommunityOnboarding> createState() => _LocationCommunityOnboardingState();
}

class _LocationCommunityOnboardingState extends State<LocationCommunityOnboarding> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
        child: Stack(
          children: [
            // -------------------- BACKGROUND IMAGE --------------------
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuB_2tSqoRqTx41L5fRArNUgs4K3h8GykCPpRWl2Sn-5kSmYNHZWYyr9kVFONqo4IBUmnwXnjSumD_Dm4YBzIMxnTsX7Pyc7MH6UarQPNMsl6Xti4EZfflQ-ilQmNHadtgUvYpdPZ0bz9QJeUr2u4V367U2TtyhedRl18ndW5RxZHrSv0fBnJjuXzfdP-5fLtroQWmfHkuyvUZJcmk_Lvc71jAfdqbW1q6o4SfJyT2kFKeyyGn4XVIjE-Wn1e7kHCW082K0Yy8f_t6E",
                fit: BoxFit.cover,
              ),
            ),

            // -------------------- GRADIENT OVERLAY --------------------
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      (isDark
                          ? const Color(0xFF140F23)
                          : const Color(0xFFF6F5F8)),
                      (isDark
                              ? const Color(0xFF140F23)
                              : const Color(0xFFF6F5F8))
                          .withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // -------------------- PAGE CONTENT --------------------
            Column(
              children: [
                const Spacer(),

                // // -------------------- DOTS --------------------
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [dot(false), dot(false), dot(true)],
                // ),
                //
                // const SizedBox(height: 20),

                // -------------------- TITLE & DESCRIPTION --------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(
                        "Join a Community That Cares",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.publicSans(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF131118),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Enable your location to discover and report issues in your neighborhood, and connect with people making a real difference.\n\nAll things are done with AI to ensure transparency and prevent fraud.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.publicSans(
                          fontSize: 17,
                          height: 1.5,
                          color: isDark
                              ? Colors.grey[300]
                              : const Color(0xFF6B5F8C),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // -------------------- BOTTOM CTA SECTION --------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF140F23)
                        : const Color(0xFFF6F5F8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, -8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F3DFA),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async{
                            askLocationPermission();
                          },
                          child: Text(
                            "Join the Community",
                            style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> askLocationPermission() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enable location services."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
        ),
      );
      return;
    }

    // Check the current permission status
    LocationPermission permission = await Geolocator.checkPermission();

    // If denied, request permission
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // If denied again
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Location permission is required."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange.shade700,
        ),
      );
      return;
    }

    // If permanently denied
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Enable location permission from settings."),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    // If permission granted → get location
    final position = await Geolocator.getCurrentPosition();

    // After permission granted, navigate or call your next flow
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text("Location enabled at ${position.latitude}, ${position.longitude}!"),
    //     behavior: SnackBarBehavior.floating,
    //   ),
    // );

    // TODO: Navigate to home screen
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen(), settings: RouteSettings(name: 'HomeScreen')));
  }

  // -------------------- DOT WIDGET --------------------
  Widget dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF6F3DFA)
            : const Color(0xFF6F3DFA).withOpacity(0.20),
        shape: BoxShape.circle,
      ),
    );
  }
}
