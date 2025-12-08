import 'package:flutter/material.dart';

class BeforeAfterImage {
  final String beforeUrl;
  final String afterUrl;

  BeforeAfterImage({
    required this.beforeUrl,
    required this.afterUrl,
  });
}

class CrowdfundProgress {
  final double percent; // 0.0 to 1.0
  final int raised;
  final int goal;

  CrowdfundProgress({
    required this.percent,
    required this.raised,
    required this.goal,
  });
}

class CrowdfundMission {
  final String missionTitle;
  final BeforeAfterImage images;

  final int aiBudget;
  final String aiEta;

  final int seedRequired;
  final int seedPercent; // 10%

  CrowdfundMission({
    required this.missionTitle,
    required this.images,
    required this.aiBudget,
    required this.aiEta,
    required this.seedRequired,
    required this.seedPercent,
  });
}
