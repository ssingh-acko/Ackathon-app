import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home_page/home.dart';
import '../oboarding/pages/screen.dart';
import '../vendor_page/vendor_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isLoading = false;

  Future<void> handleSignIn() async {
    setState(() => isLoading = true);

    final url = Uri.parse("http://3.109.152.78:8080/api/v1/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "phoneNumber": phoneController.text,
        }),
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

  goToOnboarding(){
    if(kIsWeb){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => VendorScreen()));
      return;
    }
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => OnboardingScreen()));
  }


  goToHomePage(){
    if(kIsWeb){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => VendorScreen()));
      return;
    }


    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HomeScreen(), settings: RouteSettings(name: 'HomeScreen'),), );
  }

  @override
  void initState() {
    checkIfGoHome();
    super.initState();
  }

  checkIfGoHome(){
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      final prefs = await SharedPreferences.getInstance();
      String? value = prefs.getString('userId');
      if(value != null){
        goToHomePage();
      }
    });
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
                )
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
