import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FundingHeroPage extends StatelessWidget {
  const FundingHeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF140F23) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Wall of Fame',
          style: GoogleFonts.publicSans(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Icon(Icons.star, color: Color(0xFF6F42C1)),
                const SizedBox(width: 4),
                Text(
                  '1',
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: isDark ? const Color(0xFF140F23) : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Funding Heroes Section
                    _buildFundingHeroesSection(isDark),
                    const SizedBox(height: 20),

                    // Community Goal Tracker Section
                    _buildCommunityGoalTrackerSection(isDark),
                    const SizedBox(height: 20),

                    // Heroic Next Steps Section
                    _buildHeroicNextStepsSection(isDark),
                    const SizedBox(height: 20),

                    // Vendor Bids Section
                    _buildVendorBidsSection(isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Fund Mission Button
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
                    // Handle fund mission action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F42C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.favorite, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Fund This Mission',
                        style: GoogleFonts.publicSans(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFundingHeroesSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
            'Funding Heroes',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Be the first to join the mission!',
            style: GoogleFonts.publicSans(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6F42C1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'SEED FUNDER',
                      style: GoogleFonts.publicSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'RAVI S.',
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Ravi started the mission. Be the next hero!',
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Handle become funding hero action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F42C1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Become a Funding Hero!',
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityGoalTrackerSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
            'Community Goal Tracker',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '0%',
                style: GoogleFonts.publicSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6F42C1),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'FUNDED',
                  style: GoogleFonts.publicSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Only seed fund active. Let\'s get this mission started!',
            style: GoogleFonts.publicSans(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: 0.0,
              minHeight: 9,
              color: const Color(0xFF6F42C1),
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey[200],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Handle broadcast action
              },
              icon: const Icon(Icons.broadcast_on_personal, size: 20),
              label: Text(
                'Broadcast active to <20 users',
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: const BorderSide(color: Color(0xFF6F42C1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroicNextStepsSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
            'Heroic Next Steps',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Amplify the Signal
          _buildNextStepCard(
            isDark,
            'Amplify the Signal',
            'Expand the broadcast to reach more potentially affected users in your area.',
            Icons.broadcast_on_personal,
            'Expand Broadcast',
            () {
              // Handle expand broadcast action
            },
          ),
          const SizedBox(height: 16),
          // Rally the Troops
          _buildNextStepCard(
            isDark,
            'Rally the Troops',
            'Share the mission on social media and with your local community groups.',
            Icons.share,
            'Share Mission',
            () {
              // Handle share mission action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepCard(
    bool isDark,
    String title,
    String description,
    IconData icon,
    String buttonText,
    VoidCallback onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6F42C1),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.publicSans(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon, size: 18),
              label: Text(
                buttonText,
                style: GoogleFonts.publicSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: Color(0xFF6F42C1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorBidsSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
        children: [
          Text(
            'Vendor Bids',
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Icon(
            Icons.gavel,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'Awaiting Bids',
            style: GoogleFonts.publicSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vendors will be invited once funding milestones are reached.',
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

