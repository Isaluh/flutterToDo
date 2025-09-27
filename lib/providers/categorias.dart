import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class CategoriaProvider with ChangeNotifier {
  List<Categoria> _categorias = []; 
  late Box<Categoria> _categoriasBox;

  CategoriaProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _categoriasBox = await Hive.openBox<Categoria>('categorias');

    _categorias = _categoriasBox.values.toList();
    notifyListeners();
  }

  List<Categoria> get categories => _categorias;

  void addCategoria(String name, IconData icon, Color color) {
    final novaCategoria = Categoria.create(name: name, icon: icon, color: color);
    
    _categoriasBox.add(novaCategoria); 
    _categorias.add(novaCategoria);
    notifyListeners();
  }

  void updateCategoria(Categoria categoriaAntiga, Categoria categoriaAtualizada) {
    final index = _categorias.indexOf(categoriaAntiga);

    if (index != -1) {
      _categorias[index] = categoriaAtualizada;
      _categoriasBox.putAt(index, categoriaAtualizada);

      notifyListeners();
    } else {
      final indexByName = _categorias.indexWhere((c) => c.name == categoriaAntiga.name && c.color == categoriaAntiga.color);
      if (indexByName != -1) {
          _categorias[indexByName] = categoriaAtualizada;
          _categoriasBox.putAt(indexByName, categoriaAtualizada);
          notifyListeners();
      } else {
          print("Erro: Categoria não encontrada para atualização.");
      }
    }
  }

  void removeCategoria(Categoria categoria) {
    final index = _categorias.indexOf(categoria);
    
    if (index != -1) {
      _categoriasBox.deleteAt(index);
      _categorias.removeAt(index);
      notifyListeners();
    }
  }
}
