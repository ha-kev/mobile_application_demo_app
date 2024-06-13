import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar_demo_app/user.dart';
import 'package:isar_demo_app/user_fetcher.dart';
import 'package:isar_demo_app/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = Get.put(UserService());
    final ScrollController scrollController = Get.put(ScrollController());

    return MaterialApp(
      title: 'Isar Demo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Isar Demo App'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: <Widget>[
              UtilsView(),
              SizedBox(height: 20),
              SizedBox(
                height: 450,
                  child: UserView())
            ],
          ),
        ),
      ),
    );
  }
}

class UtilsView extends StatefulWidget {
  const UtilsView({super.key});

  @override
  State<UtilsView> createState() => _UtilsViewState();
}

class _UtilsViewState extends State<UtilsView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserService userService = Get.find<UserService>();
  final ScrollController scrollController = Get.find<ScrollController>();
  bool isRandomUser = false;

  @override
  initState() {
    super.initState();
    userService.currentUser.listen((user) {
      nameController.text = user.name;
      emailController.text = user.email;
      passwordController.text = user.password;
    });
  }

  switchWatcher() {}

  create() async {
    if (nameController.text.isEmpty &&
        emailController.text.isEmpty &&
        passwordController.text.isEmpty) {
      userService.createUser(await RandomUserFetcher.fetchUser());
    } else {
      userService.createUserWithParams(
          nameController.text, emailController.text, passwordController.text);
    }
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  read() {
    userService.getAllUsers();
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  update() {
    userService.updateUser(
        nameController.text, emailController.text, passwordController.text);
  }

  delete() {
    userService.deleteUser();
  }

  clear() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    const width = 10.0;
    return Column(
      children: [
        CheckboxListTile(
          title: const Text("Watcher"),
          value: userService.checkedValue.value,
          onChanged: (newValue) {
            setState(() {
              userService.checkedValue.value = !userService.checkedValue.value;
              userService.switchWatcher();
            });
          },
          controlAffinity:
              ListTileControlAffinity.leading, //  <-- leading Checkbox
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => create(),
                child: const Text('Create'),
              ),
              const SizedBox(width: width),
              ElevatedButton(
                onPressed: () => read(),
                child: const Text('Read'),
              ),
              const SizedBox(width: width),
              ElevatedButton(
                onPressed: () => update(),
                child: const Text('Update'),
              ),
              const SizedBox(width: width),
              ElevatedButton(
                onPressed: () => delete(),
                onLongPress: () => userService.deleteAll(),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => clear(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
          ],),
        ),
      ],
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = Get.find<UserService>();
    final ScrollController scrollController = Get.find<ScrollController>();

    void selectUser(index) {
      userService.currentUser.value = userService.users[index];
    }

    return Obx(() => ListView.builder(
          controller: scrollController,
          itemCount: userService.users.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(userService.users[index].name),
              subtitle: Text(userService.users[index].email),
              trailing: Text(userService.users[index].id.toString()),
              onTap: () => selectUser(index),
            );
          },
        ));
  }
}
