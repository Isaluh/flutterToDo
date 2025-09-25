import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class ModalCriarCategoria extends StatefulWidget {
  const ModalCriarCategoria({super.key});

  @override
  State<ModalCriarCategoria> createState() => _ModalCriarCategoriaState();
}

class _ModalCriarCategoriaState extends State<ModalCriarCategoria> {
  Color _pickedColor = Colors.black;
  IconData? _pickedIcon = Icons.folder;

  void _showIconPicker() async {
    // nao esta aparecendo icon
    final pickedIcon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        iconPackModes: [IconPack.allMaterial],
      )
    );

    if (pickedIcon != null) {
      setState(() {
        _pickedIcon = pickedIcon as IconData?;
      });
      debugPrint('Ícone selecionado: $_pickedIcon');
    }
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecione uma cor'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _pickedColor,
              onColorChanged: (color) {
                setState(() {
                  _pickedColor = color;
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Crie uma nova categoria',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Nome:', style: TextStyle(color: Colors.white70)),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Compras',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text('Icone:', style: TextStyle(color: Colors.white70)),
          ElevatedButton(
            onPressed: _showIconPicker, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[850],
              iconColor: Colors.white
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_pickedIcon),
                const SizedBox(width: 8),
                const Text('Escolha um ícone', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Cor:', style: TextStyle(color: Colors.white70)),
          GestureDetector(
            onTap: _showColorPicker, 
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: _pickedColor,
                borderRadius: BorderRadius.circular(5),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Clique para escolher a cor',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButtonComponent(
                onPressed: () => Navigator.pop(context),
                text: 'Cancelar',
                color: Colors.transparent,
                textColor: Colors.white,
              ),
              // chamar o criar
              ElevatedButtonComponent(
                onPressed: () => Navigator.pop(context),
                text: 'Salvar',
                color: Colors.white,
                textColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  // CASO VOLTE PRA IDEIA DAS BOLINHAS
  // Widget _buildColorCircle(Color color) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 5),
  //     width: 24,
  //     height: 24,
  //     decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  //   );
  // }
}
