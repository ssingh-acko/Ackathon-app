import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../incident_details/cubit.dart';
import '../login/payment_page.dart';
import '../pdp_page/generic_view.dart';
import 'broadcast_group.dart';

class CrowdfundMissionPage extends StatefulWidget {
  final IncidentReport data;

  const CrowdfundMissionPage({super.key, required this.data});

  @override
  State<CrowdfundMissionPage> createState() => _CrowdfundMissionPageState();
}

class _CrowdfundMissionPageState extends State<CrowdfundMissionPage> {
  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // AI Budget from API
    final aiBudget = d.ai?.estimatedBudget?.toDouble() ?? 0;
    final seedRequired = (aiBudget * 0.10).round(); // 10%

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF140F23)
          : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            //------------------------------ TOP BAR ------------------------------
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF140F23) : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 24),
                  ),
                  // Expanded(
                  //   child: Text(
                  //     "Mission: Fix Pothole",
                  //     textAlign: TextAlign.center,
                  //     style: GoogleFonts.publicSans(
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 24),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //------------------- SINGLE IMAGE FROM INCIDENT -------------------
                    Container(
                      height: 260,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            d.imageUrls.isNotEmpty
                                ? d.imageUrls.first
                                : "https://via.placeholder.com/600x300",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //------------------- TITLE -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Text(
                        d.title.toUpperCase(),
                        style: GoogleFonts.publicSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    //------------------- AI BUDGET ONLY -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildAiCard(
                        "AI Estimated Budget",
                        aiBudget == 0 ? "N/A" : "₹${aiBudget.round()}",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6F42C1).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SvgPicture.asset('assets/acko.svg', height: 18, color: Color(0xFF6F42C1),),
                            // Icon(
                            //   Icons.rocket_launch,
                            //   color: const Color(0xFF6F42C1),
                            // ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Acko Customers Double the Impact",
                                    style: GoogleFonts.publicSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: const Color(0xFF6F42C1),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "As an Acko customer, every rupee you give can be doubled by the Acko CSR fund—unlock matching support and fix this blackspot faster for all of HSR.",
                                    style: GoogleFonts.publicSans(
                                      fontSize: 14,
                                      color: const Color(0xFF6F42C1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    //------------------- SEED CAPITAL (10% of budget) -------------------
                    if (aiBudget > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6F42C1).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.rocket_launch,
                                color: const Color(0xFF6F42C1),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Your Seed Capital is Required",
                                      style: GoogleFonts.publicSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: const Color(0xFF6F42C1),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "To launch this mission, contribute 10% (₹$seedRequired). "
                                      "This shows commitment and boosts community funding.",
                                      style: GoogleFonts.publicSans(
                                        fontSize: 14,
                                        color: const Color(0xFF6F42C1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    //------------------- BROADCAST GROUPS -------------------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BroadcastGroupCard(groups: dummyBroadcastGroups),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            //------------------- BOTTOM CTA -------------------
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF140F23) : Colors.white,
                border: Border(
                  top: BorderSide(
                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  ),
                ),
              ),
              child: SizedBox(
                height: 55,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Dio dio = Dio();
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    final response = await dio.post(
                      'http://3.109.152.78:8080/api/v1/crowdfunding/campaigns',
                      options: Options(
                        headers: {
                          'X-User-Id': sharedPreferences.getString("userId"),
                          'Content-Type': 'application/json',
                        },
                      ),
                      data: {
                        "issueId": widget.data.id,
                        "amountRequired": aiBudget.round().toInt(),
                        "endDate": DateFormat(
                          "yyyy-MM-dd",
                        ).format(DateTime.now().add(Duration(days: 14))),
                      },
                    );

                    final seedAmount = (aiBudget / 10).round();
                    final url =
                        "http://3.109.152.78:8080/api/v1/crowdfunding/campaigns/${response.data["data"]["id"]}/contribute";

                    SharedPreferences sharedPrefs =
                        await SharedPreferences.getInstance();

                    final orderResponse = await dio.post(
                      url,
                      data: {"contributionAmount": seedAmount},
                      options: Options(
                        headers: {
                          "X-User-Id": sharedPrefs.getString("userId"),
                          "Content-Type": "application/json",
                        },
                      ),
                    );

                    String orderId = orderResponse.data["data"]["orderId"];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentPage(
                          amount: seedAmount + 0.0,
                          orderId: orderId,
                        ),
                      ),
                    ).then((response) {
                      if (response != null && response["status"]) {
                        updatePaymentStatus(response);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) =>
                                MissionFundingParent(issueId: widget.data.id),
                          ),
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F42C1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Contribute & Launch Mission",
                    style: GoogleFonts.publicSans(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  updatePaymentStatus(data) async {
    final status = data["status"];
    final amount = data["amount"];
    final orderId = data["orderId"];

    final dio = Dio();

    final url = "http://3.109.152.78:8080/api/v1/payments/orders/status";

    final response = await dio.post(
      url,
      options: Options(headers: {"Content-Type": "application/json"}),
      data: {"razorpayOrderId": orderId, "status": status ? "PAID" : "FAILED"},
    );

    return response;
  }

  //------------------- small reusable card -------------------
  Widget _buildAiCard(String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
