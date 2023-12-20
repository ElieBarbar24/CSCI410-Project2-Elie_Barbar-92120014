import 'dart:async';


import 'package:flutter/material.dart';

class LaunchingPage extends StatelessWidget {
  const LaunchingPage({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed("LoginPage");
    });
    return const Scaffold(
      backgroundColor: Color(0xFF113953),
      body: Center(
        child: Text(
          'LOGO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
