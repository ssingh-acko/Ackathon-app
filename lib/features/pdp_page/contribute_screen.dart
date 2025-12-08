import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContributeBottomSheet extends StatefulWidget {
  final double totalGoal;
  final double fundedAmount;

  const ContributeBottomSheet({
    super.key,
    required this.totalGoal,
    required this.fundedAmount,
  });

  @override
  State<ContributeBottomSheet> createState() => _ContributeBottomSheetState();
}

class _ContributeBottomSheetState extends State<ContributeBottomSheet> {
  double amount = 100;

  @override
  Widget build(BuildContext context) {
    double remaining = widget.totalGoal - widget.fundedAmount;
    double maxAmount = remaining < 100 ? 100 : remaining;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 5,
            width: 55,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(40)),
          ),

          Text(
            "Select Contribution Amount",
            style: GoogleFonts.publicSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "₹${amount.toInt()}",
            style: GoogleFonts.urbanist(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF6F3DFA),
            ),
          ),

          Slider(
            value: amount,
            min: 100,
            max: maxAmount,
            divisions: (maxAmount ~/ 100),
            activeColor: const Color(0xFF6F3DFA),
            onChanged: (v) {
              setState(() {
                amount = v;
              });
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F3DFA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                // TODO: integrate payment
                Navigator.pop(context);
              },
              child: Text(
                "Pay ₹${amount.toInt()}",
                style: GoogleFonts.publicSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
