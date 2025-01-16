import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo_api/views/homeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 74, 173),
      body: Center(
        child: Column(
          children: [
            // Corrected path for the asset
            Image.asset(
              'images/todo_api_splashscreen.png',
              height: 800,
            ),
          ],
        ),
      ),
    );
  }
}
