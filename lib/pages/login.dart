import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:to_do_app/pages/home.dart';
import 'package:to_do_app/pages/cadastro.dart';
import 'package:to_do_app/providers/categorias.dart';
import 'package:to_do_app/providers/tasks.dart';
import 'package:to_do_app/providers/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if(username.trim() == '' || password.trim() == ''){
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Nome de usuário ou senha não podem ser vazios')));
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final categoriaProvider = Provider.of<CategoriaProvider>(context, listen: false);
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (userProvider.login(username, password)) {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Usuário ou senha inválidos')));
    }

  }

  Future<void> _authenticateWithBiometrics() async {
    bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
    bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

    if (!canAuthenticate) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Autenticação biométrica não suportada neste dispositivo.'),
      ));
      return;
    }

    bool isAuthenticated = false;
    try {
      isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Autentique-se para acessar o aplicativo',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Falha na autenticação biométrica.'),
      ));
    }
  }

  void _goToCadastroPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CadastroPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.white,
              height: MediaQuery.of(context).size.height / 2,
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
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: _authenticateWithBiometrics,
                    icon: Icon(Icons.fingerprint, color: Colors.black),
                    label: Text('Login com Biometria', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width - 20, 0),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButtonComponent(onPressed: _login, text: 'Entrar', color: Colors.black, textColor: Colors.white, minimumSize: Size(double.infinity, 40),),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _goToCadastroPage,
                    child: Text(
                      'Criar uma conta',
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
