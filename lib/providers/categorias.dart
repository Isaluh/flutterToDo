import 'package:flutter/material.dart';

class Categoria {
  final String name;
  final IconData icon;
  final Color color;

  Categoria({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CategoriaProvider with ChangeNotifier {
  final List<Categoria> _categorias = [
    Categoria(name: 'Grocery', icon: Icons.shopping_bag, color: Colors.orange),
    Categoria(name: 'Work', icon: Icons.work, color: Colors.blue),
    Categoria(name: 'Sport', icon: Icons.directions_run, color: Colors.green),
    Categoria(name: 'Design', icon: Icons.design_services, color: Colors.purple),
  ];

  List<Categoria> get categories => _categorias;

  void addCategoria(String name, IconData icon, Color color) {
    _categorias.add(Categoria(name: name, icon: icon, color: color));
    notifyListeners();
  }

  void removeCategoria(Categoria categoria) {
    _categorias.remove(categoria);
    notifyListeners();
  }
}
