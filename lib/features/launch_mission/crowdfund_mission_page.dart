import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../incident_details/cubit.dart';
import '../pdp_page/pdp_page.dart';
import 'broadcast_group.dart';
import 'model/launch_mission_data.dart';

class CrowdfundMissionPage extends StatefulWidget {
  final IncidentReport data;

  const CrowdfundMissionPage({super.key, required this.data});

  @override
  State<CrowdfundMissionPage> createState() => _CrowdfundMissionPageState();
}

class _CrowdfundMissionPageState extends State<CrowdfundMissionPage> {
  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // AI Budget from API
    final aiBudget = d.ai?.estimatedBudget?.toDouble() ?? 0;
    final seedRequired = (aiBudget * 0.10).round(); // 10%

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF140F23) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            //------------------------------ TOP BAR ------------------------------
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF140F23) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new, size: 24)),
                  // Expanded(
                  //   child: Text(
                  //     "Mission: Fix Pothole",
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.publicSans(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //------------------- SINGLE IMAGE FROM INCIDENT -------------------
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            d.imageUrls.isNotEmpty
                                ? d.imageUrls.first
                                : "https://via.placeholder.com/600x300",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //------------------- TITLE -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Text(
                        d.title.toUpperCase(),
                        style: GoogleFonts.publicSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    //------------------- AI BUDGET ONLY -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildAiCard("AI Estimated Budget",
                          aiBudget == 0 ? "N/A" : "₹${aiBudget.round()}"),
                    ),

                    const SizedBox(height: 20),

                    //------------------- SEED CAPITAL (10% of budget) -------------------
                    if (aiBudget > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F42C1).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.rocket_launch,
                                  color: const Color(0xFF6F42C1)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Seed Capital is Required",
                                      style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: const Color(0xFF6F42C1),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "To launch this mission, contribute 10% (₹$seedRequired). "
                                          "This shows commitment and boosts community funding.",
                                      style: GoogleFonts.publicSans(
                                        fontSize: 14,
                                        color: const Color(0xFF6F42C1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    //------------------- BROADCAST GROUPS -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BroadcastGroupCard(groups: dummyBroadcastGroups),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            //------------------- BOTTOM CTA -------------------
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF140F23) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
              ),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => const PdpScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F42C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Contribute & Launch Mission",
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

  //------------------- small reusable card -------------------
  Widget _buildAiCard(String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
