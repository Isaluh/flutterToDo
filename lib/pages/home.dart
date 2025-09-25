import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/components/categoria_modal.dart';
import 'package:to_do_app/components/new_categoria_model.dart';
import 'package:to_do_app/pages/login.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showCategoryModal(BuildContext context, bool showButton) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalCategoria(
          buttonNewCategoria: showButton, 
          onPressedNewCategory: () => _showCreateCategoryModal(context),
          onEditCategory: (categoria) {
            _showCreateCategoryModal(context, categoria: categoria);
          },);
      },
    ).then((result) {
        if (!showButton && result is Categoria) {
            print('Categoria selecionada: ${result.name}');
        }
    });
  }

  void _showCreateCategoryModal(BuildContext context, {Categoria? categoria}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ModalCriarCategoria(
        categoriaParaEditar: categoria,
      );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.new_label_outlined, color: Colors.white),
          onPressed: () => _showCategoryModal(context, true),
        ),
        title: const Text(
          'To Do',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
              child: Text(
                "Nada ainda por aqui. \nCrie sua tarefa clicando no botão +",
                style: TextStyle(color: Colors.black87, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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
