import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/table/app_user_table.dart';
import '../domain/auth_repository.dart';
import 'models/app_user_db_model.dart';

class TempoAuthRepository implements AuthRepository {
  const TempoAuthRepository(this.database, this.storage);
  final AppDatabase database;
  final FlutterSecureStorage storage;
  Future<void> _wait() => Future<void>.delayed(const Duration(seconds: 1));

  @override
  Future<bool> exists(String phone) async {
    await _wait();
    return await AppUserTable.getByPhone(phone) != null;
  }

  @override
  Future<void> register(
      String phone, String first, String last, DateTime birth) async {
    await _wait();
    final user = AppUserDbModel(
        phone: phone,
        firstName: first,
        lastName: last,
        birthDate: birth.toIso8601String());
    await AppUserTable.insert(user);
    await storage.write(key: 'session', value: phone);
  }

  @override
  Future<bool> login(String phone) async {
    if (!await exists(phone)) return false;
    await storage.write(key: 'session', value: phone);
    return true;
  }

  @override
  Future<bool> get isLoggedIn async {
    final phone = await storage.read(key: 'session');
    if (phone == null) return false;
    return await AppUserTable.getByPhone(phone) != null;
  }

  @override
  Future<void> logout() => storage.delete(key: 'session');
}
