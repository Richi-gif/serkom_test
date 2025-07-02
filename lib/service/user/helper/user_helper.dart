import 'package:sqflite/sqflite.dart';
import 'package:praktikum_1/service/database/database.dart';
import 'package:praktikum_1/service/user/model/user.dart';

class UserHelper {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<void> registerUser(User user) async {
    final db = await dbHelper.database;
    await db.insert('users', user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await dbHelper.database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User(
        id: result.first['id'],
        name: result.first['name'],
        email: result.first['email'],
        password: result.first['password'],
      );
    }
    return null;
  }
}
