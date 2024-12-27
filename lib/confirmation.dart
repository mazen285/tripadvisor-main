import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  final String destination;
  final Map<String, String> reservationDetails;
  final String placeName;

  const ConfirmationScreen({
    required this.destination,
    required this.reservationDetails,
    required this.placeName,
    Key? key,
  }) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  late ConfettiController _confettiController;
  double _scale = 1.0;
  final TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _scaleButton(bool isPressed) {
    setState(() {
      _scale = isPressed ? 0.95 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String date = widget.reservationDetails['date'] ?? 'Not Selected';
    String time = widget.reservationDetails['time'] ?? 'Not Selected';
    String numberOfPeople = widget.reservationDetails['people'] ?? '1';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: Colors.green[50],
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background4.jpg'), // Ensure this image exists
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 10,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Reservation Summary',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(Icons.location_on, 'Destination',
                              widget.destination),
                          _buildInfoRow(
                              Icons.place, 'Place Name', widget.placeName),
                          _buildInfoRow(Icons.calendar_today, 'Date', date),
                          _buildInfoRow(Icons.access_time, 'Time', time),
                          _buildInfoRow(
                              Icons.group, 'Number of People', numberOfPeople),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Enter Your Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: GestureDetector(
                              onTapDown: (_) => _scaleButton(true),
                              onTapUp: (_) => _scaleButton(false),
                              onTapCancel: () => _scaleButton(false),
                              child: AnimatedScale(
                                scale: _scale,
                                duration: const Duration(milliseconds: 100),
                                curve: Curves.easeInOut,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_usernameController.text
                                        .trim()
                                        .isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please enter your name!')),
                                      );
                                      return;
                                    }
                                    _confettiController.play();
                                    saveReservationDetails(
                                        _usernameController.text.trim());
                                    _showConfirmationDialog(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 15),
                                  ),
                                  child: const Text(
                                    'Confirm Reservation',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      colors: const [Colors.blue, Colors.green, Colors.yellow],
                      numberOfParticles: 30,
                      shouldLoop: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to confirm!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.blue,
            ),
            const SizedBox(height: 10),
            const Text(
              'Confirmed.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'See you soon!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                    username: _usernameController.text.trim(),
                    reservationDetails: widget.reservationDetails,
                    userId: user.uid,
                  ),
                ),
              );
            },
            child: const Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void saveReservationDetails(String username) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You must be logged in to save reservations!')),
      );
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .collection('reservations')
          .add({
        'username': username,
        'destination': widget.destination,
        'placeName': widget.placeName,
        'date': widget.reservationDetails['date'] ?? 'Not Selected',
        'time': widget.reservationDetails['time'] ?? 'Not Selected',
        'people': widget.reservationDetails['people'] ?? '1',
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Reservation details saved successfully!');
    } catch (e) {
      print('Error saving reservation details: $e');
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to save data: $e'),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }
}
