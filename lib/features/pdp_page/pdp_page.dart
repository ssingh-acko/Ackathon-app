import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import 'mission_executed_screen.dart';

/// ---------------------------------------------------
/// MODELS
/// ---------------------------------------------------

class HeroUser {
  final String name;
  final String image;
  final String badge;
  final Color ringColor;

  HeroUser({
    required this.name,
    required this.image,
    required this.badge,
    required this.ringColor,
  });
}

class VendorBid {
  final String vendorName;
  final String avatar;
  final double proposedAmount;
  final String timeline;
  final double rating;
  final int reviews;
  final String status; // pending, rejected, considered
  final Color statusColor;
  final Color ringColor;

  VendorBid({
    required this.vendorName,
    required this.avatar,
    required this.proposedAmount,
    required this.timeline,
    required this.rating,
    required this.reviews,
    required this.status,
    required this.statusColor,
    required this.ringColor,
  });
}

class Milestone {
  final double percentage;
  final String label;
  final String icon;
  final bool isActive;
  final bool isGoal;
  final String image;

  Milestone({
    required this.percentage,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isGoal,
    required this.image,
  });
}

/// ---------------------------------------------------
/// PDP SCREEN
/// ---------------------------------------------------

class PdpScreen extends StatefulWidget {
  const PdpScreen({super.key});

  @override
  State<PdpScreen> createState() => _PdpScreenState();
}

class _PdpScreenState extends State<PdpScreen> with SingleTickerProviderStateMixin {

  late PageController _pageController;
  int _currentImage = 0;
  int? _selectedVendorIndex;

  // Dummy Data
  final List<String> _images = [
    "https://lh3.googleusercontent.com/aida-public/AB6AXuCNNTkme7_x8rw27U7iWIGuO6k0sDYbNn8kz4gms7N7Zov24Qdq53rI8xRIlsSkc91bR60rV_vdnZzUwrm3DtkRZEGt-jc2XXVW0dnV8EXv0PPSBlVjP2uGHXfr_NnagTqWYoOv6HLk8JIvehTxo7frB-nVDUfoUIBCKjNNrhP91jFUaupuPUlqF_lqXfzhElqJplJiMr-EOsGyKYClbQrUqquFWkGjF42JJg4_K2zM3atddg5iYRrfixdiNqCH048RnozaW6-zShY",
    "https://lh3.googleusercontent.com/aida-public/AB6AXuDVgz8T1Qp1Uessc4dqMAlvhocAg-1x-4NWptEBGBQJzP2nzKrkRRDihK33Pf2PBiD42LgiYAFoxddlp3iashtwEG9cfXnNr-6ygqAyOIC_cXCuANS-AMYputHJaMoV7WOvY7m0JtA9W_zc7ciKp4eZBI6XNr-IF5AkJFF1hf4JXfXNuj76K0T3AP68QkWQtRF_qG7ahbJyWlifGVQReeYMHq4QisFrlpiuAhnc3lu3f1eb09PIT0zI31HLlFu-Hu1lphgcatBcshM",
  ];

  final List<HeroUser> heroes = [
    HeroUser(
      name: "Ravi S.",
      image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuB_HzNluTp57gjem_RNdnMRS5AhDJzqUhQiUYv27Gbdj4z6RQFjRSUSKpObxN-we9uTVZTtEKkboipDKHbO2N2TMQKyl7ij1MYl7iRS3o4YGwz5tN3whRtllPhcC7RjlHiQyz5qmBMhpGQnWksMUlqJu5KT3f1ohTvTxeEtaI-z9k93DsatqhhPShWvHV1ky6G0lGlUOewA1TC8ofrYu6swOdYNhH1hQkeKEd3PZFyhbaf3yTJN2canHwFpfmLtt4qtWc5tUTtEpeY",
      badge: "Top Funder",
      ringColor: const Color(0xFF00F0FF),
    ),
    HeroUser(
      name: "Priya K.",
      image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT-UwwKpRwbStnN8koO2m-7FBAXBsO5Fp8YanSYAIW_s6Mhl4ybKpI73ywUFVsOGCeeUN_lsW0XWsItp6gJQYlDVKSNDgjgYctev2wKF4nOLpbWdef-u8nAvAa0L4CBnV7R8e35BNd6uwR6Gvjl4ofFfaTXCJapV1roG7SBgL_4cym3uM2IqURJjd3dGjKaiJPaIAx2ru_q1g__ObwIQja8-tcNpwTLU3G-smOKd_19i6PWGwZRTKpSsx8h33BsUQTtn5j3F5a3g",
      badge: "1st Contributor",
      ringColor: const Color(0xFF00FF7F),
    ),
    HeroUser(
      name: "Priya A.",
      image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT-UwwKpRwbStnN8koO2m-7FBAXBsO5Fp8YanSYAIW_s6Mhl4ybKpI73ywUFVsOGCeeUN_lsW0XWsItp6gJQYlDVKSNDgjgYctev2wKF4nOLpbWdef-u8nAvAa0L4CBnV7R8e35BNd6uwR6Gvjl4ofFfaTXCJapV1roG7SBgL_4cym3uM2IqURJjd3dGjKaiJPaIAx2ru_q1g__ObwIQja8-tcNpwTLU3G-smOKd_19i6PWGwZRTKpSsx8h33BsUQTtn5j3F5a3g",
      badge: "1st Contributor",
      ringColor: const Color(0xFF00FF7F),
    ),
    HeroUser(
      name: "Priya B.",
      image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT-UwwKpRwbStnN8koO2m-7FBAXBsO5Fp8YanSYAIW_s6Mhl4ybKpI73ywUFVsOGCeeUN_lsW0XWsItp6gJQYlDVKSNDgjgYctev2wKF4nOLpbWdef-u8nAvAa0L4CBnV7R8e35BNd6uwR6Gvjl4ofFfaTXCJapV1roG7SBgL_4cym3uM2IqURJjd3dGjKaiJPaIAx2ru_q1g__ObwIQja8-tcNpwTLU3G-smOKd_19i6PWGwZRTKpSsx8h33BsUQTtn5j3F5a3g",
      badge: "1st Contributor",
      ringColor: const Color(0xFF00FF7F),
    ),
    HeroUser(
      name: "Priya KC.",
      image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT-UwwKpRwbStnN8koO2m-7FBAXBsO5Fp8YanSYAIW_s6Mhl4ybKpI73ywUFVsOGCeeUN_lsW0XWsItp6gJQYlDVKSNDgjgYctev2wKF4nOLpbWdef-u8nAvAa0L4CBnV7R8e35BNd6uwR6Gvjl4ofFfaTXCJapV1roG7SBgL_4cym3uM2IqURJjd3dGjKaiJPaIAx2ru_q1g__ObwIQja8-tcNpwTLU3G-smOKd_19i6PWGwZRTKpSsx8h33BsUQTtn5j3F5a3g",
      badge: "1st Contributor",
      ringColor: const Color(0xFF00FF7F),
    ),
    HeroUser(
      name: "Priya KD.",
      image:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuAWT-UwwKpRwbStnN8koO2m-7FBAXBsO5Fp8YanSYAIW_s6Mhl4ybKpI73ywUFVsOGCeeUN_lsW0XWsItp6gJQYlDVKSNDgjgYctev2wKF4nOLpbWdef-u8nAvAa0L4CBnV7R8e35BNd6uwR6Gvjl4ofFfaTXCJapV1roG7SBgL_4cym3uM2IqURJjd3dGjKaiJPaIAx2ru_q1g__ObwIQja8-tcNpwTLU3G-smOKd_19i6PWGwZRTKpSsx8h33BsUQTtn5j3F5a3g",
      badge: "1st Contributor",
      ringColor: const Color(0xFF00FF7F),
    ),
  ];

  final List<VendorBid> vendorBids = [
    VendorBid(
      vendorName: "Apex Construction",
      avatar:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuB1FxSyfsupZzuDMahqGj-4FGRFNnKNBj27rceqBVKWU6Fo18UscMxkLzOoDgnjpqyxRwgqH8_GNwMMtLe4hloVpef3iuEsYC7PcRBShDGQ_An_2Q1qpEKaxl75ND_9W3AAf7UBYS6D1u7kOhNBt8wfQe4Y-PahBE_M8GVkIsdNRvoFrcpV3vmxbSjhlYywRgj1sPaoShN2IdDmFGphvxNeX7AH_A8Gsl2fb-zMigLjodR5bzsYpyHqLnc_sXdBqttHMVbSevZ7yA4",
      proposedAmount: 72000,
      timeline: "3 Days",
      rating: 4.9,
      reviews: 124,
      status: "critical",
      statusColor: Colors.red,
      ringColor: Colors.grey,
    ),
    VendorBid(
      vendorName: "RoadMasters Inc.",
      avatar:
      "https://lh3.googleusercontent.com/aida-public/AB6AXuCv5KUjcmQkzUnAhMAywULI32uOeBTyhg9PaAfsB0pRT1ZZTRstRJ8fky29W1BT18plp24UtyNnuqcSMrvu3MRBRn514WiQTOELFefEqv-K5EPaoubjCEjv2r8eLVjVoi9iDDoKt3FdUevdtTw54h2Zs_I6lcPD7TCfa5qStR7_l5QBAXIsHAhBngpaR-aWyjOdBO7qr0PSHlkMuMIZjfAcfeQdUb_Rw3q6ZbJqgYo11vmMLdHL_GJ-Yb4TeSnM2HWenET5P7wModU",
      proposedAmount: 78500,
      timeline: "5 Days",
      rating: 4.7,
      reviews: 88,
      status: "rejected",
      statusColor: Colors.red,
      ringColor: Colors.grey,
    ),
  ];

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF140F23),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildHeroWall(),
                  _buildProgressSection(),
                  _buildImagesScroller(),
                  buildHeroicNextSteps(),
                  _buildVendorBids(),
                ],
              ),
            ),
            _buildBottomCTA(),
          ],
        ),
      ),
    );
  }

  Widget buildHeroicNextSteps() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1526).withOpacity(0.35), // bg-slate-900/40
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00F0FF).withOpacity(0.5), // border-accent-blue/50
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00F0FF).withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Title
          Text(
            "Heroic Next Steps",
            textAlign: TextAlign.center,
            style: GoogleFonts.urbanist(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),

          const SizedBox(height: 20),

          // -----------------------------------------
          // CARD 1: SHARE THE MISSION
          // -----------------------------------------
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF6F3DFA).withOpacity(0.20), // bg-primary/20
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFF6F3DFA).withOpacity(0.50),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SHARE THE MISSION!",
                  style: GoogleFonts.urbanist(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF00F0FF),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Boost funding by sharing the Wall of Fame with your network.",
                  style: GoogleFonts.publicSans(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Button
                SizedBox(
                  height: 42,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00F0FF), // accent-blue
                      foregroundColor: const Color(0xFF100C1F),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      SharePlus.instance.share( ShareParams(text: 'check out my website https://example.com'));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.share, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          "Share Now",
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //
          // const SizedBox(height: 20),
          //
          // // -----------------------------------------
          // // CARD 2: EXPAND VENDOR BIDS
          // // -----------------------------------------
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.08), // bg-slate-800/60
          //     borderRadius: BorderRadius.circular(14),
          //     border: Border.all(
          //       color: Colors.blueGrey.shade700, // border-slate-700
          //     ),
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         "EXPAND VENDOR BIDS",
          //         style: GoogleFonts.urbanist(
          //           fontSize: 20,
          //           fontWeight: FontWeight.w900,
          //           color: const Color(0xFF00FF7F), // accent-green
          //           letterSpacing: 1,
          //         ),
          //       ),
          //       const SizedBox(height: 6),
          //       Text(
          //         "AI suggests inviting 5 more contractors for optimal choice.",
          //         style: GoogleFonts.publicSans(
          //           fontSize: 15,
          //           color: Colors.white,
          //         ),
          //       ),
          //       const SizedBox(height: 12),
          //
          //       // Button
          //       SizedBox(
          //         height: 42,
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor:
          //             const Color(0xFF00FF7F).withOpacity(0.20), // accent-green/20
          //             foregroundColor: const Color(0xFF00FF7F),
          //             elevation: 0,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //           ),
          //           onPressed: () {},
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               const Icon(Icons.call_made, size: 18),
          //               const SizedBox(width: 6),
          //               Text(
          //                 "Act on AI Rec.",
          //                 style: GoogleFonts.publicSans(
          //                   fontSize: 14,
          //                   fontWeight: FontWeight.w700,
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  /// ---------------------------------------------------
  /// HEADER
  /// ---------------------------------------------------
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          Text(
            "Civic Impact Wall of Fame",
            style: GoogleFonts.publicSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Icon(Icons.star, color: Colors.white),
        ],
      ),
    );
  }

  /// ---------------------------------------------------
  /// HERO WALL
  /// ---------------------------------------------------
  /// ---------------------------------------------------
  /// HERO WALL (Shows max 3 + “More Heroes” counter)
  /// ---------------------------------------------------
  /// ---------------------------------------------------
  /// HERO WALL (2-Column Grid + More Count)
  /// ---------------------------------------------------
  Widget _buildHeroWall() {
    final int maxVisible = 3;
    final bool hasMore = heroes.length > maxVisible;
    final int remainingCount = heroes.length - maxVisible;

    // Show only 3 heroes, place “More” as the 4th grid item
    final List<dynamic> gridItems = [
      ...heroes.take(maxVisible),
      if (hasMore) "more"
    ];

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF6F3DFA).withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            "Funding Heroes",
            style: GoogleFonts.chakraPetch(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: gridItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.88,
            ),
            itemBuilder: (context, index) {
              final item = gridItems[index];

              // --------------------------------------------------
              // "More Heroes" cell
              // --------------------------------------------------
              if (item == "more") {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                        border: Border.all(color: const Color(0xFF6F3DFA), width: 4),
                      ),
                      child: Center(
                        child: Text(
                          "+$remainingCount",
                          style: GoogleFonts.chakraPetch(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "More Heroes",
                      style: GoogleFonts.chakraPetch(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                );
              }

              // --------------------------------------------------
              // Normal Hero cell
              // --------------------------------------------------
              final HeroUser hero = item;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: hero.ringColor, width: 4),
                          image: DecorationImage(
                            image: NetworkImage(hero.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: hero.ringColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            hero.badge.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hero.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.chakraPetch(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }



  /// ---------------------------------------------------
  /// PROGRESS SECTION
  /// ---------------------------------------------------
  Widget _buildProgressSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Community Goal: Pothole Progress!",
            style: GoogleFonts.chakraPetch(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("₹65,000",
                      style: GoogleFonts.chakraPetch(
                        color: const Color(0xFF00F0FF),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      )),
                  Text(
                    "raised of ₹1,00,000 goal",
                    style: TextStyle(color: Colors.grey.shade400),
                  )
                ],
              ),
              Text(
                "65%",
                style: GoogleFonts.chakraPetch(
                  color: const Color(0xFF00FF7F),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  color: Colors.white.withOpacity(0.1),
                ),
                Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width * 0.65,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6F3DFA),
                        Color(0xFF00FF7F),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------------
  /// IMAGE SCROLLER
  /// ---------------------------------------------------
  Widget _buildImagesScroller() {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(_images[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  /// ---------------------------------------------------
  /// AI NEXT STEPS
  /// ---------------------------------------------------
  Widget _buildAiNextSteps() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00F0FF).withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Text(
            "Heroic Next Steps (AI Powered)",
            style: GoogleFonts.chakraPetch(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00F0FF),
            ),
          ),

          const SizedBox(height: 12),

          _aiStep(
            icon: Icons.check_circle,
            title: "Mission Broadcast Amplified",
            subtitle: "Completed on May 12",
            color: const Color(0xFF00FF7F),
            active: true,
          ),
          _aiStep(
            icon: Icons.group_add,
            title: "Forge New Alliances: Expand Vendor Bids!",
            subtitle: "AI suggests inviting 5 more contractors",
            color: const Color(0xFF00F0FF),
            active: true,
            showButton: true,
          ),
          _aiStep(
            icon: Icons.person_search,
            title: "Strategize: Select the Champion Bid",
            subtitle: "",
            color: Colors.grey,
            active: false,
          ),
          _aiStep(
            icon: Icons.rocket_launch,
            title: "Victory Awaits: Mission Deployment",
            subtitle: "",
            color: Colors.grey,
            active: false,
          ),
        ],
      ),
    );
  }

  Widget _aiStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool active,
    bool showButton = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withOpacity(active ? 0.3 : 0.15),
                child: Icon(icon, size: 20, color: color),
              ),
              Container(
                width: 2,
                height: 40,
                color: Colors.white24,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.publicSans(
                    fontSize: active ? 16 : 15,
                    color: active ? Colors.white : Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                if (showButton)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00F0FF).withOpacity(0.15),
                        foregroundColor: const Color(0xFF00F0FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Act on AI Recommendation"),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------------
  /// VENDOR BIDS
  /// ---------------------------------------------------
  Widget _buildVendorBids() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vendor Bids",
            style: GoogleFonts.chakraPetch(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 12),

          ...vendorBids.asMap().entries.map(
                (entry) => _vendorBidCard(entry.value, entry.key),
          ),

        ],
      ),
    );
  }

  Widget _vendorBidCard(VendorBid bid, int index) {
    final bool isSelected = _selectedVendorIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVendorIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent.withOpacity(0.10)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.blueAccent
                : bid.ringColor.withOpacity(0.4),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 14,
              spreadRadius: 2,
            )
          ]
              : [],
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
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // show checkmark if selected
                if (isSelected)
                  const Icon(Icons.check_circle,
                      color: Colors.blueAccent, size: 22),
              ],
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.white24),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _bidInfo("Proposed Bid", "₹${bid.proposedAmount.toStringAsFixed(0)}"),
                _bidInfo("Timeline", bid.timeline),
              ],
            ),

            const SizedBox(height: 16),

            // Only show action buttons if selected
            if (isSelected) _criticalButtons(),
          ],
        ),
      ),
    );
  }


  Widget _statusBadge(VendorBid bid) {
    switch (bid.status) {
      case "critical":
        return _badge("Critical Bid", const Color(0xFF00F0FF));
      case "rejected":
        return _badge("Rejected", Colors.redAccent);
      case "considered":
        return _badge("Considered", Colors.greenAccent.shade400);
      default:
        return const SizedBox();
    }
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bidInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Colors.grey.shade400)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.publicSans(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }

  Widget _criticalButtons() {
    return Column(
      children: [
        const SizedBox(height: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white12,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size.fromHeight(42),
          ),
          onPressed: () {},
          child: const Text("View Full Proposal"),
        ),
        // const SizedBox(height: 10),
        // Row(
        //   children: [
        //     Expanded(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.red.withOpacity(0.2),
        //           foregroundColor: Colors.redAccent,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(12),
        //           ),
        //           minimumSize: const Size.fromHeight(42),
        //         ),
        //         onPressed: () {},
        //         child: const Text("Reject"),
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     Expanded(
        //       child: ElevatedButton(
        //         style: ElevatedButton.styleFrom(
        //           backgroundColor: Colors.green.withOpacity(0.2),
        //           foregroundColor: Colors.greenAccent,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(12),
        //           ),
        //           minimumSize: const Size.fromHeight(42),
        //         ),
        //         onPressed: () {},
        //         child: const Text("Consider"),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  /// ---------------------------------------------------
  /// BOTTOM CTA
  /// ---------------------------------------------------
  Widget _buildBottomCTA() {
    final bool canProceed = _selectedVendorIndex != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF140F23).withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            offset: const Offset(0, -4),
            blurRadius: 10,
          )
        ],
      ),
      child: ElevatedButton(
        onPressed: canProceed ? () {
          Navigator.push(context, CupertinoPageRoute(builder: (context)=>ExecutedMissionScreen(
            lat: 19.0760,
            lng: 72.8777,
          )));
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          canProceed ? const Color(0xFF00FF7F) : Colors.grey.withOpacity(0.3),
          foregroundColor: canProceed ? Colors.black : Colors.white54,
          disabledBackgroundColor: Colors.grey.withOpacity(0.3),
          disabledForegroundColor: Colors.white54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          minimumSize: const Size.fromHeight(52),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rocket_launch,
                color: canProceed ? Colors.black : Colors.white54),
            const SizedBox(width: 8),
            const Text(
              "Initiate Mission Go!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        ),
      ),
    );
  }

}
