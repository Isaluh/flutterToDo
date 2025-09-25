import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:to_do_app/pages/splash.dart';
import 'package:to_do_app/providers/categorias.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';
import 'package:to_do_app/providers/persistencia/user.dart';
import 'package:to_do_app/providers/users.dart'; 
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter()); 
  Hive.registerAdapter(CategoriaAdapter());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(  
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()), 
        ChangeNotifierProvider(create: (context) => CategoriaProvider()), 
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
