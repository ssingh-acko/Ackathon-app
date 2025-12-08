import 'package:flutter/material.dart';
import 'package:flutter_upi_india/flutter_upi_india.dart';

class UpiPaymentBottomSheet extends StatefulWidget {
  const UpiPaymentBottomSheet({super.key});

  @override
  State<UpiPaymentBottomSheet> createState() => _UpiPaymentBottomSheetState();
}

class _UpiPaymentBottomSheetState extends State<UpiPaymentBottomSheet> {
  List<ApplicationMeta>? apps;

  @override
  void initState() {
    super.initState();
    _fetchUpiApps();
  }

  Future<void> _fetchUpiApps() async {
    apps = await UpiPay.getInstalledUpiApplications();
    setState(() {});
  }

  void _startTransaction(ApplicationMeta app) async {
    final response = await UpiPay.initiateTransaction(
      amount: '10.00',
      app: app.upiApplication,
      receiverName: 'Sharan',
      receiverUpiAddress: 'sharansingh00002@okaxis',
      transactionRef: '${DateTime.now().millisecondsSinceEpoch}',
      transactionNote: 'Test transaction',
      merchantCode: "asd"
    );
    print("Response");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => _upiAppsSheet(),
            );
          },
          child: const Text("Pay with UPI"),
        ),
      ),
    );
  }

  Widget _upiAppsSheet() {
    if (apps == null) {
      return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()));
    }

    if (apps!.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("No UPI apps installed"),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Choose UPI App",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...apps!.map((app) => ListTile(
            title: Text(app.upiApplication.appName),
            onTap: () {
              Navigator.pop(context);
              _startTransaction(app);
            },
          )),
        ],
      ),
    );
  }
}
