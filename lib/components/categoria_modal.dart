import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:to_do_app/providers/categorias.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class ModalCategoria extends StatelessWidget {
  const ModalCategoria({
    super.key,
    required this.buttonNewCategoria,
    required this.onPressedNewCategory,
    this.onEditCategory, 
  });

  final bool buttonNewCategoria;
  final VoidCallback onPressedNewCategory;
  final void Function(Categoria)? onEditCategory; 

  Widget _buildCategoryIcon(BuildContext context, Categoria categoria) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (buttonNewCategoria) {
              onEditCategory?.call(categoria); 
              Navigator.of(context).pop(); 
            } else {
              Navigator.of(context).pop(categoria); 
            }
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoria.color.withAlpha(50),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(categoria.icon, color: categoria.color, size: 25,),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 60,
          child: Text(
            categoria.name,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriasProvider = Provider.of<CategoriaProvider>(context);
    final categorias = categoriasProvider.categories;

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Categorias',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            categorias.isNotEmpty
              ? GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: categorias.map((categoria) {
                    return _buildCategoryIcon(context, categoria);
                  }).toList(),
                )
              : const Text(
                  "Sem categorias criadas.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            const SizedBox(height: 20),
            if (buttonNewCategoria)
              ElevatedButtonComponent(
                onPressed: () {
                  Navigator.of(context).pop();
                  onPressedNewCategory();
                },
                text: 'Criar categoria',
                color: Colors.white,
                textColor: Colors.black,
                minimumSize: const Size(double.infinity, 0),
              ),
          ],
        ),
      ),
    );
  }
}
