import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../incident_details/pothole_incident_details.dart';

class ReportDescriptionStep extends StatefulWidget {
  const ReportDescriptionStep({super.key, required this.address, required this.latitude, required this.longitude});
  final String address;
  final double latitude;
  final double longitude;

  @override
  State<ReportDescriptionStep> createState() => _ReportDescriptionStepState();
}

class _ReportDescriptionStepState extends State<ReportDescriptionStep> {
  final TextEditingController _controller = TextEditingController();
  final int _maxLength = 300;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------- TOP BAR --------------------
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.arrow_back_ios_new,
                          size: 22,
                          color:
                          isDark ? Colors.white : const Color(0xFF111111)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Step 3 of 3: Add Details",
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

            // -------------------- PROGRESS BAR --------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: _bar(active: true)),
                  const SizedBox(width: 6),
                  Expanded(child: _bar(active: true)),
                ],
              ),
            ),

            // -------------------- TITLE TEXT --------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                "Describe the issue",
                style: GoogleFonts.publicSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111111),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                "Provide more details so we can understand the severity and context.",
                style: GoogleFonts.publicSans(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : const Color(0xFF5C5C5C),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // -------------------- TEXT FIELD --------------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F1A2E) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    onChanged: (val){
                      setState(() {

                      });
                    },
                    maxLength: _maxLength,
                    keyboardType: TextInputType.multiline,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: "Describe the pothole, how long it's been there, how severe it is...",
                      hintStyle: GoogleFonts.publicSans(
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                      border: InputBorder.none,
                      counterText: "",
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Character counter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${_controller.text.length}/$_maxLength",
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // -------------------- SUBMIT BUTTON --------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _controller.text.trim().isNotEmpty
                        ? const Color(0xFF6D38FF)
                        : const Color(0xFF6D38FF).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _controller.text.trim().isEmpty
                      ? null
                      : () {
                    // TODO: Connect to backend or move to summary screen
                    Navigator.push(context, CupertinoPageRoute(builder: (_) => IncidentDetailsPage()));
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.publicSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Progress bar element
  Widget _bar({required bool active}) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF6D38FF)
            : const Color(0xFF6D38FF).withOpacity(0.25),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
