import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pdp_page/completed_screen.dart';
import '../pdp_page/generic_view.dart';
import '../pdp_page/model/pdp_page_model.dart';
import '../report_journey/report_page.dart';
import 'HomeCubit.dart';
import 'home_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..loadHomeData(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        if (state is HomeLoading) {
          return Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF140F23)
                : const Color(0xFFF6F5F8),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! HomeLoaded) {
          return const SizedBox();
        }

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF140F23)
              : const Color(0xFFF6F5F8),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: Column(
                children: [
                  // ------------------------ TOP BAR ------------------------
                  _buildTopBar(state.locality, isDark),

                  // ------------------------ CAROUSEL ------------------------
                  _buildCarousel(context, state.homeActionCards, isDark),

                  // ------------------------ TITLE ------------------------
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nearby Issues",
                        style: GoogleFonts.publicSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),

                  // ------------------------ NEARBY LIST ------------------------
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.nearbyIssues.length,
                      itemBuilder: (context, i) {
                        final issue = state.nearbyIssues[i];
                        return _buildIssueCard(issue, isDark);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------- UI Helpers ---------------------
  Widget _buildTopBar(String locality, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: isDark ? Colors.white : Colors.black,
              ),
              const SizedBox(width: 6),
              Text(
                locality,
                style: GoogleFonts.publicSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          //
          // // Profile avatar
          // Container(
          //   width: 38,
          //   height: 38,
          //   decoration: const BoxDecoration(
          //     shape: BoxShape.circle,
          //     image: DecorationImage(
          //       fit: BoxFit.cover,
          //       image: NetworkImage(
          //         "https://lh3.googleusercontent.com/aida-public/AB6AXuCAGXwKldzUtpl1b_yw7RovcnmEGOkt_AYfH5kiEX-oCocPWyyBnOHuqDk7LGAsFaQKSz3lwcyrnUUaUlXhisPd5liapEEpwt0Wzg0TzoCa5hyEZg7HvBObJ7-kwNCykBqmsJUZ2oV1Rr7e4U-TblNDKXmhDxyvStlN728eQKwiJGBLNoFxi1_Y9xT0k7YiWkYsG5FVvxLrQ27y6lNZkSaSr7P9komGKFdD96lg0qvB3wjJA7Nb7vOWISLw_Zbd-WPeAcJjS9bFqeU",
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildCarousel(
    BuildContext context,
    List<HomeActionCard> cards,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: SizedBox(
        height: 170,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          separatorBuilder: (_, __) => const SizedBox(width: 14),
          itemBuilder: (context, index) {
            final card = cards[index];
            return GestureDetector(
              onTap: () {
                if (card.id == "report") {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (_) => const ReportPage()),
                  );
                }
              },
              child: Container(
                width: 230,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      card.subtitle,
                      style: GoogleFonts.publicSans(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: card.isPrimary
                            ? const Color(0xFF6D38FF)
                            : (isDark
                                  ? Colors.white.withOpacity(0.1)
                                  : const Color(0xFFF0F0F0)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        card.buttonText,
                        style: GoogleFonts.publicSans(
                          color: card.isPrimary
                              ? Colors.white
                              : (isDark ? Colors.white : Colors.black),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIssueCard(NearbyIssue issue, bool isDark) {
    return GestureDetector(
      onTap: () {
        final mockMission = MissionFundingModel(
          title: "Fix the Richmond Road Potholes",
          location: "Koramangala, Bengaluru",
          headerImage:
          "https://lh3.googleusercontent.com/aida-public/AB6AXuCiUCMgcgPNgu1PFWmA5FCur_LBxLqz-NjaSASBd-LQbeJUBge6KFPyRTxGhpSMrZrbJlEJs2FsQgVgOa57unD6-uHwZUyTnn6CZGom4snnpxSBgs7aMlwG0Y6L7r4YGoRcCqNVbdXACuM1m-xiECly9wis7yVgyXFxqLuFW5s6aQ-Csfqyj-Vggx5NkiY9OWqIHzrVabju-HJhRDd4PGW60-VmvGj_UZ6y4aoXtEsBF3OEBTCcMLJ23CHUiQ3G3eFXjV3RY7XcRXk",

          isMe: false,

          totalAmount: 50000,
          currentPaid: 30000,

          heroesList: [
            HeroContributor(
              name: "Ravi S.",
              amount: 1500,
              imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuB_HzNluTp57gjem_RNdnMRS5AhDJzqUhQiUYv27Gbdj4z6RQFjRSUSKpObxN-we9uTVZTtEKkboipDKHbO2N2TMQKyl7ij1MYl7iRS3o4YGwz5tN3whRtllPhcC7RjlHiQyz5qmBMhpGQnWksMUlqJu5KT3f1ohTvTxeEtaI-z9k93DsatqhhPShWvHV1ky6G0lGlUOewA1TC8ofrYu6swOdYNhH1hQkeKEd3PZFyhbaf3yTJN2canHwFpfmLtt4qtWc5tUTtEpeY",
            ),
            HeroContributor(
              name: "Priya K.",
              amount: 2500,
              imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuBsUmTH8tGkVM2TNPV9WJwOXELDLnE0oH9jaDUzzMiNG1VbJ1KDmXSajzTB6y3erC-6FjZ-LLKDkh82KlRl4D89EUEVzIFR1R3SvLfjxMXcUA_ScKcaAVmWGiEZ9GyFi-qOxFz-1xEqOnPAj5y85gIPgjhQiT1JOyYP39xoHgB0olgQnBjoEgXKETB1M7cU7aFXIT_OgknBuULnwXgnYEQxk6x4b7dK1TYrsbIb_JDCqr5ZLCXQqG0acyqTXPVCtRhYWW79yCBlYC4",
            ),
            HeroContributor(
              name: "Ankit G.",
              amount: 500,
              imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuDljAf8ycQrNZdrqAJ_qzPFbp_XeeYFV2aV6IKk9C5OCNQJ7IhwZgjVQ1MhWp5Or6LWQlcWxsVwpiSMv-9r78vVWhNqOeYyuk6MlHbfuXX0C78m6CknY1kXr8zSr6TfZue-FDmyZuggmr-5d_ns7DQWr5YcriO4cudBsnsv0QH6xfWfmPfdYme1nmYbk8UJdPPdLto3qwU5qTaYv1cptmGhpVQTEk_4PlQSzikqmwSjPlR08A1LvqjcngUVCx9plP2K9vMX2Yjcuv4",
            ),
            HeroContributor(
              name: "Shweta M.",
              amount: 1000,
              imageUrl:
              "https://i.pravatar.cc/150?img=47",
            ),
            HeroContributor(
              name: "Aarav R.",
              amount: 800,
              imageUrl:
              "https://i.pravatar.cc/150?img=59",
            ),
          ],

          vendorBids: [
            VendorBid(
              vendorName: "FixIt Crew",
              avatar: "https://i.pravatar.cc/150?img=60",
              proposedAmount: 10000,
              timeline: "3 Days",
              rating: 4.9,
              reviews: 124,
              status: "Accepted",
            ),
            VendorBid(
              vendorName: "RoadWorks Co.",
              avatar: "https://i.pravatar.cc/150?img=59",
              proposedAmount: 10000,
              timeline: "5 Days",
              rating: 4.7,
              reviews: 88,
              status: "rejected",
            ),
          ],
        );

        if(issue.progress == 100){
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => MissionAccomplishedPage()));

        }else{
          Navigator.of(
            context,
          ).push(CupertinoPageRoute(builder: (context) => MissionFundingParent(issueId: '136e67c6-10dd-41b8-8dc5-3b9b157ec59c',)));
        }

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                issue.imageUrl,
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    issue.title,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: issue.severityBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      issue.severity,
                      style: GoogleFonts.publicSans(
                        fontSize: 11,
                        color: issue.severityColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: issue.progress / 100,
                      minHeight: 6,
                      color: Colors.green,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : Colors.grey[300],
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    "${issue.progress}% funded",
                    style: GoogleFonts.publicSans(
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Container(
              height: 40,
              width: 90,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF6D38FF).withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Contribute",
                style: GoogleFonts.publicSans(
                  color: const Color(0xFF6D38FF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
