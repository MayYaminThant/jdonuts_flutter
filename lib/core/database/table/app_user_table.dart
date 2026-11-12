// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../../features/auth/data/models/app_user_db_model.dart';
import '../db_helper.dart';

const APP_USER_TABLE_NAME = 'app_user_table';
const APP_USER_PHONE = 'phone';
const APP_USER_FIRST_NAME = 'first_name';
const APP_USER_LAST_NAME = 'last_name';
const APP_USER_BIRTH_DATE = 'birth_date';

class AppUserTable {
  static Future<void> onCreate(DatabaseExecutor db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $APP_USER_TABLE_NAME ('
        '$APP_USER_PHONE TEXT PRIMARY KEY,'
        '$APP_USER_FIRST_NAME TEXT NOT NULL,'
        '$APP_USER_LAST_NAME TEXT NOT NULL,'
        '$APP_USER_BIRTH_DATE TEXT NOT NULL'
        ')');
  }

  static Future<int> insert(AppUserDbModel item) async {
    final db = await DBHelper().database;
    return db.insert(APP_USER_TABLE_NAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertOrUpdate(List<AppUserDbModel> data) async {
    if (data.isEmpty) return 0;
    final db = await DBHelper().database;
    final batch = db.batch();
    for (final item in data) {
      batch.insert(APP_USER_TABLE_NAME, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final results = await batch.commit(noResult: false);
    return results.length;
  }

  static Future<List<AppUserDbModel>> getAll() async {
    final db = await DBHelper().database;
    final rows =
        await db.query(APP_USER_TABLE_NAME, orderBy: '$APP_USER_PHONE ASC');
    return rows.map(AppUserDbModel.fromMap).toList();
  }

  static Future<AppUserDbModel?> getByPhone(String phone) async {
    final db = await DBHelper().database;
    final rows = await db.query(APP_USER_TABLE_NAME,
        where: '$APP_USER_PHONE = ?', whereArgs: [phone], limit: 1);
    return rows.isEmpty ? null : AppUserDbModel.fromMap(rows.first);
  }

  static Future<int> update(AppUserDbModel item) async {
    final db = await DBHelper().database;
    return db.update(APP_USER_TABLE_NAME, item.toMap(),
        where: '$APP_USER_PHONE = ?', whereArgs: [item.phone]);
  }

  static Future<int> deleteAll() async {
    final db = await DBHelper().database;
    return db.delete(APP_USER_TABLE_NAME);
  }
}
