import 'package:ackathon/features/funding_hero/funding_hero_page.dart';
import 'package:ackathon/features/ai_solutions/ai_solutions_page.dart';
import 'package:ackathon/shared/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../home_page/home.dart';
import '../oboarding/pages/screen.dart';
import '../vendor_page/vendor_page.dart';
import 'payment_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;
  bool _paymentInitiated = false;

  @override
  void initState() {
    super.initState();
    // Add listeners to update button state when text changes
    nameController.addListener(_updateButtonState);
    phoneController.addListener(_updateButtonState);
    checkIfGoHome();
  }

  @override
  void dispose() {
    nameController.removeListener(_updateButtonState);
    phoneController.removeListener(_updateButtonState);
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {}); // Rebuild to update button state
  }

  bool get _isFormValid {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    return name.isNotEmpty && phone.length == 10;
  }

  Future<void> handleSignIn() async {
    setState(() => isLoading = true);

    final url = Uri.parse("${AppConstants.apiUrl}/api/v1/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phoneNumber": phoneController.text}),
      );

      final data = jsonDecode(response.body);
      debugPrint("Login Response: $data");
      await saveUserId(data['data']['userId']);
      goToOnboarding();
    } catch (e) {
      debugPrint("Login Error: $e");
    }

    setState(() => isLoading = false);
  }

  Future<void> saveUserId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
  }

  goToOnboarding() {
    if (kIsWeb) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => VendorScreen()),
      );
      return;
    }
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  goToHomePage() {
    if (kIsWeb) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => VendorScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeScreen(),
        settings: RouteSettings(name: 'HomeScreen'),
      ),
    );
  }

  checkIfGoHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString('userId');
      if (value != null) {
        goToHomePage();
      }
    });
  }

  void navigateToPaymentPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentPage()),
    );
  }

  void navigateToFundingHeroPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FundingHeroPage()),
    );
  }

  void navigateToAISolutionsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AISolutionsPage()),
    );
  }

  final _formKey = GlobalKey<FormState>();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  //
                  // // Name Input
                  TextFormField(
                    controller: nameController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                    ],
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Phone Input
                  TextFormField(
                    controller: phoneController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (value.length != 10) {
                        return 'Phone number must be 10 digits';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: (isLoading || !_isFormValid)
                          ? null
                          : handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid && !isLoading
                            ? const Color(0xFF7C3AED)
                            : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  // const SizedBox(height: 24),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: navigateToPaymentPage,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF7C3AED),
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "Open Payment page",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 24),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: navigateToFundingHeroPage,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF7C3AED),
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "Open Funding Hero page",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 24),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: navigateToAISolutionsPage,
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: const Color(0xFF7C3AED),
                  //       padding: const EdgeInsets.symmetric(vertical: 14),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(16),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       "Open AI Solutions page",
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
