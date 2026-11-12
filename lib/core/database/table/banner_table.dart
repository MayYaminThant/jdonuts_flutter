// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../../features/home/data/models/banner_db_model.dart';
import '../db_helper.dart';

const BANNER_TABLE_NAME = 'banner_table';
const BANNER_ID = 'id';
const BANNER_IMAGE = 'image';
const BANNER_SORT_ORDER = 'sort_order';

class BannerTable {
  static Future<void> onCreate(DatabaseExecutor db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $BANNER_TABLE_NAME ('
        '$BANNER_ID INTEGER PRIMARY KEY,'
        '$BANNER_IMAGE TEXT NOT NULL,'
        '$BANNER_SORT_ORDER INTEGER NOT NULL'
        ')');
  }

  static Future<int> insert(BannerDbModel item) async {
    final db = await DBHelper().database;
    return db.insert(BANNER_TABLE_NAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertOrUpdate(List<BannerDbModel> data) async {
    if (data.isEmpty) return 0;
    final db = await DBHelper().database;
    final batch = db.batch();
    for (final item in data) {
      batch.insert(BANNER_TABLE_NAME, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final results = await batch.commit(noResult: false);
    return results.length;
  }

  static Future<List<BannerDbModel>> getAll() async {
    final db = await DBHelper().database;
    final rows =
        await db.query(BANNER_TABLE_NAME, orderBy: '$BANNER_SORT_ORDER ASC');
    return rows.map(BannerDbModel.fromMap).toList();
  }

  static Future<int> update(BannerDbModel item) async {
    final db = await DBHelper().database;
    return db.update(BANNER_TABLE_NAME, item.toMap(),
        where: '$BANNER_ID = ?', whereArgs: [item.id]);
  }

  static Future<int> deleteAll() async {
    final db = await DBHelper().database;
    return db.delete(BANNER_TABLE_NAME);
  }
}
