import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mission_accomplished_cubit.dart';
import 'before_after_fade.dart';
import 'model/MissionAccomplishedModel.dart';

class MissionAccomplishedPage extends StatelessWidget {
  final String issueId;

  const MissionAccomplishedPage({super.key, required this.issueId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MissionAccomplishedCubit()..loadMission(issueId),
      child: const _MissionAccomplishedView(),
    );
  }
}

class _MissionAccomplishedView extends StatelessWidget {
  const _MissionAccomplishedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MissionAccomplishedCubit, MissionAccomplishedState>(
      builder: (context, state) {
        if (state is MissionAccomplishedLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is MissionAccomplishedError) {
          return Scaffold(
            body: Center(child: Text(state.message)),
          );
        }

        final MissionAccomplishedModel data =
            (state as MissionAccomplishedLoaded).data;

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
          isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
          body: Column(
            children: [
              _buildHeader(context, data.title, isDark),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.publicSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCelebrationBadge(),
                      const SizedBox(height: 12),
                      _buildTitleSection(isDark),
                      const SizedBox(height: 24),
                      _buildBeforeAfterCard(data.beforeImage, data.afterImage),
                      const SizedBox(height: 24),
                      _buildThankYouSection(
                        isDark,
                        data.totalFunders,
                        data.vendorName,
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
              _buildBottomActions(isDark, context),
            ],
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  Widget _buildHeader(BuildContext context, String title, bool isDark) {
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
          const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildCelebrationBadge() {
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

  Widget _buildBeforeAfterCard(String before, String after) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BeforeAfterFade(
        beforeUrl: before,
        afterUrl: after,
      ),
    );
  }

  Widget _buildThankYouSection(
      bool isDark,
      int totalFunders,
      String vendor,
      ) {
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
              "This incredible achievement was a true community effort.",
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
              "Our $totalFunders Funders",
              "For pooling resources to make this happen.",
              isDark,
            ),
            _thankYouItem(
              Icons.construction,
              vendor,
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
                    color: Colors.white),
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
