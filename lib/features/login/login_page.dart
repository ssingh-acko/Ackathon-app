import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> handleSignIn() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://3.109.152.78:8080/api/v1/auth/login");

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

  Future<void> launchUPI({
    required String upiId,
    required String name,
    required int amount,
  }) async {
    final uri = Uri.parse("upi://pay?pa=$upiId&pn=$name&am=$amount&cu=INR");

    if (await canLaunchUrl(uri)) {
      _paymentInitiated = true;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "UPI apps not found!";
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkIfGoHome();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When app comes back to foreground after payment was initiated, close the app
    if (_paymentInitiated && state == AppLifecycleState.resumed) {
      SystemNavigator.pop();
    }
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
                // const SizedBox(height: 20),
                //
                // // Name Input
                // TextField(
                //   controller: nameController,
                //   decoration: InputDecoration(
                //     labelText: "Full Name",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),

                // Phone Input
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
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
                    onPressed: isLoading ? null : handleSignIn,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: navigateToPaymentPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7C3AED),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Open Payment page",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
