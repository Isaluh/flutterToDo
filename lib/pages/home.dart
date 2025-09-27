import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/components/categoria_modal.dart';
import 'package:to_do_app/components/new_categoria_model.dart';
import 'package:to_do_app/components/task_card.dart';
import 'package:to_do_app/pages/login.dart';
import 'package:to_do_app/providers/persistencia/categoria.dart';
import 'package:to_do_app/components/new_task_model.dart';
import 'package:to_do_app/providers/persistencia/task.dart'; 
import 'package:to_do_app/providers/tasks.dart';
import 'package:intl/intl.dart'; 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isCompletedFilter = false;
  late final TextEditingController _searchController; 
  Timer? _debounceTimer; 

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
      });
    });
  }

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showCategoryModal(BuildContext context, bool showButton) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ModalCategoria(
          buttonNewCategoria: showButton,
          onPressedNewCategory: () => _showCreateCategoryModal(context),
        );
      },
    ).then((result) {
      if (result != null && result is Categoria) {
        if (showButton) {
          _showCreateCategoryModal(context, categoria: result);
        } else {
          // selecionar categoria
        }
      }
    });
  }

  void _showCreateCategoryModal(BuildContext context, {Categoria? categoria}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ModalCriarCategoria(categoriaParaEditar: categoria);
      },
    );
  }

  void _showCreateTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const ModalCriarTask();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('images/noTasks.png'),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: const Text(
              "Nada ainda por aqui. \nCrie sua tarefa clicando no botão +",
              style: TextStyle(color: Colors.black87, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }


  String _formatDueDate(DateTime? date) {
    if (date == null) return 'Sem data';

    final dateOnly = DateTime(date.year, date.month, date.day);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (dateOnly.isAtSameMomentAs(today)) {
      return 'Hoje';
    } else if (dateOnly.isAtSameMomentAs(tomorrow)) {
      return 'Amanhã';
    } else if (dateOnly.isAtSameMomentAs(yesterday)) {
      return 'Ontem';
    } else {
      return DateFormat('dd.MM.yy').format(dateOnly);
    }
  }

  Map<String, List<Task>> _groupAndSortTasks(List<Task> tasks) {
    print(_searchController.text.toLowerCase());
    final searchTerm = _searchController.text.toLowerCase();
    final filteredTasks = tasks.where((task) {
      return searchTerm.isEmpty ||
          task.title.toLowerCase().contains(searchTerm);
    }).toList();

    filteredTasks.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null)
        return b.priority.compareTo(a.priority);
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      final dateComparison = b.dueDate!.compareTo(a.dueDate!);
      if (dateComparison != 0) return dateComparison;

      return b.priority.compareTo(a.priority);
    });

    final Map<String, List<Task>> groupedTasks = {};

    for (var task in filteredTasks) {
      final dateKey = _formatDueDate(task.dueDate);

      if (!groupedTasks.containsKey(dateKey)) {
        groupedTasks[dateKey] = [];
      }
      groupedTasks[dateKey]!.add(task);
    }

    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.new_label_outlined, color: Colors.white),
          onPressed: () => _showCategoryModal(context, true),
        ),
        title: const Text(
          'To Do',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
      ),
      backgroundColor: Colors.white,
      body: Consumer<TaskProvider>(
        builder: (context, tasksProvider, child) {
          final activeTasks = tasksProvider.tasks
              .where((task) => task.isDone == _isCompletedFilter)
              .toList();

          final groupedTasks = _groupAndSortTasks(activeTasks);
          final dateKeys = groupedTasks.keys
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (tasksProvider.tasks.isEmpty)
                Expanded(child: _buildEmptyState())
              else
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Buscar...',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 8.0,
                            ), 
                            child: FilterChip(
                              label: Text(
                                'A Fazer',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: !_isCompletedFilter
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                              selected: !_isCompletedFilter,
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.black,
                              checkmarkColor: Colors.white,
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _isCompletedFilter = false);
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 16.0,
                            ),
                            child: FilterChip(
                              label: Text(
                                'Concluídas',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _isCompletedFilter
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                              selected: _isCompletedFilter,
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.black,
                              checkmarkColor: Colors.white,
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _isCompletedFilter = true);
                              },
                            ),
                          ),
                        ],
                      ),

                      Expanded(
                        child: (activeTasks.isEmpty && _searchController.text.isEmpty)
                            ? Center(
                                child: Text(
                                  _isCompletedFilter
                                      ? "Nenhuma tarefa concluída ainda."
                                      : "Parabéns! Nenhuma tarefa pendente.",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              )
                            : (groupedTasks.isEmpty && _searchController.text.isNotEmpty)
                                ? Center(
                                    child: Text(
                                      "Nenhum resultado encontrado para '${_searchController.text}'.",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 8.0,
                                    ),
                                    itemCount: dateKeys.length,
                                    itemBuilder: (context, index) {
                                      final dateKey = dateKeys[index];
                                      final tasksForDate = groupedTasks[dateKey]!;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 16.0,
                                              bottom: 8.0,
                                            ),
                                            child: Text(
                                              dateKey,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ),

                                          ...tasksForDate
                                              .map((task) => TaskCard(task: task))
                                              .toList(),
                                        ],
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: () {
                _showCreateTaskModal(context);
              },
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              mini: true,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
