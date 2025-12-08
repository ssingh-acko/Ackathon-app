import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final TextEditingController bidController = TextEditingController();
  final TextEditingController valuePropController = TextEditingController();
  final TextEditingController whyUsController = TextEditingController();

  String selectedMaterial = "Asphalt Mix";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF140F23)
          : const Color(0xFFF6F5F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProjectDetailsCard(),
                    _buildStats(),
                    _sectionTitle("Your Proposal"),
                    _inputBid(),
                    _inputMaterial(),
                    _inputValueProp(),
                    _inputWhyUs(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _stickyCTA(),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP APP BAR
  // ---------------------------------------------------------------------------
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF140F23)
            : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Invitation to Bid",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF131118),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Icon(
              Icons.close,
              size: 26,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF131118),
            ),
          )
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROJECT DETAILS CARD + IMAGES
  // ---------------------------------------------------------------------------
  Widget _buildProjectDetailsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C1A20)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(blurRadius: 4, spreadRadius: 1, color: Colors.black12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pothole Fix: Elm Street",
            style: GoogleFonts.publicSans(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF131118),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Project ID: #P78-A12",
            style: GoogleFonts.publicSans(
              fontSize: 14,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey
                  : const Color(0xFF6B5F8C),
            ),
          ),
          const SizedBox(height: 12),
          _imageCarousel(),
        ],
      ),
    );
  }

  Widget _imageCarousel() {
    final List<String> images = [
      "https://lh3.googleusercontent.com/aida-public/AB6AXuCisiEEJ8DrtH5S1C9-H-CCwT6a9ctlcT_pPexud9Zo6eLPVOCO11Nnqqo-y1llHW3AyPfAnCNcqmskh3dx_vM3EJ7Pv7NTIazLB8w62f3HAqxa9D6mwnnRMqU5E725mXYZLTbdBZiNixDOX9G0ymyWmLp7BWT-lIlCkRj8dpfMa54A8888pMvboKJ4h9wAR06-x-yC4aSTn0A2AKNYNQjlo8jYEeuehS-Lx7BRG0l066ukdLgBqwope1X4LQEnS4Ligd9pmCiAaYs",
      "https://lh3.googleusercontent.com/aida-public/AB6AXuCMkIm-NFL57ix2LY6tTfRt5q866FBNcTOmj6k0bg5V0DlXBH-2wGjH7aLsUpLw9kHYhP1pwJVuhS-LeNTsceSURXPpK000QwLKxICFM9Q4kB-5CSPmUyQdbmuXphSFu27mMWRDXpto8SweUQi-xK76YQLTLffEqerwGUmry406BdspA5QEkvwFCPXU4xOgYrvz9ECvwao2LIpcynP5uM7-fPV6Cb1glX44XPDp92PqT4-Vaoqw0G3-K61LYw10P0yPFFFlK5t6xA0",
      "https://lh3.googleusercontent.com/aida-public/AB6AXuC54GsxIKSx18QFnC--KipO5Bl85UugObYrYZn1JnC81fTqtu2NGr6fwbmzdtarFBgV5pH8EY3CiEU2yNRbu03FGAE8qI8FvEM0rYvPqIjQvCMxSB3xkKwgqK15J13iHSXZ8SZYYPq_OZ73ksmqg5bdOdZ3FiQm30teyKA1c3IFOMKnyVgl8W8Soi6AOHCY8VmxbUK36hRVoVfVG-ArlaPJ30Bcp_nrbSwb8uSr3hUnk_qTXLD352DugVxAsDkPKvz60XOcOHlRLY4",
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: images.length,
        itemBuilder: (_, i) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              images[i],
              width: 260,
              height: 180,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATS ROW
  // ---------------------------------------------------------------------------
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _statCard("Estimated Time to Fix", "4 Hours"),
          const SizedBox(width: 12),
          _statCard("AI Cost Estimate", "\$550.00"),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF140F23)
              : const Color(0xFFF6F5F8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.publicSans(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey
                        : const Color(0xFF6B5F8C))),
            const SizedBox(height: 4),
            Text(value,
                style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF131118),
                )),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INPUT SECTIONS
  // ---------------------------------------------------------------------------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Text(
        title,
        style: GoogleFonts.publicSans(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF131118),
        ),
      ),
    );
  }

  Widget _inputBid() {
    return _inputWrapper(
      label: "Your Bid Amount (\$)",
      child: TextField(
        controller: bidController,
        keyboardType: TextInputType.number,
        decoration: _inputDecoration("Enter your total bid amount"),
      ),
    );
  }

  Widget _inputMaterial() {
    return _inputWrapper(
      label: "Primary Material",
      child: DropdownButtonFormField<String>(
        value: selectedMaterial,
        items: const [
          DropdownMenuItem(value: "Asphalt Mix", child: Text("Asphalt Mix")),
          DropdownMenuItem(
              value: "Recycled Aggregate", child: Text("Recycled Aggregate")),
          DropdownMenuItem(value: "Concrete", child: Text("Concrete")),
          DropdownMenuItem(value: "Other", child: Text("Other")),
        ],
        onChanged: (val) => setState(() => selectedMaterial = val!),
        decoration: _inputDecoration(""),
      ),
    );
  }

  Widget _inputValueProp() {
    return _inputWrapper(
      label: "Your Value Proposition",
      child: TextField(
        maxLines: 4,
        controller: valuePropController,
        decoration: _inputDecoration("e.g., We offer a 5-year warranty..."),
      ),
    );
  }

  Widget _inputWhyUs() {
    return _inputWrapper(
      label: "Why Choose Your Team?",
      child: TextField(
        maxLines: 4,
        controller: whyUsController,
        decoration: _inputDecoration("Explain your experience..."),
      ),
    );
  }

  Widget _inputWrapper({required String label, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.publicSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade300
                    : const Color(0xFF131118),
              )),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: dark ? const Color(0xFF1C1A20) : Colors.white,
      hintStyle: TextStyle(color: dark ? Colors.grey : const Color(0xFF6B5F8C)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
        BorderSide(color: dark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide:
        BorderSide(color: Colors.deepPurpleAccent.withOpacity(0.7), width: 2),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STICKY CTA
  // ---------------------------------------------------------------------------
  Widget _stickyCTA() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1C1A20)
            : Colors.white,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
          ),
        ),
      ),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F3DFA),
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          "Submit Bid",
          style: GoogleFonts.publicSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
