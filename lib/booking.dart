import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _dateController = TextEditingController();
  int _guests = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Booking')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Selection
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Select Date'),
              readOnly: true,
              onTap: () {
                // Open date picker here
              },
            ),
            SizedBox(height: 20),

            // Number of Guests
            Row(
              children: [
                Text('Guests: $_guests'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _guests++;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (_guests > 1) _guests--;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Confirm Booking Button
            ElevatedButton(
              onPressed: () {
                // Implement booking logic, possibly an API call
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Booking confirmed!')),
                );
                Navigator.pop(context);
              },
              child: Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}
