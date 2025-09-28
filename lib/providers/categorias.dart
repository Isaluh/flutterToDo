import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class CategoriaProvider with ChangeNotifier {
  List<Categoria> _categorias = []; 
  late Box<Categoria> _categoriasBox;

  String? _currentUserId; 

  CategoriaProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _categoriasBox = await Hive.openBox<Categoria>('categorias');

    notifyListeners();
  }

  void loadCategoriasForUser(String userId) {
    _currentUserId = userId;
    _categorias = _categoriasBox.values
        .where((c) => c.userId == userId) 
        .toList();
    notifyListeners();
  }
  
  void clearCategorias() {
    _currentUserId = null;
    _categorias = [];
    notifyListeners();
  }

  List<Categoria> get categories => _categorias;

  void addCategoria(String name, IconData icon, Color color, String userId) {
    if (_currentUserId != userId) {
      print("Erro: Tentativa de adicionar categoria para um usuário diferente do logado.");
      return; 
    }
    
    final novaCategoria = Categoria.create(name: name, icon: icon, color: color, userId: userId); 
    
    _categoriasBox.add(novaCategoria); 
    _categorias.add(novaCategoria);
    notifyListeners();
  }


  void updateCategoria(Categoria categoriaAntiga, Categoria categoriaAtualizada) {
    final key = categoriaAntiga.key;

    if (key != null) {
        _categoriasBox.put(key, categoriaAtualizada);

        final indexLocal = _categorias.indexOf(categoriaAntiga);
        if (indexLocal != -1) {
            _categorias[indexLocal] = categoriaAtualizada;
        }

        notifyListeners();
    } else {
        print("Erro: Categoria Antiga não tem uma chave Hive válida. Não foi possível atualizar.");
    }
}

void removeCategoria(Categoria categoria) {
    final key = categoria.key;

    if (key != null) {
        _categoriasBox.delete(key); 
        _categorias.remove(categoria); 
        
        notifyListeners();
    } else {
        print("Erro: Categoria não tem uma chave Hive válida. Não foi possível remover.");
    }
}
}
