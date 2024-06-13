import 'package:isar/isar.dart';
import 'package:isar_demo_app/user.dart';
import 'package:path_provider/path_provider.dart';


class IsarDB {
  late final Isar isar;

  IsarDB() {
    init().then((value) => isar = value);
  }

  Future<Isar> init() async {
    if (Isar.getInstance() == null) {
      final dir = await getApplicationDocumentsDirectory();
      final isar = await Isar.open([UserSchema], directory: dir.path);
      return isar;
    } else {
      return Isar.getInstance()!;
    }
  }

  Future<void> createUser(User user) async {
    await isar.writeTxn(() async {
      await isar.users.put(user);
    });
  }

  Future<void> updateUser(User user) async {
    await createUser(user);
  }

  Future<void> deleteUser(User user) async {
    await isar.writeTxn(() async {
      final userInDb = await isar.users.where().idEqualTo(user.id!).findFirst();
      if (userInDb != null) {
        await isar.users.delete(userInDb.id!);
      }
    });
  }

  Future<void> deleteAll() async {
    await isar.writeTxn(() async {
      await isar.users.clear();
    });
  }

  Future<List<User>> getAllUsers() async {
    return await isar.users.where().findAll();
  }
}
