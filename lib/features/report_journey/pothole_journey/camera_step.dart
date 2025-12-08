import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'location_step.dart';

class ReportCameraStep extends StatefulWidget {
  const ReportCameraStep({super.key});

  @override
  State<ReportCameraStep> createState() =>
      _ReportCameraStepState();
}

class _ReportCameraStepState extends State<ReportCameraStep> {
  final List<File> _images = [];
  final picker = ImagePicker();

  // -------------------- IMAGE PICKER BOTTOM SHEET --------------------
  Future<void> _selectImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              ListTile(
                leading:
                const Icon(Icons.camera_alt, color: Color(0xFF6D38FF)),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked =
                  await picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    setState(() => _images.add(File(picked.path)));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library,
                    color: Color(0xFF6D38FF)),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);
                  final picked = await picker.pickMultiImage();
                  if (picked.isNotEmpty) {
                    setState(() {
                      _images.addAll(picked.map((e) => File(e.path)));
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF140F23) : const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // -------------------- TOP BAR --------------------
            Container(
              padding: const EdgeInsets.fromLTRB(0, 8, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back_ios_new, color: const Color(0xFF111111), size: 20,)),
                  // SizedBox(
                  //   width: 48,
                  //   height: 48,
                  //   child: Icon(Icons.arrow_back_ios_new,
                  //       size: 22,
                  //       color: isDark ? Colors.white : const Color(0xFF111111)),
                  // ),

                  // Title
                  Expanded(
                    child: Text(
                      "Step 1 of 2: Add Photos",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.publicSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                        isDark ? Colors.white : const Color(0xFF111111),
                      ),
                    ),
                  ),

                  // Skip
                  // SizedBox(
                  //   width: 48,
                  //   child: Center(
                  //     child: Text(
                  //       "Skip",
                  //       style: GoogleFonts.publicSans(
                  //         fontWeight: FontWeight.bold,
                  //         color: const Color(0xFF6D38FF),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // -------------------- PROGRESS BAR --------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6D38FF),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6D38FF).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 6),
                  // Expanded(
                  //   child: Container(
                  //     height: 4,
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xFF6D38FF).withOpacity(0.15),
                  //       borderRadius: BorderRadius.circular(50),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),

            // -------------------- INSTRUCTIONS --------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                "Add clear photos of the issue. You can take multiple shots for better clarity.",
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  color:
                  isDark ? Colors.grey[300] : const Color(0xFF5C5C5C),
                ),
              ),
            ),

            // -------------------- IMAGE GRID --------------------
            // -------------------- IMAGE GRID + INFO CARDS --------------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ---- IMAGE GRID ----
                    GridView.builder(
                      itemCount: _images.length + 1,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (context, index) {
                        if (index == _images.length) {
                          return GestureDetector(
                            onTap: _selectImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark ? Colors.grey.shade800 : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: const Center(
                                child: Icon(Icons.add_a_photo,
                                    color: Color(0xFF6D38FF), size: 32),
                              ),
                            ),
                          );
                        }

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _images[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () => setState(() => _images.removeAt(index)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.55),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: const Icon(Icons.close,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // -------------------- HOW IT WORKS CARD --------------------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.auto_awesome,
                                  color: Color(0xFF6D38FF), size: 26),
                              SizedBox(width: 8),
                              Text(
                                "How it works",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Upload multiple photos from different angles. "
                                "Our AI analyzes them to suggest the most accurate fix.",
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // -------------------- PHOTO GUIDELINES CARD --------------------
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[900] : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.photo_camera,
                                  color: Color(0xFF6D38FF), size: 26),
                              SizedBox(width: 8),
                              Text(
                                "Photo Guidelines",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          _ruleItem(
                            isDark,
                            "Capture the pothole from different angles (close-up, mid, far).",
                          ),
                          _ruleItem(
                            isDark,
                            "Zoom into the worst part of the damage.",
                          ),
                          _ruleItem(
                            isDark,
                            "Ensure photos are clear and taken in good lighting.",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),


            // -------------------- NEXT BUTTON --------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _images.isNotEmpty
                        ? const Color(0xFF6D38FF)
                        : const Color(0xFF6D38FF).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _images.isNotEmpty ? () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReportLocationStep(imagesList: _images)));
                  } : null,
                  child: Text(
                    "Next",
                    style: GoogleFonts.publicSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _ruleItem(bool isDark, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle,
              size: 18, color: Color(0xFF6D38FF)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
