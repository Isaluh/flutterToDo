import 'package:flutter/material.dart';
import 'package:to_do_app/components/botoes.dart';
import 'dart:async';
import 'package:to_do_app/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/pages/on_boarding.dart';

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

  Future<void> _checkLoginStatus() async {
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
        MaterialPageRoute(builder: (context) => OnboardingPage()),
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
                    style: TextStyle(fontSize: 20, color: Colors.white54),
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
              child: ElevatedButtonComponent(onPressed: () => _checkLoginStatus(), text: 'Continuar', color: Colors.white, textColor: Colors.black,),
            ),
        ],
      ),
    );
  }
}
