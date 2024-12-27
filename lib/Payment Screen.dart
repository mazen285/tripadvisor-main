import 'package:flutter/material.dart';
import 'confirmation.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> reservationDetails;

  const PaymentScreen({Key? key, required this.reservationDetails})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  String paymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    // Extract details and provide defaults if necessary
    final String placeName =
        widget.reservationDetails['placeName'] ?? 'Unknown Place';
    final String destination =
        widget.reservationDetails['destination'] ?? 'Unknown Destination';
    final String date = widget.reservationDetails['date'] ?? 'Unknown Date';
    final String time = widget.reservationDetails['time'] ?? 'Unknown Time';
    final String people = widget.reservationDetails['people'] ?? '1';

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green[50],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay for darkening the background
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reservation Summary
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reservation Summary',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Place Name: $placeName',
                            style: TextStyle(fontSize: 16)),
                        Text('Destination: $destination',
                            style: TextStyle(fontSize: 16)),
                        Text('Date: $date', style: TextStyle(fontSize: 16)),
                        Text('Time: $time', style: TextStyle(fontSize: 16)),
                        Text('Number of People: $people',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Credit Card Image
                  Center(
                    child: Image.asset(
                      'assets/creditcard.png',
                      height: screenHeight * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Payment Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildDropdownField(),
                        SizedBox(height: 20),
                        _buildTextField('Card Number', Icons.credit_card,
                            TextInputType.number, (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 16) {
                            return 'Please enter a valid card number';
                          }
                          return null;
                        }),
                        SizedBox(height: 20),
                        _buildTextField(
                            'Expiry Date (MM/YY)',
                            Icons.calendar_today,
                            TextInputType.datetime, (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$')
                                  .hasMatch(value)) {
                            return 'Please enter a valid expiry date';
                          }
                          return null;
                        }),
                        SizedBox(height: 20),
                        _buildTextField('CVV', Icons.lock, TextInputType.number,
                            (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length != 3) {
                            return 'Please enter a valid CVV';
                          }
                          return null;
                        }, isPassword: true),
                      ],
                    ),
                  ),

                  SizedBox(height: 30),

                  // Confirm Payment Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) =>
                              Center(child: CircularProgressIndicator()),
                        );

                        // Simulate payment processing delay
                        await Future.delayed(Duration(seconds: 2));

                        // Close loading indicator and navigate to ConfirmationScreen
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmationScreen(
                              reservationDetails: widget.reservationDetails,
                              destination: destination,
                              placeName: placeName,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please fill in all fields correctly')),
                        );
                      }
                    },
                    child: Text(
                      'Confirm Payment',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: paymentMethod,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      items: [
        DropdownMenuItem(value: 'Credit Card', child: Text('Credit Card')),
        DropdownMenuItem(value: 'PayPal', child: Text('PayPal')),
      ],
      onChanged: (value) {
        setState(() {
          paymentMethod = value!;
        });
      },
    );
  }

  Widget _buildTextField(String hintText, IconData icon,
      TextInputType inputType, String? Function(String?) validator,
      {bool isPassword = false}) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: isPassword,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
