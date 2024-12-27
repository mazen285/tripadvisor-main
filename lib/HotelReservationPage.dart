import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelReservationPage extends StatefulWidget {
  @override
  _HotelReservationPageState createState() => _HotelReservationPageState();
}

class _HotelReservationPageState extends State<HotelReservationPage> {
  String? selectedHotel;
  String? selectedRoomType;
  Map<String, Map<String, dynamic>> roomAvailability = {}; // Includes price
  bool isLoading = false;

  DateTime? checkInDate;
  DateTime? checkOutDate;

  @override
  void initState() {
    super.initState();
    _fetchRoomAvailability();
  }

  // Fetch room availability and prices for all hotels
  Future<void> _fetchRoomAvailability() async {
    setState(() => isLoading = true);
    try {
      final snapshot = await FirebaseFirestore.instance.collection('hotels').get();
      final fetchedData = snapshot.docs.fold<Map<String, Map<String, dynamic>>>({}, (map, doc) {
        final data = doc.data();
        map[doc['name']] = {
          'Single': {
            'availability': int.tryParse(data['singleRooms'].toString()) ?? 0,
            'price': data['singleRoomPrice'] ?? 0,
          },
          'Double': {
            'availability': int.tryParse(data['doubleRooms'].toString()) ?? 0,
            'price': data['doubleRoomPrice'] ?? 0,
          },
          'Royal Suite': {
            'availability': int.tryParse(data['royalSuites'].toString()) ?? 0,
            'price': data['royalSuitePrice'] ?? 0,
          },
        };
        return map;
      });

      setState(() {
        roomAvailability = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching hotel data: $e')),
      );
    }
  }

  // Reserve the room
  Future<void> _makeReservation() async {
    if (selectedHotel == null || selectedRoomType == null || checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both a hotel, room type, and dates')),
      );
      return;
    }

    final roomDetails = roomAvailability[selectedHotel]?[selectedRoomType];
    if (roomDetails == null || roomDetails['availability'] <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No available rooms of this type')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Update availability in Firestore for the selected hotel
      await FirebaseFirestore.instance
          .collection('hotels')
          .doc(selectedHotel)
          .update({selectedRoomType!.toLowerCase() + 'Rooms': roomDetails['availability'] - 1});

      // Save reservation details in the 'test' collection
      await FirebaseFirestore.instance.collection('test').add({
        'hotel': selectedHotel,    // Save only the hotel name
        'roomType': selectedRoomType,  // Save only the room type
        'price': roomDetails['price'], // Save the room price
        'checkIn': checkInDate, // Save the check-in date
        'checkOut': checkOutDate, // Save the check-out date
        'timestamp': FieldValue.serverTimestamp(), // Add timestamp
      });

      setState(() {
        roomAvailability[selectedHotel]![selectedRoomType!] = {
          'availability': roomDetails['availability'] - 1,
          'price': roomDetails['price'],
        };
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation successful!')),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making reservation: $e')),
      );
    }
  }

  // Delete a reservation
  Future<void> _deleteReservation(String reservationId, String hotel, String roomType) async {
    setState(() => isLoading = true);

    try {
      // Delete reservation from the 'test' collection
      await FirebaseFirestore.instance.collection('test').doc(reservationId).delete();

      // Update room availability for the hotel
      final roomDetails = roomAvailability[hotel]?[roomType];
      if (roomDetails != null) {
        await FirebaseFirestore.instance
            .collection('hotels')
            .doc(hotel)
            .update({roomType.toLowerCase() + 'Rooms': roomDetails['availability'] + 1});

        setState(() {
          roomAvailability[hotel]![roomType] = {
            'availability': roomDetails['availability'] + 1,
            'price': roomDetails['price'],
          };
        });
      }

      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation deleted successfully!')),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting reservation: $e')),
      );
    }
  }

  // Build the list of reservations from the 'test' collection
  Widget _buildReservationList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('test').orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No reservations found'));
        }

        final reservations = snapshot.data!.docs;

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            final hotel = reservation['hotel'] ?? 'Unknown Hotel';
            final roomType = reservation['roomType'] ?? 'Unknown Room';
            final price = reservation['price'] ?? 0;
            final checkIn = reservation['checkIn']?.toDate() ?? DateTime.now();
            final checkOut = reservation['checkOut']?.toDate() ?? DateTime.now();

            return Card(
              child: ListTile(
                title: Text('Hotel: $hotel'),
                subtitle: Text(
                    'Room Type: $roomType\nPrice: \$${price.toString()}\nCheck-in: ${checkIn.toLocal()}\nCheck-out: ${checkOut.toLocal()}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteReservation(reservation.id, hotel, roomType),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Show Date Picker for Check-In and Check-Out
  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? DateTime.now();

    setState(() {
      if (isCheckIn) {
        checkInDate = picked;
      } else {
        checkOutDate = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Reservation'),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          DropdownButtonFormField<String>(
            value: selectedHotel,
            hint: Text('Select Hotel'),
            items: roomAvailability.keys.map((hotel) {
              return DropdownMenuItem(
                value: hotel,
                child: Text(hotel),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedHotel = value;
                selectedRoomType = null;
              });
            },
          ),
          if (selectedHotel != null) ...[
            DropdownButtonFormField<String>(
              value: selectedRoomType,
              hint: Text('Select Room Type'),
              items: roomAvailability[selectedHotel]!.keys.map((roomType) {
                return DropdownMenuItem(
                  value: roomType,
                  child: Text('$roomType (${roomAvailability[selectedHotel]![roomType]['availability']} available, \$${roomAvailability[selectedHotel]![roomType]['price']})'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoomType = value;
                });
              },
            ),
          ],
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context, true),
                child: Text(checkInDate == null ? 'Select Check-in Date' : 'Check-in: ${checkInDate!.toLocal()}'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context, false),
                child: Text(checkOutDate == null ? 'Select Check-out Date' : 'Check-out: ${checkOutDate!.toLocal()}'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _makeReservation,
            child: Text('Reserve'),
          ),
          Expanded(child: _buildReservationList()),
        ],
      ),
    );
  }
}
