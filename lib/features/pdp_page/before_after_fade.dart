import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeforeAfterFade extends StatefulWidget {
  final String beforeUrl;
  final String afterUrl;

  const BeforeAfterFade({
    required this.beforeUrl,
    required this.afterUrl,
  });

  @override
  State<BeforeAfterFade> createState() => _BeforeAfterFadeState();
}

class _BeforeAfterFadeState extends State<BeforeAfterFade>
    with SingleTickerProviderStateMixin {
  bool showAfter = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => showAfter = !showAfter),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // BEFORE IMAGE (fades out)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: showAfter ? 0 : 1,
              child: _buildImage(widget.beforeUrl),
            ),

            // AFTER IMAGE (fades in)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 600),
              opacity: showAfter ? 1 : 0,
              child: _buildImage(widget.afterUrl),
            ),

            // Labels (change dynamically)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  showAfter ? "After" : "Before",
                  style: GoogleFonts.publicSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),

            // Swipe icon (center)
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Icon(Icons.touch_app,
                      size: 32, color: Colors.white.withOpacity(0.8)),
                  Text(
                    "Tap to switch",
                    style: GoogleFonts.publicSans(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    return SizedBox(
      height: 260,
      width: double.infinity,
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }
}
