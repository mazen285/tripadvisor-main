import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Restaurant Reservation Page.dart';
import 'confirmation.dart'; // Import ConfirmationScreen

class CategorySelectionScreen extends StatefulWidget {
  final String destination;

  const CategorySelectionScreen({Key? key, required this.destination})
      : super(key: key);

  @override
  _CategorySelectionScreenState createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  String selectedCategory = 'Hotel'; // Default category
  List<dynamic> places = []; // List to hold places (hotels or restaurants)
  bool isLoading = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  // Function to fetch places based on selected category
  Future<void> _fetchPlaces() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    final String category =
        selectedCategory == 'Hotel' ? 'hotel' : 'restaurant';
    final String location = widget.destination;

    try {
      // OpenStreetMap Nominatim API URL for hotel or restaurant search
      final String osmUrl =
          'https://nominatim.openstreetmap.org/search?q=$category+$location&format=json';

      final response = await http.get(Uri.parse(osmUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          places = data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to load places')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        backgroundColor: Colors.green[50],
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background4.jpg'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
          ),
          // Content on top of the background
          Column(
            children: [
              // Category Buttons
              Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCategoryButton('Hotel', Icons.hotel),
                    _buildCategoryButton('Restaurant', Icons.restaurant),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16.0)),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : hasError
                          ? _buildErrorUI()
                          : places.isEmpty
                              ? _buildEmptyUI()
                              : _buildPlacesList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category, IconData icon) {
    final isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
          _fetchPlaces();
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.black),
            SizedBox(width: 8.0),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesList() {
    return ListView.builder(
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        final displayName = place['display_name'] ?? 'No name';
        final split = displayName.split(',');
        final name = split[0];
        final address = split.length > 1
            ? split.sublist(1).join(', ')
            : 'Address not available';

        return ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: AssetImage('assets/restaurant.jpg'), // Placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          subtitle: Text(
            address,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReservationScreen(
                  destination: widget.destination,
                  restaurantName: name,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Error fetching data. Please try again.",
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchPlaces,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUI() {
    return Center(
      child: Text(
        "No places found.",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
