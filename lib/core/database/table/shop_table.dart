// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../../features/home/data/models/shop_db_model.dart';
import '../db_helper.dart';

const SHOP_TABLE_NAME = 'shop_table';
const SHOP_ID = 'id';
const SHOP_NAME = 'name';
const SHOP_LOCATION = 'location';

class ShopTable {
  static Future<void> onCreate(DatabaseExecutor db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $SHOP_TABLE_NAME ('
        '$SHOP_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$SHOP_NAME TEXT NOT NULL,'
        '$SHOP_LOCATION TEXT NOT NULL'
        ')');
  }

  static Future<int> insert(ShopDbModel item) async {
    final db = await DBHelper().database;
    return db.insert(SHOP_TABLE_NAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertOrUpdate(List<ShopDbModel> data) async {
    if (data.isEmpty) return 0;
    final db = await DBHelper().database;
    final batch = db.batch();
    for (final item in data) {
      batch.insert(SHOP_TABLE_NAME, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final results = await batch.commit(noResult: false);
    return results.length;
  }

  static Future<List<ShopDbModel>> getAll() async {
    final db = await DBHelper().database;
    final rows = await db.query(SHOP_TABLE_NAME, orderBy: '$SHOP_ID ASC');
    return rows.map(ShopDbModel.fromMap).toList();
  }

  static Future<int> update(ShopDbModel item) async {
    final db = await DBHelper().database;
    return db.update(SHOP_TABLE_NAME, item.toMap(),
        where: '$SHOP_ID = ?', whereArgs: [item.id]);
  }

  static Future<int> deleteAll() async {
    final db = await DBHelper().database;
    return db.delete(SHOP_TABLE_NAME);
  }
}
