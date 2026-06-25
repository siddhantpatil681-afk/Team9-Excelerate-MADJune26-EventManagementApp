import 'package:flutter/material.dart';
import 'screens/login_signin.dart';
// ignore: unused_import
import 'screens/main_shell.dart';

void main() {
  runApp(const EventHubApp());
}


class EventHubApp extends StatelessWidget {
  const EventHubApp({super.key});

 @override
  Widget build(BuildContext context) {
    // Listen to the ThemeProvider changes
    

    return MaterialApp(
      title: 'Event App',
      themeMode: ThemeMode.dark,
      
      // LIGHT THEME CONFIGURATION
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7), // Light grey
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF5F5F7)),
        cardColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      
      // DARK THEME CONFIGURATION
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Your current black background
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0A0A0A)),
        cardColor: const Color(0xFF121212), // Your current card item color
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      
      home: const LoginScreen(),
    );
  }
}