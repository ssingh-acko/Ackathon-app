import 'dart:ui';

class HomeActionCard {
  final String title;
  final String subtitle;
  final String buttonText;
  final bool isPrimary;
  final String id;

  HomeActionCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.id,
    this.isPrimary = false,
  });
}

class NearbyIssue {
  final String title;
  final String imageUrl;
  final String severity;
  final Color severityColor;
  final Color severityBg;
  final int progress;
  final bool isCompleted;

  NearbyIssue({
    required this.title,
    required this.imageUrl,
    required this.severity,
    required this.severityColor,
    required this.severityBg,
    required this.progress,
    required this.isCompleted,
  });
}

final homeActionCards = [
  HomeActionCard(
    title: "Report an Issue",
    subtitle: "Submit a new civic problem for review.",
    buttonText: "Start Report",
    isPrimary: true,
    id: "report"
  ),
  // HomeActionCard(
  //   title: "My Active Fixes",
  //   subtitle: "Track the progress of your issues.",
  //   buttonText: "View",
  //   id: "view"
  // ),
  // HomeActionCard(
  //   title: "Contribute Near You",
  //   subtitle: "Find and fund important projects.",
  //   buttonText: "Explore",
  //   id: "contribute"
  // ),
];

final nearbyIssues = [
  NearbyIssue(
    title: "Pothole on 5th Main Road",
    imageUrl:
    "https://lh3.googleusercontent.com/aida-public/AB6AXuCSPjkqAGMxouRpNu20f9jvCZFvR79dtIP0htxONzzDFV5QoQZ6-lzIreLJp4RePl-_5_qbay1T3AH-fDYJw1v2jFO7QcAoWAMr93PC6S2HKqG_e68pzV7XWsqccvwRKnd1hVdAGor1OjCuVZF7V0OvQUJ27eawTeFx5dgNm6aGw_21WKvnrbCh_S31Q1QOtSuh4XgM_BCssO1cy16VeKWgVEHJVz8oT88clq4oudDWn80VnaM6nV_bDc3Aay0nQAUli7Znx0Nfsc4",
    severity: "High Severity",
    severityColor: Color(0xFFB91C1C),
    severityBg: Color(0xFFFEE2E2),
    progress: 75,
    isCompleted: false,
  ),
  NearbyIssue(
    title: "Broken Streetlight at Junction",
    imageUrl:
    "https://lh3.googleusercontent.com/aida-public/AB6AXuD5QQZ-5CnmHqNDLfxx5qYxCvj5I1eAV9LYyCMAOwk8Ikx5WtGwFCUsEuOTdEJXNUYfv1BSRP7xyLPNSgR85k9PVG9kvuBrbXemPRGrN_kkIFs3vNGJvSl-JeitSZqjglVhsldUnySBepw3w789G8kBBhI70J3EsZMOWXdC0gYNCpvqgW1hr-AxOifsbi-mRSp8XaspkJUy1MP-XVYLDgfBrJvbuoQzrbrxM7qPXuyaNmvy9opfUrfYYGWy_Er_aUeMVJx6rnhekAg",
    severity: "Medium Severity",
    severityColor: Color(0xFF9A3412),
    severityBg: Color(0xFFFFEDD5),
    progress: 100,
    isCompleted: false,
  ),
  NearbyIssue(
    title: "Waste Overflow on Park St.",
    imageUrl:
    "https://lh3.googleusercontent.com/aida-public/AB6AXuAWgyHgXMJ-bL0LGURMCHZuAeCsETotFfuXY5hUsyzPznosi_3DqZqdB4uYP-dqnrIc73d5zWvA_jS7KRuHnsMgQoPugrkDdzSLtIZL5wHKUmS6QZW2C4Si8t9mI0dZjwS5uEcjaBbnKbAq-Sa6L1mUlhCVKSvg-EqqC1gLsoV_sqQesA206YnNC6GKjZoJgdrLXDarRnlypbIHFlVFi3HGaUtI1jjFjB6YZ7m6VgKDG5vrIYuNCe-aCx_B_o7G7vQSd55hsg_A6I4",
    severity: "Low Severity",
    severityColor: Color(0xFF92400E),
    severityBg: Color(0xFFFFF7E6),
    progress: 100,
    isCompleted: true,
  ),
];
