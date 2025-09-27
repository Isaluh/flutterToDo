import 'package:flutter/material.dart';

class ModalPrioridade extends StatefulWidget {
  final int? currentPriority; 

  const ModalPrioridade({
    super.key,
    this.currentPriority,
  });

  @override
  State<ModalPrioridade> createState() => _ModalPrioridadeState();
}

class _ModalPrioridadeState extends State<ModalPrioridade> {
  late int _selectedPriority;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.currentPriority ?? 1; 
  }

  Widget _buildPriorityIcon(int priority) {
    final isSelected = _selectedPriority == priority;
    final color = isSelected ? Colors.white : Colors.grey[800];
    final textColor = isSelected ? Colors.black : Colors.white;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
          Navigator.of(context).pop(_selectedPriority);
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag, color: textColor, size: 15),
            const SizedBox(width: 5),
            Text(
              '$priority',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priorities = List<int>.generate(10, (i) => i + 1); 

    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: const Text(
        'Prioridade',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: priorities.map((p) {
              return _buildPriorityIcon(p);
            }).toList(),
          ),
          
          const SizedBox(height: 30),

          Center(
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(null); 
                },
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
