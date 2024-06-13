import 'dart:async';

import 'package:get/get.dart';
import 'package:isar_demo_app/user_repository.dart';

import 'user.dart';

class UserService extends GetxController {
  late final IsarDB _userRepository;
  final users = <User>[].obs;
  final currentUser = User(name: '', email: '', password: '').obs;
  final checkedValue = false.obs;
  StreamSubscription? userSubscription;

  UserService() {
    _userRepository = IsarDB();
  }

  void switchWatcher() {
    if (!checkedValue.value) {
      userSubscription?.cancel();
    } else {
      userSubscription = _userRepository.isar.users.watchLazy().listen((event) {
        getAllUsers();
      });
    }
  }

  void createUserWithParams(String name, String email, String password) {
    User user = User(name: name, email: email, password: password);
    _userRepository.createUser(user);
  }
  void createUser(User user) {
    _userRepository.createUser(user);
  }

  void updateUser(String name, String email, String password) {
    currentUser.value.name = name;
    currentUser.value.email = email;
    currentUser.value.password = password;
    _userRepository.updateUser(currentUser.value);
  }

  void deleteUser() {
    _userRepository.deleteUser(currentUser.value);
  }

  void deleteAll() {
    _userRepository.deleteAll();
  }

  void getAllUsers() async {
    users.value = await _userRepository.getAllUsers();
  }
}