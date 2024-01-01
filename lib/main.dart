
import 'package:connect/pages/Friends.dart';
import 'package:connect/pages/HomePage.dart';
import 'package:connect/pages/LaunchingPage.dart';
import 'package:connect/pages/LoginPage.dart';
import 'package:connect/pages/PendingRequests.dart';
import 'package:connect/pages/RegisterPage.dart';
import 'package:connect/pages/SearchFriends.dart';
import 'package:connect/pages/Setting.dart';
import 'package:flutter/material.dart';


void main() async {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF5F5F3),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0x000fffff),
            foregroundColor: Color(0xFF113953),
          )),
      routes: {
        "/": (context) => const LaunchingPage(),
        "homepage": (context) => const HomePage(),
        "setting":(context) =>  const Setting(),
        "searchFriends": (context) => const SearchFriends(),
        "RegisterPage": (context) => const RegisterPage(),
        "LoginPage": (context) => const LoginPage(),
        "Friends": (context) => const Friends(),
        "FriendsRequests": (context) => const PendingRequests(),
      },
    );
  }
}
