import 'package:hive/hive.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart'; 

part 'task.g.dart';

@HiveType(typeId: 2)
class Task extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  int priority;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  Categoria? category;

  @HiveField(7) 
  String userId; 

  Task({
    required this.title,
    this.description = '',
    this.isDone = false,
    this.priority = 0,
    required this.createdAt,
    this.dueDate,
    this.category,
    required this.userId,
  });

  Task.create({
    required this.title,
    this.description = '',
    this.priority = 0,
    this.dueDate,
    this.category,
    required this.userId,
  }) : isDone = false,
       createdAt = DateTime.now();

  void toggleDone() {
    isDone = !isDone;
  }
}
