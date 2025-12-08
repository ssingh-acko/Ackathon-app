import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contribute_screen.dart';
import 'funding_heroes_page.dart';

class MissionFundingPage extends StatefulWidget {
  const MissionFundingPage({super.key});

  @override
  State<MissionFundingPage> createState() => _MissionFundingPageState();
}

class _MissionFundingPageState extends State<MissionFundingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildFundingProgressCard(),
                      const SizedBox(height: 20),
                      _buildFundingHeroesCard(),
                      const SizedBox(height: 20),
                      _buildImpactCard(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _buildContributeButton(context),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // HEADER
  // -------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://lh3.googleusercontent.com/aida-public/AB6AXuCiUCMgcgPNgu1PFWmA5FCur_LBxLqz-NjaSASBd-LQbeJUBge6KFPyRTxGhpSMrZrbJlEJs2FsQgVgOa57unD6-uHwZUyTnn6CZGom4snnpxSBgs7aMlwG0Y6L7r4YGoRcCqNVbdXACuM1m-xiECly9wis7yVgyXFxqLuFW5s6aQ-Csfqyj-Vggx5NkiY9OWqIHzrVabju-HJhRDd4PGW60-VmvGj_UZ6y4aoXtEsBF3OEBTCcMLJ23CHUiQ3G3eFXjV3RY7XcRXk",
            fit: BoxFit.cover,
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _glassIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
                _glassIconButton(
                  icon: Icons.share,
                  onTap: () {},
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fix the Richmond Road Potholes",
                  style: GoogleFonts.publicSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      "Koramangala, Bengaluru",
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // FUNDING PROGRESS CARD
  // -------------------------------------------------------------
  Widget _buildFundingProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: 0.6,
                    strokeWidth: 12,
                    backgroundColor: const Color(0xFFE6E6E6),
                    valueColor: const AlwaysStoppedAnimation(
                      Color(0xFF6F3DFA),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "60%",
                      style: GoogleFonts.urbanist(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF6F3DFA),
                      ),
                    ),
                    Text(
                      "Funded",
                      style: GoogleFonts.publicSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: "₹30,000",
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6F3DFA),
              ),
              children: [
                TextSpan(
                  text: " raised of ₹50,000 goal",
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            "Every contribution brings us closer to a safer neighborhood!",
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // FUNDING HEROES
  // -------------------------------------------------------------
  Widget _buildFundingHeroesCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const FundingHeroesPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Funding Heroes",
              style: GoogleFonts.publicSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),

            _centeredAvatarStack(),

            const SizedBox(height: 14),
            Text(
              "Join 26 other heroes who have already contributed.",
              style: GoogleFonts.publicSans(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // CENTERED STACK OF AVATARS
  Widget _centeredAvatarStack() {
    const double size = 48;
    const double overlap = 32;
    const int count = 4;

    final totalWidth = size + overlap * (count - 1);

    return SizedBox(
      height: size,
      width: totalWidth,
      child: Stack(
        children: [
          _stackedAvatar(
            index: 0,
            imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuB_HzNluTp57gjem_RNdnMRS5AhDJzqUhQiUYv27Gbdj4z6RQFjRSUSKpObxN-we9uTVZTtEKkboipDKHbO2N2TMQKyl7ij1MYl7iRS3o4YGwz5tN3whRtllPhcC7RjlHiQyz5qmBMhpGQnWksMUlqJu5KT3f1ohTvTxeEtaI-z9k93DsatqhhPShWvHV1ky6G0lGlUOewA1TC8ofrYu6swOdYNhH1hQkeKEd3PZFyhbaf3yTJN2canHwFpfmLtt4qtWc5tUTtEpeY",
          ),
          _stackedAvatar(
            index: 1,
            imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuBsUmTH8tGkVM2TNPV9WJwOXELDLnE0oH9jaDUzzMiNG1VbJ1KDmXSajzTB6y3erC-6FjZ-LLKDkh82KlRl4D89EUEVzIFR1R3SvLfjxMXcUA_ScKcaAVmWGiEZ9GyFi-qOxFz-1xEqOnPAj5y85gIPgjhQiT1JOyYP39xoHgB0olgQnBjoEgXKETB1M7cU7aFXIT_OgknBuULnwXgnYEQxk6x4b7dK1TYrsbIb_JDCqr5ZLCXQqG0acyqTXPVCtRhYWW79yCBlYC4",
          ),
          _stackedAvatar(
            index: 2,
            imageUrl:
            "https://lh3.googleusercontent.com/aida-public/AB6AXuDljAf8ycQrNZdrqAJ_qzPFbp_XeeYFV2aV6IKk9C5OCNQJ7IhwZgjVQ1MhWp5Or6LWQlcWxsVwpiSMv-9r78vVWhNqOeYyuk6MlHbfuXX0C78m6CknY1kXr8zSr6TfZue-FDmyZuggmr-5d_ns7DQWr5YcriO4cudBsnsv0QH6xfWfmPfdYme1nmYbk8UJdPPdLto3qwU5qTaYv1cptmGhpVQTEk_4PlQSzikqmwSjPlR08A1LvqjcngUVCx9plP2K9vMX2Yjcuv4",
          ),

          Positioned(
            left: overlap * 3,
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                color: const Color(0xFF6F3DFA).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              alignment: Alignment.center,
              child: Text(
                "23+",
                style: GoogleFonts.publicSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F3DFA),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stackedAvatar({required int index, required String imageUrl}) {
    return Positioned(
      left: index * 32.0,
      child: CircleAvatar(
        radius: 24,
        backgroundImage: NetworkImage(imageUrl),
      ),
    );
  }

  // -------------------------------------------------------------
  // IMPACT CARD
  // -------------------------------------------------------------
  Widget _buildImpactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6F3DFA).withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6F3DFA).withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.health_and_safety_outlined,
            size: 40,
            color: Color(0xFF6F3DFA),
          ),
          const SizedBox(height: 10),
          Text(
            "Your Impact is Immeasurable",
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Every ₹500 helps prevent an accident.",
            style: GoogleFonts.publicSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6F3DFA),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Your contribution directly funds materials and labor for a lasting fix, making our roads safer for everyone.",
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // CONTRIBUTE BUTTON
  // -------------------------------------------------------------
  Widget _buildContributeButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
          top: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.3),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F3DFA),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: const Color(0xFF6F3DFA).withOpacity(0.4),
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return ContributeBottomSheet(
                    totalGoal: 50000,
                    fundedAmount: 30000,
                  );
                },
              );
            },
            icon: const Icon(Icons.volunteer_activism_outlined, size: 24),
            label: Text(
              "Contribute Now & Be a Hero!",
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
