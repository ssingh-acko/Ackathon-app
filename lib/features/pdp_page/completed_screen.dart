import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'before_after_fade.dart';

class MissionAccomplishedPage extends StatelessWidget {
  const MissionAccomplishedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      body: Column(
        children: [
          _buildHeader(context, isDark),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildCelebrationBadge(isDark),
                  const SizedBox(height: 12),
                  _buildTitleSection(isDark),
                  const SizedBox(height: 24),
                  _buildBeforeAfterCard(),
                  const SizedBox(height: 24),
                  _buildThankYouSection(isDark),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
          _buildBottomActions(isDark, context),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      color: isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "Pothole on Main St Fixed!",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // CELEBRATION BADGE
  // ----------------------------------------------------------------------
  Widget _buildCelebrationBadge(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration,
              size: 16, color: Colors.purple.withOpacity(0.8)),
          const SizedBox(width: 6),
          Text(
            "Mission Complete",
            style: GoogleFonts.publicSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.purple,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // TITLE + SUBTITLE
  // ----------------------------------------------------------------------
  Widget _buildTitleSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Text(
            "We did it!",
            style: GoogleFonts.publicSans(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF6F3DFA),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "From a neighborhood problem to a community-powered solution. See the transformation you made possible.",
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 15,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // BEFORE / AFTER PHOTO CARD
  // ----------------------------------------------------------------------
  // Widget _buildBeforeAfterCard() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: Stack(
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(16),
  //           child: SizedBox(
  //             height: 260,
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Image.network(
  //                     "https://lh3.googleusercontent.com/aida-public/AB6AXuBY_erWtkTlDgL5J5OLHcFIyBCc1GKEU5p39_Sah6c_S3TXp2kA4h02vHfXu7OnF7hspMfAVM5uRNoVJXWAJe_HhXSbSIc_iIeYp8KCRG8_8Xjk4yym_xfhlB5A01noLKQbT2Zcymmlloarag242R-iF-qWCxplM6y30AXncTpW6BYye3dp6aakwvguQmeY-5vaGlwycp5Y02VYDnj8fl3olADYTCLgkhld_M5s3v6lQ2FZMXJYLWIV6bK60d6c995B6uiPFOxBf4c",
  //                     fit: BoxFit.cover,
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: Stack(
  //                     children: [
  //                       Image.network(
  //                         "https://lh3.googleusercontent.com/aida-public/AB6AXuDg-n3AA3PmPTUJbtYc6_1suE6PDqeRkdkhW9F9-BjPJ9z59Ie147oztbNvlEYNvVAjyDivuodmrjw11mroMf2V_r0DDXjcdSDIMkilGbGJ-KylqQmvAgjfPPoPlb-LNyYKYls4KQ_Sdl-SFStTu1XA8L1CgyrhpR-RHYDFtkfRkhxZq-UUuAX-HEGqc_Ru6PmDvTsDEiF9wpbcX5sf5AsvyM5h-01hdr4Pt5EFf5xE7v8r2mIyghhdgvqnxWTVtGdIiu6o1h2un8k",
  //                         fit: BoxFit.cover,
  //                       ),
  //                       Positioned(
  //                         top: 12,
  //                         right: 12,
  //                         child: Icon(
  //                           Icons.auto_awesome,
  //                           color: Colors.yellow[400],
  //                           size: 28,
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //
  //         // Gradient Text Overlay
  //         Positioned.fill(
  //           child: Container(
  //             decoration: const BoxDecoration(
  //               gradient: LinearGradient(
  //                 begin: Alignment.bottomCenter,
  //                 end: Alignment.center,
  //                 colors: [
  //                   Colors.black87,
  //                   Colors.transparent,
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         // Labels
  //         Positioned(
  //           bottom: 12,
  //           left: 0,
  //           right: 0,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceAround,
  //             children: [
  //               _buildBeforeAfterLabel("How We Started", "The Problem"),
  //               _buildBeforeAfterLabel("How It's Going", "The Solution!"),
  //             ],
  //           ),
  //         ),
  //
  //         // Center swipe icon
  //         Positioned(
  //           left: 0,
  //           right: 0,
  //           top: 110,
  //           child: Center(
  //             child: Container(
  //               height: 42,
  //               width: 42,
  //               decoration: BoxDecoration(
  //                 color: Colors.white.withOpacity(0.9),
  //                 shape: BoxShape.circle,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.black.withOpacity(0.2),
  //                     blurRadius: 6,
  //                   ),
  //                 ],
  //               ),
  //               child: const Icon(Icons.swipe, color: Colors.purple),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildBeforeAfterLabel(String title, String subtitle) {
  //   return Column(
  //     children: [
  //       Text(
  //         title,
  //         style: GoogleFonts.publicSans(
  //           color: Colors.white,
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //         ),
  //       ),
  //       Text(
  //         subtitle,
  //         style: GoogleFonts.publicSans(
  //           color: Colors.white70,
  //           fontSize: 12,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBeforeAfterCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BeforeAfterFade(
        beforeUrl:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuBY_erWtkTlDgL5J5OLHcFIyBCc1GKEU5p39_Sah6c_S3TXp2kA4h02vHfXu7OnF7hspMfAVM5uRNoVJXWAJe_HhXSbSIc_iIeYp8KCRG8_8Xjk4yym_xfhlB5A01noLKQbT2Zcymmlloarag242R-iF-qWCxplM6y30AXncTpW6BYye3dp6aakwvguQmeY-5vaGlwycp5Y02VYDnj8fl3olADYTCLgkhld_M5s3v6lQ2FZMXJYLWIV6bK60d6c995B6uiPFOxBf4c",
        afterUrl:
        "https://lh3.googleusercontent.com/aida-public/AB6AXuDg-n3AA3PmPTUJbtYc6_1suE6PDqeRkdkhW9F9-BjPJ9z59Ie147oztbNvlEYNvVAjyDivuodmrjw11mroMf2V_r0DDXjcdSDIMkilGbGJ-KylqQmvAgjfPPoPlb-LNyYKYls4KQ_Sdl-SFStTu1XA8L1CgyrhpR-RHYDFtkfRkhxZq-UUuAX-HEGqc_Ru6PmDvTsDEiF9wpbcX5sf5AsvyM5h-01hdr4Pt5EFf5xE7v8r2mIyghhdgvqnxWTVtGdIiu6o1h2un8k",
      ),
    );
  }

  // ----------------------------------------------------------------------
  // THANK YOU SECTION
  // ----------------------------------------------------------------------
  Widget _buildThankYouSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.12),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.favorite, color: Color(0xFF6F3DFA), size: 32),
                const SizedBox(width: 10),
                Text(
                  "A Big Thank You!",
                  style: GoogleFonts.publicSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "This incredible achievement was a true community effort. Our heartfelt thanks to:",
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 18),
            _thankYouItem(
              Icons.person,
              "The Mission Creator",
              "For spotting the issue and starting the mission.",
              isDark,
            ),
            _thankYouItem(
              Icons.groups,
              "Our 25 Funders",
              "For pooling resources to make this happen.",
              isDark,
            ),
            _thankYouItem(
              Icons.construction,
              "FixIt Crew Vendor",
              "For their swift and professional work.",
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _thankYouItem(
      IconData icon, String title, String subtitle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.purple),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------
  // BOTTOM BUTTONS
  // ----------------------------------------------------------------------
  Widget _buildBottomActions(bool isDark, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
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
                backgroundColor: const Color(0xFF6F3DFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.share),
              label: Text(
                "Share the Good News",
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white
                ),
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 52,
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF6F3DFA)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.rate_review, color: Color(0xFF6F3DFA)),
              label: Text(
                "Thank the Vendor",
                style: GoogleFonts.publicSans(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F3DFA),
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
