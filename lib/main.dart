import 'package:flutter/material.dart';

import 'features/incident_details/pothole_incident_details.dart';
import 'features/login/login_page.dart';
import 'features/oboarding/onboarding.dart';
import 'features/report_journey/pothole_journey/desc_step.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}