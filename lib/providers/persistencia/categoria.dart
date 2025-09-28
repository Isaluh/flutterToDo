import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'categoria.g.dart';

@HiveType(typeId: 0)
class Categoria extends HiveObject{
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int iconCodePoint;

  @HiveField(2)
  final int colorValue;
  
  @HiveField(3)
  final String userId; 

  Categoria({
    required this.name,
    required this.iconCodePoint,
    required this.colorValue,
    required this.userId, 
  });

  Categoria.create({
    required this.name,
    required IconData icon,
    required Color color,
    required this.userId,
  }) :
    iconCodePoint = icon.codePoint,
    colorValue = color.value;
  
  IconData get icon => IconData(iconCodePoint, fontFamily: 'MaterialIcons');
  Color get color => Color(colorValue);
}