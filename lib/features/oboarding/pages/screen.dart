import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../permission_page.dart';
import 'onboarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final step = onboardingData[currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(step.bgImage, fit: BoxFit.cover),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    (isDark
                        ? const Color(0xFF140F23)
                        : const Color(0xFFF6F5F8)),
                    (isDark
                        ? const Color(0xFF140F23)
                        : const Color(0xFFF6F5F8))
                        .withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ------------------ PAGE VIEW ------------------
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() => currentPage = index);
            },
            itemBuilder: (context, index) {
              final step = onboardingData[index];

              return Column(
                children: [
                  const SizedBox(height: 60),

                  // Dots Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                          (i) => dot(i == currentPage),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Content
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F3DFA).withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            step.icon,
                            size: 40,
                            color: const Color(0xFF6F3DFA),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          step.cta,
                          style: GoogleFonts.publicSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6F3DFA),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          step.title,
                          style: GoogleFonts.publicSans(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF131118),
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          step.description,
                          style: GoogleFonts.publicSans(
                            fontSize: 15,
                            height: 1.4,
                            color: isDark
                                ? Colors.grey[300]
                                : const Color(0xFF6B5F8C),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Continue Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6F3DFA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 1,
                            ),
                            onPressed: () {
                              if (currentPage < onboardingData.length - 1) {
                                _controller.nextPage(
                                  duration:
                                  const Duration(milliseconds: 250),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                // LAST PAGE ACTION
                                Navigator.pushReplacement(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (_) => const LocationCommunityOnboarding(),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              currentPage == onboardingData.length - 1
                                  ? "Get Started"
                                  : "Continue",
                              style: GoogleFonts.publicSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // -------------------- DOT WIDGET --------------------
  Widget dot(bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xFF6F3DFA)
            : const Color(0xFF6F3DFA).withOpacity(0.20),
        shape: BoxShape.circle,
      ),
    );
  }
}
