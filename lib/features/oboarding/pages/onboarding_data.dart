import 'package:flutter/cupertino.dart';
import 'package:material_symbols_icons/symbols.dart';

class OnboardingStep {
  final String bgImage;
  final IconData icon;
  final String cta;
  final String title;
  final String description;

  OnboardingStep({
    required this.bgImage,
    required this.icon,
    required this.cta,
    required this.title,
    required this.description,
  });
}

final onboardingData = [
  OnboardingStep(
    bgImage:
    "assets/onboarding_1.jpeg",
    icon: Symbols.volunteer_activism,
    cta: "SIMPLE AS 1-2-3",
    title: "Fund the fix personally or with others.",
    description:
    "Chip in to solve the issue faster. You can fund the entire fix yourself or invite neighbors to join in.",
  ),
  OnboardingStep(
    bgImage:
    "assets/onboarding_2.png",
    icon: Symbols.location_on,
    cta: "SPOT THE ISSUE",
    title: "Find potholes, garbage dumps, and civic issues.",
    description:
    "Just point, click, and report. Your location helps authorities act quickly.",
  ),
  OnboardingStep(
    bgImage:
    "assets/onboarding_3.png",
    icon: Symbols.check_circle,
    cta: "TRACK THE FIX",
    title: "Watch progress from report to resolution.",
    description:
    "Stay updated as authorities and volunteers work together to improve your neighborhood.",
  ),
];