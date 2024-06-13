import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:isar_demo_app/user.dart';

class RandomUserFetcher {
  static String getRandomString(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  static Future<User> fetchUser() async {
    const String url = "https://randomuser.me/api/?nat=de&inc=name,email";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['results'][0];
      return User(
          name: result['name']['first'] + ' ' + result['name']['last'],
          email: result['email'],
          password: getRandomString(10));
    } else {
      throw Exception('Failed to load user');
    }
  }
}
