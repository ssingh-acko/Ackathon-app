import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MissionErrorPage extends StatelessWidget {
  const MissionErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8);
    final textLight = isDark ? Colors.white : Colors.black;
    final neutral = isDark ? Colors.grey[300] : Colors.grey[600];

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          _buildHeader(context, isDark),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // ERROR ICON
                  Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.withOpacity(0.15),
                    ),
                    child: Icon(Icons.error_rounded,
                        size: 56,
                        color:
                        isDark ? Colors.red.shade300 : Colors.red.shade600),
                  ),
                  const SizedBox(height: 20),

                  // TITLE
                  Text(
                    "We’re Sorry",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.publicSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color:
                      isDark ? Colors.red.shade300 : Colors.red.shade600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Our AI was unable to extract enough details from your photo to identify this as a pothole.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      color: neutral,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "It doesn't meet our minimum standards to raise an issue.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.publicSans(
                      fontSize: 15,
                      color: neutral,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // TIPS CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.08)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb,
                            size: 28,
                            color: isDark
                                ? Colors.yellow.shade300
                                : Colors.yellow.shade700),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tips for better detection",
                                style: GoogleFonts.publicSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _tip("Ensure the pothole is clearly visible"),
                              _tip("Take the photo from closer distance"),
                              _tip("Avoid shadows & low-light conditions"),
                              _tip("Center the pothole in the frame"),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // TAGS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      _tag("#NotEnoughData", Colors.red.shade400),
                      _tag("#TryAgain", const Color(0xFF6F42C1)),
                      _tag("#BetterLighting", Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // BOTTOM BUTTONS
          _buildBottomActions(context, isDark),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HEADER
  // --------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
        border: Border(
          bottom: BorderSide(
            color:
            isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const Spacer(),
          Text(
            "Pothole Analysis",
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 20),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TIPS
  // --------------------------------------------------------------------------
  Widget _tip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  ",
              style: TextStyle(fontSize: 16, height: 1.4, color: Colors.grey)),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                height: 1.4,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // TAG
  // --------------------------------------------------------------------------
  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: color.withOpacity(0.15),
      ),
      child: Text(
        label,
        style: GoogleFonts.publicSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // BOTTOM BUTTONS
  // --------------------------------------------------------------------------
  Widget _buildBottomActions(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        left: 16,
        right: 16,
        top: 14,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
        border: Border(
          top: BorderSide(
            color:
            isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade300,
          ),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F42C1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.camera_alt),
              label: Text(
                "Retake Photo & Try Again",
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.settings.name == "HomeScreen");
              },
            ),
          ),

        ],
      ),
    );
  }
}
