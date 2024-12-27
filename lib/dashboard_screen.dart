import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'ProfileScreen.dart';
import 'CategorySelection.dart';
import 'HotelReservationPage.dart'; // Import the new page

class DashboardScreen extends StatefulWidget {
  final String username; // Accepting username parameter
  final String userId; // Accepting userId parameter
  final Map<String, String> reservationDetails; // Accepting reservation details

  const DashboardScreen({
    Key? key,
    required this.username,
    required this.userId,
    required this.reservationDetails,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? selectedDestination;
  List<String> destinations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDestinations(); // Fetch destinations from Firestore
  }

  Future<void> fetchDestinations() async {
    try {
      final snapshot =
      await FirebaseFirestore.instance.collection('destination').get();
      if (snapshot.docs.isNotEmpty) {
        final fetchedDestinations =
        snapshot.docs.map((doc) => doc['name'] as String).toList();
        setState(() {
          destinations = fetchedDestinations;
          isLoading = false; // Stop loading spinner
        });
      } else {
        setState(() {
          destinations = [];
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No destinations found in the database!')),
        );
      }
    } catch (e) {
      print("Error fetching destinations: $e");
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('Error fetching destinations. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.green[50],
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(
                  reservationDetails: {
                    'user': widget.username,
                    ...widget.reservationDetails,
                  },
                ),
              ),
            );
          },
          child: Icon(
            Icons.account_circle,
            size: 30,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/background4.jpg'), // Replace with the path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${widget.username}!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : destinations.isEmpty
                    ? Center(
                  child: Text(
                    'No destinations available.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
                    : _buildDestinationDropdown(),
                SizedBox(height: 20),
                _buildConfirmButton(),
                SizedBox(height: 20),
                Text(
                  'Reservation Details:',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 10),
                _buildReservationList(),
                SizedBox(height: 20),
                // Button to navigate to the new page
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.blueGrey),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelReservationPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Go to Hotel Reservation Page',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to logout: $e')),
            );
          }
        },
        child: Icon(Icons.exit_to_app),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildDestinationDropdown() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedDestination,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        ),
        hint:
        Text('Select a Destination', style: TextStyle(color: Colors.grey)),
        items: destinations.map((destination) {
          return DropdownMenuItem(
            value: destination,
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.black),
                SizedBox(width: 10),
                Text(destination),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedDestination = value;
          });
        },
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green[50]),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 12, horizontal: 20)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      onPressed: () {
        if (selectedDestination == null || selectedDestination!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select a destination!')),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CategorySelectionScreen(destination: selectedDestination!),
          ),
        );
      },
      child: Text(
        'Confirm Destination',
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
    );
  }

  Widget _buildReservationList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .collection('reservations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No reservations found.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final reservation = reservations[index];
              return Card(
                child: ListTile(
                  title: Text('Destination: ${reservation['destination']}'),
                  subtitle: Text(
                    'Place: ${reservation['placeName']}\n'
                        'Date: ${reservation['date']}\n'
                        'Time: ${reservation['time']}\n'
                        'People: ${reservation['people']}',
                  ),
                  trailing: Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
