import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tela Principal')),
      body: Center(
        child: Text('Bem-vindo à HomePage!', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}