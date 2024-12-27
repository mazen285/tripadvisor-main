import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'Payment Screen.dart';

class ReservationScreen extends StatefulWidget {
  final String restaurantName;
  final String destination;

  const ReservationScreen({
    Key? key,
    required this.restaurantName,
    required this.destination,
  }) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int numberOfPeople = 1;
  bool isLoading = false;

  // Function to select the date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to select the time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // Confirm navigation to Payment Screen
  void _confirmReservation(BuildContext context) async {
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (numberOfPeople < 1 || numberOfPeople > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Number of people must be between 1 and 20')),
      );
      return;
    }

    setState(() => isLoading = true);

    final reservationDetails = {
      'placeName': widget.restaurantName,
      'destination': widget.destination,
      'date': DateFormat('MMMM dd, yyyy').format(selectedDate!),
      'time': selectedTime!.format(context),
      'people': numberOfPeople.toString(),
    };

    // Simulate delay or perform an API call
    await Future.delayed(Duration(seconds: 2));

    setState(() => isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaymentScreen(reservationDetails: reservationDetails),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Do you want to discard your changes?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Yes'),
                  ),
                ],
              ),
            ) ??
            false;
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reservation at ${widget.restaurantName}'),
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
            Container(
              color: Colors.black.withOpacity(0.5),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Colors.white.withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Make your reservation at ${widget.restaurantName}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),

                            // Selected Date Display
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Selected Date:",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    selectedDate != null
                                        ? DateFormat('MMMM dd, yyyy')
                                            .format(selectedDate!)
                                        : 'Select Date',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            // Date Picker Button with Icon
                            ElevatedButton.icon(
                              onPressed: () => _selectDate(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: Icon(Icons.calendar_today,
                                  color: Colors.white),
                              label: Text(
                                'Pick Date',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Selected Time Display
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Selected Time:",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black54),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    selectedTime != null
                                        ? selectedTime!.format(context)
                                        : 'Select Time',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            // Time Picker Button with Icon
                            ElevatedButton.icon(
                              onPressed: () => _selectTime(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon:
                                  Icon(Icons.access_time, color: Colors.white),
                              label: Text(
                                'Pick Time',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),

                            SizedBox(height: 20),

                            // Number of People
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Number of People:",
                                    style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    IconButton(
                                      icon:
                                          Icon(Icons.remove, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          if (numberOfPeople > 1)
                                            numberOfPeople--;
                                        });
                                      },
                                    ),
                                    Text('$numberOfPeople',
                                        style: TextStyle(fontSize: 20)),
                                    IconButton(
                                      icon:
                                          Icon(Icons.add, color: Colors.green),
                                      onPressed: () {
                                        setState(() {
                                          if (numberOfPeople < 20)
                                            numberOfPeople++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: () => _confirmReservation(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 15),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      'Confirm Reservation',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
