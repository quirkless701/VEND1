import 'dart:async';
import 'dart:typed_data';
import 'package:shop_app/screens/Dispense/dispense_screen.dart';
import '../../models/Cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:lottie/lottie.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = "/payment";

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Uint8List _svgBytes = Uint8List(0); // Initialize _svgBytes
  late Timer _timer;
  int _secondsRemaining = 360;
  double totalAmount = 0.0; // Total amount variable
  final _plugin = Readsms();
  String sms = 'no sms received';
  String sender = 'no sms received';
  String time = 'no sms received';
  bool isSmsValid = false; // Flag to track whether SMS is valid
  bool _isButtonsVisible = true;

  @override
  void initState() {
    super.initState();
    calculateTotal(); // Call calculateTotal function
    fetchQRImage(totalAmount); // Pass the amount
    startTimer();
    getPermission().then((value) {
      if (value) {
        _plugin.read();
        _plugin.smsStream.listen((event) {
          setState(() {
            sms = event.body;
            sender = event.sender;
            time = event.timeReceived.toString();

            print('Received SMS: $sms');
            print('From: $sender');
            print('Received at: $time');

            String orderTotalPattern = 'Rs\\.${totalAmount.toStringAsFixed(2)}';

            bool isCredited = RegExp(r'credited').hasMatch(sms);
            bool hasExactOrderTotal = RegExp(orderTotalPattern).hasMatch(sms);

            if (isCredited && hasExactOrderTotal) {
              print('SMS is valid');
              isSmsValid = true; // Set SMS valid flag to true
              fetchNewSvg(); // Fetch the new SVG
              _isButtonsVisible = false;
              _timer.cancel();
              _plugin.dispose();

              Future.delayed(const Duration(milliseconds: 2500), () {
                Navigator.pushNamed(context, DispensingMedicineScreen.routeName);
              });
            }
          });
        });
      }
    });
  }

  Future<bool> getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      if (await Permission.sms.request() == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
    _plugin.dispose();
  }

  void fetchQRImage(double amount) async {
    final url = Uri.parse('https://upiqr.in/api/qr');
    final response = await http.get(
      url.replace(queryParameters: {
        'name': 'Jaitra',
        'vpa': 'jaitrav@okicici',
        'amount': amount.toStringAsFixed(2),
        // Ensure the amount is formatted properly
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _svgBytes = response.bodyBytes;
      });
    } else {
      // Handle error
      print('Failed to load QR image: ${response.statusCode}');
    }
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _cancelPayment(); // Cancel payment when timer runs out
        }
      });
    });
  }

  void _cancelPayment() {
    _timer.cancel(); // Cancel the timer

    showDialog(
      context: context,
      barrierDismissible: true, // Allow tapping outside to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Payment Cancelled"),
          content: const Text("Your payment was cancelled."),
          actions: [
            TextButton(
              onPressed: () {
                _timer.cancel(); // Cancel the timer
                Navigator.of(context).popUntil(
                    ModalRoute.withName('/')); // Go back to the home screen
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void fetchNewSvg() {
    // Fetch new SVG here and update _svgBytes
    // Replace the following line with the logic to fetch the new SVG
    _svgBytes = Uint8List(0); // Set _svgBytes to empty
  }

  String formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Function to calculate the total amount
  void calculateTotal() {
    double total = 0.0;
    for (var cartItem in demoCarts) {
      total += cartItem.product.price * cartItem.numOfItem;
    }
    setState(() {
      totalAmount = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent popping if SMS is valid
        return !isSmsValid;
      },
      child: Scaffold(
        appBar: AppBar(
          title: isSmsValid ? null : const Text("cancel"),
          automaticallyImplyLeading: isSmsValid ? false : true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    isSmsValid ? "Payment Received" : "Complete Your Payment",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                isSmsValid
                    ? SizedBox(
                      width: 200, // Adjust width according to your need
                      height: 200, // Adjust height according to your need
                      child: Lottie.asset(
                        'assets/green_tick.json',
                        fit: BoxFit.contain,
                      ),
                    )
                    : _svgBytes.isNotEmpty
                    ? SizedBox(
                      width: 200,
                      height: 200,
                      child: SvgPicture.memory(
                        _svgBytes,
                        fit: BoxFit.contain,
                      ),
                    )
                    : const CircularProgressIndicator(),
                // Loading indicator while waiting for response
                const SizedBox(height: 16),
                isSmsValid ? const SizedBox() : Text(
                  'Time remaining: ${formatTimer(_secondsRemaining)}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 16),
                isSmsValid || !_isButtonsVisible
                    ? const SizedBox()
                    : ElevatedButton(
                  onPressed: () {
                    _cancelPayment(); // Cancel payment when cancel button is pressed
                  },
                  child: const Text("Cancel Payment"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
