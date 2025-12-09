import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AIDetectionProgressPage extends StatefulWidget {
  const AIDetectionProgressPage({super.key});

  @override
  State<AIDetectionProgressPage> createState() =>
      _AIDetectionProgressPageState();
}

class _AIDetectionProgressPageState extends State<AIDetectionProgressPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer stepTimer;

  int currentStep = 0;

  final steps = [
    "Uploading image…",
    "Enhancing clarity…",
    "Running AI model…",
    "Extracting pothole details…",
    "Finalizing results…",
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    stepTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (currentStep < steps.length - 1) {
        setState(() => currentStep++);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    stepTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // -------------------------------
              // Animated Loader Circle
              // -------------------------------
              SizedBox(
                height: 100,
                width: 100,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _controller.value * 6.3,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border(
                        top: BorderSide(
                            color: const Color(0xFF6F42C1), width: 4),
                        right: BorderSide(
                            color: const Color(0xFF6F42C1).withOpacity(0.4),
                            width: 4),
                        bottom: BorderSide(
                            color: const Color(0xFF6F42C1).withOpacity(0.2),
                            width: 4),
                        left: BorderSide(
                            color: const Color(0xFF6F42C1).withOpacity(0.1),
                            width: 4),
                      ),
                    ),
                    child: Icon(Icons.auto_awesome,
                        size: 40, color: Colors.purple.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // -------------------------------
              // Big Title
              // -------------------------------
              Text(
                "Analyzing Your Pothole...",
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // -------------------------------
              // Step Text
              // -------------------------------
              Text(
                steps[currentStep],
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // -------------------------------
              // Step Indicators
              // -------------------------------
              Column(
                children: List.generate(
                  steps.length,
                      (i) => _buildStepIndicator(i, isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int index, bool isDark) {
    final bool completed = index < currentStep;
    final bool active = index == currentStep;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: completed
            ? Colors.green.withOpacity(0.12)
            : active
            ? Colors.purple.withOpacity(0.12)
            : (isDark ? Colors.white10 : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed
              ? Colors.green
              : active
              ? Colors.purple
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle
                : active
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color: completed
                ? Colors.green
                : active
                ? Colors.purple
                : Colors.grey,
          ),
          const SizedBox(width: 12),
          Text(
            steps[index],
            style: GoogleFonts.publicSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: completed
                  ? Colors.green.shade700
                  : active
                  ? Colors.purple
                  : (isDark ? Colors.grey[400] : Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}
