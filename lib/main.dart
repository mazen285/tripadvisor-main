import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Import Firebase options
import 'signup.dart'; // SignUpScreen
import 'login.dart'; // LoginScreen
import 'dashboard_screen.dart'; // DashboardScreen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Firebase is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Use platform-specific Firebase options
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TripAdvisor Clone',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // Set initial screen as login
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/dashboard') {
          final args =
              settings.arguments as Map<String, dynamic>?; // Extract arguments

          if (args != null) {
            final username = args['username'] ?? 'Guest'; // Default to 'Guest'
            final reservationDetails =
                args['reservationDetails'] ?? {}; // Default to empty map
            final userId =
                args['userId']; // User ID passed from Login or Confirmation

            if (userId != null) {
              return MaterialPageRoute(
                builder: (context) => DashboardScreen(
                  username: username,
                  reservationDetails: reservationDetails,
                  userId: userId, // Pass userId to DashboardScreen
                ),
              );
            }
          }

          // Fallback in case of missing arguments
          return MaterialPageRoute(
            builder: (context) => DashboardScreen(
              username: 'Guest',
              reservationDetails: {},
              userId: '', // Default empty userId
            ),
          );
        }
        // Default route for undefined paths
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );
      },
    );
  }
}
