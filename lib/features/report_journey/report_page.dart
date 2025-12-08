import 'package:ackathon/features/report_journey/pothole_journey/camera_step.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: dark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, dark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderTexts(dark),
                    // const SizedBox(height: 12),
                    // _buildSearchAndEmergency(context, dark),
                    const SizedBox(height: 20),
                    _buildIssueCategories(context, dark),
                    const SizedBox(height: 24),
                    _buildHelperSection(dark),
                    const SizedBox(height: 24),
                    _buildPhotoCTA()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  Widget _buildAppBar(BuildContext context, bool dark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 16, 4),
      color: dark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                size: 20, color: dark ? Colors.white : Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(child: Container()),
          const SizedBox(width: 40), // placeholder for alignment
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER TITLE & DESCRIPTION
  // ---------------------------------------------------------------------------
  Widget _buildHeaderTexts(bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Issue Discovery",
            style: GoogleFonts.publicSans(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : const Color(0xFF131118),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Spot a hazard? Report it now — your community can fix it together.",
            style: GoogleFonts.publicSans(
              fontSize: 16,
              height: 1.4,
              color: dark
                  ? Colors.white70
                  : const Color(0xFF4A4A4A),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH BAR + EMERGENCY BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildSearchAndEmergency(BuildContext context, bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search Bar
          Stack(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Search for a hazard type…",
                  prefixIcon: Icon(Icons.search,
                      color: dark ? Colors.white54 : Colors.grey),
                  filled: true,
                  fillColor:
                  dark ? Colors.black26 : Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Emergency Button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor:
              dark ? Colors.red.shade900.withOpacity(0.4) : Colors.red.shade100,
              foregroundColor: dark ? Colors.red.shade300 : Colors.red.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size.fromHeight(50),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.error, size: 20),
                SizedBox(width: 8),
                Text(
                  "Report Emergency Hazard",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ISSUE CATEGORIES CARD
  // ---------------------------------------------------------------------------
  Widget _buildIssueCategories(BuildContext context, bool dark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF140F23) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!dark) BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
        border: dark
            ? Border.all(color: Colors.grey.shade800)
            : null,
      ),
      child: Column(
        children: [
          // Title Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
                ),
              ),
            ),
            child: Text(
              "What’s the issue?",
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : Colors.black87,
              ),
            ),
          ),

          // ITEMS
          _categoryItem(
            context,
            icon: "🛣️",
            title: "Roads & Walking Paths",
            subtitle: "Potholes, broken sidewalks, missing covers",
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) => ReportCameraStep()));
            },
          ),
          _categoryItem(
            context,
            icon: "🚦",
            title: "Traffic & Street Safety",
            subtitle: "Broken signals, dark streets, blocked paths",
          ),
          _categoryItem(
            context,
            icon: "⚡",
            title: "Public Utilities & Hazards",
            subtitle: "Streetlights out, exposed wires, leaks",
          ),
          _categoryItem(
            context,
            icon: "🗑️",
            title: "Cleanliness & Environment",
            subtitle: "Overflowing garbage, polluted water",
          ),
          _categoryItem(
            context,
            icon: "🐾",
            title: "Animals & Nuisance",
            subtitle: "Stray dogs or cattle causing danger",
          ),
          _categoryItem(
            context,
            icon: "🔥",
            title: "Fire & Flood Risks",
            subtitle: "Blocked exits, flammable storage",
          ),
          _categoryItem(
            context,
            icon: "❓",
            title: "Something Else",
            subtitle: "Don’t see your issue? Describe it here",
          ),
        ],
      ),
    );
  }

  Widget _categoryItem(
      BuildContext context, {
        required String icon,
        required String title,
        required String subtitle,
        VoidCallback? onTap,
      }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: dark ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFF6F3DFA).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: dark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.publicSans(
                      fontSize: 13,
                      color: dark ? Colors.grey : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: dark ? Colors.grey.shade400 : Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER SECTION
  // ---------------------------------------------------------------------------
  Widget _buildHelperSection(bool dark) {
    return Center(
      child: Column(
        children: [
          Text(
            "Each report helps map hazards and unlock community funding.",
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              color: dark ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
          // const SizedBox(height: 6),
          // Text(
          //   "See what issues are being fixed now",
          //   style: GoogleFonts.publicSans(
          //     color: const Color(0xFF6F3DFA),
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM CTA
  // ---------------------------------------------------------------------------
  Widget _buildPhotoCTA() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F3DFA),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(width: 16),
            Icon(Icons.photo_camera, color: Colors.white,),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "Not sure? Take a photo",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
