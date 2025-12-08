import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AISolutionsPage extends StatelessWidget {
  const AISolutionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF140F23)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'AI Proposed Solutions',
          style: GoogleFonts.publicSans(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    // Intro Section
                    _buildIntroSection(isDark),
                    const SizedBox(height: 24),

                    // Solution Cards
                    _buildSolutionCard(
                      isDark,
                      icon: Icons.campaign,
                      title: 'Ping Govt Officials',
                      description: 'Notify local authorities instantly.',
                      onTap: () {
                        // Handle ping govt officials action
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSolutionCard(
                      isDark,
                      icon: Icons.people,
                      title: 'Crowdfund and Fix it',
                      description: 'Start a community fundraiser.',
                      onTap: () {
                        // Handle crowdfund action
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildSolutionCard(
                      isDark,
                      icon: Icons.lightbulb_outline,
                      title: 'Any other solutions?',
                      description: 'Explore more options & ideas.',
                      onTap: () {
                        // Handle explore more options action
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
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
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F42C1).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'I\'ll decide later',
                    style: GoogleFonts.publicSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6F42C1),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSection(bool isDark) {
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
          // AI Icon with sparkles
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF6F42C1).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Sparkle icons
                Positioned(
                  top: 20,
                  left: 20,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: const Color(0xFF6F42C1),
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 16,
                    color: const Color(0xFF6F42C1),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: Icon(
                    Icons.auto_awesome,
                    size: 20,
                    color: const Color(0xFF6F42C1),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Here\'s how we can fix it',
            style: GoogleFonts.publicSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our AI has analyzed the issue and suggests the following actions. Choose the one that works best for you.',
            textAlign: TextAlign.center,
            style: GoogleFonts.publicSans(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionCard(
    bool isDark, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF6F42C1).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF6F42C1), size: 28),
            ),
            const SizedBox(width: 16),
            // Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.publicSans(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
