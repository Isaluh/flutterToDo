import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/providers/persistencia/task.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  late Box<Task> _tasksBox;

  TaskProvider() {
    _initHive();
  }

  Future<void> _initHive() async {

    _tasksBox = await Hive.openBox<Task>('tasks');
    _tasks = _tasksBox.values.toList();
    
    notifyListeners();
  }

  List<Task> get tasks => _tasks;

  List<Task> get pendingTasks => _tasks.where((task) => !task.isDone).toList();
  
  List<Task> get completedTasks => _tasks.where((task) => task.isDone).toList();

  void addTask({
    required String title,
    String description = '',
    int priority = 0,
    DateTime? dueDate,
    Categoria? category,
  }) {
    final newTask = Task.create(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      category: category,
    );

    _tasksBox.add(newTask);
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    final index = _tasks.indexOf(task);

    if (index != -1) {
      task.toggleDone();
      _tasksBox.putAt(index, task);

      notifyListeners();
    }
  }

  void removeTask(Task task) {
    final index = _tasks.indexOf(task);
    
    if (index != -1) {
      _tasksBox.deleteAt(index);
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  void updateTask(Task oldTask, Task updatedTask) {
    final index = _tasks.indexOf(oldTask);

    if (index != -1) {
      _tasks[index] = updatedTask;
      _tasksBox.putAt(index, updatedTask);
      notifyListeners();
    } else {
      print('Erro ao atualizar: Tarefa não encontrada.');
    }
  }
}
