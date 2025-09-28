import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:to_do_app/pages/home.dart';
import 'package:to_do_app/pages/login.dart';
import 'package:to_do_app/providers/categorias.dart';
import 'package:to_do_app/providers/tasks.dart';
import 'package:to_do_app/providers/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _cadastrar() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.trim() == "" ||
        password.trim() == "" ||
        confirmPassword == "") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Há campos em branco.')));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('As senhas não coincidem')));
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final categoriaProvider = Provider.of<CategoriaProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (userProvider.users.any((user) => user.username == username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Este nome de usuário já está em uso.')),
      );
      return;
    }

    userProvider.addUser(username, password);

    final success = userProvider.login(username, password);

    if (success) {
      final currentUserId = userProvider.currentUser!.id;
      
      categoriaProvider.loadCategoriasForUser(currentUserId);
      taskProvider.loadTasksForUser(currentUserId);
      
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao efetuar login automático.')),
      );
    }
  }

  void _goToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Center(
                child: Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              height:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height / 2.5,
              padding: EdgeInsets.all(20),
              color: Colors.white,
              child: Column(
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Usuário',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 15),
        
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 15),
        
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirmar Senha',
                      prefixIcon: Icon(Icons.lock_reset_rounded),
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButtonComponent(
                    onPressed: _cadastrar,
                    text: 'Cadastrar',
                    color: Colors.black,
                    textColor: Colors.white,
                    minimumSize: Size(double.infinity, 40),
                  ),
                  SizedBox(height: 20),
        
                  GestureDetector(
                    onTap: _goToLoginPage,
                    child: Text(
                      'Ja tem conta?',
                      style: TextStyle(fontSize: 16, color: Colors.black38),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
