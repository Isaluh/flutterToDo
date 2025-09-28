import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart'; // Importe para gerar o ID
part 'user.g.dart';

const uuid = Uuid();

@HiveType(typeId: 1)
class User extends HiveObject {
  
  @HiveField(0)
  String username;
  
  @HiveField(1)
  String password;

  @HiveField(2) 
  String id; 

  User({
    required this.username, 
    required this.password,
    required this.id, 
  });
  
  User.create({
    required this.username, 
    required this.password,
  }) : id = uuid.v4();
}