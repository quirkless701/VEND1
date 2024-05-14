import 'package:flutter/material.dart';
import '../../models/Cart.dart';
import 'package:http/http.dart' as http;

class DispensingMedicineScreen extends StatefulWidget {
  static const String routeName = "/dispensing_medicine";

  const DispensingMedicineScreen({Key? key}) : super(key: key);

  @override
  _DispensingMedicineScreenState createState() =>
      _DispensingMedicineScreenState();
}

class _DispensingMedicineScreenState extends State<DispensingMedicineScreen> {
  int _totalQuantity = 0;
  final int _angle = 10;
  int _servoAngle = 0;
  String _displayText = "Please wait, your medicines are being dispensed";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTotalQuantity();
  }

  Future<void> _fetchTotalQuantity() async {
    // Calculate total quantity
    _totalQuantity = demoCarts.first.numOfItem;

    _servoAngle = _totalQuantity * _angle;
    // Send HTTP request
    await _sendHttpRequest(_servoAngle);
  }

  Future<void> _sendHttpRequest(int quantity) async {
    try {
      // Define your ESP32 server URL
      final url = Uri.http(
          '192.168.137.44', '/moveServo', {'angle': '$quantity'});

      // Make the POST request
      final response = await http.post(
        url,
        // You can pass any additional headers or body here if needed
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Request successful
        print('HTTP POST request successful');
        print('Response: ${response.body}');
        setState(() {
          _displayText = "Please collect your medicines";
          _isLoading = false; // Set isLoading to false
        });
      } else {
        // Request failed
        print( 'HTTP POST request failed with status code: ${response.statusCode}');
        setState(() {
          _isLoading = false; // Set isLoading to false even if request failed
        });
      }
    } catch (e) {
      // Handle errors
      print('Error: $e');
      setState(() {
        _isLoading = false; // Set isLoading to false if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null, // Null title
        automaticallyImplyLeading:
        false, // Hide the back button
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _displayText,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : const SizedBox(), // Render CircularProgressIndicator conditionally based on isLoading
            ],
          ),
        ),
      ),
    );
  }
}
