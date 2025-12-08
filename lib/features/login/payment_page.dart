import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  const PaymentPage({super.key, required this.amount});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isLoading = false;
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // Open payment automatically when page loads
    // Add a small delay to ensure widget is fully mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          openPayment();
        }
      });
    });
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up Razorpay instance
    super.dispose();
  }

  void openPayment() {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    // Base options common to both platforms
    var options = <String, dynamic>{
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
      'amount': (widget.amount * 100)
          .toInt(), // Amount in paise (convert from rupees)
      'name': 'Civic Fix',
      'description': 'Payment',
      'prefill': {
        'contact': '+916354072132',
        'email': 'alind.sharma@acko.tech',
        'name': 'Alind Sharma',
      },
      'theme': {
        //purple color
        'color': '#8B5CF6',
        'background': '#FFFFFF',
        'button': '#8B5CF6',
        'text': '#000000',
        'heading': '#000000',
        'subheading': '#000000',
        'body': '#000000',
        'caption': '#000000',
        'buttonText': '#FFFFFF',
      },
      'image':
          'https://acko-brand.ackoassets.com/brand/app-icon-transparent/horizontal-gradient.png',
    };

    // Add iOS-specific or Android-specific options
    if (Platform.isAndroid) {
      // Android-specific: Add UPI options
      options['description'] = 'UPI Payment';
      options['prefill'] = {
        'contact': '+916354072132',
        'email': 'alind.sharma@acko.tech',
        'mobile': '+916354072132',
        'phone': '+916354072132',
        'name': 'Alind Sharma',
        'upi_id': '6354072132@superyes',
        'upi_type': 'pay',
        'upi_name': 'Alind Sharma',
        'upi_address': '6354072132@superyes',
      };
      options['external'] = {
        'wallets': ['upi'], // Enable UPI payment method (Android only)
      };
    } else if (Platform.isIOS) {
      // iOS-specific: Remove UPI-specific options as they're not well supported
      options['description'] = 'Payment';
      // Don't include UPI-specific prefill fields on iOS
      // Don't include external wallets on iOS
    }

    try {
      debugPrint(
        'Opening Razorpay on ${Platform.isIOS ? "iOS" : "Android"} with amount: ${widget.amount} (${(widget.amount * 100).toInt()} paise)',
      );
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening payment: $e')));
      }
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    debugPrint('Payment Success: ${response.paymentId}');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment Successful'),
        backgroundColor: Colors.green,
      ),
    );
    // Optionally navigate back or to another page
    Navigator.of(context).pop();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    debugPrint('Payment Error: ${response.code} - ${response.message}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    debugPrint('External Wallet: ${response.walletName}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('External Wallet: ${response.walletName}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
      ),
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
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Opening payment gateway...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
        ),
      ),
    );
  }
}
