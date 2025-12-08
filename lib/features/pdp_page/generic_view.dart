import 'dart:ui';
import 'package:ackathon/features/pdp_page/pdp_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contribute_screen.dart';
import 'funding_heroes_page.dart';
import 'model/pdp_page_model.dart';
// import 'mission_funding_model.dart';

class MissionFundingPage extends StatefulWidget {
  final MissionFundingModel data;

  const MissionFundingPage({super.key, required this.data});

  @override
  State<MissionFundingPage> createState() => _MissionFundingPageState();
}

class _MissionFundingPageState extends State<MissionFundingPage> {
  int? _selectedVendorIndex;
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
          Image.network(widget.data.headerImage, fit: BoxFit.cover),

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
                  onTap: () => Navigator.pop(context),
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
                  widget.data.title,
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
                      widget.data.location,
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
    final fundedPercent = widget.data.fundedPercent;
    final percentText = "${(fundedPercent * 100).round()}%";

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // -------------------------------------------------
          // PROGRESS CIRCLE WITH CLEAN TEXT BACKGROUND
          // -------------------------------------------------
          SizedBox(
            height: 180,
            width: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer Circle
                SizedBox(
                  height: 180,
                  width: 180,
                  child: CircularProgressIndicator(
                    value: fundedPercent,
                    strokeWidth: 14,
                    backgroundColor: const Color(0xFFE8E8E8),
                    valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF6F3DFA)),
                  ),
                ),

                // White background behind text (fixes overlap)
                Container(
                  height: 92,
                  width: 92,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        percentText,
                        style: GoogleFonts.urbanist(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF6F3DFA),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Funded",
                        style: GoogleFonts.publicSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          // -------------------------------------------------
          // RAISED / GOAL TEXT
          // -------------------------------------------------
          Text.rich(
            TextSpan(
              text: "₹${widget.data.currentPaid}",
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF6F3DFA),
              ),
              children: [
                TextSpan(
                  text: " raised of ₹${widget.data.totalAmount} goal",
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

          const SizedBox(height: 10),

          // -------------------------------------------------
          // SUBTEXT
          // -------------------------------------------------
          Text(
            "Every contribution brings us closer to a safer neighborhood!",
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 13,
              height: 1.4,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }


  // -------------------------------------------------------------
  // FUNDING HEROES CARD
  // -------------------------------------------------------------
  Widget _buildFundingHeroesCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>
                FundingHeroesPage(heroesList: widget.data.heroesList),
          ),
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
              "Join ${widget.data.heroesList.length} other heroes who have already contributed.",
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

  Widget _centeredAvatarStack() {
    const double size = 48;
    const double overlap = 32;
    final heroes = widget.data.heroesList;
    final visibleCount = heroes.length >= 3 ? 3 : heroes.length;

    final totalWidth = size + overlap * visibleCount;

    return SizedBox(
      height: size,
      width: totalWidth,
      child: Stack(
        children: [
          ...List.generate(visibleCount, (i) {
            return Positioned(
              left: overlap * i,
              child: CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(heroes[i].imageUrl),
              ),
            );
          }),

          if (heroes.length > 3)
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
                  "${heroes.length - 3}+",
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
                    totalGoal: widget.data.totalAmount + 0.0,
                    fundedAmount: widget.data.currentPaid + 0.0,
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
