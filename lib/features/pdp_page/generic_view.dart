import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'completed_screen.dart';
import 'contribute_screen.dart';
import 'cubit.dart';
import 'funding_heroes_page.dart';
import 'model/mission_status_response.dart';
import 'model/pdp_page_model.dart';

class MissionFundingParent extends StatelessWidget {
  final String issueId;

  const MissionFundingParent({super.key, required this.issueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MissionFundingCubit(issueId),
      child: MissionFundingPage(issueId: issueId),
    );
  }
}

class MissionFundingPage extends StatelessWidget {
  final String issueId;

  const MissionFundingPage({super.key, required this.issueId});

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
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is MissionFundingLoaded) {
          return MissionFundingMain(
            data: state.data,
            campaignId: state.campaignId,
            issueId: issueId,
          );
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
  final String? campaignId;
  final String issueId;

  const MissionFundingMain({
    super.key,
    required this.data,
    this.campaignId,
    required this.issueId,
  });

  @override
  State<MissionFundingMain> createState() => _MissionFundingMainState();
}

class _MissionFundingMainState extends State<MissionFundingMain> {
  String? _selectedVendorId;

  @override
  Widget build(BuildContext context) {
    final data = widget.data;

    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(
          context,
          (route) => route.settings.name == "HomeScreen",
        );
        return Future.value(false);
      },
      child: RefreshIndicator(
        onRefresh: () async {
          refreshPage();
        },
        child: Scaffold(
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
                          if (data.heroesList.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildFundingHeroesCard(data),
                          ],
                          const SizedBox(height: 20),
                          _buildVendorBidsCard(data),
                          if (context.read<MissionFundingCubit>().milestoneResponseModel != null) ...[
                            const SizedBox(height: 20),
                            _buildMilestonesSection(context.read<MissionFundingCubit>().milestoneResponseModel!),
                          ],
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
        ),
      ),
    );
  }

  Widget _buildMilestonesSection(MissionStatusResponse model) {
    if (model.data.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Milestones",
          style: GoogleFonts.publicSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        ...model.data.map((m) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Title / Description
                Text(
                  m.description,
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                /// Status
                Text(
                  "Status: ${m.status}",
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 8),

                /// Created At
                Text(
                  "Created: ${m.createdAt.toLocal().toString().split('.').first}",
                  style: GoogleFonts.publicSans(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 12),

                /// Image (if exists)
                if (m.imageUrls.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      m.imageUrls.first,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ],
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
                _glassIcon(Icons.arrow_back_ios_new, () {
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == "HomeScreen",
                  );
                }),
                _glassIcon(Icons.share, () {

                  shareContent();


                }),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      data.title,
                      style: GoogleFonts.publicSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          data.location,
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> shareContent() async {
    try {
      // 1️⃣ Download image
      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/shared_image.jpg";

      final response = await Dio().get(
        widget.data.headerImage,
        options: Options(responseType: ResponseType.bytes),
      );

      final file = File(filePath);
      await file.writeAsBytes(response.data);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: "Your small contribution can help fix this pothole and make the road safer for everyone. Join the mission!"
      );
    } catch (e) {
      print("Error sharing: $e");
    }
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
      width: MediaQuery.of(context).size.width,
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
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF6F3DFA)),
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
                      Text(
                        "Funded",
                        style: GoogleFonts.publicSans(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
          ),
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
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
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

            _avatarStack(data),

            const SizedBox(height: 14),
            Text(
              "Join ${data.heroesList.length} other heroes who contributed.",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
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

    String _initials(String name) {
      final parts = name.trim().split(" ");
      if (parts.length == 1) {
        return parts[0][0].toUpperCase();
      }
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }

    return SizedBox(
      height: size,
      width: size + overlap * visible,
      child: Stack(
        children: [
          ...List.generate(visible, (i) {
            final initials = _initials(heroes[i].name);

            return Positioned(
              left: overlap * i,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF6F3DFA).withOpacity(0.12),
                child: Text(
                  initials,
                  style: GoogleFonts.publicSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: const Color(0xFF6F3DFA),
                  ),
                ),
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

    if (bids.isEmpty) {
      return _buildHandpickedVendorsCard();
    }

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
                Icon(
                  Icons.gavel_outlined,
                  size: 36,
                  color: Colors.grey.shade700,
                ),
                const SizedBox(height: 16),
                Text(
                  "Awaiting Bids",
                  style: GoogleFonts.publicSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
    final bool selected = _selectedVendorId == bid.id;

    String _initials(String name) {
      final parts = name.trim().split(" ");
      if (parts.length == 1) return parts[0][0].toUpperCase();
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }

    final initials = _initials(bid.vendorName);

    return GestureDetector(
      onTap: () {
        if (!widget.data.isMe) {
          return;
        }

        final cubit = BlocProvider.of<MissionFundingCubit>(context);

        if (cubit.bidAccepted) {
          return;
        }

        setState(() {
          _selectedVendorId = selected ? null : bid.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF6F3DFA).withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF6F3DFA)
                : Colors.grey.withOpacity(0.2),
            width: selected ? 2 : 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-----------------------------------------------------------
            // HEADER ROW
            //-----------------------------------------------------------
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF6F3DFA).withOpacity(0.12),
                  child: Text(
                    initials,
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF6F3DFA),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bid.vendorName,
                        style: GoogleFonts.publicSans(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.yellow,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${bid.rating} (${bid.reviews} reviews)",
                            style: GoogleFonts.publicSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            //-----------------------------------------------------------
            // BID AMOUNT + TIMELINE
            //-----------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Proposed Bid",
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      "₹${bid.proposedAmount.toStringAsFixed(0)}",
                      style: GoogleFonts.publicSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? const Color(0xFF6F3DFA)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "Timeline",
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      bid.timeline,
                      style: GoogleFonts.publicSans(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: selected
                            ? const Color(0xFF6F3DFA)
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            //-----------------------------------------------------------
            // MATERIALS USED
            //-----------------------------------------------------------
            Text(
              "Materials Used",
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bid.materialUsed.join(", "),
              style: GoogleFonts.publicSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            //-----------------------------------------------------------
            // WHY CHOOSE ME
            //-----------------------------------------------------------
            Text(
              "Why choose me",
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              bid.whyChooseMe,
              style: GoogleFonts.publicSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),

            if (selected) const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHandpickedVendorsCard() {
    final vendors = [
      {
        "name": "PaveRight Contractors",
        "rating": "4.8 ★ | 50+ CivicFix missions",
      },
      {"name": "InfraBuilders Inc.", "rating": "4.6 ★ | 32+ CivicFix missions"},
      {"name": "RoadMakers United", "rating": "4.5 ★ | 25+ CivicFix missions"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Handpicked Vendors for Tenders",
          style: GoogleFonts.publicSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),

        ...vendors.map((v) {
          final initials = v["name"]!
              .trim()
              .split(" ")
              .map((e) => e.isNotEmpty ? e[0] : "")
              .take(2)
              .join()
              .toUpperCase();

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFF6F3DFA).withOpacity(0.12),
                  child: Text(
                    initials,
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFF6F3DFA),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        v["name"]!,
                        style: GoogleFonts.publicSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        v["rating"]!,
                        style: GoogleFonts.publicSans(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          );
        }).toList(),
      ],
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
            "Every ₹500 prevents an accident.",
            style: GoogleFonts.publicSans(
              fontSize: 15,
              color: Color(0xFF6F3DFA),
              fontWeight: FontWeight.w600,
            ),
          ),
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

  refreshPage() {
    context.read<MissionFundingCubit>().loadMission(widget.issueId);
  }

  // ===================================================================
  // CONTRIBUTE BUTTON
  // ===================================================================
  Widget _buildContributeButton(
    BuildContext context,
    MissionFundingModel data,
  ) {
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
              backgroundColor: Color(0xFF6F3DFA),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () async {
              final cubit = BlocProvider.of<MissionFundingCubit>(context);
              if ((data.isMe &&
                  (_selectedVendorId != null &&
                      (widget.data.fundedPercent * 100.0) == 100.0) &&
                  !cubit.bidAccepted)) {
                final dio = Dio();

                final url =
                    "http://3.109.152.78:8080/api/v1/bids/$_selectedVendorId/accept";

                final prefs = await SharedPreferences.getInstance();

                final response = await dio.post(
                  url,
                  options: Options(
                    headers: {'X-User-Id': prefs.getString("userId")},
                    contentType: "application/json",
                  ),
                );

                refreshPage();

                return;
              }

              if (widget.data.isMe && cubit.bidAccepted) {
                if (cubit.bidCompleted) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>
                          MissionAccomplishedPage(issueId: widget.issueId),
                    ),
                  );
                }

                return;
              }

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) {
                  return ContributeBottomSheet(
                    fundedAmount: data.currentPaid.toDouble(),
                    totalGoal: data.totalAmount.toDouble(),
                    campaignId: widget.campaignId,
                    refreshScreen: refreshPage,
                  );
                },
              );
            },
            child: Text(
              (data.isMe) ? getText() : "Contribute Now & Be a Hero!",
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

  getText() {
    final cubit = BlocProvider.of<MissionFundingCubit>(context);

    if (widget.data.isMe &&
        _selectedVendorId != null &&
        widget.data.fundedPercent == 100 &&
        !cubit.bidAccepted) {
      return "Start the work";
    } else if (widget.data.isMe && cubit.bidAccepted) {
      return cubit.bidCompleted
          ? 'Approve payment'
          : (cubit.incidentReport?.status ?? "").toLowerCase().contains(
              'schedul',
            )
          ? 'Work scheduled'
          : 'Work in progress';
    }

    return "Contribute & launch a mission";
  }

  ///Contribute & launch a mission
  ///Start the work
  ///Approve payment
  isFilled() {
    if (_selectedVendorId == null || widget.data.fundedPercent != 100) {
      return false;
    }
    return true;
  }
}
