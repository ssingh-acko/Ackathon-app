import 'package:ackathon/features/login/login_page.dart';
import 'package:ackathon/features/oboarding/pages/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _naviagteToOnboarding();
    super.initState();
  }

  _naviagteToOnboarding(){
    Future.delayed(Duration(seconds: 1), (){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => LoginPage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF7A5CFF),
              Color(0xFF5D3FD3),
            ],
          ),
        ),
        child: Stack(
          children: [

            // --- ICON BG 1
            Positioned(
              left: -40,
              top: -20,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Symbols.road,
                  size: 200,
                  color: Color(0xFFF5F5F7),
                ),
              ),
            ),

            // --- ICON BG 2
            Positioned(
              right: -60,
              bottom: MediaQuery.of(context).size.height * 0.25,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Symbols.delete,
                  size: 250,
                  color: Color(0xFFF5F5F7),
                ),
              ),
            ),

            // --- ICON BG 3
            Positioned(
              left: 32,
              bottom: 32,
              child: Opacity(
                opacity: 0.10,
                child: Icon(
                  Symbols.construction,
                  size: 150,
                  color: Color(0xFFF5F5F7),
                ),
              ),
            ),

            // --- MAIN CONTENT
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Acko SafeHood",
                    style: GoogleFonts.publicSans(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Report. Fund. Fix.",
                    style: GoogleFonts.publicSans(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // // --- LOADING INDICATOR
            // Positioned(
            //   bottom: 50,
            //   left: 0,
            //   right: 0,
            //   child: Center(
            //     child: SizedBox(
            //       height: 32,
            //       width: 32,
            //       child: CircularProgressIndicator(
            //         color: Colors.white,
            //         strokeWidth: 2,
            //         strokeCap: StrokeCap.round,
            //       ),
            //     ),
            //   ),
            // ),

          ],
        ),
      ),
    );
  }
}