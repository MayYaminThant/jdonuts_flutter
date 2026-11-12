// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../../features/rewards/data/models/challenge_db_model.dart';
import '../db_helper.dart';

const CHALLENGE_TABLE_NAME = 'challenge_table';
const CHALLENGE_ID = 'id';
const CHALLENGE_TITLE = 'title';
const CHALLENGE_CURRENT = 'current';
const CHALLENGE_TARGET = 'target';
const CHALLENGE_IMAGE = 'image';

class ChallengeTable {
  static Future<void> onCreate(DatabaseExecutor db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $CHALLENGE_TABLE_NAME ('
        '$CHALLENGE_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$CHALLENGE_TITLE TEXT NOT NULL,'
        '$CHALLENGE_CURRENT INTEGER NOT NULL,'
        '$CHALLENGE_TARGET INTEGER NOT NULL,'
        '$CHALLENGE_IMAGE TEXT NOT NULL'
        ')');
  }

  static Future<int> insert(ChallengeDbModel item) async {
    final db = await DBHelper().database;
    return db.insert(CHALLENGE_TABLE_NAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertOrUpdate(List<ChallengeDbModel> data) async {
    if (data.isEmpty) return 0;
    final db = await DBHelper().database;
    final batch = db.batch();
    for (final item in data) {
      batch.insert(CHALLENGE_TABLE_NAME, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final results = await batch.commit(noResult: false);
    return results.length;
  }

  static Future<List<ChallengeDbModel>> getAll() async {
    final db = await DBHelper().database;
    final rows =
        await db.query(CHALLENGE_TABLE_NAME, orderBy: '$CHALLENGE_ID ASC');
    return rows.map(ChallengeDbModel.fromMap).toList();
  }

  static Future<int> update(ChallengeDbModel item) async {
    final db = await DBHelper().database;
    return db.update(CHALLENGE_TABLE_NAME, item.toMap(),
        where: '$CHALLENGE_ID = ?', whereArgs: [item.id]);
  }

  static Future<int> deleteAll() async {
    final db = await DBHelper().database;
    return db.delete(CHALLENGE_TABLE_NAME);
  }
}
