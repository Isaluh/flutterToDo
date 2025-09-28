import 'package:flutter/material.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:to_do_app/pages/cadastro.dart';
import 'package:to_do_app/pages/login.dart';

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
      "image": "assets/images/icon_tasks.png", 
    },
    {
      "title": "Criar Rotinas",
      "description": "Estabeleça rotinas diárias para organizar sua vida.",
      "image": "assets/images/icon_routine.png", 
    },
    {
      "title": "Organizar Categorias",
      "description": "Agrupe suas tarefas em categorias específicas.",
      "image": "assets/images/icon_organizar.png", 
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
            top: 80,
            left: 20,
            child: GestureDetector(
              onTap: _finishOnboarding,
              child: Text(
                "Pular",
                style: TextStyle(fontSize: 16, color: Colors.white60),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage > 0 && _currentPage < _onboardingData.length - 1)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButtonComponent(onPressed: _previousPage, text: 'Voltar', color: Colors.white, textColor: Colors.black, fontSize: 14,),
                    ),
                  ),
                if (_currentPage < _onboardingData.length - 1)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButtonComponent(onPressed: _nextPage, text: 'Avançar', color: Colors.white, textColor: Colors.black, fontSize: 14,),
                    ),
                  ),
                if (_currentPage == _onboardingData.length - 1)
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButtonComponent(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage())), text: 'Login', color: Colors.white, textColor: Colors.black, minimumSize: Size(double.infinity, 40), fontSize: 14,),
                        SizedBox(height: 5),
                        ElevatedButtonComponent(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CadastroPage())), text: 'Cadastrar', minimumSize: Size(double.infinity, 40), fontSize: 14,),
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
