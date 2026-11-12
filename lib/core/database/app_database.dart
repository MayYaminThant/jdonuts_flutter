import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jdonuts_flutter/features/home/data/models/shop_db_model.dart';
import 'package:jdonuts_flutter/features/rewards/data/models/challenge_db_model.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import '../../features/home/data/models/member_db_model.dart';
import '../../features/home/data/models/product_db_model.dart';
import 'table/app_user_table.dart';
import 'table/banner_table.dart';
import 'table/challenge_table.dart';
import 'table/member_table.dart';
import 'table/product_table.dart';
import 'table/shop_table.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();
  factory AppDatabase() => instance;
  static const databaseName = 'jdonuts.db';
  static const databaseVersion = 1;
  Database? _instance;

  Future<Database> get database async {
    if (_instance != null) return _instance!;
    final location = path.join(await getDatabasesPath(), databaseName);
    _instance = await openDatabase(
      location,
      version: databaseVersion,
      onCreate: (db, _) async {
        await _createTables(db);
        await _insertDefaultDatas(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {}
      },
    );
    return _instance!;
  }

  Future<void> _createTables(DatabaseExecutor db) async {
    await ProductTable.onCreate(db);
    await MemberTable.onCreate(db);
    await ShopTable.onCreate(db);
    await ChallengeTable.onCreate(db);
    await BannerTable.onCreate(db);
    await AppUserTable.onCreate(db);
  }

  Future<void> _insertDefaultDatas(DatabaseExecutor db) async {
    final json = jsonDecode(
      await rootBundle.loadString('assets/data/seed.json'),
    ) as Map<String, dynamic>;

    // Products
    for (final raw in json['products'] as List<dynamic>) {
      final product = ProductDbModel.fromMap(
        raw as Map<String, dynamic>,
      );

      await db.insert(
        PRODUCT_TABLE_NAME,
        product.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // Member
    final member = MemberDbModel.fromMap(
      json['member'] as Map<String, dynamic>,
    );

    await db.insert(
      MEMBER_TABLE_NAME,
      member.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );

    // Shops
    for (final raw in json['shops'] as List<dynamic>) {
      final shop = ShopDbModel.fromMap(
        raw as Map<String, dynamic>,
      );

      await db.insert(
        SHOP_TABLE_NAME,
        {...shop.toMap()}..remove(SHOP_ID),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // Challenges
    for (final raw in json['challenges'] as List<dynamic>) {
      final challenge = ChallengeDbModel.fromMap(
        raw as Map<String, dynamic>,
      );

      await db.insert(
        CHALLENGE_TABLE_NAME,
        {...challenge.toMap()}..remove(CHALLENGE_ID),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    // Banners
    for (var i = 1; i <= 3; i++) {
      await db.insert(
        BANNER_TABLE_NAME,
        {
          BANNER_ID: i,
          BANNER_IMAGE: 'banner_$i.jpg',
          BANNER_SORT_ORDER: i,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
