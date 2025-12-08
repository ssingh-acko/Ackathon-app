import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../pdp_page/pdp_page.dart';
import 'broadcast_group.dart';
import 'model/launch_mission_data.dart';

class CrowdfundMissionPage extends StatefulWidget {
  final CrowdfundMission data;

  const CrowdfundMissionPage({super.key, required this.data});

  @override
  State<CrowdfundMissionPage> createState() => _CrowdfundMissionPageState();
}

class _CrowdfundMissionPageState extends State<CrowdfundMissionPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late Timer timer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();

    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      _fadeController.reverse().then((_) {
        setState(() => _currentIndex = 1 - _currentIndex);
        _fadeController.forward();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  const Icon(Icons.arrow_back_ios_new, size: 24),
                  Expanded(
                    child: Text(
                      "Mission: Fix Pothole",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.publicSans(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //------------------- BEFORE/AFTER IMAGE SLIDER -------------------
                    // const SizedBox(height: 8),
                    Stack(
                      children: [
                        SizedBox(
                          height: 260,
                          width: double.infinity,
                          child: FadeTransition(
                            opacity: _fadeAnim,
                            child: Image.network(
                              _currentIndex == 0
                                  ? d.images.beforeUrl
                                  : d.images.afterUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // gradient overlay
                        Container(
                          height: 260,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                (isDark
                                    ? const Color(0xFF140F23)
                                    : const Color(0xFFF8F9FA))
                                    .withOpacity(0.7),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),

                        // tag top right
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              _currentIndex == 0 ? "Before" : "After",
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    //------------------- TITLE -------------------
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        d.missionTitle,
                        style: GoogleFonts.publicSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    //------------------- PROGRESS CARD -------------------
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(18),
                    //     decoration: BoxDecoration(
                    //       color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    //       borderRadius: BorderRadius.circular(16),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.black.withOpacity(0.06),
                    //           blurRadius: 12,
                    //           offset: const Offset(0, 4),
                    //         ),
                    //       ],
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text("Crowdfunding Progress",
                    //             style: GoogleFonts.publicSans(
                    //                 fontSize: 16, fontWeight: FontWeight.bold)),
                    //         const SizedBox(height: 6),
                    //
                    //         Text(
                    //           "${(d.progress.percent * 100).round()}% funded",
                    //           style: GoogleFonts.publicSans(
                    //             color: Colors.grey,
                    //             fontSize: 13,
                    //           ),
                    //         ),
                    //
                    //         const SizedBox(height: 10),
                    //
                    //         ClipRRect(
                    //           borderRadius: BorderRadius.circular(20),
                    //           child: LinearProgressIndicator(
                    //             value: d.progress.percent,
                    //             minHeight: 9,
                    //             color: const Color(0xFF6F42C1),
                    //             backgroundColor:
                    //             isDark ? Colors.grey.shade800 : Colors.grey[200],
                    //           ),
                    //         ),
                    //
                    //         const SizedBox(height: 10),
                    //
                    //         Center(
                    //           child: Text(
                    //             "₹${d.progress.raised} raised of ₹${d.progress.goal}",
                    //             style: GoogleFonts.publicSans(
                    //               fontSize: 14,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 16),

                    //------------------- AI BUDGET + ETA -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(child: _buildAiCard("AI Budget", "₹${d.aiBudget}")),
                          const SizedBox(width: 12),
                          Expanded(child: _buildAiCard("AI ETA", d.aiEta)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    //------------------- SEED CAPITAL NOTICE -------------------
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
                                    "To launch this mission, you must contribute • ${d.seedPercent}% (₹${d.seedRequired}). This shows commitment and boosts community funding.",
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BroadcastGroupCard(
                        groups: dummyBroadcastGroups,
                      ),
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
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => PdpScreen()));
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
            )
          ],
        ),
      ),
    );
  }

  //------------------- small reusable card -------------------
  Widget _buildAiCard(String label, String value) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
