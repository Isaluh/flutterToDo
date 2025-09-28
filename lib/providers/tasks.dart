import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/providers/persistencia/task.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  late Box<Task> _tasksBox;

  String? _currentUserId;

  TaskProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _tasksBox = await Hive.openBox<Task>('tasks');

    notifyListeners();
  }

  void loadTasksForUser(String userId) {
    _currentUserId = userId;
    _tasks = _tasksBox.values.where((t) => t.userId == userId).toList();
    notifyListeners();
  }

  void clearTasks() {
    _currentUserId = null;
    _tasks = [];
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
    required String userId,
  }) {
    if (_currentUserId != userId) {
      print(
        "Erro: Tentativa de adicionar tarefa para um usuário diferente do logado.",
      );
      return;
    }

    final newTask = Task.create(
      title: title,
      description: description,
      priority: priority,
      dueDate: dueDate,
      category: category,
      userId: userId,
    );

    _tasksBox.add(newTask);
    _tasks.add(newTask);
    notifyListeners();
  }

  void toggleTaskStatus(Task task) {
    final key = task.key;

    if (key != null) {
      task.toggleDone();
      _tasksBox.put(key, task);

      notifyListeners();
    }
  }

  void removeTask(Task task) {
    final key = task.key;

    if (key != null) {
      _tasksBox.delete(key);
      _tasks.remove(task);

      notifyListeners();
    }
  }

  void updateTask(Task oldTask, Task updatedTask) {
    final key = oldTask.key;

    if (key != null) {
      _tasksBox.put(key, updatedTask);

      final indexLocal = _tasks.indexOf(oldTask);
      if (indexLocal != -1) {
        _tasks[indexLocal] = updatedTask;
      }

      notifyListeners();
    } else {
      print('Erro ao atualizar: Tarefa não tem uma chave Hive válida.');
    }
  }
}
