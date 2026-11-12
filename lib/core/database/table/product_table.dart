// ignore_for_file: constant_identifier_names

import 'package:sqflite/sqflite.dart';

import '../../../features/home/data/models/product_db_model.dart';
import '../db_helper.dart';

const PRODUCT_TABLE_NAME = 'product_table';
const PRODUCT_ID = 'id';
const PRODUCT_CODE = 'code';
const PRODUCT_NAME = 'name';
const PRODUCT_PRICE_MMK = 'price_mmk';
const PRODUCT_IMAGE = 'image';
const PRODUCT_IMAGE_URL = 'image_url';
const PRODUCT_DESCRIPTION = 'description';
const PRODUCT_IS_NEW = 'is_new';
const PRODUCT_DISCOUNT_PERCENT = 'discount_percent';

class ProductTable {
  static Future<void> onCreate(DatabaseExecutor db) async {
    await db.execute('CREATE TABLE IF NOT EXISTS $PRODUCT_TABLE_NAME ('
        '$PRODUCT_ID TEXT PRIMARY KEY,'
        '$PRODUCT_CODE TEXT NOT NULL,'
        '$PRODUCT_NAME TEXT NOT NULL,'
        '$PRODUCT_PRICE_MMK INTEGER NOT NULL,'
        '$PRODUCT_IMAGE TEXT NOT NULL,'
        '$PRODUCT_IMAGE_URL TEXT NOT NULL,'
        '$PRODUCT_DESCRIPTION TEXT NOT NULL,'
        '$PRODUCT_IS_NEW INTEGER NOT NULL DEFAULT 0,'
        '$PRODUCT_DISCOUNT_PERCENT INTEGER'
        ')');
  }

  static Future<int> insert(ProductDbModel item) async {
    final db = await DBHelper().database;
    return db.insert(PRODUCT_TABLE_NAME, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> insertOrUpdate(List<ProductDbModel> data) async {
    if (data.isEmpty) return 0;
    final db = await DBHelper().database;
    final batch = db.batch();
    for (final item in data) {
      batch.insert(PRODUCT_TABLE_NAME, item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    final results = await batch.commit(noResult: false);
    return results.length;
  }

  static Future<List<ProductDbModel>> getAll({String? search}) async {
    final db = await DBHelper().database;
    final rows = await db.query(
      PRODUCT_TABLE_NAME,
      where: search == null || search.trim().isEmpty
          ? null
          : '$PRODUCT_NAME LIKE ? OR $PRODUCT_CODE LIKE ?',
      whereArgs: search == null || search.trim().isEmpty
          ? null
          : ['%${search.trim()}%', '%${search.trim()}%'],
      orderBy: '$PRODUCT_NAME ASC',
    );
    return rows.map(ProductDbModel.fromMap).toList();
  }

  static Future<ProductDbModel?> getById(String id) async {
    final db = await DBHelper().database;
    final rows = await db.query(PRODUCT_TABLE_NAME,
        where: '$PRODUCT_ID = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : ProductDbModel.fromMap(rows.first);
  }

  static Future<int> update(ProductDbModel item) async {
    final db = await DBHelper().database;
    return db.update(PRODUCT_TABLE_NAME, item.toMap(),
        where: '$PRODUCT_ID = ?', whereArgs: [item.id]);
  }

  static Future<int> deleteAll() async {
    final db = await DBHelper().database;
    return db.delete(PRODUCT_TABLE_NAME);
  }
}
