import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      openPayment();
    });
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up Razorpay instance
    super.dispose();
  }

  void openPayment() {
    setState(() {
      isLoading = true;
    });

    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag', // Replace with your Razorpay key
      'amount': 10000, // Amount in paise (10000 = ₹100)
      'name': 'Civic Fix',
      'description': 'UPI Payment',
      'prefill': {
        'contact': '+916354072132',
        'email': 'alind.sharma@acko.tech',
        'mobile': '+916354072132',
        'phone': '+916354072132',
        'name': 'Alind Sharma',
        'upi_id': '6354072132@superyes',
        'upi_type': 'pay',
        'upi_name': 'Alind Sharma',
        'upi_address': '6354072132@superyes',
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
      'external': {
        'wallets': ['upi'], // Enable UPI payment method
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error opening Razorpay: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
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
