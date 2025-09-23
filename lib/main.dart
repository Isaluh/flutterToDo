import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:to_do_app/pages/splash.dart';
import 'package:to_do_app/providers/users.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(  
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To do App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashPage(),
      ),
    );
  }
}
