import 'package:flutter/material.dart';

class User {
  String username;
  String password;

  User({required this.username, required this.password});
}

class UserProvider with ChangeNotifier {
  final List<User> _users = [
    User(username: 'heloisa', password: '12345'),
  ];

  List<User> get users => _users;

  void addUser(String username, String password) {
    _users.add(User(username: username, password: password));
    notifyListeners();
  }

  bool validateUser(String username, String password) {
    return _users.any((user) => user.username == username && user.password == password);
  }
}
