import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper _instance = DBHelper._();
  factory DBHelper() => _instance;
  Future<Database> get database => AppDatabase.instance.database;
}
