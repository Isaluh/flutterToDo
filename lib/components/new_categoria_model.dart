import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:to_do_app/providers/categorias.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class ModalCriarCategoria extends StatefulWidget {
  final Categoria? categoriaParaEditar; 

  const ModalCriarCategoria({super.key, this.categoriaParaEditar});

  @override
  State<ModalCriarCategoria> createState() => _ModalCriarCategoriaState();
}

class _ModalCriarCategoriaState extends State<ModalCriarCategoria> {
  late TextEditingController _nomeCategoriaController; 
  late Color _pickedColor;
  late Icon _icon;
  String _titulo = "Crie uma nova categoria"; 
  
  bool get isEditing => widget.categoriaParaEditar != null; 
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    _nomeCategoriaController = TextEditingController();
    _pickedColor = Colors.black;
    _icon = const Icon(Icons.folder);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (!_isInitialized && isEditing) {
      _initializeFieldsForEditing();
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant ModalCriarCategoria oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.categoriaParaEditar != oldWidget.categoriaParaEditar) {
      if (isEditing) {
        _initializeFieldsForEditing();
      } else {
        _nomeCategoriaController.text = '';
        _pickedColor = Colors.black;
        _icon = const Icon(Icons.folder);
        _titulo = "Crie uma nova categoria"; 
      }
      setState(() {});
    }
  }

  void _initializeFieldsForEditing() {
    final categoria = widget.categoriaParaEditar!;
    
    _nomeCategoriaController.text = categoria.name;
    _pickedColor = categoria.color;
    _icon = Icon(categoria.icon);
    _titulo = "Editar categoria";
  }

  Future<void> _pickIcon() async {
    IconPickerIcon? icon = await showIconPicker(
        context,
        configuration: SinglePickerConfiguration(
          iconPackModes: [IconPack.allMaterial],
        ),
    );

    _icon = (icon != null) 
      ? Icon(icon.data) 
      : Icon(Icons.folder); 

    setState(() {});
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

  void _salvarCategoria(){
    final String nome = _nomeCategoriaController.text.trim();
    final IconData? iconeData = _icon?.icon;
    final Color cor = _pickedColor;

    if (nome.isEmpty || iconeData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos.')),
      );
      return;
    }

    try {
      if (isEditing) {
        final categoriaAntiga = widget.categoriaParaEditar!;
        final categoriaAtualizada = Categoria.create(
          name: nome,
          icon: iconeData,
          color: cor,
        );
        Provider.of<CategoriaProvider>(context, listen: false).updateCategoria(categoriaAntiga, categoriaAtualizada);
      } else {
        Provider.of<CategoriaProvider>(context, listen: false).addCategoria(nome, iconeData, cor);
      }
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao salvar categoria.')),
      );
    }
  }

  void _excluirCategoria() {
    if (!isEditing) return;

    Provider.of<CategoriaProvider>(context, listen: false).removeCategoria(widget.categoriaParaEditar!);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _nomeCategoriaController.dispose();
    super.dispose();
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
          Text(
            _titulo,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Nome:', style: TextStyle(color: Colors.white70)),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Compras',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
            controller: _nomeCategoriaController,
          ),
          const SizedBox(height: 20),
          const Text('Icone:', style: TextStyle(color: Colors.white70)),
          ElevatedButton(
            onPressed: _pickIcon, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[850],
              iconColor: Colors.white
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _icon!,
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
          const SizedBox(height: 20),
          if(isEditing)
          ElevatedButtonComponent(onPressed: _excluirCategoria, text: 'Excluir categoria', color: Colors.red,),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); 
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              ElevatedButtonComponent(
                onPressed: () => _salvarCategoria(),
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
}
