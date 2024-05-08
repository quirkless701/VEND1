import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_receiver/sms_receiver.dart';

class PaymentScreen extends StatefulWidget {
  static const String routeName = "/payment";

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Uint8List _svgBytes = Uint8List(0); // Initialize _svgBytes
  late Timer _timer;
  int _secondsRemaining = 360;
  double totalAmount = 0.0; // Total amount variable
  String? _smsContent = 'Waiting for SMS...'; // SMS content variable
  SmsReceiver? _smsReceiver;

  @override
  void initState() {
    super.initState();
    calculateTotal(); // Call calculateTotal function
    fetchQRImage(totalAmount); // Pass the amount
    startTimer();
    _smsReceiver = SmsReceiver(onSmsReceived);
    _startListeningForSMS();
  }

  @override
  void dispose() {
    _timer.cancel();
    _smsReceiver?.stopListening();
    super.dispose();
  }

  void fetchQRImage(double amount) async {
    final url = Uri.parse('https://upiqr.in/api/qr');
    final response = await http.get(
      url.replace(queryParameters: {
        'name': 'Jaitra',
        'vpa': 'jaitrav@okicici',
        'amount': amount.toStringAsFixed(2), // Ensure the amount is formatted properly
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop(); // Close the dialog when tapping outside
          },
          child: AlertDialog(
            title: Text("Payment Cancelled"),
            content: Text("Your payment was cancelled."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                  Navigator.of(context).pop(); // Go back to the previous screen
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _startListeningForSMS() async {
    if (_smsReceiver == null) return;
    await _smsReceiver?.startListening();
    setState(() {
      _smsContent = 'Waiting for SMS...';
    });
  }

  void onSmsReceived(String? message) {
    if (message != null) {
      setState(() {
        _smsContent = message;
        if (_smsContent!.contains('Rs.') &&
            _smsContent!.contains('credited') &&
            _smsContent!.contains('linked to VPA')) {
          // Extract amount from the SMS and compare with totalAmount
          // If amount matches, process the payment
          _processPayment();
        }
      });
    }
  }

  void _processPayment() {
    // Your code to process the payment after reading the SMS
    // For example, send a signal to the ESP32 to turn the servo
    // This could be done using HTTP requests or other communication methods

    // Example of sending an HTTP request to the ESP32 with JSON payload
    String esp32Url = 'http://192.168.137.190/turn_servo'; // Replace with your ESP32 IP address and endpoint
    Map<String, dynamic> payload = {
      'quantity1': 3, // Example quantity for servo 1
      'quantity2': 2, // Example quantity for servo 2
    };
    http.post(Uri.parse(esp32Url), body: jsonEncode(payload)).then((response) {
      if (response.statusCode == 200) {
        // Successful response from ESP32
        print('Signal sent to ESP32 to turn servo');
      } else {
        // Handle error response from ESP32
        print('Error sending signal to ESP32');
      }
    }).catchError((error) {
      // Handle network error
      print('Network error: $error');
    });
  }

  void calculateTotal() {
    // Your code to calculate the total amount
    // Assume the total amount calculation is already implemented
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
              Text(
                'SMS Content: $_smsContent',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _cancelPayment(); // Cancel payment when cancel button is pressed
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
