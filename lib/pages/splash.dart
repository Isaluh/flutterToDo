import 'package:flutter/material.dart';
import 'dart:async';
import 'package:to_do_app/pages/login.dart';
import 'package:to_do_app/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool buttonProxPage = false;

  @override
  void initState() {
    super.initState();
    _showButton();
  }

  void _showButton() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        buttonProxPage = true;
      });
    });
  }

  Future<void> _checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print(isLoggedIn);

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.checklist_rounded, size: 100, color: Colors.white),
                SizedBox(height: 15),
                Text(
                  "To Do",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 40,
                  child: Text(
                    "Lembre os seus futuros afazeres. Todo dia.",
                    style: TextStyle(fontSize: 20, color: Colors.white38),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          if (buttonProxPage)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () => _checkLoginStatus(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
