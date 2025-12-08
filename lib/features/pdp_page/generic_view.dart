import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contribute_screen.dart';
import 'cubit.dart';
import 'funding_heroes_page.dart';
import 'model/pdp_page_model.dart';

class MissionFundingParent extends StatelessWidget {
  final String issueId;

  const MissionFundingParent({super.key, required this.issueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MissionFundingCubit(issueId),
      child: const MissionFundingPage(),
    );
  }
}

class MissionFundingPage extends StatelessWidget {
  const MissionFundingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionFundingCubit, MissionFundingState>(
      builder: (context, state) {
        if (state is MissionFundingLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MissionFundingError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        if (state is MissionFundingLoaded) {
          return MissionFundingMain(data: state.data);
        }

        return const SizedBox();
      },
    );
  }
}

// ===================================================================
// FULL PAGE — UI + LOGIC
// ===================================================================
class MissionFundingMain extends StatefulWidget {
  final MissionFundingModel data;

  const MissionFundingMain({super.key, required this.data});

  @override
  State<MissionFundingMain> createState() => _MissionFundingMainState();
}

class _MissionFundingMainState extends State<MissionFundingMain> {
  int? _selectedVendorIndex;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children: [
                _buildHeader(context, data),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildFundingProgressCard(data),
                      if(data.heroesList.isNotEmpty)...[
                        const SizedBox(height: 20),
                        _buildFundingHeroesCard(data),
                      ],
                      const SizedBox(height: 20),
                      _buildVendorBidsCard(data),
                      const SizedBox(height: 20),
                      _buildImpactCard(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          _buildContributeButton(context, data),
        ],
      ),
    );
  }

  // ===================================================================
  // HEADER
  // ===================================================================
  Widget _buildHeader(BuildContext context, MissionFundingModel data) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(data.headerImage, fit: BoxFit.cover),

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
                _glassIcon(Icons.arrow_back_ios_new, () => Navigator.pop(context)),
                _glassIcon(Icons.share, () {}),
              ],
            ),
          ),

          Positioned(
            left: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: GoogleFonts.publicSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      data.location,
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassIcon(IconData icon, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  // ===================================================================
  // FUNDING PROGRESS CARD
  // ===================================================================
  Widget _buildFundingProgressCard(MissionFundingModel data) {
    final fundedPercent = data.fundedPercent;

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
                    value: fundedPercent,
                    strokeWidth: 14,
                    backgroundColor: const Color(0xFFE8E8E8),
                    valueColor:
                    const AlwaysStoppedAnimation(Color(0xFF6F3DFA)),
                  ),
                ),
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
                        "${(fundedPercent * 100).round()}%",
                        style: GoogleFonts.urbanist(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF6F3DFA),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text("Funded",
                          style: GoogleFonts.publicSans(
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "₹${data.currentPaid} raised of ₹${data.totalAmount} goal",
            style: GoogleFonts.publicSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  // ===================================================================
  // FUNDING HEROES CARD
  // ===================================================================
  Widget _buildFundingHeroesCard(MissionFundingModel data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => FundingHeroesPage(heroesList: data.heroesList),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text("Funding Heroes",
                style: GoogleFonts.publicSans(
                    fontSize: 20, fontWeight: FontWeight.w800)),

            const SizedBox(height: 16),

            _avatarStack(data),

            const SizedBox(height: 14),
            Text(
              "Join ${data.heroesList.length} other heroes who contributed.",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _avatarStack(MissionFundingModel data) {
    const double size = 48;
    const double overlap = 32;
    final heroes = data.heroesList;
    final visible = heroes.length >= 3 ? 3 : heroes.length;

    return SizedBox(
      height: size,
      width: size + overlap * visible,
      child: Stack(
        children: [
          ...List.generate(visible, (i) {
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
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6F3DFA).withOpacity(0.1),
                ),
                child: Text(
                  "${heroes.length - 3}+",
                  style: GoogleFonts.publicSans(
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

  // ===================================================================
  // VENDOR BIDS CARD
  // ===================================================================
  Widget _buildVendorBidsCard(MissionFundingModel data) {
    final bids = data.vendorBids;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Vendor Bids",
          style: GoogleFonts.publicSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        if (bids.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.gavel_outlined, size: 36, color: Colors.grey.shade700),
                const SizedBox(height: 16),
                Text("Awaiting Bids",
                    style: GoogleFonts.publicSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 8),
                Text(
                  "Vendors will be invited once funding milestones are reached.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          )
        else
          ...bids.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _buildVendorBidTile(entry.key, entry.value),
            );
          }),
      ],
    );
  }

  Widget _buildVendorBidTile(int index, VendorBid bid) {
    final bool selected = _selectedVendorIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVendorIndex = selected ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
          selected ? const Color(0xFF6F3DFA).withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF6F3DFA)
                : Colors.grey.withOpacity(0.2),
            width: selected ? 2 : 1.4,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(bid.avatar),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bid.vendorName,
                    style: GoogleFonts.publicSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  bid.timeline,
                  style: GoogleFonts.publicSans(
                      fontSize: 14, fontWeight: FontWeight.w600),
                )
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Text(
                  "₹${bid.proposedAmount.toStringAsFixed(0)}",
                  style: GoogleFonts.publicSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: selected ? const Color(0xFF6F3DFA) : Colors.black,
                  ),
                ),
              ],
            ),

            if (selected) ...[
              const SizedBox(height: 14),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F3DFA),
                ),
                onPressed: () {},
                child: const Text("View Full Proposal"),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // ===================================================================
  // IMPACT CARD
  // ===================================================================
  Widget _buildImpactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF6F3DFA).withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.health_and_safety_outlined,
              size: 40, color: Color(0xFF6F3DFA)),
          const SizedBox(height: 10),
          Text("Your Impact is Immeasurable",
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 6),
          Text("Every ₹500 prevents an accident.",
              style: GoogleFonts.publicSans(
                fontSize: 15,
                color: Color(0xFF6F3DFA),
                fontWeight: FontWeight.w600,
              )),
          const SizedBox(height: 6),
          Text(
            "Your contribution funds materials & labor for long-term fixes.",
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

  // ===================================================================
  // CONTRIBUTE BUTTON
  // ===================================================================
  Widget _buildContributeButton(
      BuildContext context, MissionFundingModel data) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 12 + MediaQuery.of(context).padding.bottom,
          top: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.3))),
        ),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F3DFA),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (_) {
                    return ContributeBottomSheet(
                      fundedAmount: data.currentPaid.toDouble(),
                      totalGoal: data.totalAmount.toDouble(),
                    );
                  });
            },
            child: Text(
              data.isMe
                  ? "Initiate Mission Go!"
                  : "Contribute Now & Be a Hero!",
              style: GoogleFonts.publicSans(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
