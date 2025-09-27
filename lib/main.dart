import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; 
import 'package:to_do_app/pages/splash.dart';
import 'package:to_do_app/providers/categorias.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';
import 'package:to_do_app/providers/persistencia/task.dart';
import 'package:to_do_app/providers/persistencia/user.dart';
import 'package:to_do_app/providers/tasks.dart';
import 'package:to_do_app/providers/users.dart'; 
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter()); 
  Hive.registerAdapter(CategoriaAdapter());
  Hive.registerAdapter(TaskAdapter());
  
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
        ChangeNotifierProvider(create: (context) => TaskProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To do App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashPage(),

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('pt', 'BR'),
        ],
        locale: const Locale('pt', 'BR'),
      ),
    );
  }
}
