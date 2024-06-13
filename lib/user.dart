import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection()
class User {
  Id? id = Isar.autoIncrement;
  String name;
  String email;
  String password;

  User({required this.name, required this.email, required this.password});
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password}';
  }
}