import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/pages/cadastro.dart';
import 'package:to_do_app/pages/login.dart';
import 'home.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Gerenciar Tarefas",
      "description": "Crie, edite e marque tarefas como concluídas.",
      "image": "images/icon_tasks.png", 
    },
    {
      "title": "Criar Rotinas",
      "description": "Estabeleça rotinas diárias para organizar sua vida.",
      "image": "images/icon_routine.png", 
    },
    {
      "title": "Organizar Categorias",
      "description": "Agrupe suas tarefas em categorias específicas.",
      "image": "images/icon_organizar.png", 
    },
    {
      "title": "Bem vindo ao To Do",
      "description": "Vamos começar? Faça login ou crie a sua conta.",
      "image": "", 
    },
  ];

  void _finishOnboarding() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(_onboardingData[index]["image"]!.isNotEmpty)
                    Image.asset(
                      _onboardingData[index]["image"]!,
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 24),
                    Text(
                      _onboardingData[index]["title"]!,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _onboardingData[index]["description"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                  ],
                ),
              );
            },
          ),

          if(_currentPage != _onboardingData.length - 1)
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: _finishOnboarding,
              child: Text(
                "Pular",
                style: TextStyle(fontSize: 16, color: Colors.white54),
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0 && _currentPage < _onboardingData.length - 1)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: _previousPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Voltar", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                if (_currentPage < _onboardingData.length - 1)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("Avançar", style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                if (_currentPage == _onboardingData.length - 1)
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: Size(double.infinity, 40),
                          ),
                          child: Text("Login", style: TextStyle(color: Colors.black)),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CadastroPage()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 40),
                          ),
                          child: Text("Cadastrar", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
