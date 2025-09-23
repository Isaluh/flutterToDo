import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/pages/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showCategoryModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850], 
          title: const Text(
            'Categorias',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10)
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.count(
                  shrinkWrap: true, 
                  crossAxisCount: 3, 
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: [
                    _buildCategoryIcon(Icons.shopping_bag, Colors.orange, 'Grocery'),
                    _buildCategoryIcon(Icons.work, Colors.blue, 'Work'),
                    _buildCategoryIcon(Icons.directions_run, Colors.green, 'Sport'),
                    _buildCategoryIcon(Icons.design_services, Colors.purple, 'Design'),
                    // _buildCategoryIcon(Icons.school, Colors.brown, 'University'),
                    // _buildCategoryIcon(Icons.campaign, Colors.pink, 'Social'),
                    // _buildCategoryIcon(Icons.music_note, Colors.cyan, 'Music'),
                    // _buildCategoryIcon(Icons.favorite, Colors.red, 'Health'),
                    // _buildCategoryIcon(Icons.movie, Colors.yellow, 'Movie'),
                    // _buildCategoryIcon(Icons.home, Colors.teal, 'Home'),
                    // _buildCategoryIcon(Icons.add_circle, Colors.grey, 'Create New', isNew: true),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    // ir pra tela de criar categoria
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Criar categoria',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(IconData icon, Color color, String label) {
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, 
        leading: IconButton(
          icon: const Icon(Icons.new_label_outlined, color: Colors.white),
          onPressed: () => _showCategoryModal(context),
        ),
        title: const Text(
          'To Do',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ),
        ),
        centerTitle: true, 
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/noTasks.png'),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Nada ainda por aqui. \nCrie sua tarefa clicando no botão +", style: TextStyle(color: Colors.black54), textAlign: TextAlign.center),
            )
          ],
        )
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                // Lógica para criar nova tarefa
              },
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              mini: true,
              child: const Icon(Icons.add, color: Colors.white), 
            ),
          ),
        ],
      ),
    );
  }
}
