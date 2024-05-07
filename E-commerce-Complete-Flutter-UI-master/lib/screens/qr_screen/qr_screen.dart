import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  static const String routeName = "/payment";

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Uint8List _svgBytes = Uint8List(0); // Initialize _svgBytes
  late Timer _timer;
  int _secondsRemaining = 60;

  @override
  void initState() {
    super.initState();
    fetchQRImage();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void fetchQRImage() async {
    final response = await http.get(Uri.parse('https://upiqr.in/api/qr?name=Jaitra&vpa=jaitrav@okicici&amount=20.50'));
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          // Here you can cancel the payment or take any action
        }
      });
    });
  }

  String formatTimer(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
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
                  "Complete Your Payment",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              _svgBytes.isNotEmpty
                  ? SizedBox(
                width: 200,
                height: 200,
                child: SvgPicture.memory(
                  _svgBytes,
                  fit: BoxFit.contain,
                ),
              )
                  : CircularProgressIndicator(), // Loading indicator while waiting for response
              const SizedBox(height: 16),
              Text(
                'Time remaining: ${formatTimer(_secondsRemaining)}',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                child: Text("Cancel Payment"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

