import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, String> reservationDetails; // The reservation details

  const ProfileScreen({
    Key? key,
    required this.reservationDetails, // The reservation details
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String restaurant;
  late String date;
  late String time;
  late String people;
  late String profilePicPath;
  late String userName;

  @override
  void initState() {
    super.initState();

    // Initialize fields with reservation details, using default values if not provided
    restaurant = widget.reservationDetails['restaurant'] ?? 'Not Available';
    date = widget.reservationDetails['date'] ?? 'Not Available';
    time = widget.reservationDetails['time'] ?? 'Not Available';
    people = widget.reservationDetails['people'] ?? 'Not Available';
    profilePicPath = 'assets/profile_pic.jpg'; // Default profile picture path
    userName = widget.reservationDetails['userName'] ?? 'Guest'; // Default username if not provided
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display Profile Picture
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(profilePicPath),
              ),
            ),
            SizedBox(height: 20),

            // Display Username
            Text(
              'Username: $userName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Reservation Details Heading
            Text(
              'Reservation Details:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Restaurant Field (non-editable)
            TextFormField(
              initialValue: restaurant,
              decoration: InputDecoration(
                labelText: 'Restaurant',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Make it non-editable
            ),
            SizedBox(height: 10),

            // Date Field (non-editable)
            TextFormField(
              controller: TextEditingController(text: date),
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Make it non-editable
            ),
            SizedBox(height: 10),

            // Time Field (non-editable)
            TextFormField(
              controller: TextEditingController(text: time),
              decoration: InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Make it non-editable
            ),
            SizedBox(height: 10),

            // Number of People Field (non-editable)
            TextFormField(
              initialValue: people,
              decoration: InputDecoration(
                labelText: 'Number of People',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Make it non-editable
            ),
            SizedBox(height: 20),

            // Save Changes Button (Dummy for now)
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Profile updated successfully')),
                );
              },
              child: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
