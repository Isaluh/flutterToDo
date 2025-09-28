import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/components/botoes.dart';
import 'package:to_do_app/components/categoria_modal.dart';
import 'package:to_do_app/components/priority_modal.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';
import 'package:to_do_app/providers/persistencia/task.dart';
import 'package:to_do_app/providers/tasks.dart';
import 'package:to_do_app/providers/users.dart';

class ModalCriarTask extends StatefulWidget {
  final Task? taskToEdit;

  const ModalCriarTask({this.taskToEdit, super.key});

  @override
  State<ModalCriarTask> createState() => _ModalCriarTaskState();
}

class _ModalCriarTaskState extends State<ModalCriarTask> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  Categoria? _selectedCategory;
  int _priority = 0;
  DateTime? _selectedDateTime;

  bool get isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    final task = widget.taskToEdit;

    _titleController = TextEditingController(
      text: isEditing ? task!.title : '',
    );
    _descriptionController = TextEditingController(
      text: isEditing ? task!.description : '',
    );
    _selectedCategory = isEditing ? task!.category : null;
    _priority = isEditing ? task!.priority : 0;
    _selectedDateTime = isEditing ? task!.dueDate : null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.lightBlueAccent,
                onSurface: Colors.white,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.lightBlueAccent,
                ),
              ),
            ),
            child: child!,
          );
        },
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
        print('Data/Hora Selecionada: $_selectedDateTime');
      }
    }
  }

  void _showPriorityModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalPrioridade(
          currentPriority: _priority == 0 ? null : _priority,
        );
      },
    ).then((selectedPriority) {
      if (selectedPriority != null && selectedPriority is int) {
        setState(() {
          _priority = selectedPriority;
        });
        print('Prioridade Selecionada: $_priority');
      }
    });
  }

  Color _getPriorityColor(int priority) {
    if (priority == 0) return Colors.white70;
    if (priority <= 3) return Colors.greenAccent;
    if (priority <= 7) return Colors.orange;
    return Colors.redAccent;
  }

  void _selectCategory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ModalCategoria(
          buttonNewCategoria: false,
          onPressedNewCategory: () => Navigator.of(context).pop(),
        );
      },
    ).then((selectedCategory) {
      if (selectedCategory is Categoria) {
        setState(() {
          _selectedCategory = selectedCategory;
        });
        print('Categoria Vinculada: ${_selectedCategory!.name}');
      }
    });
  }

  void _createTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      // nao aparece pq a modal fica em cima
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Titulo da tarefa é obrigatório.')),
      );
      return;
    }

    try {
      final usuario = Provider.of<UserProvider>(context, listen: false).currentUser?.id;
      Provider.of<TaskProvider>(context, listen: false).addTask(
        title: title,
        description: description,
        priority: _priority,
        dueDate: _selectedDateTime,
        category: _selectedCategory,
        userId: usuario!
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao criar tarefa: $e')));
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título da tarefa é obrigatório.')),
      );
      return;
    }

    try {
      final usuario = Provider.of<UserProvider>(context, listen: false).currentUser?.id;
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (isEditing) {
        final taskAntiga = widget.taskToEdit!;
        final updatedTask = Task.create(
          title: title,
          description: description,
          priority: _priority,
          dueDate: _selectedDateTime,
          category: _selectedCategory,
          userId: usuario!,
        );
        taskProvider.updateTask(taskAntiga, updatedTask);
      } else {
        taskProvider.addTask(
          title: title,
          description: description,
          priority: _priority,
          dueDate: _selectedDateTime,
          category: _selectedCategory,
          userId: usuario!
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar tarefa: $e')));
    }
  }

  void _toggleFinishTask() {
    if (isEditing) {
      Provider.of<TaskProvider>(
        context,
        listen: false,
      ).toggleTaskStatus(widget.taskToEdit!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableHeight = MediaQuery.of(context).size.height;
    final finishText = isEditing && widget.taskToEdit!.isDone
        ? 'Marcar como Pendente'
        : 'Finalizar Tarefa';

    return Container(
      padding: const EdgeInsets.all(20),
      height: availableHeight * 0.75,
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Editar Tarefa' : 'Criar Nova Tarefa',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Título:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: 'Prova',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Descrição:',
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Opcional: Detalhes, endereço, etc.',
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),

                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Tooltip(
                        message: _selectedDateTime == null
                            ? 'Definir Data/Hora'
                            : 'Agendado para ${_selectedDateTime!.day}/${_selectedDateTime!.month} às ${_selectedDateTime!.hour}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}',
                        child: IconButton(
                          icon: Icon(
                            _selectedDateTime == null
                                ? Icons.calendar_month_outlined
                                : Icons.calendar_month,
                            color: _selectedDateTime == null
                                ? Colors.white70
                                : Colors.blueAccent,
                            size: 28,
                          ),
                          onPressed: _pickDateTime,
                        ),
                      ),

                      Tooltip(
                        message:
                            'Prioridade: ${_priority == 0 ? "Nenhuma" : _priority}',
                        child: IconButton(
                          icon: Icon(
                            Icons.flag,
                            color: _getPriorityColor(_priority),
                            size: 28,
                          ),
                          onPressed: _showPriorityModal,
                        ),
                      ),

                      Tooltip(
                        message: _selectedCategory == null
                            ? 'Atribuir Categoria'
                            : 'Categoria: ${_selectedCategory!.name}',
                        child: IconButton(
                          icon: Icon(
                            Icons.folder_open,
                            color: _selectedCategory == null
                                ? Colors.white70
                                : _selectedCategory!.color,
                            size: 28,
                          ),
                          onPressed: _selectCategory,
                        ),
                      ),
                    ],
                  ),

                  if (_selectedCategory != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          const Text(
                            'Categoria: ',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Icon(
                            _selectedCategory!.icon,
                            size: 18,
                            color: _selectedCategory!.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _selectedCategory!.name,
                            style: TextStyle(
                              color: _selectedCategory!.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: _toggleFinishTask,
                            child: Text(
                              finishText,
                              style: TextStyle(
                                color: widget.taskToEdit!.isDone
                                    ? Colors.orange.shade600
                                    : Colors.green.shade600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButtonComponent(
                            onPressed: () {
                              Provider.of<TaskProvider>(
                                context,
                                listen: false,
                              ).removeTask(widget.taskToEdit!);
                              Navigator.of(context).pop();
                            },
                            text: 'Excluir tarefa',
                            color: Colors.red,
                          ),
                          const Divider(color: Colors.white12, height: 20),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              ElevatedButtonComponent(
                onPressed: _saveTask,
                text: isEditing ? 'Atualizar' : 'Salvar',
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
