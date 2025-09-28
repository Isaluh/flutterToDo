// O Provider ajuda a gerenciar o estado da sua aplicação e permite que você compartilhe objetos ou dados entre widgets sem precisar passar esses dados explicitamente de um widget para outro através de construtores.

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/providers/persistencia/user.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  late Box<User> _userBox;

  User? _currentUser; 

  UserProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _userBox = await Hive.openBox<User>('users');
    _users = _userBox.values.toList();
    
    if (_users.isEmpty) {
      final initialUser = User.create(username: 'admin', password: '12345'); 
      _userBox.add(initialUser);
      _users.add(initialUser);
    }
    
    notifyListeners();
  }

  User? get currentUser => _currentUser;
  List<User> get users => _users;

  void addUser(String username, String password) {
    final newUser = User.create(username: username, password: password);
    _userBox.add(newUser);
    _users.add(newUser);
    notifyListeners();
  }

  bool login(String username, String password) {
    try {
      final user = _users.firstWhere(
        (user) => user.username == username && user.password == password,
        orElse: () => throw Exception('User not found or invalid credentials'), 
      );
      
      _currentUser = user;
      notifyListeners();
      return true;

    } catch (e) {
      _currentUser = null;
      notifyListeners();
      return false;
    }
  }
  
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
  
  bool validateUser(String username, String password) {
    return _users.any((user) => user.username == username && user.password == password);
  }
}
