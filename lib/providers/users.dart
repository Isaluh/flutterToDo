// O Provider ajuda a gerenciar o estado da sua aplicação e permite que você compartilhe objetos ou dados entre widgets sem precisar passar esses dados explicitamente de um widget para outro através de construtores.

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class User {
  String username;
  String password;

  User({required this.username, required this.password});
}

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  late Box<User> _userBox;

  UserProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _userBox = await Hive.openBox<User>('users');
    _users = _userBox.values.toList();
    
    if (_users.isEmpty) {
       final initialUser = User(username: 'admin', password: '12345');
       _userBox.add(initialUser);
       _users.add(initialUser);
    }
    
    notifyListeners();
  }

  List<User> get users => _users;

  void addUser(String username, String password) {
    final newUser = User(username: username, password: password);
    _userBox.add(newUser);
    _users.add(newUser);
    notifyListeners();
  }

  bool validateUser(String username, String password) {
    return _users.any((user) => user.username == username && user.password == password);
  }
}
