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
            backgroundColor:
            isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! HomeLoaded) return const SizedBox();

        return Scaffold(
          backgroundColor:
          isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 6),

                    // ------------------------ TOP BAR ------------------------
                    _buildTopBar(state.locality, isDark),

                    // ------------------------ CAROUSEL ------------------------
                    _buildCarousel(context, state.homeActionCards, isDark),

                    // ------------------------ TITLE ------------------------
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
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

                    const SizedBox(height: 6),

                    // ------------------------ TAB CONTROLLER ------------------------
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          TabBar(
                            labelColor: const Color(0xFF6D38FF),
                            unselectedLabelColor: isDark
                                ? Colors.grey[500]
                                : Colors.grey[700],
                            labelStyle: GoogleFonts.publicSans(
                                fontWeight: FontWeight.w700, fontSize: 14),
                            indicatorColor: const Color(0xFF6D38FF),
                            tabs: const [
                              Tab(text: "Ongoing"),
                              Tab(text: "Completed"),
                            ],
                          ),

                          SizedBox(
                            height:
                            MediaQuery.of(context).size.height * 0.68,
                            child: TabBarView(
                              children: [
                                _buildOngoingList(
                                    state.nearbyIssues, isDark),
                                _buildCompletedList(
                                    state.nearbyIssues, isDark),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------- TOP BAR ---------------------
  Widget _buildTopBar(String locality, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on,
                  color: isDark ? Colors.white : Colors.black),
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
        ],
      ),
    );
  }

  // -------------------- CAROUSEL ---------------------
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

  // -------------------- ISSUE CARD ---------------------
  Widget _buildIssueCard(NearbyIssue issue, bool isDark) {
    return GestureDetector(
      onTap: () {
        if (issue.status == 'COMPLETED') {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => MissionAccomplishedPage(issueId: issue.id)),
          );
        } else {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => MissionFundingParent(issueId: issue.id),
            ),
          );
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      backgroundColor:
                      isDark ? Colors.grey[800] : Colors.grey[300],
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

  // -------------------- ONGOING LIST ---------------------
  Widget _buildOngoingList(List<NearbyIssue> all, bool isDark) {
    final filtered =
    all.where((e) => e.status != "COMPLETED").toList();

    if (filtered.isEmpty) return _emptyMessage("No ongoing issues right now.");

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: filtered.length,
      itemBuilder: (context, i) => _buildIssueCard(filtered[i], isDark),
    );
  }

  // -------------------- COMPLETED LIST ---------------------
  Widget _buildCompletedList(List<NearbyIssue> all, bool isDark) {
    final filtered =
    all.where((e) => e.status == "COMPLETED").toList();

    if (filtered.isEmpty) return _emptyMessage("No completed issues yet.");

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: filtered.length,
      itemBuilder: (context, i) => _buildIssueCard(filtered[i], isDark),
    );
  }

  Widget _emptyMessage(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Text(
          text,
          style: GoogleFonts.publicSans(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
