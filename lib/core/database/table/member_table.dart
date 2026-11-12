// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../../features/home/data/models/member_db_model.dart';
import '../db_helper.dart';

const MEMBER_TABLE_NAME = 'member_table';
const MEMBER_ID = 'id';
const MEMBER_NAME = 'name';
const MEMBER_TIER = 'tier';
const MEMBER_POINTS = 'points';
const MEMBER_POINTS_TO_GOLD = 'points_to_gold';

class MemberTable {
  static Future<void> onCreate(DatabaseExecutor db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $MEMBER_TABLE_NAME ('
        '$MEMBER_ID INTEGER PRIMARY KEY,'
        '$MEMBER_NAME TEXT NOT NULL,'
        '$MEMBER_TIER TEXT NOT NULL,'
        '$MEMBER_POINTS INTEGER NOT NULL,'
        '$MEMBER_POINTS_TO_GOLD INTEGER NOT NULL'
        ')');
  }

  static Future<int> insert(MemberDbModel item) async {
    final db = await DBHelper().database;
    return db.insert(MEMBER_TABLE_NAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertOrUpdate(List<MemberDbModel> data) async {
    if (data.isEmpty) return 0;
    final db = await DBHelper().database;
    final batch = db.batch();
    for (final item in data) {
      batch.insert(MEMBER_TABLE_NAME, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final results = await batch.commit(noResult: false);
    return results.length;
  }

  static Future<List<MemberDbModel>> getAll() async {
    final db = await DBHelper().database;
    final rows = await db.query(MEMBER_TABLE_NAME, orderBy: '$MEMBER_ID ASC');
    return rows.map(MemberDbModel.fromMap).toList();
  }

  static Future<int> update(MemberDbModel item) async {
    final db = await DBHelper().database;
    return db.update(MEMBER_TABLE_NAME, item.toMap(),
        where: '$MEMBER_ID = ?', whereArgs: [item.id]);
  }

  static Future<int> deleteAll() async {
    final db = await DBHelper().database;
    return db.delete(MEMBER_TABLE_NAME);
  }
}
